import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'core/services/auth_service.dart';
import 'core/services/battery_optimization_service.dart';
import 'core/services/interstitial_ad_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/purchase_service.dart';
import 'core/services/review_prompt_service.dart';
import 'data/local/app_database.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // No Android, o próprio google-services.json já inicializa um app
  // Firebase "[DEFAULT]" nativamente antes do Flutter rodar. Chamar
  // initializeApp() de novo aqui pode disparar "duplicate-app" mesmo sendo
  // a primeira vez do lado Dart — isso é inofensivo, só ignoramos.
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } on FirebaseException catch (e) {
    if (e.code != 'duplicate-app') rethrow;
  }

  // Crashlytics: captura crashes do Flutter (erros de widget/build) e do
  // Dart puro (erros fora da árvore de widget, ex: em Future não tratada).
  // Em debug, desativamos o envio pra não poluir o painel com erro de dev.
  await FirebaseCrashlytics.instance
      .setCrashlyticsCollectionEnabled(!kDebugMode);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await MobileAds.instance.initialize();

  // Banco local (drift) fica disponível pro app inteiro via GetX.
  Get.put(AppDatabase(), permanent: true);

  // Notificações locais de vencimento de manutenção.
  final notificationService = await NotificationService().init();
  Get.put(notificationService, permanent: true);

  Get.put(BatteryOptimizationService(), permanent: true);
  Get.put(ReviewPromptService(), permanent: true);

  // RevenueCat: chave pública Android criada no dashboard.
  final purchaseService = await PurchaseService().init(
    androidApiKey: 'goog_DXifUvEqFMkgNaKWEpSTOBzDQdU',
  );
  Get.put(purchaseService, permanent: true);

  final interstitialAdService = InterstitialAdService();
  await interstitialAdService.init();
  Get.put(interstitialAdService, permanent: true);

  // AuthService depende do PurchaseService já estar registrado (ver
  // _onAuthStateChanged em auth_service.dart), por isso vem depois.
  final authService = await AuthService().init();
  Get.put(authService, permanent: true);

  runApp(const AutoDiaApp());
}

class AutoDiaApp extends StatelessWidget {
  const AutoDiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Manutenção Veicular',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      // Referência visual é só light por enquanto; travando o modo pra
      // não cair num dark theme desatualizado quando o celular estiver
      // em modo escuro.
      themeMode: ThemeMode.light,
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
    );
  }
}