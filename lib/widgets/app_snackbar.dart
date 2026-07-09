import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/app_colors.dart';

enum AppSnackBarType { success, error, info }

class AppSnackBarStyle {
  const AppSnackBarStyle({
    required this.backgroundColor,
    required this.textColor,
    required this.iconData,
    required this.iconColor,
    required this.leftBarIndicatorColor,
  });

  final Color backgroundColor;
  final Color textColor;
  final IconData iconData;
  final Color iconColor;
  final Color leftBarIndicatorColor;

  factory AppSnackBarStyle.fromType(AppSnackBarType type) {
    switch (type) {
      case AppSnackBarType.success:
        return const AppSnackBarStyle(
          backgroundColor: AppColors.successContainer,
          textColor: AppColors.onSuccessContainer,
          iconData: Icons.check_circle_outline_rounded,
          iconColor: AppColors.success,
          leftBarIndicatorColor: AppColors.success,
        );
      case AppSnackBarType.error:
        return const AppSnackBarStyle(
          backgroundColor: AppColors.errorContainer,
          textColor: AppColors.onErrorContainer,
          iconData: Icons.error_outline_rounded,
          iconColor: AppColors.error,
          leftBarIndicatorColor: AppColors.error,
        );
      case AppSnackBarType.info:
        return const AppSnackBarStyle(
          backgroundColor: AppColors.surface,
          textColor: AppColors.onBackground,
          iconData: Icons.info_outline_rounded,
          iconColor: AppColors.secondary,
          leftBarIndicatorColor: AppColors.secondary,
        );
    }
  }
}

void showAppSnackbar({
  required String title,
  required String message,
  AppSnackBarType type = AppSnackBarType.info,
  Duration? duration,
}) {
  final style = AppSnackBarStyle.fromType(type);

  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.TOP,
    duration: duration ?? const Duration(seconds: 4),
    margin: const EdgeInsets.all(0),
    borderRadius: 0,
    backgroundColor: style.backgroundColor,
    colorText: style.textColor,
    leftBarIndicatorColor: style.leftBarIndicatorColor,
    icon: Icon(style.iconData, color: style.iconColor, size: 24),
    isDismissible: true,
    forwardAnimationCurve: Curves.easeOutCirc,
    reverseAnimationCurve: Curves.easeOutCirc,
  );
}

void showSuccessSnackbar({required String title, required String message, Duration? duration}) {
  showAppSnackbar(title: title, message: message, type: AppSnackBarType.success, duration: duration);
}

void showErrorSnackbar({required String title, required String message, Duration? duration}) {
  showAppSnackbar(title: title, message: message, type: AppSnackBarType.error, duration: duration);
}

void showInfoSnackbar({required String title, required String message, Duration? duration}) {
  showAppSnackbar(title: title, message: message, type: AppSnackBarType.info, duration: duration);
}
