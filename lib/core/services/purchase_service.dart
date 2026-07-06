import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// Chave do entitlement configurado no dashboard do RevenueCat.
/// Precisa bater exatamente com o nome criado lá.
const String kPremiumEntitlementId = 'premium';

/// Encapsula toda a integração com o RevenueCat.
///
/// Fluxo de amarração com o usuário:
/// 1. App inicia com Purchases.configure() usando um `appUserID` anônimo
///    (o próprio RevenueCat gera um por padrão).
/// 2. Quando o usuário loga (Firebase), chamamos `linkToUser(uid)`, que faz
///    Purchases.logIn(uid) — a partir daí, qualquer compra feita fica
///    associada a esse uid. Se o usuário logar em outro aparelho com a
///    mesma conta, o Premium é restaurado automaticamente.
/// 3. Se o usuário desloga, chamamos `unlinkUser()` (Purchases.logOut()),
///    voltando a um app_user_id anônimo local.
class PurchaseService extends GetxService {
  final RxBool isPremium = false.obs;

  Future<PurchaseService> init({required String androidApiKey}) async {
    await Purchases.setLogLevel(LogLevel.warn);
    final configuration = PurchasesConfiguration(androidApiKey);
    await Purchases.configure(configuration);

    Purchases.addCustomerInfoUpdateListener(_onCustomerInfoUpdated);
    final info = await Purchases.getCustomerInfo();
    _applyCustomerInfo(info);

    return this;
  }

  void _onCustomerInfoUpdated(CustomerInfo info) => _applyCustomerInfo(info);

  void _applyCustomerInfo(CustomerInfo info) {
    isPremium.value =
        info.entitlements.active.containsKey(kPremiumEntitlementId);
  }

  Future<void> linkToUser(String uid) async {
    final result = await Purchases.logIn(uid);
    _applyCustomerInfo(result.customerInfo);
  }

  Future<void> unlinkUser() async {
    try {
      final info = await Purchases.logOut();
      _applyCustomerInfo(info);
    } on PlatformException catch (e) {
      // Se já estava anônimo, não há o que desfazer — ignora esse caso.
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.logOutWithAnonymousUserError) {
        rethrow;
      }
    }
  }

  Future<Offerings> getOfferings() => Purchases.getOfferings();

Future<void> purchasePackage(Package package) async {
  try {
    final result = await Purchases.purchase(
      PurchaseParams.package(package),
    );

    _applyCustomerInfo(result.customerInfo);
  } on PlatformException catch (e) {
    final errorCode = PurchasesErrorHelper.getErrorCode(e);

    if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
      // Usuário cancelou a compra.
      return;
    }

    rethrow;
  }
}

  Future<void> restorePurchases() async {
    final info = await Purchases.restorePurchases();
    _applyCustomerInfo(info);
  }
}
