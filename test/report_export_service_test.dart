import 'package:flutter_test/flutter_test.dart';
import 'package:autodia/core/services/report_export_service.dart';

void main() {
  group('ReportExportService', () {
    test('gera conteúdo CSV com total, meses e categorias', () {
      final service = ReportExportService();

      final csv = service.buildCsvContent(
        vehicleName: 'CG 150',
        year: 2025,
        total: 1250.5,
        monthlyValues: [
        const ReportExportMonth(month: 'Jan', value: 500.0),
          const ReportExportMonth(month: 'Fev', value: 750.5),
        ],
        categoryValues: [
          const ReportExportCategory(name: 'Manutenção', value: 900.0),
          const ReportExportCategory(name: 'Combustível', value: 350.5),
        ],
      );

      expect(csv, contains('veiculo,ano,total'));
      expect(csv, contains('CG 150,2025,1250.5'));
      expect(csv, contains('mes,valor'));
      expect(csv, contains('Jan,500.0'));
      expect(csv, contains('categoria,valor'));
      expect(csv, contains('Manutenção,900.0'));
    });
  });
}
