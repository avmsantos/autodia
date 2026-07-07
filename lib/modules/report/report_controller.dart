import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:excel/excel.dart' as xls;
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/local/app_database.dart';

class GastoMensal {
  final int mes; // 1-12
  final double valor;
  const GastoMensal({required this.mes, required this.valor});
}

class GastoCategoria {
  final String nome;
  final double valor;
  const GastoCategoria({required this.nome, required this.valor});
}

class ReportController extends GetxController {
  final AppDatabase _db = Get.find<AppDatabase>();
  late final Vehicle vehicle;

  final RxBool isLoading = true.obs;
  final RxBool isExporting = false.obs;
  final RxInt anoSelecionado = DateTime.now().year.obs;
  final RxList<int> anosDisponiveis = <int>[].obs;

  final RxDouble totalAno = 0.0.obs;
  final RxList<GastoMensal> gastoPorMes = <GastoMensal>[].obs;
  final RxList<GastoCategoria> gastoPorCategoria = <GastoCategoria>[].obs;

  static const _mesesNomes = [
    'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
    'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro',
  ];

  List<MaintenanceEvent> _todosEventos = [];
  List<Reminder> _todosPagamentos = [];
  Map<String, String> _categoriaNomes = {};

  @override
  void onInit() {
    super.onInit();
    vehicle = Get.arguments as Vehicle;
    _carregar();
  }

  Future<void> _carregar() async {
    _todosEventos = await _db.allEventsForVehicle(vehicle.id);
    _todosPagamentos = await _db.allRemindersWithPaymentForVehicle(vehicle.id);

    final categorias = await _db.categoriesForType(vehicle.tipo);
    _categoriaNomes = {for (final c in categorias) c.id: c.nome};

    final anos = <int>{
      ..._todosEventos.map((e) => e.dataRealizada.year),
      ..._todosPagamentos.map((r) => r.ultimaDataFeita.year),
      DateTime.now().year,
    }.toList()
      ..sort((a, b) => b.compareTo(a));
    anosDisponiveis.assignAll(anos);

    _recalcular();
    isLoading.value = false;
  }

  void selecionarAno(int ano) {
    anoSelecionado.value = ano;
    _recalcular();
  }

  void _recalcular() {
    final ano = anoSelecionado.value;
    final eventosDoAno = _todosEventos.where((e) => e.dataRealizada.year == ano);
    final pagamentosDoAno =
        _todosPagamentos.where((r) => r.ultimaDataFeita.year == ano);

    double total = 0;
    final porMes = List<double>.filled(12, 0);
    final porCategoria = <String, double>{};

    for (final e in eventosDoAno) {
      final valor = e.valorGasto ?? 0;
      total += valor;
      porMes[e.dataRealizada.month - 1] += valor;
      final nome = _categoriaNomes[e.categoriaId] ?? 'Outros';
      porCategoria[nome] = (porCategoria[nome] ?? 0) + valor;
    }
    for (final r in pagamentosDoAno) {
      final valor = r.valorPago ?? 0;
      total += valor;
      porMes[r.ultimaDataFeita.month - 1] += valor;
      final nome = _categoriaNomes[r.categoriaId] ?? 'Outros';
      porCategoria[nome] = (porCategoria[nome] ?? 0) + valor;
    }

    totalAno.value = total;
    gastoPorMes.assignAll(
      List.generate(12, (i) => GastoMensal(mes: i + 1, valor: porMes[i])),
    );

    final listaCategoria = porCategoria.entries
        .map((e) => GastoCategoria(nome: e.key, valor: e.value))
        .toList()
      ..sort((a, b) => b.valor.compareTo(a.valor));
    gastoPorCategoria.assignAll(listaCategoria);
  }

  String get _nomeArquivoBase =>
      'gastos_${vehicle.nome.replaceAll(' ', '_')}_${anoSelecionado.value}';

  Future<void> exportarPdf() async {
    isExporting.value = true;
    try {
      final doc = pw.Document();
      final ano = anoSelecionado.value;

      doc.addPage(
        pw.Page(
          build: (context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Relatório de gastos · ${vehicle.nome}',
                style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
              ),
              pw.Text('Ano: $ano'),
              pw.SizedBox(height: 12),
              pw.Text(
                'Total gasto: R\$ ${totalAno.value.toStringAsFixed(2)}',
                style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Gasto por mês', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Table.fromTextArray(
                headers: ['Mês', 'Valor (R\$)'],
                data: gastoPorMes
                    .where((g) => g.valor > 0)
                    .map((g) => [_mesesNomes[g.mes - 1], g.valor.toStringAsFixed(2)])
                    .toList(),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Gasto por categoria', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Table.fromTextArray(
                headers: ['Categoria', 'Valor (R\$)'],
                data: gastoPorCategoria
                    .map((g) => [g.nome, g.valor.toStringAsFixed(2)])
                    .toList(),
              ),
            ],
          ),
        ),
      );

      await Printing.sharePdf(
        bytes: await doc.save(),
        filename: '$_nomeArquivoBase.pdf',
      );
    } finally {
      isExporting.value = false;
    }
  }

  Future<void> exportarExcel() async {
    isExporting.value = true;
    try {
      final ano = anoSelecionado.value;
      final workbook = xls.Excel.createExcel();
      final sheet = workbook[workbook.getDefaultSheet()!];

      sheet.appendRow([xls.TextCellValue('Relatório de gastos - ${vehicle.nome}')]);
      sheet.appendRow([xls.TextCellValue('Ano'), xls.IntCellValue(ano)]);
      sheet.appendRow([
        xls.TextCellValue('Total gasto'),
        xls.DoubleCellValue(totalAno.value),
      ]);
      sheet.appendRow([]);

      sheet.appendRow([xls.TextCellValue('Gasto por mês')]);
      sheet.appendRow([xls.TextCellValue('Mês'), xls.TextCellValue('Valor')]);
      for (final g in gastoPorMes.where((g) => g.valor > 0)) {
        sheet.appendRow([
          xls.TextCellValue(_mesesNomes[g.mes - 1]),
          xls.DoubleCellValue(g.valor),
        ]);
      }
      sheet.appendRow([]);

      sheet.appendRow([xls.TextCellValue('Gasto por categoria')]);
      sheet.appendRow([xls.TextCellValue('Categoria'), xls.TextCellValue('Valor')]);
      for (final g in gastoPorCategoria) {
        sheet.appendRow([xls.TextCellValue(g.nome), xls.DoubleCellValue(g.valor)]);
      }

      final bytes = workbook.save();
      if (bytes == null) return;

     final tempDir = await getTemporaryDirectory();
    final file = File(p.join(tempDir.path, '$_nomeArquivoBase.xlsx'));
    await file.writeAsBytes(bytes);

    // CORREÇÃO AQUI:
    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'Relatório de gastos - ${vehicle.nome}',
    );
    } finally {
      isExporting.value = false;
    }
  }
}