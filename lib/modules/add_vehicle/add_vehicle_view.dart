import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/local/tables.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_style.dart';
import 'add_vehicle_controller.dart';

class AddVehicleView extends GetView<AddVehicleController> {
  const AddVehicleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.isEditing ? 'Editar veículo' : 'Novo veículo',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Card ilustrativo
          Container(
            width: double.infinity,
            height: 160,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              controller.isEditing ? 'Atualize seu veículo' : 'Cadastre seu veículo',
              textAlign: TextAlign.center,
              style: AppTextStyles.headlineMd.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Segmented control Carro / Moto
          Obx(
            () => Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _TypeTab(
                      icon: Icons.directions_car,
                      label: 'Carro',
                      selected: controller.tipoSelecionado.value == VehicleType.carro,
                      onTap: () => controller.tipoSelecionado.value = VehicleType.carro,
                    ),
                  ),
                  Expanded(
                    child: _TypeTab(
                      icon: Icons.two_wheeler,
                      label: 'Moto',
                      selected: controller.tipoSelecionado.value == VehicleType.moto,
                      onTap: () => controller.tipoSelecionado.value = VehicleType.moto,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Campos do formulário
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                TextField(
                  controller: controller.nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome / apelido',
                    hintText: 'Ex: Onix 2020, CG 160 Fan',
                    suffixIcon: Icon(Icons.badge_outlined, size: 20),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller.placaController,
                  decoration: const InputDecoration(
                    labelText: 'Placa (opcional)',
                    suffixIcon: Icon(Icons.confirmation_number_outlined, size: 20),
                  ),
                  textCapitalization: TextCapitalization.characters,
                ),
                if (!controller.isEditing) ...[
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller.kmController,
                    decoration: const InputDecoration(
                      labelText: 'Km atual',
                      suffixIcon: Icon(Icons.speed_outlined, size: 20),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Botão salvar
          Obx(
            () => SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: controller.isSaving.value ? null : controller.salvar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.onBackground,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.onBackground.withValues(alpha: 0.6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                ),
                child: controller.isSaving.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Salvar Veículo',
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.save_outlined, size: 20),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeTab extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TypeTab({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? AppColors.onBackground : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: selected ? AppColors.surface : AppColors.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: selected ? AppColors.surface : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}