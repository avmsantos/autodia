import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../core/services/auth_service.dart';
import '../../core/services/purchase_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_snackbar.dart';

class PaywallController extends GetxController {
  final PurchaseService _purchaseService = Get.find<PurchaseService>();
  final AuthService _authService = Get.find<AuthService>();

  final Rx<Offering?> offering = Rx<Offering?>(null);
  final RxBool isLoading = true.obs;
  final RxBool isPurchasing = false.obs;

  bool get isPremium => _purchaseService.isPremium.value;

  @override
  void onInit() {
    super.onInit();
    _loadOfferings();
  }

  Future<void> _loadOfferings() async {
    try {
      final offerings = await _purchaseService.getOfferings();
      offering.value = offerings.current;
    } finally {
      isLoading.value = false;
    }
  }

  /// Ponto de entrada chamado pela tela ao tocar em "Assinar Agora".
  /// Se o usuário não estiver logado, mostra um aviso — mas não bloqueia:
  /// ele pode entrar com Google ali mesmo (e a compra continua sozinha
  /// depois do login) ou seguir sem login.
  Future<void> tentarComprar(Package package) async {
    if (_authService.isGoogleLinked) {
      await comprar(package);
      return;
    }

    final resultado = await Get.dialog<String>(
      const _LoginBeforeBuyDialog(),
      barrierColor: Colors.black.withValues(alpha: 0.15),
    );

    if (resultado == 'entrar') {
      final credential = await _authService.signInWithGoogle();
      if (credential == null) return; // cancelou o login, não compra
    } else if (resultado != 'continuar') {
      return; // fechou o diálogo sem escolher nada
    }

    await comprar(package);
  }

  Future<void> comprar(Package package) async {
    isPurchasing.value = true;
    try {
      await _purchaseService.purchasePackage(package);
      if (_purchaseService.isPremium.value) {
        Get.back();
        showSuccessSnackbar(
          title: 'Premium ativado',
          message: 'Aproveite os recursos extras!',
        );
      }
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        showErrorSnackbar(
          title: 'Não foi possível concluir',
          message: 'Tente novamente.',
        );
      }
    } finally {
      isPurchasing.value = false;
    }
  }

  Future<void> restaurar() async {
    isPurchasing.value = true;
    try {
      await _purchaseService.restorePurchases();
      if (_purchaseService.isPremium.value) {
        showSuccessSnackbar(
          title: 'Compra restaurada',
          message: 'Seu Premium foi reativado.',
        );
      } else {
        showInfoSnackbar(
          title: 'Nada encontrado',
          message: 'Nenhuma compra anterior localizada.',
        );
      }
    } finally {
      isPurchasing.value = false;
    }
  }
}

/// Aviso "assinar sem login?" com fundo desfocado (mesmo tratamento visual
/// do alerta de exclusão de conta) — só aparência; quem decide o fluxo
/// continua sendo `tentarComprar` acima, através do valor retornado
/// ('entrar' / 'continuar' / null).
class _LoginBeforeBuyDialog extends StatelessWidget {
  const _LoginBeforeBuyDialog();

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
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
                  const Text(
                    'Assinar sem login?',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                 const Text(
                    'Recomendamos entrar com Google antes de assinar — isso '
                    'facilita suporte e recuperação da sua assinatura no '
                    'futuro. Você também pode continuar sem login, sem '
                    'problema.',
                    style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14, height: 1.4),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => Get.back(result: 'continuar'),
                    style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                    child: const Text(
                      'Continuar mesmo assim',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: () => Get.back(result: 'entrar'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      label: const Text(
                        'Entrar agora',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
