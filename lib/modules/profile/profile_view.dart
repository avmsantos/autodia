import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/app_colors.dart';
import 'profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: Obx(() {
        if (!controller.isLoggedIn) {
          return _NaoLogado(controller: controller);
        }
        return _Logado(controller: controller);
      }),
    );
  }
}

class _NaoLogado extends StatelessWidget {
  final ProfileController controller;
  const _NaoLogado({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.account_circle_outlined, size: 72, color: AppColors.outline),
            const SizedBox(height: 16),
            const Text(
              'Você está usando o app sem login',
              style: TextStyle(color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            Obx(
              () => FilledButton.icon(
                onPressed: controller.isLoading.value ? null : controller.loginComGoogle,
                icon: const Icon(Icons.login),
                label: const Text('Entrar com Google'),
              ),
            ),
            const SizedBox(height: 24),
            TextButton.icon(
              onPressed: controller.copiarEmailSuporte,
              icon: const Icon(Icons.help_outline),
              label: const Text('Central de ajuda'),
            ),
            TextButton.icon(
              onPressed: controller.abrirPoliticaETermos,
              icon: const Icon(Icons.description_outlined),
              label: const Text('Política de privacidade e termos'),
            ),
            const SizedBox(height: 24),
            Divider(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            const Text(
              'BACKUP',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
                color: AppColors.outline,
              ),
            ),
            const SizedBox(height: 12),
            Obx(
              () => _HelpTile(
                icon: Icons.upload_file_outlined,
                title: 'Exportar backup',
                subtitle: 'Salva um arquivo com todos os seus dados',
                onTap: controller.isBackupBusy.value ? () {} : controller.exportarBackup,
                isLoading: controller.isBackupBusy.value,
              ),
            ),
            const SizedBox(height: 10),
            Obx(
              () => _HelpTile(
                icon: Icons.download_outlined,
                title: 'Restaurar backup',
                subtitle: 'Substitui os dados atuais pelos do arquivo',
                onTap: controller.isBackupBusy.value
                    ? () {}
                    : () => _confirmarRestauracao(context, controller),
                isLoading: controller.isBackupBusy.value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Logado extends StatelessWidget {
  final ProfileController controller;
  const _Logado({required this.controller});

  @override
  Widget build(BuildContext context) {
    final nome = controller.nome ?? 'Sem nome';
    final inicial = nome.trim().isNotEmpty ? nome.trim()[0].toUpperCase() : '?';

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      children: [
        // Identidade do usuário
        Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 44,
                backgroundColor: AppColors.avatarBg,
                backgroundImage:
                    controller.fotoUrl != null ? NetworkImage(controller.fotoUrl!) : null,
                child: controller.fotoUrl == null
                    ? Text(
                        inicial,
                        style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      )
                    : null,
              ),
              const SizedBox(height: 14),
              Text(
                nome,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              if (controller.email != null) ...[
                const SizedBox(height: 4),
                Text(
                  controller.email!,
                  style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 15),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 28),

        // Card de assinatura (premium ou conta gratuita)
        Obx(
          () => controller.isPremium ? _PremiumCard(controller: controller) : _FreeCard(controller: controller),
        ),
        const SizedBox(height: 16),

        // Sair da conta
        OutlinedButton.icon(
          onPressed: controller.sair,
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(56),
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.onBackground,
            side: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.6)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
          icon: const Icon(Icons.logout),
          label: const Text('Sair da conta'),
        ),
        const SizedBox(height: 28),
        Divider(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
        const SizedBox(height: 20),

        // Backup
        const Text(
          'BACKUP',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
            color: AppColors.outline,
          ),
        ),
        const SizedBox(height: 12),
        Obx(
          () => _HelpTile(
            icon: Icons.upload_file_outlined,
            title: 'Exportar backup',
            subtitle: 'Salva um arquivo com todos os seus dados',
            onTap: controller.isBackupBusy.value ? () {} : controller.exportarBackup,
            isLoading: controller.isBackupBusy.value,
          ),
        ),
        const SizedBox(height: 10),
        Obx(
          () => _HelpTile(
            icon: Icons.download_outlined,
            title: 'Restaurar backup',
            subtitle: 'Substitui os dados atuais pelos do arquivo',
            onTap: controller.isBackupBusy.value
                ? () {}
                : () => _confirmarRestauracao(context, controller),
            isLoading: controller.isBackupBusy.value,
          ),
        ),
        const SizedBox(height: 24),
        Divider(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
        const SizedBox(height: 20),

        // Central de ajuda
        const Text(
          'CENTRAL DE AJUDA',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
            color: AppColors.outline,
          ),
        ),
        const SizedBox(height: 12),
        _HelpTile(
          icon: Icons.help_outline,
          title: 'Falar com o suporte',
          subtitle: 'avmtechlab@gmail.com',
          onTap: controller.copiarEmailSuporte,
        ),
        const SizedBox(height: 10),
        _HelpTile(
          icon: Icons.description_outlined,
          title: 'Política de privacidade e termos',
          onTap: controller.abrirPoliticaETermos,
        ),
        const SizedBox(height: 24),

        // Gerenciamento da Conta
        const Text(
          'OPÇÕES DA CONTA',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
            color: AppColors.error,
          ),
        ),
        const SizedBox(height: 12),
        Obx(
          () => _DangerTile(
            isLoading: controller.isDeletingAccount.value,
            onTap: controller.isDeletingAccount.value
                ? null
                : () => _confirmarExclusaoConta(context, controller),
          ),
        ),
      ],
    );
  }

  Future<void> _confirmarExclusaoConta(BuildContext context, ProfileController controller) async {
    final confirmou = await showGeneralDialog<bool>(
      context: context,
      barrierLabel: 'Excluir conta',
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
              child: const _DeleteAccountDialog(),
            ),
          ),
        );
      },
    );
    if (confirmou == true) {
      await controller.excluirConta();
    }
  }
}

/// Confirmação de restaurar backup — dialog simples (não o com blur, esse
/// fica reservado pra exclusão de conta, a ação mais grave do app).
Future<void> _confirmarRestauracao(BuildContext context, ProfileController controller) async {
  final confirmou = await showGeneralDialog<bool>(
    context: context,
    barrierLabel: 'Restaurar backup',
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
            child: const _RestoreBackupDialog(),
          ),
        ),
      );
    },
  );
  if (confirmou == true) {
    await controller.restaurarBackup();
  }
}
 
/// Alerta de restauração de backup com fundo desfocado (mesmo tratamento do
/// alerta de exclusão de conta) — só aparência, a chamada real continua em
/// `controller.restaurarBackup()`.
class _RestoreBackupDialog extends StatelessWidget {
  const _RestoreBackupDialog();
 
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
                    color: AppColors.planSelectedBg,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.settings_backup_restore, color: AppColors.secondary, size: 28),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Restaurar backup?',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text.rich(
                  TextSpan(
                    style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14, height: 1.4),
                    children: [
                      TextSpan(
                        text: 'Isso substitui TODOS os veículos, histórico e lembretes '
                            'atuais pelos dados do arquivo escolhido. ',
                      ),
                      TextSpan(
                        text: 'Não dá pra desfazer.',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.onBackground,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text(
                      'Escolher arquivo e restaurar',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: TextButton.styleFrom(foregroundColor: AppColors.onBackground),
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

/// Alerta de exclusão de conta com fundo desfocado (BackdropFilter) em vez
/// do overlay escuro padrão do Flutter — só aparência, a chamada real de
/// exclusão continua em `controller.excluirConta()`.
class _DeleteAccountDialog extends StatelessWidget {
  const _DeleteAccountDialog();

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
                  'Excluir sua conta?',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text.rich(
                  TextSpan(
                    style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14, height: 1.4),
                    children: [
                      TextSpan(
                        text: 'Isso apaga permanentemente seus veículos, histórico de '
                            'manutenção, lembretes e sua conta. ',
                      ),
                      TextSpan(
                        text: 'Não dá pra desfazer.',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
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
                      'Excluir permanentemente',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: TextButton.styleFrom(foregroundColor: AppColors.onBackground),
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

class _PremiumCard extends StatelessWidget {
  final ProfileController controller;
  const _PremiumCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.premiumCardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.premiumCardBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: AppColors.premiumGold,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.star, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Você é Premium',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
          ),
          TextButton(
            onPressed: controller.gerenciarAssinatura,
            style: TextButton.styleFrom(foregroundColor: AppColors.premiumCardText),
            child: const Text('Gerenciar', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _FreeCard extends StatelessWidget {
  final ProfileController controller;
  const _FreeCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppColors.freeCardIconBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.gpp_good_outlined, color: AppColors.outline, size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child:  Text(
              'Conta gratuita',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
          ),
          TextButton(
            onPressed: controller.irParaPremium,
            style: TextButton.styleFrom(foregroundColor: AppColors.onBackground),
            child: const Text('Assinar', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _HelpTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool isLoading;

  const _HelpTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.4)),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.outline),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13),
                      ),
                    ],
                  ],
                ),
              ),
              if (isLoading)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                const Icon(Icons.chevron_right, color: AppColors.outlineVariant),
            ],
          ),
        ),
      ),
    );
  }
}

class _DangerTile extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onTap;

  const _DangerTile({required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.dangerBorder),
          ),
          child: Row(
            children: [
              const Icon(Icons.delete_forever_outlined, color: AppColors.error),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text(
                      'Excluir minha conta',
                      style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.error),
                    ),
                     SizedBox(height: 2),
                     Text(
                      'Ação irreversível',
                      style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12),
                    ),
                  ],
                ),
              ),
              if (isLoading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
               const Icon(Icons.chevron_right, color: AppColors.error),
            ],
          ),
        ),
      ),
    );
  }
}