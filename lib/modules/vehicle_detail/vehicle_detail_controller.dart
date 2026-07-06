import 'package:get/get.dart';

import '../../core/calculations/maintenance_calculator.dart';
import '../../core/services/notification_service.dart';
import '../../core/services/purchase_service.dart';
import '../../data/local/app_database.dart';

class ReminderWithResult {
  final Reminder reminder;
  final MaintenanceResult result;
  const ReminderWithResult({required this.reminder, required this.result});
}

class VehicleDetailController extends GetxController {
  final AppDatabase _db = Get.find<AppDatabase>();
  final NotificationService _notificationService = Get.find<NotificationService>();
  final PurchaseService _purchaseService = Get.find<PurchaseService>();

  bool get isPremium => _purchaseService.isPremium.value;

  /// Guardado como Rx pra qualquer edição (nome, placa, km) — feita nessa
  /// tela ou em outra (ex: tela de editar veículo) — refletir aqui na hora,
  /// sem precisar sair e voltar. Sempre que ler/escrever, usa os getters
  /// `vehicle` / `vehicle =` abaixo, não `_vehicleRx` direto.
  late final Rx<Vehicle> _vehicleRx;

  Vehicle get vehicle => _vehicleRx.value;
  set vehicle(Vehicle v) => _vehicleRx.value = v;

  final RxList<MaintenanceEvent> events = <MaintenanceEvent>[].obs;
  final RxList<ReminderWithResult> reminders = <ReminderWithResult>[].obs;
  final RxMap<String, MaintenanceCategory> categoriesById =
      <String, MaintenanceCategory>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _vehicleRx = Rx<Vehicle>(Get.arguments as Vehicle);
    _loadCategories();

    // Mantém `vehicle` sempre sincronizado com o banco — pega tanto edições
    // feitas por essa tela quanto por qualquer outra (ex: editar veículo).
    _db.watchVehicleById(vehicle.id).listen((v) => vehicle = v);

    _db.streamEventsForVehicle(vehicle.id).listen(events.assignAll);
    _db.streamRemindersForVehicle(vehicle.id).listen(_recalculateReminders);
  }

  Future<void> _loadCategories() async {
    final cats = await _db.categoriesForType(vehicle.tipo);
    categoriesById.clear();
    categoriesById.addAll({for (final c in cats) c.id: c});
  }

  Future<void> _recalculateReminders(List<Reminder> list) async {
    final kmHistoryRaw = await _db.kmHistoryForVehicle(vehicle.id);
    final kmHistory =
        kmHistoryRaw.map((e) => KmHistoryPoint(date: e.$1, km: e.$2)).toList();

    final results = list.map((r) {
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
            currentKm: vehicle.kmAtual,
            today: DateTime.now(),
            kmHistory: kmHistory,
          ),
        );
      }
      return ReminderWithResult(reminder: r, result: result);
    }).toList();

    results.sort((a, b) =>
        (a.result.daysRemaining ?? 999999).compareTo(b.result.daysRemaining ?? 999999));
    reminders.assignAll(results);
  }

  String categoryName(String categoriaId) =>
      categoriesById[categoriaId]?.nome ?? 'Categoria';

  Future<void> atualizarKm(int novoKm) async {
    await _db.updateVehicleKm(vehicle.id, novoKm);
    // Não precisa mais fazer copyWith manual aqui — o watchVehicleById acima
    // já vai atualizar `vehicle` sozinho assim que o banco mudar.
    final list = await _db.streamRemindersForVehicle(vehicle.id).first;
    await _recalculateReminders(list);
    await _notificationService.rescheduleAllForVehicle(_db, vehicle);
  }

  /// Cancela as notificações de todos os lembretes do veículo e remove o
  /// veículo (junto com histórico e lembretes) do banco.
  Future<void> excluirVeiculo() async {
    for (final item in reminders) {
      await _notificationService.cancelReminderNotification(item.reminder.id);
    }
    await _db.deleteVehicle(vehicle.id);
  }
}