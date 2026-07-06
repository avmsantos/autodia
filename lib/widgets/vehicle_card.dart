import 'package:flutter/material.dart';

import '../data/local/app_database.dart';
import '../modules/home/home_controller.dart';
import 'status_badge.dart';

class VehicleCard extends StatelessWidget {
  final VehicleWithStatus item;
  final VoidCallback onTap;

  const VehicleCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final vehicle = item.vehicle;
    final isMoto = vehicle.tipo == 'moto';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          child: Icon(isMoto ? Icons.two_wheeler : Icons.directions_car),
        ),
        title: Text(vehicle.nome, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          '${vehicle.placa ?? 'sem placa'} · ${vehicle.kmAtual} km',
        ),
        trailing: StatusBadge(status: item.mostUrgentResult?.status),
      ),
    );
  }
}
