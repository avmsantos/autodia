import 'package:flutter/material.dart';

import '../core/calculations/maintenance_calculator.dart';
import '../modules/home/home_controller.dart';
import '../theme/app_colors.dart';
import 'status_badge.dart';

class VehicleCard extends StatelessWidget {
  final VehicleWithStatus item;
  final VoidCallback onTap;

  const VehicleCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final vehicle = item.vehicle;
    final isMoto = vehicle.tipo == 'moto';
    final isAtrasado =
        item.mostUrgentResult?.status == MaintenanceStatus.atrasado;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isAtrasado
              ? AppColors.error
              : AppColors.outlineVariant.withValues(alpha: 0.4),
          width: isAtrasado ? 1.5 : 1,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: isAtrasado
              ? const Border(
                  left: BorderSide(
                    color: AppColors.error,
                    width: 6,
                  ),
                )
              : null,
        ),
        child: ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: CircleAvatar(
            backgroundColor: AppColors.vehicleIconBg,
            child: Icon(
              isMoto ? Icons.two_wheeler : Icons.directions_car,
              color: AppColors.vehicleIcon,
            ),
          ),
          title: Text(
            vehicle.nome,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            '${vehicle.placa ?? 'sem placa'} · ${vehicle.kmAtual} km',
          ),
          trailing: StatusBadge(
            status: item.mostUrgentResult?.status,
          ),
        ),
      ),
    );
  }
}