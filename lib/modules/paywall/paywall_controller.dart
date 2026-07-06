import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../core/services/purchase_service.dart';

class PaywallController extends GetxController {
  final PurchaseService _purchaseService = Get.find<PurchaseService>();

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

  Future<void> comprar(Package package) async {
    isPurchasing.value = true;
    try {
      await _purchaseService.purchasePackage(package);
      if (_purchaseService.isPremium.value) {
        Get.back();
        Get.snackbar('Premium ativado', 'Aproveite os recursos extras!');
      }
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        Get.snackbar('Não foi possível concluir', 'Tente novamente.');
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
        Get.snackbar('Compra restaurada', 'Seu Premium foi reativado.');
      } else {
        Get.snackbar('Nada encontrado', 'Nenhuma compra anterior localizada.');
      }
    } finally {
      isPurchasing.value = false;
    }
  }
}
