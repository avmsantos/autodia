import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../theme/app_colors.dart';
import 'paywall_controller.dart';

class PaywallView extends GetView<PaywallController> {
  const PaywallView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Premium', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.isPremium) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Você já é Premium. Obrigado pelo apoio!',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 16),
              ),
            ),
          );
        }

        final packages = controller.offering.value?.availablePackages ?? [];

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            // Hero
            Center(
              child: Column(
                children: [
                  Container(
                    width: 112,
                    height: 112,
                    decoration: const BoxDecoration(
                      color: AppColors.premiumHeroBg,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.workspace_premium,
                      size: 56,
                      color: AppColors.premiumHeroIcon,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Vantagens do Premium',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.onBackground),
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'Eleve a gestão do seu veículo a um nível profissional '
                      'com recursos exclusivos de precisão técnica.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.onSurfaceVariant, height: 1.4, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Benefícios
            const _BenefitCard(
              icon: Icons.block,
              title: 'Sem anúncios',
              description: 'Foco total na manutenção sem interrupções visuais.',
            ),
            const SizedBox(height: 12),
            const _BenefitCard(
              icon: Icons.speed,
              title: 'Lembrete por quilometragem rodada',
              description: 'Alertas precisos baseados no desgaste real do seu motor.',
            ),
            const SizedBox(height: 12),
            const _BenefitCard(
              icon: Icons.document_scanner_outlined,
              title: 'Leitura automática (OCR)',
              description: 'Digitalize faturas e documentos em segundos via câmera.',
            ),
            const SizedBox(height: 12),
            const _BenefitCard(
              icon: Icons.bar_chart,
              title: 'Relatório de gastos',
              description: 'Análise técnica detalhada da economia do seu veículo.',
            ),
            const SizedBox(height: 28),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                'ESCOLHA SEU PLANO',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                  color: AppColors.onBackground,
                ),
              ),
            ),
            const SizedBox(height: 10),

            if (packages.isEmpty)
             const Padding(
                padding:  EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Nenhum plano disponível no momento.',
                  style: TextStyle(color: AppColors.onSurfaceVariant),
                ),
              )
            else
              Obx(
                () => _PlansSection(
                  packages: packages,
                  isPurchasing: controller.isPurchasing.value,
                  onConfirm: controller.comprar,
                ),
              ),

            const SizedBox(height: 8),
            Center(
              child: Obx(
                () => TextButton(
                  onPressed: controller.isPurchasing.value ? null : controller.restaurar,
                  style: TextButton.styleFrom(foregroundColor: AppColors.onBackground),
                  child: const Text(
                    'Restaurar compra anterior',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
           const Text(
              'Assinaturas renovadas automaticamente. Cancele quando quiser '
              'nas configurações da loja.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.outline,
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _BenefitCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _BenefitCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.benefitIconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.benefitIcon, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.onBackground)),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Lista de planos com seleção visual local (destaca o plano escolhido) e um
/// botão único de confirmação — isso é só estado de UI; a chamada de compra
/// de verdade continua sendo `controller.comprar(pkg)`, exatamente como
/// antes.
class _PlansSection extends StatefulWidget {
  final List<Package> packages;
  final bool isPurchasing;
  final void Function(Package pkg) onConfirm;

  const _PlansSection({
    required this.packages,
    required this.isPurchasing,
    required this.onConfirm,
  });

  @override
  State<_PlansSection> createState() => _PlansSectionState();
}

class _PlansSectionState extends State<_PlansSection> {
  late int _selectedIndex = _defaultIndex();

  int _defaultIndex() {
    final annualIndex = widget.packages.indexWhere(
      (p) => !(p.identifier).contains('monthly'),
    );
    return annualIndex >= 0 ? annualIndex : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < widget.packages.length; i++) ...[
          _PlanCard(
            label: (widget.packages[i].identifier).contains('monthly')
                ? 'Plano Mensal'
                : 'Plano Anual',
            subtitle: (widget.packages[i].identifier).contains('monthly')
                ? 'Flexibilidade total'
                : 'Cobrança anual, economize 15% ao ano',
            price: widget.packages[i].storeProduct.priceString,
            period: (widget.packages[i].identifier).contains('monthly')
                ? '/mês'
                : '/ano',
            selected: _selectedIndex == i,
            onTap: () => setState(() => _selectedIndex = i),
          ),
          const SizedBox(height: 12),
        ],
        const SizedBox(height: 4),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: FilledButton(
            onPressed: widget.isPurchasing
                ? null
                : () => widget.onConfirm(widget.packages[_selectedIndex]),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.onBackground,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: widget.isPurchasing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Text(
                    'Assinar Agora',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                  ),
          ),
        ),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String label;
  final String subtitle;
  final String price;
  final String period;
  final bool selected;
  final VoidCallback onTap;

  const _PlanCard({
    required this.label,
    required this.subtitle,
    required this.price,
    required this.period,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: selected ? AppColors.planSelectedBg : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.planSelectedBorder : AppColors.outlineVariant.withValues(alpha: 0.3),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13)),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.premiumHeroIcon,
                  ),
                ),
                Text(period, style: const TextStyle(color: AppColors.outline, fontSize: 11)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}