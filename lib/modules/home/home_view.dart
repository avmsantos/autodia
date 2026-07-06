import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../core/services/notification_service.dart';
import '../../widgets/ad_banner_widget.dart';
import '../../widgets/vehicle_card.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus veículos'),
        actions: [
          // TEMPORÁRIO — botão de debug pra testar notificação imediata.
          // Remove depois que resolver o problema do agendamento.
          IconButton(
            icon: const Icon(Icons.notifications_active_outlined),
            tooltip: 'Testar notificação',
            onPressed: () =>
                Get.find<NotificationService>().testarNotificacaoImediata(),
          ),
          Obx(
            () => IconButton(
              icon: Icon(
                Icons.workspace_premium,
                color: controller.isPremium ? Colors.amber : null,
              ),
              tooltip: 'Premium',
              onPressed: () => Get.toNamed(AppRoutes.paywall),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Obx(() => controller.mostrarBannerBateria.value
              ? _BatteryOptimizationBanner(controller: controller)
              : const SizedBox.shrink()),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.vehicles.isEmpty) {
                return _EmptyState(
                  onAdd: () => Get.toNamed(AppRoutes.addVehicle),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: controller.vehicles.length,
                itemBuilder: (context, index) {
                  final item = controller.vehicles[index];
                  return VehicleCard(
                    item: item,
                    onTap: () => Get.toNamed(
                      AppRoutes.vehicleDetail,
                      arguments: item.vehicle,
                    ),
                  );
                },
              );
            }),
          ),
          // Banner discreto no footer — some sozinho pra usuário Premium.
          Obx(() => controller.isPremium
              ? const SizedBox.shrink()
              : const SafeArea(top: false, child: AdBannerWidget())),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.addVehicle),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _BatteryOptimizationBanner extends StatelessWidget {
  final HomeController controller;
  const _BatteryOptimizationBanner({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      color: Theme.of(context).colorScheme.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.battery_alert_outlined),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Garanta que os lembretes cheguem',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Alguns celulares (Xiaomi, Samsung e outros) fecham apps '
                    'em segundo plano e podem bloquear notificações.',
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      TextButton(
                        onPressed: controller.ajustarOtimizacaoBateria,
                        child: const Text('Ajustar agora'),
                      ),
                      TextButton(
                        onPressed: controller.dispensarBannerBateria,
                        child: const Text('Agora não'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.directions_car_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Nenhum veículo cadastrado ainda'),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('Cadastrar veículo'),
            ),
          ],
        ),
      ),
    );
  }
}