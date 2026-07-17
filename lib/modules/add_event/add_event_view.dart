import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../theme/app_colors.dart';
import 'add_event_controller.dart';

class AddEventView extends GetView<AddEventController> {
  const AddEventView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.isEditing ? 'Editar manutenção' : 'Registrar manutenção',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
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
        return SafeArea(
          top: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            children: [
              const _FieldLabel('Tipo de Manutenção'),
              DropdownButtonFormField<String>(
                initialValue: controller.categoriaSelecionada.value?.id,
                items: controller.categorias
                    .map((c) => DropdownMenuItem(value: c.id, child: Text(c.nome)))
                    .toList(),
                onChanged: (id) {
                  controller.categoriaSelecionada.value =
                      controller.categorias.firstWhere((c) => c.id == id);
                },
              ),
              const SizedBox(height: 18),

              const _FieldLabel('Data'),
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: controller.data.value,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) controller.data.value = picked;
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.calendar_today_outlined, size: 18),
                  ),
                  child: Text(DateFormat('dd/MM/yyyy').format(controller.data.value)),
                ),
              ),
              const SizedBox(height: 18),

              const _FieldLabel('Km na Data'),
              TextField(
                controller: controller.kmController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 18),

              const _FieldLabel('Valor Gasto (opcional)'),
              TextField(
                controller: controller.valorController,
                decoration: const InputDecoration(prefixText: 'R\$ '),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 18),

              const _FieldLabel('Oficina (opcional)'),
              TextField(
                controller: controller.oficinaController,
                decoration: const InputDecoration(
                  hintText: 'Nome da oficina',
                  hintStyle: TextStyle(color: AppColors.onBackground, fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(height: 18),

              const _FieldLabel('Observação (opcional)'),
              TextField(
                controller: controller.observacaoController,
                decoration: const InputDecoration(
                  hintText: 'Detalhes adicionais...',
                  hintStyle: TextStyle(color: AppColors.onBackground, fontWeight: FontWeight.w400),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),

              _AttachmentSection(controller: controller),
              const SizedBox(height: 28),

              Obx(
                () => SizedBox(
                  height: 56,
                  child: FilledButton(
                    onPressed: controller.isSaving.value ? null : controller.salvar,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.onBackground,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: AppColors.onBackground.withValues(alpha: 0.6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: controller.isSaving.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Salvar', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

Future<void> _confirmarExclusao(BuildContext context) async {
  final confirmou = await showGeneralDialog<bool>(
    context: context,
    barrierLabel: 'Excluir manutenção',
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
            child: const _DeleteEventDialog(),
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
 
/// Alerta de exclusão de manutenção com fundo desfocado (mesmo tratamento do
/// alerta de exclusão de conta) — só aparência, a chamada real continua em
/// `controller.excluir()`.
class _DeleteEventDialog extends StatelessWidget {
  const _DeleteEventDialog();
 
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
                  'Excluir manutenção?',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Isso remove esse registro do histórico. Não dá pra desfazer.',
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
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.onBackground,
        ),
      ),
    );
  }
}

/// Anexo opcional de foto da nota fiscal/recibo — só guarda pra consulta
/// futura, sem OCR nenhum aqui (isso é feature separada, do lembrete).
class _AttachmentSection extends StatelessWidget {
  final AddEventController controller;
  const _AttachmentSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final anexo = controller.anexoSelecionado.value;

      if (anexo == null) {
        return InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _mostrarOpcoes(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.outlineVariant),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.attach_file, size: 18, color: AppColors.outline),
                SizedBox(width: 8),
                Text(
                  'Anexar foto da nota fiscal (opcional)',
                  style: TextStyle(color: AppColors.outline, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _FieldLabel('Nota fiscal anexada'),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.file(
                  anexo,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  backgroundColor: Colors.black54,
                  radius: 16,
                  child: IconButton(
                    icon: const Icon(Icons.close, size: 18, color: Colors.white),
                    onPressed: controller.removerAnexo,
                    tooltip: 'Remover',
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Future<void> _mostrarOpcoes(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Tirar foto'),
              onTap: () {
                Navigator.pop(context);
                controller.escolherAnexoDaCamera();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Escolher da galeria'),
              onTap: () {
                Navigator.pop(context);
                controller.escolherAnexoDaGaleria();
              },
            ),
          ],
        ),
      ),
    );
  }
}