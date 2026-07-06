import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../core/services/notification_service.dart';
import '../../data/local/app_database.dart';

class AddEventController extends GetxController {
  final AppDatabase _db = Get.find<AppDatabase>();
  final NotificationService _notificationService = Get.find<NotificationService>();
  final ImagePicker _imagePicker = ImagePicker();
  final _uuid = const Uuid();
  late Vehicle vehicle;

  final RxList<MaintenanceCategory> categorias = <MaintenanceCategory>[].obs;
  final Rx<MaintenanceCategory?> categoriaSelecionada =
      Rx<MaintenanceCategory?>(null);

  final Rx<DateTime> data = DateTime.now().obs;
  final kmController = TextEditingController();
  final valorController = TextEditingController();
  final oficinaController = TextEditingController();
  final observacaoController = TextEditingController();

  final RxBool isSaving = false.obs;
  final Rx<File?> anexoSelecionado = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    vehicle = Get.arguments as Vehicle;
    kmController.text = vehicle.kmAtual.toString();
    _loadCategorias();
  }

  Future<void> _loadCategorias() async {
    final list = await _db.categoriesForType(vehicle.tipo);
    categorias.assignAll(list);
    if (list.isNotEmpty) categoriaSelecionada.value = list.first;
  }

  Future<void> escolherAnexoDaCamera() => _escolherAnexo(ImageSource.camera);
  Future<void> escolherAnexoDaGaleria() => _escolherAnexo(ImageSource.gallery);

  Future<void> _escolherAnexo(ImageSource source) async {
    final foto = await _imagePicker.pickImage(source: source, maxWidth: 1600);
    if (foto == null) return;

    // Copia pra uma pasta persistente do app — o caminho temporário que o
    // image_picker devolve pode ser limpo pelo sistema depois, então não dá
    // pra confiar em salvar só esse caminho no banco.
    final docsDir = await getApplicationDocumentsDirectory();
    final anexosDir = Directory(p.join(docsDir.path, 'anexos'));
    if (!await anexosDir.exists()) {
      await anexosDir.create(recursive: true);
    }
    final extensao = p.extension(foto.path);
    final novoCaminho = p.join(anexosDir.path, '${_uuid.v4()}$extensao');
    final arquivoCopiado = await File(foto.path).copy(novoCaminho);

    anexoSelecionado.value = arquivoCopiado;
  }

  void removerAnexo() => anexoSelecionado.value = null;

  Future<void> salvar() async {
    if (categoriaSelecionada.value == null) {
      Get.snackbar('Falta a categoria', 'Escolha o tipo de manutenção.');
      return;
    }

    isSaving.value = true;
    try {
      final km = int.tryParse(kmController.text);
      await _db.insertEvent(
        veiculoId: vehicle.id,
        categoriaId: categoriaSelecionada.value!.id,
        dataRealizada: data.value,
        kmRealizado: km,
        valorGasto: double.tryParse(valorController.text.replaceAll(',', '.')),
        oficina: oficinaController.text.trim().isEmpty
            ? null
            : oficinaController.text.trim(),
        observacao: observacaoController.text.trim().isEmpty
            ? null
            : observacaoController.text.trim(),
        anexoPath: anexoSelecionado.value?.path,
      );

      // Se o km informado for maior que o atual do veículo, atualiza —
      // é o "sensor" mais confiável que o app tem: o próprio usuário
      // reportando quilometragem ao registrar manutenção.
      if (km != null && km > vehicle.kmAtual) {
        await _db.updateVehicleKm(vehicle.id, km);
        vehicle = vehicle.copyWith(kmAtual: km, kmAtualizadoEm: DateTime.now());
      }

      // Uma manutenção nova também muda o histórico usado na estimativa por
      // km, e pode ter zerado a contagem de uma categoria — reagenda tudo
      // pra manter a notificação alinhada com o cálculo mais recente.
      await _notificationService.rescheduleAllForVehicle(_db, vehicle);

      Get.back();
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    kmController.dispose();
    valorController.dispose();
    oficinaController.dispose();
    observacaoController.dispose();
    super.onClose();
  }
}