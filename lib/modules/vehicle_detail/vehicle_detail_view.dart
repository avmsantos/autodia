import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../app/routes/app_routes.dart';
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
          title: Obx(() => Text(controller.vehicle.nome)),
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
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Lembretes'),
              Tab(text: 'Histórico'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _RemindersTab(controller: controller),
            _HistoryTab(controller: controller),
          ],
        ),
        floatingActionButton: Builder(builder: (context) {
          final tabController = DefaultTabController.of(context);
          return AnimatedBuilder(
            animation: tabController,
            builder: (context, _) {
              final isReminderTab = tabController.index == 0;
              return FloatingActionButton.extended(
                onPressed: () {
                  if (isReminderTab) {
                    Get.toNamed(
                      AppRoutes.addReminder,
                      arguments: {'vehicle': controller.vehicle},
                    );
                  } else {
                    Get.toNamed(AppRoutes.addEvent, arguments: controller.vehicle);
                  }
                },
                icon: const Icon(Icons.add),
                label: Text(isReminderTab ? 'Lembrete' : 'Manutenção'),
              );
            },
          );
        }),
      ),
    );
  }

  Future<void> _confirmarExclusaoVeiculo(BuildContext context) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir veículo?'),
        content: const Text(
          'Isso remove o veículo, o histórico de manutenções e os lembretes '
          'associados a ele. Não dá pra desfazer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmou == true) {
      await controller.excluirVeiculo();
      Get.back();
    }
  }
}

class _RemindersTab extends StatelessWidget {
  final VehicleDetailController controller;
  const _RemindersTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.reminders.isEmpty) {
        return const Center(child: Text('Nenhum lembrete configurado ainda'));
      }
      return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: controller.reminders.length,
        itemBuilder: (context, index) {
          final item = controller.reminders[index];
          final result = item.result;
          return Card(
            child: ListTile(
              title: Text(controller.categoryName(item.reminder.categoriaId)),
              subtitle: Text(_subtitleFor(result)),
              trailing: StatusBadge(status: result.status),
              onTap: () => Get.toNamed(
                AppRoutes.addReminder,
                arguments: {
                  'vehicle': controller.vehicle,
                  'reminder': item.reminder,
                },
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
      parts.add('até ${DateFormat('dd/MM/yyyy').format(result.effectiveDueDate)}');
    }
    if (result.nextDueKm != null) {
      parts.add('ou ${result.nextDueKm} km');
    }
    return parts.isEmpty ? 'Sem previsão' : parts.join(' ');
  }
}

class _HistoryTab extends StatelessWidget {
  final VehicleDetailController controller;
  const _HistoryTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.events.isEmpty) {
        return const Center(child: Text('Nenhuma manutenção registrada ainda'));
      }
      final totalGasto = controller.events
          .fold<double>(0, (sum, e) => sum + (e.valorGasto ?? 0));

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Total gasto: R\$ ${totalGasto.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: controller.events.length,
              itemBuilder: (context, index) {
                final e = controller.events[index];
                return ListTile(
                  leading: e.anexoPath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.file(
                            File(e.anexoPath!),
                            width: 44,
                            height: 44,
                            fit: BoxFit.cover,
                          ),
                        )
                      : null,
                  title: Text(controller.categoryName(e.categoriaId)),
                  subtitle: Text(
                    '${DateFormat('dd/MM/yyyy').format(e.dataRealizada)}'
                    '${e.kmRealizado != null ? ' · ${e.kmRealizado} km' : ''}'
                    '${e.oficina != null ? ' · ${e.oficina}' : ''}',
                  ),
                  trailing: e.valorGasto != null
                      ? Text('R\$ ${e.valorGasto!.toStringAsFixed(2)}')
                      : null,
                );
              },
            ),
          ),
        ],
      );
    });
  }
}