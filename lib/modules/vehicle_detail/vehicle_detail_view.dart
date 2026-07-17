import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../app/routes/app_routes.dart';
import '../../core/services/purchase_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/ad_banner_widget.dart';
import '../../widgets/status_badge.dart';
import 'vehicle_detail_controller.dart';

class VehicleDetailView extends GetView<VehicleDetailController> {
  const VehicleDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Obx(
            () => Text(
              controller.vehicle.nome,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.bar_chart_outlined),
              tooltip: 'Relatório de gastos',
              onPressed: () {
                if (controller.isPremium) {
                  Get.toNamed(AppRoutes.report, arguments: controller.vehicle);
                } else {
                  Get.toNamed(AppRoutes.paywall);
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Editar veículo',
              onPressed: () => Get.toNamed(
                AppRoutes.addVehicle,
                arguments: controller.vehicle,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Excluir veículo',
              onPressed: () => _confirmarExclusaoVeiculo(context),
            ),
          ],
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(80),
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: _SegmentedTabs(),
            ),
          ),
        ),
        body: Column(
          children: [
            const Expanded(
              child: TabBarView(
                children: [
                  _RemindersTabContent(),
                  _HistoryTabContent(),
                ],
              ),
            ),
            Obx(() {
              final isPremium = Get.find<PurchaseService>().isPremium.value;
              return isPremium
                  ? const SizedBox.shrink()
                  : const SafeArea(top: false, child: AdBannerWidget());
            }),
          ],
        ),
        floatingActionButton: Builder(builder: (context) {
          final tabController = DefaultTabController.of(context);
          return AnimatedBuilder(
            animation: tabController,
            builder: (context, _) {
              final isReminderTab = tabController.index == 0;
              return FloatingActionButton.extended(
                backgroundColor: AppColors.onBackground,
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
                onPressed: () {
                  if (isReminderTab) {
                    Get.toNamed(
                      AppRoutes.addReminder,
                      arguments: {'vehicle': controller.vehicle},
                    );
                  } else {
                    Get.toNamed(
                      AppRoutes.addEvent,
                      arguments: {'vehicle': controller.vehicle},
                    );
                  }
                },
                icon: const Icon(Icons.add),
                label: Text(
                  isReminderTab ? 'Lembrete' : 'Manutenção',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Future<void> _confirmarExclusaoVeiculo(BuildContext context) async {
    final confirmou = await showGeneralDialog<bool>(
      context: context,
      barrierLabel: 'Excluir veículo',
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.15),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
      transitionBuilder: (context, anim1, anim2, _) {
        final blur = 6 * anim1.value;
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: FadeTransition(
            opacity: anim1,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.94, end: 1).animate(
                CurvedAnimation(parent: anim1, curve: Curves.easeOut),
              ),
              child: const _DeleteVehicleDialog(),
            ),
          ),
        );
      },
    );
    if (confirmou == true) {
      await controller.excluirVeiculo();
      Get.back();
    }
  }
}

/// Alerta de exclusão de veículo com fundo desfocado (mesmo tratamento do
/// alerta de exclusão de conta) — só aparência, a chamada real continua em
/// `controller.excluirVeiculo()`.
class _DeleteVehicleDialog extends StatelessWidget {
  const _DeleteVehicleDialog();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: AppColors.dangerBorder,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.warning_amber_rounded,
                      color: AppColors.error, size: 28),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Excluir veículo?',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text.rich(
                  TextSpan(
                    style: TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 14,
                        height: 1.4),
                    children: [
                      TextSpan(
                        text:
                            'Isso remove o veículo, o histórico de manutenções e os '
                            'lembretes associados a ele. ',
                      ),
                      TextSpan(
                        text: 'Não dá pra desfazer.',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.error,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text(
                      'Excluir',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: TextButton.styleFrom(
                      foregroundColor: AppColors.onSurfaceVariant,),
                  child: const Text('Cancelar',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Pill de navegação Lembretes/Histórico: fundo cinza, aba selecionada
/// em branco com sombra — controla a mesma TabController do
/// DefaultTabController, não é um estado novo de negócio.
class _SegmentedTabs extends StatelessWidget {
  const _SegmentedTabs();

  @override
  Widget build(BuildContext context) {
    final tabController = DefaultTabController.of(context);
    return AnimatedBuilder(
      animation: tabController,
      builder: (context, _) {
        return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Expanded(
                child: _SegmentButton(
                  label: 'Lembretes',
                  selected: tabController.index == 0,
                  onTap: () => tabController.animateTo(0),
                ),
              ),
              Expanded(
                child: _SegmentButton(
                  label: 'Histórico',
                  selected: tabController.index == 1,
                  onTap: () => tabController.animateTo(1),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SegmentButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SegmentButton(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color:
                selected ? AppColors.onBackground : AppColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _RemindersTabContent extends GetView<VehicleDetailController> {
  const _RemindersTabContent();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.reminders.isEmpty) {
        return const _EmptyTabState(
          icon: Icons.notifications_none_rounded,
          title: 'Sem lembretes',
          description:
              'Nenhum lembrete configurado ainda. Adicione um pra ser avisado '
              'na hora certa.',
        );
      }
      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        itemCount: controller.reminders.length,
        itemBuilder: (context, index) {
          final item = controller.reminders[index];
          final result = item.result;
          // Sem um campo de ícone por categoria no modelo, uso a presença
          // de km como pista visual: lembrete com km envolvido ganha ícone
          // de "medidor", os baseados só em data ganham ícone de documento.
          final temKm = result.nextDueKm != null;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Material(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => Get.toNamed(
                  AppRoutes.addReminder,
                  arguments: {
                    'vehicle': controller.vehicle,
                    'reminder': item.reminder,
                  },
                ),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                        color: AppColors.outlineVariant.withValues(alpha: 0.4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.onSecondaryContainer,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              temKm ? Icons.build : Icons.payments,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              controller
                                  .categoryName(item.reminder.categoriaId),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 16),
                            ),
                          ),
                          StatusBadge(status: result.status),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(height: 1),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            temKm
                                ? Icons.speed_outlined
                                : Icons.calendar_today_outlined,
                            size: 16,
                            color: AppColors.onSurfaceVariant,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _subtitleFor(result),
                              style: const TextStyle(
                                  color: AppColors.onSurfaceVariant,
                                  fontSize: 13),
                            ),
                          ),
                          const Icon(Icons.chevron_right,
                              color: AppColors.outlineVariant),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }

  String _subtitleFor(dynamic result) {
    final parts = <String>[];
    if (result.effectiveDueDate != null) {
      parts.add(
          'até ${DateFormat('dd/MM/yyyy').format(result.effectiveDueDate)}');
    }
    if (result.nextDueKm != null) {
      parts.add('ou ${result.nextDueKm} km');
    }
    return parts.isEmpty ? 'Sem previsão' : parts.join(' ');
  }
}

class _HistoryTabContent extends GetView<VehicleDetailController> {
  const _HistoryTabContent();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.events.isEmpty) {
        return const _EmptyTabState(
          icon: Icons.history_rounded,
          title: 'Sem registros',
          description:
              'Nenhuma manutenção registrada ainda. Adicione sua primeira '
              'atividade para começar a monitorar o ciclo de vida do seu '
              'veículo.',
        );
      }

      final totalGasto = controller.events
          .fold<double>(0, (sum, e) => sum + (e.valorGasto ?? 0));

      return ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        children: [
          Center(
            child: Column(
              children: [
                const Text(
                  'TOTAL GASTO',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                    color: AppColors.outline,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'R\$ ${totalGasto.toStringAsFixed(2).replaceAll('.', ',')}',
                  style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ...controller.events.map((e) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Material(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => Get.toNamed(
                    AppRoutes.addEvent,
                    arguments: {'vehicle': controller.vehicle, 'event': e},
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                          color:
                              AppColors.outlineVariant.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: e.anexoPath != null
                              ? Image.file(
                                  File(e.anexoPath!),
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: 48,
                                  height: 48,
                                  color: AppColors.surfaceContainerLow,
                                  child: const Icon(Icons.receipt_long_outlined,
                                      color: AppColors.outline, size: 20),
                                ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.categoryName(e.categoriaId),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                [
                                  DateFormat('dd/MM/yyyy')
                                      .format(e.dataRealizada),
                                  if (e.kmRealizado != null)
                                    '${e.kmRealizado} km',
                                  if (e.oficina != null) e.oficina!,
                                ].join(' · '),
                                style: const TextStyle(
                                    color: AppColors.onSurfaceVariant,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        if (e.valorGasto != null)
                          Text(
                            'R\$ ${e.valorGasto!.toStringAsFixed(2).replaceAll('.', ',')}',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      );
    });
  }
}

class _EmptyTabState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _EmptyTabState({
    required this.icon,
    required this.title,
    required this.description,
  })  : actionLabel = null,
        onAction = null;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, size: 40, color: AppColors.secondary),
            ),
            const SizedBox(height: 20),
            Text(title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppColors.onSurfaceVariant, height: 1.4),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed: onAction,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.onBackground,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(actionLabel!,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
