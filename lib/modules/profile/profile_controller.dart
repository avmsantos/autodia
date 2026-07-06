import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/services/auth_service.dart';
import '../../core/services/purchase_service.dart';

class ProfileController extends GetxController {
  final AuthService authService = Get.find<AuthService>();
  final PurchaseService purchaseService = Get.find<PurchaseService>();

  bool get isPremium => purchaseService.isPremium.value;

  String get userDisplayName => authService.currentUser.value?.displayName ?? 'Usuário';

  String get userEmail => authService.currentUser.value?.email ?? 'Sem e-mail';

  Future<void> logout() async {
    await authService.signOut();
    Get.offAllNamed('/login');
  }

  Future<void> abrirPremium() async {
    Get.toNamed('/premium');
  }

  Future<void> abrirCentralAjuda() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'avmtechlab@gmail.com',
      query: 'subject=Central%20de%20Ajuda%20-%20Moto%20Carro%20App',
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      Get.snackbar('Erro', 'Não foi possível abrir o e-mail.');
    }
  }
}
