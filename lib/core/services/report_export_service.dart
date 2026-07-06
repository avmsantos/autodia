import 'dart:io';

import 'package:path_provider/path_provider.dart';

class ReportExportMonth {
  final String month;
  final double value;

  const ReportExportMonth({required this.month, required this.value});
}

class ReportExportCategory {
  final String name;
  final double value;

  const ReportExportCategory({required this.name, required this.value});
}

class ReportExportService {
  String buildCsvContent({
    required String vehicleName,
    required int year,
    required double total,
    required List<ReportExportMonth> monthlyValues,
    required List<ReportExportCategory> categoryValues,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('veiculo,ano,total');
    buffer.writeln('$vehicleName,$year,$total');
    buffer.writeln();
    buffer.writeln('mes,valor');
    for (final item in monthlyValues) {
      buffer.writeln('${item.month},${item.value.toStringAsFixed(2)}');
    }
    buffer.writeln();
    buffer.writeln('categoria,valor');
    for (final item in categoryValues) {
      buffer.writeln('${item.name},${item.value.toStringAsFixed(2)}');
    }
    return buffer.toString();
  }

  Future<File> exportCsv({
    required String vehicleName,
    required int year,
    required double total,
    required List<ReportExportMonth> monthlyValues,
    required List<ReportExportCategory> categoryValues,
  }) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/relatorio_${vehicleName.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')}_$year.csv');
    final content = buildCsvContent(
      vehicleName: vehicleName,
      year: year,
      total: total,
      monthlyValues: monthlyValues,
      categoryValues: categoryValues,
    );
    return file.writeAsString(content, flush: true);
  }
}
