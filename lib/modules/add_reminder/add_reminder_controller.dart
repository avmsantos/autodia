import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/services/notification_service.dart';
import '../../core/services/ocr_service.dart';
import '../../core/services/purchase_service.dart';
import '../../data/local/app_database.dart';
import '../../data/local/tables.dart';
import '../../widgets/app_snackbar.dart';

class AddReminderController extends GetxController {
  final AppDatabase _db = Get.find<AppDatabase>();
  final PurchaseService _purchaseService = Get.find<PurchaseService>();
  final NotificationService _notificationService = Get.find<NotificationService>();
  final OcrService _ocrService = OcrService();
  final ImagePicker _imagePicker = ImagePicker();

  late final Vehicle vehicle;
  Reminder? _editingReminder;
  bool get isEditing => _editingReminder != null;

  final RxList<MaintenanceCategory> categorias = <MaintenanceCategory>[].obs;
  final Rx<MaintenanceCategory?> categoriaSelecionada =
      Rx<MaintenanceCategory?>(null);

  /// true quando a categoria escolhida é documento/custo fixo (IPVA, seguro,
  /// licenciamento) — nesse caso não faz sentido perguntar km nenhum.
  bool get isCalendarCategory =>
      categoriaSelecionada.value?.tipoCalculo ==
      CategoryCalculationType.calendario;

  // ---- Campos comuns ----
  final Rx<DateTime> ultimaData = DateTime.now().obs;
  final ultimoKmController = TextEditingController();

  // ---- Campos só de categoria mecânica (uso) ----
  final RxBool usarData = true.obs;
  final RxBool usarKm = false.obs; // recurso Premium
  final intervaloMesesController = TextEditingController(text: '12');
  final intervaloKmController = TextEditingController(text: '10000');

  // ---- Campos só de categoria calendário (documento) ----
  final Rx<DateTime> dataVencimento =
      DateTime.now().add(const Duration(days: 365)).obs;
  final valorPagoController = TextEditingController();

  final RxBool isSaving = false.obs;
  final RxBool isScanning = false.obs;

  bool get isPremium => _purchaseService.isPremium.value;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    vehicle = args['vehicle'] as Vehicle;
    _editingReminder = args['reminder'] as Reminder?;
    ultimoKmController.text = vehicle.kmAtual.toString();
    _loadCategorias();
  }

  Future<void> _loadCategorias() async {
    final list = await _db.categoriesForType(vehicle.tipo);
    categorias.assignAll(list);

    if (_editingReminder != null) {
      _preencherParaEdicao(_editingReminder!, list);
    } else if (list.isNotEmpty) {
      categoriaSelecionada.value = list.first;
    }
  }

  void _preencherParaEdicao(Reminder r, List<MaintenanceCategory> list) {
    categoriaSelecionada.value = list.firstWhereOrNull((c) => c.id == r.categoriaId);
    ultimaData.value = r.ultimaDataFeita;
    ultimoKmController.text = (r.ultimoKmFeito ?? vehicle.kmAtual).toString();
    usarData.value = r.intervaloMeses != null;
    usarKm.value = r.intervaloKm != null;
    if (r.intervaloMeses != null) {
      intervaloMesesController.text = r.intervaloMeses.toString();
    }
    if (r.intervaloKm != null) {
      intervaloKmController.text = r.intervaloKm.toString();
    }
    if (r.dataVencimentoManual != null) {
      dataVencimento.value = r.dataVencimentoManual!;
    }
    if (r.valorPago != null) {
      valorPagoController.text = r.valorPago.toString();
    }
  }

  void selecionarCategoria(String? id) {
    if (id == null) return;
    categoriaSelecionada.value = categorias.firstWhere((c) => c.id == id);
  }

  /// Leitura automática de documento é feature Premium — tira foto do CRLV,
  /// boleto de IPVA ou apólice de seguro e tenta preencher a data de
  /// vencimento sozinho.
  Future<void> escanearDocumento() async {
    if (!isPremium) {
      Get.toNamed('/premium');
      return;
    }

    final foto = await _imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1600, // suficiente pra OCR, evita foto gigante lenta de processar
    );
    if (foto == null) return;

    isScanning.value = true;
    try {
      final dataEncontrada = await _ocrService.extractDueDateFromImage(foto.path);
      if (dataEncontrada != null) {
        dataVencimento.value = dataEncontrada;
        showSuccessSnackbar(
          title: 'Data encontrada',
          message: 'Confira se ${_formatarData(dataEncontrada)} está certo antes de salvar.',
        );
      } else {
        showErrorSnackbar(
          title: 'Não encontrei a data',
          message: 'Preenche manualmente — a leitura automática não conseguiu identificar.',
        );
      }
    } finally {
      isScanning.value = false;
    }
  }

  String _formatarData(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  /// Lembrete por km é feature Premium (é a parte mais trabalhosa do
  /// cálculo — estimativa por média de uso do veículo).
  void toggleUsarKm(bool value) {
    if (value && !isPremium) {
      Get.toNamed('/premium');
      return;
    }
    usarKm.value = value;
  }

  Future<void> salvar() async {
    if (categoriaSelecionada.value == null) {
      showErrorSnackbar(
        title: 'Falta a categoria',
        message: 'Escolha o tipo de manutenção.',
      );
      return;
    }

    if (isCalendarCategory) {
      await _salvarCalendario();
    } else {
      await _salvarMecanica();
    }
  }

  Future<void> _salvarCalendario() async {
    isSaving.value = true;
    try {
      final valor = double.tryParse(valorPagoController.text.replaceAll(',', '.'));
      if (isEditing) {
        await _db.updateReminder(
          reminderId: _editingReminder!.id,
          ultimaDataFeita: ultimaData.value,
          dataVencimentoManual: dataVencimento.value,
          valorPago: valor,
        );
      } else {
        await _db.insertReminder(
          veiculoId: vehicle.id,
          categoriaId: categoriaSelecionada.value!.id,
          ultimaDataFeita: ultimaData.value,
          dataVencimentoManual: dataVencimento.value,
          valorPago: valor,
        );
      }
      await _notificationService.rescheduleAllForVehicle(_db, vehicle);
      Get.back();
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> _salvarMecanica() async {
    if (!usarData.value && !usarKm.value) {
      showErrorSnackbar(
        title: 'Falta o gatilho',
        message: 'Escolha ao menos data ou km.',
      );
      return;
    }

    isSaving.value = true;
    try {
      final ultimoKm = int.tryParse(ultimoKmController.text);
      final meses = usarData.value ? int.tryParse(intervaloMesesController.text) : null;
      final km = usarKm.value ? int.tryParse(intervaloKmController.text) : null;

      if (isEditing) {
        await _db.updateReminder(
          reminderId: _editingReminder!.id,
          ultimaDataFeita: ultimaData.value,
          ultimoKmFeito: ultimoKm,
          intervaloMeses: meses,
          intervaloKm: km,
        );
      } else {
        await _db.insertReminder(
          veiculoId: vehicle.id,
          categoriaId: categoriaSelecionada.value!.id,
          ultimaDataFeita: ultimaData.value,
          ultimoKmFeito: ultimoKm,
          intervaloMeses: meses,
          intervaloKm: km,
        );
      }
      await _notificationService.rescheduleAllForVehicle(_db, vehicle);
      Get.back();
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> excluir() async {
    if (_editingReminder == null) return;
    await _db.deleteReminder(_editingReminder!.id);
    await _notificationService.cancelReminderNotification(_editingReminder!.id);
    Get.back();
  }

  @override
  void onClose() {
    ultimoKmController.dispose();
    intervaloMesesController.dispose();
    intervaloKmController.dispose();
    valorPagoController.dispose();
    _ocrService.dispose();
    super.onClose();
  }
}