import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Pede avaliação na loja depois que a pessoa já demonstrou uso de verdade
/// do app (registrou algumas manutenções) — nunca na primeira abertura, e
/// nunca mais de uma vez.
class ReviewPromptService {
  static const _chaveContagem = 'eventos_registrados_contagem';
  static const _chaveJaPediu = 'ja_pediu_avaliacao';

  /// Pede depois do 3º evento registrado — cedo o suficiente pra pegar
  /// gente engajada, tarde o suficiente pra não incomodar quem só abriu
  /// o app uma vez.
  static const _gatilho = 3;

  Future<void> registrarEventoERevisarPrompt() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_chaveJaPediu) ?? false) return;

    final contagem = (prefs.getInt(_chaveContagem) ?? 0) + 1;
    await prefs.setInt(_chaveContagem, contagem);

    if (contagem < _gatilho) return;

    final inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      await inAppReview.requestReview();
      await prefs.setBool(_chaveJaPediu, true);
    }
  }
}