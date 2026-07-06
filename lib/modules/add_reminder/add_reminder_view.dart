import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'add_reminder_controller.dart';

class AddReminderView extends GetView<AddReminderController> {
  const AddReminderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.isEditing ? 'Editar lembrete' : 'Novo lembrete'),
        actions: [
          if (controller.isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Excluir',
              onPressed: () => _confirmarExclusao(context),
            ),
        ],
      ),
      body: Obx(() {
        if (controller.categorias.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<String>(
              initialValue: controller.categoriaSelecionada.value?.id,
              decoration: const InputDecoration(
                labelText: 'Tipo de manutenção',
                border: OutlineInputBorder(),
              ),
              items: controller.categorias
                  .map((c) => DropdownMenuItem(value: c.id, child: Text(c.nome)))
                  .toList(),
              onChanged: controller.selecionarCategoria,
            ),
            const SizedBox(height: 16),
            if (controller.isCalendarCategory)
              _CalendarFields(controller: controller)
            else
              _MechanicalFields(controller: controller),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: controller.isSaving.value ? null : controller.salvar,
              child: controller.isSaving.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Salvar lembrete'),
            ),
          ],
        );
      }),
    );
  }

  Future<void> _confirmarExclusao(BuildContext context) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir lembrete?'),
        content: const Text('Isso remove o lembrete e cancela a notificação agendada.'),
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
      await controller.excluir();
    }
  }
}

/// Campos pra categorias mecânicas (troca de óleo, pneu, freio, etc.) —
/// baseadas em desgaste, então fazem sentido data E/OU km.
class _MechanicalFields extends StatelessWidget {
  final AddReminderController controller;
  const _MechanicalFields({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Última vez feita'),
            subtitle:
                Text(DateFormat('dd/MM/yyyy').format(controller.ultimaData.value)),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: controller.ultimaData.value,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (picked != null) controller.ultimaData.value = picked;
            },
          ),
          TextField(
            controller: controller.ultimoKmController,
            decoration: const InputDecoration(
              labelText: 'Km na última vez (opcional)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const Divider(height: 32),
          Text('Repetir a cada:', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Por tempo'),
            value: controller.usarData.value,
            onChanged: (v) => controller.usarData.value = v,
          ),
          if (controller.usarData.value)
            TextField(
              controller: controller.intervaloMesesController,
              decoration: const InputDecoration(
                labelText: 'Intervalo em meses',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Row(
              children: [
                const Text('Por quilometragem'),
                if (!controller.isPremium) ...[
                  const SizedBox(width: 6),
                  const Icon(Icons.lock, size: 16, color: Colors.orange),
                ],
              ],
            ),
            subtitle: controller.isPremium ? null : const Text('Recurso Premium'),
            value: controller.usarKm.value,
            onChanged: controller.toggleUsarKm,
          ),
          if (controller.usarKm.value)
            TextField(
              controller: controller.intervaloKmController,
              decoration: const InputDecoration(
                labelText: 'Intervalo em km',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
        ],
      ),
    );
  }
}

/// Campos pra categorias de documento/custo fixo (IPVA, seguro,
/// licenciamento) — não envolve km, só datas e valor pago.
class _CalendarFields extends StatelessWidget {
  final AddReminderController controller;
  const _CalendarFields({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OutlinedButton.icon(
            onPressed: controller.isScanning.value ? null : controller.escanearDocumento,
            icon: controller.isScanning.value
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(
                    Icons.document_scanner_outlined,
                    color: controller.isPremium ? null : Colors.orange,
                  ),
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Escanear documento'),
                if (!controller.isPremium) ...[
                  const SizedBox(width: 6),
                  const Icon(Icons.lock, size: 14, color: Colors.orange),
                ],
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tira foto do CRLV, boleto ou apólice e a data de vencimento é '
            'preenchida automaticamente.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Data de pagamento'),
            subtitle:
                Text(DateFormat('dd/MM/yyyy').format(controller.ultimaData.value)),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: controller.ultimaData.value,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) controller.ultimaData.value = picked;
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Data de vencimento'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy').format(controller.dataVencimento.value),
            ),
            trailing: const Icon(Icons.event),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: controller.dataVencimento.value,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) controller.dataVencimento.value = picked;
            },
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller.valorPagoController,
            decoration: const InputDecoration(
              labelText: 'Valor pago (opcional)',
              prefixText: 'R\$ ',
              border: OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ],
      ),
    );
  }
}