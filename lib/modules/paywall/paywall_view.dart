import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'paywall_controller.dart';

class PaywallView extends GetView<PaywallController> {
  const PaywallView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Premium')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.isPremium) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text('Você já é Premium. Obrigado pelo apoio!'),
            ),
          );
        }

        final packages = controller.offering.value?.availablePackages ?? [];

        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Icon(Icons.workspace_premium, size: 56, color: Colors.orange),
            const SizedBox(height: 16),
            Text(
              'Vantagens do Premium',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            const _BenefitRow(icon: Icons.block, text: 'Sem anúncios'),
            const _BenefitRow(
              icon: Icons.speed,
              text: 'Lembrete por quilometragem rodada',
            ),
            const _BenefitRow(
              icon: Icons.camera_alt,
              text: 'Leitura automática de documentos (OCR)',
            ),
            const _BenefitRow(
              icon: Icons.bar_chart,
              text: 'Relatório de gastos por veículo',
            ),
            const SizedBox(height: 24),
            if (packages.isEmpty)
              const Text('Nenhum plano disponível no momento.')
            else
              ...packages.map((pkg) {
              String label = pkg.identifier.contains('monthly') ? 'Plano Mensal' : 'Plano Anual';
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: FilledButton(
                  onPressed: () => controller.comprar(pkg),
                  child: Text('$label · ${pkg.storeProduct.priceString}'),
                ),
              );
            }),
            TextButton(
              onPressed: controller.isPurchasing.value
                  ? null
                  : controller.restaurar,
              child: const Text('Restaurar compra anterior'),
            ),
          ],
        );
      }),
    );
  }
}

class _BenefitRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _BenefitRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.green),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
