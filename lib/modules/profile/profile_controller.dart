import 'dart:convert';
import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
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
  final RxBool isBackupBusy = false.obs;

  static const _emailSuporte = 'avmtechlab@gmail.com';

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

  /// Exporta todos os dados locais (veículos, categorias customizadas,
  /// histórico, lembretes) num arquivo .json e abre o menu de compartilhar.
  /// Não inclui as fotos anexadas — só o caminho, que só existe nesse
  /// aparelho (colocar imagem em base64 deixaria o arquivo gigante).
  Future<void> exportarBackup() async {
    isBackupBusy.value = true;
    try {
      final db = Get.find<AppDatabase>();
      final dados = await db.exportarBackup();
      final jsonStr = const JsonEncoder.withIndent('  ').convert(dados);

      final tempDir = await getTemporaryDirectory();
      final dataFormatada = DateTime.now().toIso8601String().split('T').first;
      final file = File(p.join(tempDir.path, 'autodia_backup_$dataFormatada.json'));
      await file.writeAsString(jsonStr);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text: 'Backup do AutoDia — guarde esse arquivo pra restaurar depois.',
        ),
      );
    } catch (_) {
      showErrorSnackbar(
        title: 'Não foi possível exportar',
        message: 'Tente novamente em instantes.',
      );
    } finally {
      isBackupBusy.value = false;
    }
  }

  /// Escolhe um arquivo .json de backup e SUBSTITUI os dados atuais pelos
  /// dele. Quem chama isso já deve ter confirmado com o usuário antes — a
  /// confirmação em si fica na view, aqui só executa.
  Future<void> restaurarBackup() async {
    final resultado = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    final caminho = resultado?.files.single.path;
    if (caminho == null) return; // cancelou a seleção

    isBackupBusy.value = true;
    try {
      final conteudo = await File(caminho).readAsString();
      final dados = jsonDecode(conteudo) as Map<String, dynamic>;

      final db = Get.find<AppDatabase>();
      await db.restaurarBackup(dados);

      // Reagenda notificações de todos os veículos restaurados.
      final notificationService = Get.find<NotificationService>();
      final veiculos = await db.watchAllVehicles();
      for (final v in veiculos) {
        await notificationService.rescheduleAllForVehicle(db, v);
      }

      showSuccessSnackbar(
        title: 'Backup restaurado',
        message: 'Seus dados foram atualizados.',
      );
    } catch (_) {
      showErrorSnackbar(
        title: 'Não foi possível restaurar',
        message: 'Confira se o arquivo é um backup válido do AutoDia.',
      );
    } finally {
      isBackupBusy.value = false;
    }
  }
}