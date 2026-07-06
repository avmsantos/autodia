import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/local/app_database.dart';
import '../../data/local/tables.dart';

class AddVehicleController extends GetxController {
  final AppDatabase _db = Get.find<AppDatabase>();

  Vehicle? _editingVehicle;
  bool get isEditing => _editingVehicle != null;

  final nomeController = TextEditingController();
  final placaController = TextEditingController();
  final kmController = TextEditingController(text: '0');

  final Rx<String> tipoSelecionado = VehicleType.carro.obs;
  final RxBool isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Se veio um Vehicle como argumento, é edição; senão, cadastro novo.
    final args = Get.arguments;
    if (args is Vehicle) {
      _editingVehicle = args;
      tipoSelecionado.value = args.tipo;
      nomeController.text = args.nome;
      placaController.text = args.placa ?? '';
      kmController.text = args.kmAtual.toString();
    }
  }

  Future<void> salvar() async {
    if (nomeController.text.trim().isEmpty) {
      Get.snackbar('Falta o nome', 'Dá um nome pro veículo (ex: "Onix 2020").');
      return;
    }

    isSaving.value = true;
    try {
      if (isEditing) {
        await _db.updateVehicle(
          vehicleId: _editingVehicle!.id,
          tipo: tipoSelecionado.value,
          nome: nomeController.text.trim(),
          placa: placaController.text.trim().isEmpty
              ? null
              : placaController.text.trim(),
        );
        // Km não é editável aqui de propósito — a atualização de km tem
        // efeito em cascata nos lembretes/notificações, então fica só na
        // tela de detalhe do veículo, onde isso já é tratado corretamente.
      } else {
        await _db.insertVehicle(
          tipo: tipoSelecionado.value,
          nome: nomeController.text.trim(),
          placa: placaController.text.trim().isEmpty
              ? null
              : placaController.text.trim(),
          kmAtual: int.tryParse(kmController.text) ?? 0,
        );
      }
      Get.back();
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    nomeController.dispose();
    placaController.dispose();
    kmController.dispose();
    super.onClose();
  }
}
