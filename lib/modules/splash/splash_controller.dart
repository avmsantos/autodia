import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../core/services/auth_service.dart';

class SplashController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  @override
  void onInit() {
    super.onInit();
    _navegarQuandoPronto();
  }

  /// Tempo mínimo pra animação da logo respirar na tela — mesmo que tudo já
  /// tenha carregado mais rápido que isso, o splash não pode piscar rápido
  /// demais, fica com aparência de bug em vez de intencional.
  Future<void> _navegarQuandoPronto() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    Get.offAllNamed(_authService.isLoggedIn ? AppRoutes.home : AppRoutes.login);
  }
}