import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../core/services/auth_service.dart';

class LoginController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final RxBool isLoading = false.obs;

  Future<void> loginComGoogle() async {
    isLoading.value = true;
    try {
      final credential = await _authService.signInWithGoogle();
      if (credential != null) {
        Get.offAllNamed(AppRoutes.home);
      }
    } catch (e) {
      Get.snackbar('Erro ao entrar', 'Tente novamente em instantes.');
    } finally {
      isLoading.value = false;
    }
  }

  /// Permite usar o app sem cadastro. O Premium comprado nesse modo fica
  /// atrelado a um id anônimo do RevenueCat; se o usuário mais tarde
  /// vincular uma conta Google, oferecer "restaurar compras" garante que
  /// ele não perca o que já pagou.
  Future<void> continuarSemLogin() async {
    isLoading.value = true;
    try {
      await _authService.signInAnonymously();
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível continuar sem login agora.');
    } finally {
      isLoading.value = false;
    }
  }
}
