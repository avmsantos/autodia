import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/app_colors.dart';
import 'login_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ícone dentro de um cartão branco arredondado
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.directions_car_filled,
                  size: 44,
                  color: AppColors.onBackground,
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Manutenção Veicular',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Controle seu carro e moto: revisões, vencimentos e gastos, '
                'tudo em um só lugar.',
                style: TextStyle(color: AppColors.onSurfaceVariant, height: 1.4, fontSize: 15),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton.icon(
                    onPressed:
                        controller.isLoading.value ? null : controller.loginComGoogle,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.onBackground,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: AppColors.onBackground.withValues(alpha: 0.6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: const _GoogleIcon(),
                    label: const Text(
                      'Entrar com Google',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => TextButton(
                  onPressed:
                      controller.isLoading.value ? null : controller.continuarSemLogin,
                  style: TextButton.styleFrom(foregroundColor: AppColors.secondary),
                  child: const Text(
                    'Continuar sem login',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Entrar com Google garante que seu Premium acompanhe você '
                  'se trocar de aparelho.',
                  style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13, height: 1.4),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// "G" colorido do Google — desenhado com um Stack de letras coloridas pra
/// não depender de nenhum asset/pacote extra.


class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/google_logo.svg',
      width: 20,
      height: 20,
    );
  }
}