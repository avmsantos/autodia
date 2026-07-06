// Este arquivo é normalmente GERADO automaticamente pelo comando:
//
//   flutterfire configure
//
// (depois de instalar a FlutterFire CLI e criar o projeto no console do
// Firebase). Ele detecta o pacote Android/iOS e preenche as chaves reais.
//
// Deixei aqui um placeholder só pra o projeto compilar referenciando a
// classe certa — troque pelo arquivo real gerado pelo comando acima antes
// de rodar o app de verdade.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions não configurado pra essa plataforma. '
          'Rode `flutterfire configure` pra gerar o arquivo real.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'TROCAR_PELA_API_KEY_REAL',
    appId: 'TROCAR_PELO_APP_ID_REAL',
    messagingSenderId: 'TROCAR_PELO_SENDER_ID_REAL',
    projectId: 'TROCAR_PELO_PROJECT_ID_REAL',
    storageBucket: 'TROCAR_PELO_STORAGE_BUCKET_REAL',
  );
}
