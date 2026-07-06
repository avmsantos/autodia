import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

/// Lê o texto de uma foto de documento (CRLV, boleto de IPVA, apólice de
/// seguro) e tenta encontrar uma data de vencimento nele.
///
/// Roda 100% no aparelho (on-device), sem enviar a foto pra nenhum servidor
/// e sem custo por uso — é o modelo de texto latino do ML Kit do Google.
///
/// Heurística usada (documentos brasileiros não têm um formato único, então
/// isso é uma aproximação, não uma leitura garantida):
/// 1. Procura todas as datas no formato dd/mm/aaaa (ou com "-"/"." no lugar
///    da barra) em todo o texto reconhecido.
/// 2. Se alguma aparecer numa linha que contém "venc" ou "validade", usa essa
///    — é o sinal mais forte de que é a data de vencimento, e não de emissão.
/// 3. Sem esse sinal, usa a data mais distante no futuro encontrada (em
///    boletos e apólices, a data de vencimento costuma ser posterior à de
///    emissão/pagamento).
class OcrService {
  final TextRecognizer _recognizer =
      TextRecognizer(script: TextRecognitionScript.latin);

  static final RegExp _dateRegex =
      RegExp(r'(\d{1,2})[\/\-.](\d{1,2})[\/\-.](\d{2,4})');

  Future<DateTime?> extractDueDateFromImage(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final recognizedText = await _recognizer.processImage(inputImage);

    DateTime? melhorPalpite;
    DateTime? palpiteComPalavraChave;

    for (final block in recognizedText.blocks) {
      for (final line in block.lines) {
        final texto = line.text;
        final textoMinusculo = texto.toLowerCase();
        final temPalavraChave =
            textoMinusculo.contains('venc') || textoMinusculo.contains('validade');

        for (final match in _dateRegex.allMatches(texto)) {
          final data = _parseMatch(match);
          if (data == null) continue;

          if (temPalavraChave) {
            palpiteComPalavraChave = data;
          }
          if (melhorPalpite == null || data.isAfter(melhorPalpite)) {
            melhorPalpite = data;
          }
        }
      }
    }

    return palpiteComPalavraChave ?? melhorPalpite;
  }

  DateTime? _parseMatch(RegExpMatch match) {
    try {
      final dia = int.parse(match.group(1)!);
      final mes = int.parse(match.group(2)!);
      var ano = int.parse(match.group(3)!);
      if (ano < 100) ano += 2000;
      if (mes < 1 || mes > 12 || dia < 1 || dia > 31) return null;
      return DateTime(ano, mes, dia);
    } catch (_) {
      return null;
    }
  }

  void dispose() => _recognizer.close();
}