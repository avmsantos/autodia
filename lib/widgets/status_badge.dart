import 'package:flutter/material.dart';

import '../core/calculations/maintenance_calculator.dart';
import '../theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final MaintenanceStatus? status;

  const StatusBadge({super.key, this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      MaintenanceStatus.atrasado => ('ATRASADO', AppColors.error),
      MaintenanceStatus.proximo => ('PRÓXIMO', AppColors.premiumGold),
      MaintenanceStatus.emDia => ('EM DIA', AppColors.success),
      null => ('SEM LEMBRETE', AppColors.onSurfaceVariant),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.onPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
