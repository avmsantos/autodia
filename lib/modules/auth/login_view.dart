import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.directions_car_filled, size: 72),
              const SizedBox(height: 16),
              Text(
                'Manutenção Veicular',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Controle carro e moto: revisões, vencimentos e gastos, tudo em um lugar.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Obx(
                () => FilledButton.icon(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.loginComGoogle,
                  icon: const Icon(Icons.login),
                  label: const Text('Entrar com Google'),
                ),
              ),
              const SizedBox(height: 12),
              Obx(
                () => TextButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.continuarSemLogin,
                  child: const Text('Continuar sem login'),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Entrar com Google garante que seu Premium acompanhe você '
                'se trocar de aparelho.',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
