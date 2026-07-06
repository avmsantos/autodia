import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'add_event_controller.dart';

class AddEventView extends GetView<AddEventController> {
  const AddEventView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar manutenção')),
      body: Obx(() {
        if (controller.categorias.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<String>(
              value: controller.categoriaSelecionada.value?.id,
              decoration: const InputDecoration(
                labelText: 'Tipo de manutenção',
                border: OutlineInputBorder(),
              ),
              items: controller.categorias
                  .map((c) => DropdownMenuItem(value: c.id, child: Text(c.nome)))
                  .toList(),
              onChanged: (id) {
                controller.categoriaSelecionada.value =
                    controller.categorias.firstWhere((c) => c.id == id);
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Data'),
              subtitle: Text(DateFormat('dd/MM/yyyy').format(controller.data.value)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: controller.data.value,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (picked != null) controller.data.value = picked;
              },
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller.kmController,
              decoration: const InputDecoration(
                labelText: 'Km na data',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.valorController,
              decoration: const InputDecoration(
                labelText: 'Valor gasto (opcional)',
                prefixText: 'R\$ ',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.oficinaController,
              decoration: const InputDecoration(
                labelText: 'Oficina (opcional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.observacaoController,
              decoration: const InputDecoration(
                labelText: 'Observação (opcional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            _AttachmentSection(controller: controller),
            const SizedBox(height: 24),
            Obx(
              () => FilledButton(
                onPressed: controller.isSaving.value ? null : controller.salvar,
                child: controller.isSaving.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Salvar'),
              ),
            ),
          ],
        );
      }),
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
        return OutlinedButton.icon(
          onPressed: () => _mostrarOpcoes(context),
          icon: const Icon(Icons.attach_file),
          label: const Text('Anexar foto da nota fiscal (opcional)'),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nota fiscal anexada', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  anexo,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
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