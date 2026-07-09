import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'purchase_service.dart';

/// Anúncio de tela cheia, mostrado só ocasionalmente — nunca a cada ação,
/// senão o Google Play pode suspender o app por densidade de anúncio
/// abusiva. A trava de frequência aqui é o que protege isso.
class InterstitialAdService extends GetxService {
  static const _testAdUnitId = 'ca-app-pub-3940256099942544/1033173712';

  /// Mostra 1 a cada N ações "salvar" — ajuste conforme feedback de receita
  /// x reclamação de usuário. Começar conservador (4) é mais seguro.
  static const _mostrarACada = 4;

  InterstitialAd? _adCarregado;
  int _contadorDeAcoes = 0;

  Future<void> init() async {
    await _carregar();
  }

  Future<void> _carregar() async {
    await InterstitialAd.load(
      adUnitId: _testAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _adCarregado = ad,
        onAdFailedToLoad: (error) => _adCarregado = null,
      ),
    );
  }

  /// Chame isso depois de uma ação relevante (ex: salvar manutenção).
  /// Só mostra de fato 1 a cada [_mostrarACada] chamadas, e nunca pra quem
  /// é Premium.
  Future<void> talvezMostrar() async {
    if (Get.find<PurchaseService>().isPremium.value) return;

    _contadorDeAcoes++;
    if (_contadorDeAcoes < _mostrarACada) return;
    _contadorDeAcoes = 0;

    final ad = _adCarregado;
    if (ad == null) return; // ainda carregando, não trava o fluxo do usuário

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _adCarregado = null;
        _carregar(); // já prepara o próximo
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _adCarregado = null;
        _carregar();
      },
    );
    await ad.show();
  }
}