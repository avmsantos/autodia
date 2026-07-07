import 'package:get/get.dart';

import '../../core/calculations/maintenance_calculator.dart';
import '../../core/services/battery_optimization_service.dart';
import '../../core/services/notification_service.dart';
import '../../core/services/purchase_service.dart';
import '../../data/local/app_database.dart';

/// Agrupa um veículo com o resultado de cálculo do lembrete mais urgente,
/// pra exibir um badge de status direto no card da Home sem o usuário
/// precisar entrar no detalhe.
class VehicleWithStatus {
  final Vehicle vehicle;
  final MaintenanceResult? mostUrgentResult;

  const VehicleWithStatus({required this.vehicle, this.mostUrgentResult});
}

class HomeController extends GetxController {
  final AppDatabase _db = Get.find<AppDatabase>();
  final PurchaseService purchaseService = Get.find<PurchaseService>();
  final BatteryOptimizationService _batteryService = BatteryOptimizationService();

  final RxList<VehicleWithStatus> vehicles = <VehicleWithStatus>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool mostrarBannerBateria = false.obs;

  List<Vehicle> _latestVehicles = [];

  bool get isPremium => purchaseService.isPremium.value;

  @override
  void onInit() {
    super.onInit();
    _db.streamAllVehicles().listen((list) {
      _latestVehicles = list;
      _recompute();
    });
    // Qualquer mudança em qualquer lembrete (criar/editar) também precisa
    // recalcular os badges da Home — sem isso, só atualizava quando um
    // veículo era criado/removido.
    _db.watchAllReminders().listen((_) => _recompute());

    _verificarOtimizacaoBateria();
  }

  Future<void> _verificarOtimizacaoBateria() async {
    mostrarBannerBateria.value = await _batteryService.precisaAjustar();
  }

  Future<void> ajustarOtimizacaoBateria() async {
    await _batteryService.mostrarTelasDeAjuste();
    // O plugin não garante saber se o usuário concluiu o ajuste — some o
    // banner de qualquer forma pra não incomodar quem já viu a tela.
    mostrarBannerBateria.value = false;
  }

  void dispensarBannerBateria() => mostrarBannerBateria.value = false;

  Future<void> alternarNotificacoes() async {
    final notificationService = Get.find<NotificationService>();
    await notificationService.alternarNotificacoes(
      !notificationService.notificacoesAtivas.value,
      _db,
    );
  }

  Future<void> _recompute() async {
    final results = <VehicleWithStatus>[];
    for (final v in _latestVehicles) {
      final result = await _mostUrgentResultForVehicle(v);
      results.add(VehicleWithStatus(vehicle: v, mostUrgentResult: result));
    }
    // Mais urgente primeiro: atrasado > próximo > em dia > sem lembrete.
    results.sort((a, b) => _statusRank(a.mostUrgentResult?.status)
        .compareTo(_statusRank(b.mostUrgentResult?.status)));
    vehicles.assignAll(results);
    isLoading.value = false;
  }

  int _statusRank(MaintenanceStatus? status) {
    switch (status) {
      case MaintenanceStatus.atrasado:
        return 0;
      case MaintenanceStatus.proximo:
        return 1;
      case MaintenanceStatus.emDia:
        return 2;
      case null:
        return 3;
    }
  }

  Future<MaintenanceResult?> _mostUrgentResultForVehicle(Vehicle v) async {
    final reminders = await _db.streamRemindersForVehicle(v.id).first;
    if (reminders.isEmpty) return null;

    final kmHistoryRaw = await _db.kmHistoryForVehicle(v.id);
    final kmHistory = kmHistoryRaw
        .map((e) => KmHistoryPoint(date: e.$1, km: e.$2))
        .toList();

    MaintenanceResult? mostUrgent;
    for (final r in reminders) {
      final MaintenanceResult result;
      if (r.dataVencimentoManual != null) {
        result = calculateDateOnlyStatus(
          dueDate: r.dataVencimentoManual!,
          today: DateTime.now(),
        );
      } else {
        result = calculateMaintenanceStatus(
          MaintenanceInput(
            lastDoneDate: r.ultimaDataFeita,
            lastDoneKm: r.ultimoKmFeito,
            intervalMonths: r.intervaloMeses,
            intervalKm: r.intervaloKm,
            currentKm: v.kmAtual,
            today: DateTime.now(),
            kmHistory: kmHistory,
          ),
        );
      }
      if (mostUrgent == null ||
          _statusRank(result.status) < _statusRank(mostUrgent.status)) {
        mostUrgent = result;
      }
    }
    return mostUrgent;
  }
}