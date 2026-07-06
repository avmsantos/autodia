import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'core/services/auth_service.dart';
import 'core/services/battery_optimization_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/purchase_service.dart';
import 'data/local/app_database.dart';
import 'firebase_options.dart';

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
  await MobileAds.instance.initialize();

  // Banco local (drift) fica disponível pro app inteiro via GetX.
  Get.put(AppDatabase(), permanent: true);

  // Notificações locais de vencimento de manutenção.
  final notificationService = await NotificationService().init();
  Get.put(notificationService, permanent: true);

  Get.put(BatteryOptimizationService(), permanent: true);

  // RevenueCat: chave pública Android criada no dashboard.
  final purchaseService = await PurchaseService().init(
    androidApiKey: 'goog_DXifUvEqFMkgNaKWEpSTOBzDQdU',
  );
  Get.put(purchaseService, permanent: true);

  // AuthService depende do PurchaseService já estar registrado (ver
  // _onAuthStateChanged em auth_service.dart), por isso vem depois.
  final authService = await AuthService().init();
  Get.put(authService, permanent: true);

  runApp(const MotoCarroApp());
}

class MotoCarroApp extends StatelessWidget {
  const MotoCarroApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Get.find<AuthService>();

    return GetMaterialApp(
      title: 'Manutenção Veicular',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF1B5E20),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF1B5E20),
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: authService.isLoggedIn ? AppRoutes.home : AppRoutes.login,
      getPages: AppPages.pages,
    );
  }
}