import 'package:get/get.dart';

import '../../core/services/notification_service.dart';
import '../../data/local/app_database.dart';

class NotificationSettingsController extends GetxController {
  final NotificationService _notificationService = Get.find<NotificationService>();
  final AppDatabase _db = Get.find<AppDatabase>();

  RxBool get ativo => _notificationService.notificacoesAtivas;
  final RxBool isSalvando = false.obs;

  Future<void> alternar(bool valor) async {
    isSalvando.value = true;
    try {
      await _notificationService.alternarNotificacoes(valor, _db);
    } finally {
      isSalvando.value = false;
    }
  }

  Future<void> testarAgora() => _notificationService.testarNotificacaoImediata();
}