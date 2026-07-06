import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/local/tables.dart';
import 'add_vehicle_controller.dart';

class AddVehicleView extends GetView<AddVehicleController> {
  const AddVehicleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.isEditing ? 'Editar veículo' : 'Novo veículo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Obx(
            () => SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: VehicleType.carro,
                  label: Text('Carro'),
                  icon: Icon(Icons.directions_car),
                ),
                ButtonSegment(
                  value: VehicleType.moto,
                  label: Text('Moto'),
                  icon: Icon(Icons.two_wheeler),
                ),
              ],
              selected: {controller.tipoSelecionado.value},
              onSelectionChanged: (value) =>
                  controller.tipoSelecionado.value = value.first,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: controller.nomeController,
            decoration: const InputDecoration(
              labelText: 'Nome / apelido',
              hintText: 'Ex: Onix 2020, CG 160 Fan',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controller.placaController,
            decoration: const InputDecoration(
              labelText: 'Placa (opcional)',
              border: OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.characters,
          ),
          if (!controller.isEditing) ...[
            const SizedBox(height: 16),
            TextField(
              controller: controller.kmController,
              decoration: const InputDecoration(
                labelText: 'Km atual',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
          const SizedBox(height: 24),
          Obx(
            () => FilledButton(
              onPressed: controller.isSaving.value ? null : controller.salvar,
              child: controller.isSaving.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Salvar'),
            ),
          ),
        ],
      ),
    );
  }
}
