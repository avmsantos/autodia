import 'package:flutter/material.dart';

/// Paleta de cores centralizada do app.
/// Baseada na referência visual "AutoLog Premium" (tons de azul,
/// fundo neutro claro, ao invés do verde usado anteriormente).
class AppColors {
  AppColors._();

  // ---------------------------------------------------------------------
  // Cores principais
  // ---------------------------------------------------------------------
  static const Color primary = Color(0xFF006591);
  static const Color primaryContainer = Color(0xFFC9E6FF);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF004C6E);

  static const Color secondary = Color(0xFF39B8FD);
  static const Color secondaryContainer = Color(0xFFC9E6FF);
  static const Color onSecondaryContainer = Color(0xFF004666);

  // ---------------------------------------------------------------------
  // Superfícies / fundo
  // ---------------------------------------------------------------------
  static const Color background = Color(0xFFF7F9FB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF2F4F6);
  static const Color surfaceContainer = Color(0xFFECEEF0);
  static const Color surfaceContainerHigh = Color(0xFFE6E8EA);
  static const Color outline = Color(0xFF76777D);
  static const Color outlineVariant = Color(0xFFC6C6CD);

  // ---------------------------------------------------------------------
  // Texto
  // ---------------------------------------------------------------------
  static const Color onBackground = Color(0xFF191C1E);
  static const Color onSurfaceVariant = Color(0xFF45464D);

  // ---------------------------------------------------------------------
  // Erro
  // ---------------------------------------------------------------------
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFF93000A);

  static const Color success = Color(0xFF1B7A3A);
  static const Color successContainer = Color(0xFFDDF6E8);
  static const Color onSuccessContainer = Color(0xFF0A4C27);

  // ---------------------------------------------------------------------
  // Cores semânticas de status (chips de lembrete na lista de veículos)
  // ---------------------------------------------------------------------
  static const Color statusEmDia = Color(0xFF2E7D32);
  static const Color statusEmDiaBg = Color(0xFFD9F2DD);

  static const Color statusProximo = Color(0xFFB26A00);
  static const Color statusProximoBg = Color(0xFFFFEBC8);

  static const Color statusAtrasado = Color(0xFFC62828);
  static const Color statusAtrasadoBg = Color(0xFFFBDCDA);

  static const Color statusManutencao = Color(0xFFC62828);
  static const Color statusManutencaoBg = Color(0xFFFBDCDA);

  static const Color statusSemLembrete = Color(0xFF757575);
  static const Color statusSemLembreteBg = Color(0xFFE6E6E6);

  // ---------------------------------------------------------------------
  // Ícones de tipo de veículo (avatar circular na lista)
  // ---------------------------------------------------------------------
  static const Color vehicleIcon = Color(0xFF006591);
  static const Color vehicleIconBg = Color(0xFFDCEEFB);

  // ---------------------------------------------------------------------
  // Tela de perfil
  // ---------------------------------------------------------------------
  static const Color avatarBg = Color(0xFF3B82F6);
  static const Color premiumGold = Color(0xFFFACC15);
  static const Color premiumCardBg = Color(0xFFECFDF5);
  static const Color premiumCardBorder = Color(0xFFD1FAE5);
  static const Color premiumCardText = Color(0xFF047857);
  static const Color freeCardIconBg = Color(0xFFF1F5F9);
  static const Color dangerBorder = Color(0xFFFEE2E2);

  // ---------------------------------------------------------------------
  // Tela de premium (paywall)
  // ---------------------------------------------------------------------
  static const Color premiumHeroBg = Color(0xFFBEE3F8);
  static const Color premiumHeroIcon = Color(0xFF006591);
  static const Color benefitIconBg = Color(0xFFDFF3EC);
  static const Color benefitIcon = Color(0xFF009668);
  static const Color planSelectedBorder = Color(0xFF006591);
  static const Color planSelectedBg = Color(0xFFF0F9FF);


}