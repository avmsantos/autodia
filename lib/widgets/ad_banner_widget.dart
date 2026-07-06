import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Banner adaptativo fixo no rodapé. Some sozinho quando `isPremium` é true —
/// o widget que usa isso decide, via Obx, se renderiza ou não.
///
/// IMPORTANTE: troque o adUnitId de teste pelo real antes de publicar.
/// O ID abaixo é o de teste oficial do Google, seguro de usar durante dev.
class AdBannerWidget extends StatefulWidget {
  const AdBannerWidget({super.key});

  static const _testAdUnitId = 'ca-app-pub-3940256099942544/6300978111';

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  Future<void> _loadAd() async {
    // AdSize.banner fixo (320x50) cobre o MVP. Pra usar o banner adaptativo
    // de verdade, troque por AdaptiveBannerAdSize, que precisa da largura da
    // tela — dá pra pegar em MediaQuery.of(context).size.width no
    // didChangeDependencies e recriar o BannerAd com o tamanho certo.
    final ad = BannerAd(
      adUnitId: AdBannerWidget._testAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() => _isLoaded = true),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    await ad.load();
    _bannerAd = ad;
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _bannerAd == null) return const SizedBox.shrink();
    return SizedBox(
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
