import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'notification_settings_controller.dart';

class NotificationSettingsView extends GetView<NotificationSettingsController> {
  const NotificationSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notificações')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Obx(
            () => SwitchListTile(
              title: const Text('Ativar notificações'),
              subtitle: Text(
                controller.ativo.value
                    ? 'Você recebe avisos de manutenção próxima ou vencida.'
                    : 'Nenhum lembrete vai notificar até você reativar.',
              ),
              value: controller.ativo.value,
              onChanged: controller.isSalvando.value ? null : controller.alternar,
            ),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.notifications_none),
            title: const Text('Testar notificação agora'),
            subtitle: const Text('Envia uma notificação imediata pra conferir se está funcionando.'),
            onTap: controller.testarAgora,
          ),
        ],
      ),
    );
  }
}