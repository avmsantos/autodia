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
        return ListView(
          padding: const EdgeInsets.all(16),
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
              decoration: const InputDecoration(hintText: 'Nome da oficina', hintStyle: TextStyle(color: AppColors.onBackground, fontWeight: FontWeight.w400)),
            ),
            const SizedBox(height: 18),

            const _FieldLabel('Observação (opcional)'),
            TextField(
              controller: controller.observacaoController,
              decoration: const InputDecoration(hintText: 'Detalhes adicionais...', hintStyle: TextStyle(color: AppColors.onBackground, fontWeight: FontWeight.w400)),
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
        );
      }),
    );
  }

  Future<void> _confirmarExclusao(BuildContext context) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir manutenção?'),
        content: const Text('Isso remove esse registro do histórico. Não dá pra desfazer.'),
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