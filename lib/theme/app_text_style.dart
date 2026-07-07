import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Estilos de texto centralizados.
///
/// Nota: o layout de referência usa as fontes "Hanken Grotesk" (títulos) e
/// "Manrope" (corpo de texto). Se quiser usá-las de verdade no app, adicione
/// o pacote `google_fonts` e troque `fontFamily: null` por, por exemplo,
/// `GoogleFonts.hankenGrotesk(...)` / `GoogleFonts.manrope(...)`.
/// Sem isso, o app usa a fonte padrão do sistema — o layout continua
/// funcionando normalmente.
class AppTextStyles {
  AppTextStyles._();

  static const TextStyle headlineLg = TextStyle(
    fontSize: 28,
    height: 36 / 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
    color: AppColors.onBackground,
  );

  static const TextStyle headlineMd = TextStyle(
    fontSize: 22,
    height: 28 / 22,
    fontWeight: FontWeight.w700,
    color: AppColors.onBackground,
  );

  static const TextStyle titleMd = TextStyle(
    fontSize: 16,
    height: 22 / 16,
    fontWeight: FontWeight.w600,
    color: AppColors.onBackground,
  );

  static const TextStyle bodyLg = TextStyle(
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w400,
    color: AppColors.onBackground,
  );

  static const TextStyle bodyMd = TextStyle(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurfaceVariant,
  );

  static const TextStyle labelMd = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
  );

  /// Usado dentro dos chips de status (Em dia / Atrasado / Próximo etc.)
  static const TextStyle statusChip = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w700,
  );
}