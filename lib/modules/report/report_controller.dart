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

  /// Texto do card "Insight" — null quando não há dado suficiente pra gerar
  /// nada relevante (evita mostrar insight forçado/sem sentido).
  final Rx<String?> insight = Rx<String?>(null);

  static const _mesesNomes = [
    'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
    'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro',
  ];

  /// Sugestão complementar por categoria — puramente cosmético, dá contexto
  /// prático ao insight em vez de só o número. Categoria sem entrada aqui
  /// cai no fallback genérico em [_sugestaoPara].
  static const _sugestoesPorCategoria = {
    'Abastecimento': 'Considere uma revisão nos filtros de ar para melhorar a eficiência.',
    'Troca de óleo': 'Vale conferir se o intervalo entre trocas está sendo respeitado.',
    'Troca de pneu': 'Confira o alinhamento — desgaste irregular encarece a troca.',
    'Pastilha/lona de freio': 'Um freio gasto demais pode indicar necessidade de revisão do sistema.',
  };

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

    // Categoria -> mês(1-12) -> valor. Granularidade extra só usada pelo
    // cálculo do insight, não pelos outros cards da tela.
    final porCategoriaPorMes = <String, List<double>>{};

    void registrar(String categoriaId, int mes, double valor) {
      total += valor;
      porMes[mes - 1] += valor;
      final nome = _categoriaNomes[categoriaId] ?? 'Outros';
      porCategoria[nome] = (porCategoria[nome] ?? 0) + valor;
      porCategoriaPorMes.putIfAbsent(nome, () => List.filled(12, 0));
      porCategoriaPorMes[nome]![mes - 1] += valor;
    }

    for (final e in eventosDoAno) {
      registrar(e.categoriaId, e.dataRealizada.month, e.valorGasto ?? 0);
    }
    for (final r in pagamentosDoAno) {
      registrar(r.categoriaId, r.ultimaDataFeita.month, r.valorPago ?? 0);
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

    _gerarInsight(porCategoriaPorMes);
  }

  /// Compara o mês mais recente com gasto, em cada categoria, contra a média
  /// dos outros meses da mesma categoria nesse ano. Mostra só a categoria com
  /// o desvio mais expressivo (%), e só se passar de um limiar mínimo — pra
  /// não gerar "insight" de ruído estatístico com pouco dado.
  void _gerarInsight(Map<String, List<double>> porCategoriaPorMes) {
    String? melhorCategoria;
    double melhorVariacao = 0;

    porCategoriaPorMes.forEach((categoria, valoresPorMes) {
      final mesesComDado = <int>[];
      for (var i = 0; i < 12; i++) {
        if (valoresPorMes[i] > 0) mesesComDado.add(i);
      }
      // Precisa de pelo menos 2 meses com gasto pra ter "média" com sentido.
      if (mesesComDado.length < 2) return;

      final mesMaisRecente = mesesComDado.last;
      final valorMesAtual = valoresPorMes[mesMaisRecente];

      final mesesAnteriores = mesesComDado.sublist(0, mesesComDado.length - 1);
      final mediaAnterior =
          mesesAnteriores.map((m) => valoresPorMes[m]).reduce((a, b) => a + b) /
              mesesAnteriores.length;

      if (mediaAnterior <= 0) return;

      final variacao = (valorMesAtual - mediaAnterior) / mediaAnterior;

      // Só considera aumento relevante (>=15%) — quedas não viram alerta aqui,
      // o objetivo é chamar atenção pra gasto crescendo, não elogiar economia.
      if (variacao >= 0.15 && variacao > melhorVariacao) {
        melhorVariacao = variacao;
        melhorCategoria = categoria;
      }
    });

    if (melhorCategoria == null) {
      insight.value = null;
      return;
    }

    final percentual = (melhorVariacao * 100).round();
    final sugestao = _sugestaoPara(melhorCategoria!);
    insight.value =
        'Seus gastos com ${melhorCategoria!.toLowerCase()} aumentaram $percentual% '
        'neste mês em comparação à média. $sugestao';
  }

  String _sugestaoPara(String categoria) {
    return _sugestoesPorCategoria[categoria] ??
        'Vale ficar de olho nesse gasto nos próximos meses.';
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