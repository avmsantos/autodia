import 'package:get/get.dart';

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
  final RxInt anoSelecionado = DateTime.now().year.obs;
  final RxList<int> anosDisponiveis = <int>[].obs;

  final RxDouble totalAno = 0.0.obs;
  final RxList<GastoMensal> gastoPorMes = <GastoMensal>[].obs;
  final RxList<GastoCategoria> gastoPorCategoria = <GastoCategoria>[].obs;

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
}