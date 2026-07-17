import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../theme/app_colors.dart';
import 'add_reminder_controller.dart';

class AddReminderView extends GetView<AddReminderController> {
  const AddReminderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.isEditing ? 'Editar lembrete' : 'Novo lembrete',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          if (controller.isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Excluir',
              onPressed: () => _confirmarExclusao(context),
            )
          
        ],
      ),
      body: Obx(() {
        if (controller.categorias.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const _FieldLabel('Tipo de Manutenção'),
            DropdownButtonFormField<String>(
              initialValue: controller.categoriaSelecionada.value?.id,
              items: controller.categorias
                  .map((c) => DropdownMenuItem(value: c.id, child: Text(c.nome)))
                  .toList(),
              onChanged: controller.selecionarCategoria,
            ),
            const SizedBox(height: 20),
            Obx(
              () => controller.isCalendarCategory
                  ? _CalendarFields(controller: controller)
                  : _MechanicalFields(controller: controller),
            ),
            const SizedBox(height: 28),
            Obx(
              () => SizedBox(
                height: 56,
                child: FilledButton.icon(
                  onPressed: controller.isSaving.value ? null : controller.salvar,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.onBackground,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.onBackground.withValues(alpha: 0.6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  icon: controller.isSaving.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.save_outlined, size: 20),
                  label: const Text(
                    'Salvar lembrete',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

Future<void> _confirmarExclusao(BuildContext context) async {
  final confirmou = await showGeneralDialog<bool>(
    context: context,
    barrierLabel: 'Excluir lembrete',
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
            child: const _DeleteReminderDialog(),
          ),
        ),
      );
    },
  );
  if (confirmou == true) {
    await controller.excluir();
  }
}
}
 
/// Alerta de exclusão de lembrete com fundo desfocado (mesmo tratamento do
/// alerta de exclusão de conta) — só aparência, a chamada real continua em
/// `controller.excluir()`.
class _DeleteReminderDialog extends StatelessWidget {
  const _DeleteReminderDialog();
 
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
                  child: const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 28),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Excluir lembrete?',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Isso remove o lembrete e cancela a notificação agendada.',
                  style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14, height: 1.4),
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text(
                      'Excluir',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: TextButton.styleFrom(foregroundColor: AppColors.onSurfaceVariant),
                  child: const Text('Cancelar', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 2),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.onBackground),
      ),
    );
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
          const _FieldLabel('Última vez feita'),
          _DateBox(
            date: controller.ultimaData.value,
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
          const SizedBox(height: 18),
          const _FieldLabel('Km na última vez (opcional)'),
          TextField(
            controller: controller.ultimoKmController,
            decoration: const InputDecoration(suffixText: 'KM'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 12),
          const Text('Repetir a cada:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 14),

          _ToggleCard(
            icon: Icons.schedule,
            title: 'Por tempo',
            value: controller.usarData.value,
            onChanged: (v) => controller.usarData.value = v,
            child: controller.usarData.value
                ? Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: _InlineField(
                      label: 'Intervalo em meses',
                      controller: controller.intervaloMesesController,
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 12),
          _ToggleCard(
            icon: Icons.location_on_outlined,
            title: 'Por quilometragem',
            locked: !controller.isPremium,
            value: controller.usarKm.value,
            onChanged: controller.toggleUsarKm,
            child: controller.usarKm.value
    ? Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InlineField(
              label: 'Intervalo em km',
              controller: controller.intervaloKmController,
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.secondary.withValues(alpha: 0.2),
                ),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 18,
                    color: AppColors.onSecondaryContainer,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Como calculamos a data: usamos sua última quilometragem registrada e a média de quanto você roda por dia (baseado no seu histórico) para estimar quando vai atingir a quilometragem do lembrete. Sempre que você atualizar o km do veículo, essa data será ajustada automaticamente.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    : null,
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
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: controller.isScanning.value ? null : controller.escanearDocumento,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.planSelectedBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (controller.isScanning.value)
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    const Icon(Icons.document_scanner_outlined, color: AppColors.onSecondaryContainer, size: 20),
                  const SizedBox(width: 10),
                 const Text(
                    'Escanear documento',
                    style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.onSecondaryContainer),
                  ),
                  if (!controller.isPremium) ...[
                    const SizedBox(width: 6),
                    const Icon(Icons.lock, size: 16, color: Colors.orange),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tira foto do CRLV, boleto ou apólice e a data de vencimento é '
            'preenchida automaticamente.',
            style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13),
          ),
          const SizedBox(height: 20),

          const _FieldLabel('Data de Pagamento'),
          _DateBox(
            date: controller.ultimaData.value,
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
          const SizedBox(height: 18),

          const _FieldLabel('Data de Vencimento'),
          _DateBox(
            icon: Icons.event,
            date: controller.dataVencimento.value,
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
          const SizedBox(height: 18),

          const _FieldLabel('Valor Pago (opcional)'),
          TextField(
            controller: controller.valorPagoController,
            decoration: const InputDecoration(prefixText: 'R\$ '),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ],
      ),
    );
  }
}

class _DateBox extends StatelessWidget {
  final DateTime date;
  final VoidCallback onTap;
  final IconData icon;

  const _DateBox({required this.date, required this.onTap, this.icon = Icons.calendar_today_outlined});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(suffixIcon: Icon(icon, size: 18)),
        child: Text(DateFormat('dd/MM/yyyy').format(date)),
      ),
    );
  }
}

class _InlineField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const _InlineField({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.onBackground)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surfaceContainerLow,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

class _ToggleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool locked;
  final Widget? child;

  const _ToggleCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
    this.locked = false,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.onSecondaryContainer, size: 20),
              const SizedBox(width: 10),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
              if (locked) ...[
                const SizedBox(width: 6),
                const Icon(Icons.lock, size: 15, color: Colors.orange),
              ],
              const Spacer(),
              Switch(
                value: value,
                onChanged: onChanged,
                activeThumbColor: Colors.white,
                activeTrackColor: AppColors.onSecondaryContainer,
              ),
            ],
          ),
          if (child != null) child!,
        ],
      ),
    );
  }
}