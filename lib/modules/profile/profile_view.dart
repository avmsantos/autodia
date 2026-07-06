import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 32,
                    child: Icon(Icons.person, size: 32),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    controller.userDisplayName,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(controller.userEmail),
                  const SizedBox(height: 12),
                  Chip(
                    avatar: Icon(
                      controller.isPremium ? Icons.workspace_premium : Icons.shield_outlined,
                      color: controller.isPremium ? Colors.amber : null,
                    ),
                    label: Text(
                      controller.isPremium ? 'Premium ativo' : 'Versão gratuita',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: controller.abrirPremium,
            icon: const Icon(Icons.workspace_premium),
            label: const Text('Assinar Premium'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: controller.abrirCentralAjuda,
            icon: const Icon(Icons.help_outline),
            label: const Text('Central de ajuda'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: controller.logout,
            icon: const Icon(Icons.logout),
            label: const Text('Sair da conta'),
          ),
        ],
      ),
    );
  }
}
