import 'package:flutter/material.dart';

import '../core/calculations/maintenance_calculator.dart';

class StatusBadge extends StatelessWidget {
  final MaintenanceStatus? status;

  const StatusBadge({super.key, this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      MaintenanceStatus.atrasado => ('Atrasado', Colors.red),
      MaintenanceStatus.proximo => ('Próximo', Colors.orange),
      MaintenanceStatus.emDia => ('Em dia', Colors.green),
      null => ('Sem lembrete', Colors.grey),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
