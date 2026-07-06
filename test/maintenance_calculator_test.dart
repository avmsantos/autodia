import 'package:flutter_test/flutter_test.dart';
import 'package:autodia/core/calculations/maintenance_calculator.dart';

void main() {
  group('calculateMaintenanceStatus - por data', () {
    test('em dia quando falta mais de 30 dias', () {
      final result = calculateMaintenanceStatus(
        MaintenanceInput(
          lastDoneDate: DateTime(2026, 1, 1),
          intervalMonths: 12,
          currentKm: 10000,
          today: DateTime(2026, 6, 1),
        ),
      );
      expect(result.status, MaintenanceStatus.emDia);
      expect(result.effectiveDueDate, DateTime(2027, 1, 1));
    });

    test('atrasado quando a data já passou', () {
      final result = calculateMaintenanceStatus(
        MaintenanceInput(
          lastDoneDate: DateTime(2025, 1, 1),
          intervalMonths: 12,
          currentKm: 10000,
          today: DateTime(2026, 2, 1),
        ),
      );
      expect(result.status, MaintenanceStatus.atrasado);
    });
  });

  group('calculateMaintenanceStatus - por km', () {
    test('calcula km de vencimento e estimativa de data', () {
      final result = calculateMaintenanceStatus(
        MaintenanceInput(
          lastDoneDate: DateTime(2026, 1, 1),
          lastDoneKm: 10000,
          intervalKm: 10000,
          currentKm: 15000,
          today: DateTime(2026, 6, 1),
          kmHistory: [
            KmHistoryPoint(date: DateTime(2026, 1, 1), km: 10000),
            KmHistoryPoint(date: DateTime(2026, 6, 1), km: 15000),
          ],
        ),
      );
      // Média: 5000km em 151 dias ~= 33km/dia
      expect(result.nextDueKm, 20000);
      expect(result.kmRemaining, 5000);
      expect(result.status, MaintenanceStatus.emDia);
      expect(result.estimatedDateForKmTrigger, isNotNull);
    });

    test('próximo quando faltam 500km ou menos', () {
      final result = calculateMaintenanceStatus(
        MaintenanceInput(
          lastDoneDate: DateTime(2026, 1, 1),
          lastDoneKm: 10000,
          intervalKm: 10000,
          currentKm: 19600,
          today: DateTime(2026, 6, 1),
        ),
      );
      expect(result.kmRemaining, 400);
      expect(result.status, MaintenanceStatus.proximo);
    });

    test('usa média padrão de 30km/dia sem histórico suficiente', () {
      final avg = estimateAverageKmPerDay([]);
      expect(avg, 30.0);
    });
  });

  group('calculateMaintenanceStatus - data e km combinados', () {
    test('usa o gatilho que vence primeiro (km neste caso)', () {
      final result = calculateMaintenanceStatus(
        MaintenanceInput(
          lastDoneDate: DateTime(2026, 1, 1),
          lastDoneKm: 10000,
          intervalMonths: 12, // venceria em jan/2027
          intervalKm: 10000, // venceria em 20.000km
          currentKm: 19900, // faltam só 100km
          today: DateTime(2026, 3, 1),
          kmHistory: [
            KmHistoryPoint(date: DateTime(2026, 1, 1), km: 10000),
            KmHistoryPoint(date: DateTime(2026, 3, 1), km: 19900),
          ],
        ),
      );
      expect(result.triggerType, TriggerType.both);
      // A data estimada por km deve ser bem mais próxima que jan/2027
      expect(
        result.effectiveDueDate!.isBefore(DateTime(2027, 1, 1)),
        isTrue,
      );
      expect(result.status, MaintenanceStatus.proximo);
    });
  });
}
