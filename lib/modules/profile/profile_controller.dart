import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/routes/app_routes.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/notification_service.dart';
import '../../core/services/purchase_service.dart';
import '../../data/local/app_database.dart';
import '../../widgets/app_snackbar.dart';

class ProfileController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final PurchaseService _purchaseService = Get.find<PurchaseService>();

  final RxBool isLoading = false.obs;
  final RxBool isDeletingAccount = false.obs;

  static const _emailSuporte = 'avmtechlab@gmail.com';

  // TROQUE pela URL real depois de publicar a página no Firebase Hosting.
  static const _urlPoliticaETermos = 'https://autodia-974dd.web.app';

  bool get isLoggedIn => _authService.isLoggedIn;
  String? get nome => _authService.currentUser.value?.displayName;
  String? get email => _authService.currentUser.value?.email;
  String? get fotoUrl => _authService.currentUser.value?.photoURL;
  bool get isPremium => _purchaseService.isPremium.value;

  Future<void> loginComGoogle() async {
    isLoading.value = true;
    try {
      await _authService.signInWithGoogle();
    } catch (_) {
      showErrorSnackbar(
        title: 'Erro ao entrar',
        message: 'Tente novamente em instantes.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sair() async {
    await _authService.signOut();
    Get.offAllNamed(AppRoutes.login);
  }

  void irParaPremium() => Get.toNamed(AppRoutes.paywall);

  /// Abre a tela da própria Play Store onde o usuário gerencia (ou cancela)
  /// a assinatura — o app não controla isso diretamente, quem manda é a loja.
  Future<void> gerenciarAssinatura() async {
    final uri = Uri.parse(
      'https://play.google.com/store/account/subscriptions'
      '?sku=autodia_premium_mensal&package=com.autodia.app',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> copiarEmailSuporte() async {
    try {
      await Clipboard.setData(const ClipboardData(text: _emailSuporte));
      showSuccessSnackbar(
        title: 'E-mail copiado',
        message: 'O endereço de suporte foi copiado para a área de transferência.',
      );
    } catch (_) {
      showErrorSnackbar(
        title: 'Não foi possível copiar',
        message: 'Tente novamente em instantes.',
      );
    }
  }

  Future<void> abrirPoliticaETermos() async {
    final uri = Uri.parse(_urlPoliticaETermos);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      showErrorSnackbar(
        title: 'Não foi possível abrir',
        message: 'Tente novamente em instantes.',
      );
    }
  }

  /// Exigência do Google Play: apps que permitem criar conta precisam
  /// oferecer exclusão de conta DENTRO do app. Isso apaga os dados locais,
  /// cancela notificações pendentes, e exclui a conta do Firebase Auth.
  Future<void> excluirConta() async {
    isDeletingAccount.value = true;
    try {
      await Get.find<AppDatabase>().excluirTudoDoUsuario();
      await Get.find<NotificationService>().cancelAll();
      await _authService.excluirConta();
      Get.offAllNamed(AppRoutes.login);
      showSuccessSnackbar(
        title: 'Conta excluída',
        message: 'Seus dados foram removidos.',
      );
    } catch (_) {
      showErrorSnackbar(
        title: 'Não foi possível excluir',
        message: 'Tente novamente, ou entre em contato pelo suporte.',
      );
    } finally {
      isDeletingAccount.value = false;
    }
  }
}