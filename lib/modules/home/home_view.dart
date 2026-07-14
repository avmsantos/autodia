import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../core/services/notification_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/ad_banner_widget.dart';
import '../../widgets/vehicle_card.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationService = Get.find<NotificationService>();

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 56,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16),
          child: Icon(Icons.directions_car_outlined, color: AppColors.onBackground),
        ),
        title: const Text(
          'Meus veículos',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                notificationService.notificacoesAtivas.value
                    ? Icons.notifications_active_outlined
                    : Icons.notifications_off_outlined,
              ),
              tooltip: notificationService.notificacoesAtivas.value
                  ? 'Configurar notificações'
                  : 'Configurar notificações',
              onPressed: () => Get.toNamed(AppRoutes.notificationSettings),
            ),
          ),
          Obx(
            () => IconButton(
              icon: Icon(
                Icons.account_circle,
                color: controller.isPremium ? AppColors.onBackground : null,
              ),
              tooltip: 'Perfil',
              onPressed: () => Get.toNamed(AppRoutes.profile),
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: controller.vehicles.length,
                itemBuilder: (context, index) {
                  final item = controller.vehicles[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: VehicleCard(
                      item: item,
                      onTap: () => Get.toNamed(
                        AppRoutes.vehicleDetail,
                        arguments: item.vehicle,
                      ),
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
        backgroundColor: AppColors.onBackground,
        foregroundColor: AppColors.onPrimary,
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
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      color: AppColors.secondaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide.none,
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.battery_alert_outlined, color: AppColors.onSecondaryContainer),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Garanta que os lembretes cheguem',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSecondaryContainer,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Alguns celulares (Xiaomi, Samsung e outros) fecham apps '
                    'em segundo plano e podem bloquear notificações.',
                    style: TextStyle(fontSize: 12, color: AppColors.onSecondaryContainer),
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
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             Icon(Icons.directions_car_outlined, size: 64, color: AppColors.onBackground),
             SizedBox(height: 16),
             Text(
              'Nenhum veículo cadastrado ainda',
              style: TextStyle(color: AppColors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}