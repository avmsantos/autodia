import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'tables.dart';

part 'app_database.g.dart';

const _uuid = Uuid();

@DriftDatabase(tables: [Vehicles, MaintenanceCategories, MaintenanceEvents, Reminders])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _seedCategories();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(maintenanceCategories, maintenanceCategories.tipoCalculo);
            await m.addColumn(reminders, reminders.dataVencimentoManual);
            await m.addColumn(reminders, reminders.valorPago);
            // Categorias já existentes de documento/custo fixo passam a ser
            // tratadas como "calendario" (sem km) em vez do padrão "uso".
            await (update(maintenanceCategories)
                  ..where((c) => c.nome.isIn(['IPVA', 'Seguro', 'Licenciamento'])))
                .write(
              const MaintenanceCategoriesCompanion(
                tipoCalculo: Value(CategoryCalculationType.calendario),
              ),
            );
          }
          if (from < 3) {
            // Categoria de combustível não existia — necessária pro relatório
            // de gastos e pros insights conseguirem falar sobre abastecimento.
            final jaExiste = await (select(maintenanceCategories)
                  ..where((c) => c.nome.equals('Abastecimento')))
                .getSingleOrNull();
            if (jaExiste == null) {
              await into(maintenanceCategories).insert(_cat('Abastecimento', 'ambos', 'local_gas_station'));
            }
          }
        },
      );

  // ---------- Veículos ----------

  Future<List<Vehicle>> watchAllVehicles() => select(vehicles).get();

  Stream<List<Vehicle>> streamAllVehicles() => select(vehicles).watch();

  /// Observa um único veículo — usado na tela de detalhe pra refletir
  /// edições (nome, placa, km) feitas em qualquer lugar do app, sem precisar
  /// sair e voltar da tela pra ver a mudança.
  ///
  /// Usa `watchSingleOrNull` (não `watchSingle`) de propósito: quando o
  /// veículo é excluído, a linha desaparece e `watchSingle` quebraria o
  /// stream com um erro não tratado, já que ele exige sempre exatamente
  /// uma linha.
  Stream<Vehicle?> watchVehicleById(String id) {
    return (select(vehicles)..where((v) => v.id.equals(id))).watchSingleOrNull();
  }

  Future<String> insertVehicle({
    required String tipo,
    required String nome,
    String? placa,
    String? fotoPath,
    int kmAtual = 0,
  }) async {
    final id = _uuid.v4();
    await into(vehicles).insert(
      VehiclesCompanion.insert(
        id: id,
        tipo: tipo,
        nome: nome,
        placa: Value(placa),
        fotoPath: Value(fotoPath),
        kmAtual: Value(kmAtual),
        kmAtualizadoEm: Value(DateTime.now()),
      ),
    );
    return id;
  }

  Future<void> updateVehicleKm(String vehicleId, int novoKm) {
    return (update(vehicles)..where((v) => v.id.equals(vehicleId))).write(
      VehiclesCompanion(
        kmAtual: Value(novoKm),
        kmAtualizadoEm: Value(DateTime.now()),
      ),
    );
  }

  Future<void> updateVehicle({
    required String vehicleId,
    required String tipo,
    required String nome,
    String? placa,
  }) {
    return (update(vehicles)..where((v) => v.id.equals(vehicleId))).write(
      VehiclesCompanion(
        tipo: Value(tipo),
        nome: Value(nome),
        placa: Value(placa),
      ),
    );
  }

  /// Remove o veículo e tudo que depende dele (eventos e lembretes).
  /// Quem chamar isso também precisa cancelar as notificações agendadas
  /// desses lembretes (ver NotificationService) ANTES ou DEPOIS de chamar
  /// este método — a exclusão em si não mexe em notificação.
  Future<void> deleteVehicle(String vehicleId) async {
    await (delete(maintenanceEvents)..where((e) => e.veiculoId.equals(vehicleId))).go();
    await (delete(reminders)..where((r) => r.veiculoId.equals(vehicleId))).go();
    await (delete(vehicles)..where((v) => v.id.equals(vehicleId))).go();
  }

  // ---------- Categorias ----------

  Future<List<MaintenanceCategory>> categoriesForType(String veiculoTipo) {
    return (select(maintenanceCategories)
          ..where((c) =>
              c.veiculoTipoAplicavel.equals(veiculoTipo) |
              c.veiculoTipoAplicavel.equals('ambos')))
        .get();
  }

  Future<void> _seedCategories() async {
    final seed = <MaintenanceCategoriesCompanion>[
      // ambos — mecânicas (uso)
      _cat('Troca de óleo', 'ambos', 'oil_barrel'),
      _cat('Revisão geral', 'ambos', 'build'),
      _cat('Troca de pneu', 'ambos', 'tire_repair'),
      _cat('Pastilha/lona de freio', 'ambos', 'disc_full'),
      _cat('Abastecimento', 'ambos', 'local_gas_station'),
      // ambos — documento/calendário
      _cat('IPVA', 'ambos', 'receipt_long',
          tipo: CategoryCalculationType.calendario),
      _cat('Seguro', 'ambos', 'shield',
          tipo: CategoryCalculationType.calendario),
      _cat('Licenciamento', 'ambos', 'assignment_turned_in',
          tipo: CategoryCalculationType.calendario),
      // carro — mecânicas
      _cat('Alinhamento e balanceamento', 'carro', 'align_horizontal_center'),
      _cat('Troca de filtro de ar', 'carro', 'air'),
      _cat('Troca de correia dentada', 'carro', 'settings'),
      _cat('Bateria', 'carro', 'battery_full'),
      // moto — mecânicas
      _cat('Relação (corrente/coroa/pinhão)', 'moto', 'link'),
      _cat('Troca de vela', 'moto', 'flash_on'),
      _cat('Revisão de suspensão', 'moto', 'height'),
    ];
    await batch((b) => b.insertAll(maintenanceCategories, seed));
  }

  MaintenanceCategoriesCompanion _cat(
    String nome,
    String tipoVeiculo,
    String icone, {
    String tipo = CategoryCalculationType.uso,
  }) {
    return MaintenanceCategoriesCompanion.insert(
      id: _uuid.v4(),
      nome: nome,
      veiculoTipoAplicavel: tipoVeiculo,
      icone: Value(icone),
      tipoCalculo: Value(tipo),
    );
  }

  // ---------- Eventos de manutenção ----------

  Future<void> insertEvent({
    required String veiculoId,
    required String categoriaId,
    required DateTime dataRealizada,
    int? kmRealizado,
    double? valorGasto,
    String? oficina,
    String? observacao,
    String? anexoPath,
  }) {
    return into(maintenanceEvents).insert(
      MaintenanceEventsCompanion.insert(
        id: _uuid.v4(),
        veiculoId: veiculoId,
        categoriaId: categoriaId,
        dataRealizada: dataRealizada,
        kmRealizado: Value(kmRealizado),
        valorGasto: Value(valorGasto),
        oficina: Value(oficina),
        observacao: Value(observacao),
        anexoPath: Value(anexoPath),
      ),
    );
  }

  Future<void> updateEvent({
    required String eventId,
    required String categoriaId,
    required DateTime dataRealizada,
    int? kmRealizado,
    double? valorGasto,
    String? oficina,
    String? observacao,
    String? anexoPath,
  }) {
    return (update(maintenanceEvents)..where((e) => e.id.equals(eventId))).write(
      MaintenanceEventsCompanion(
        categoriaId: Value(categoriaId),
        dataRealizada: Value(dataRealizada),
        kmRealizado: Value(kmRealizado),
        valorGasto: Value(valorGasto),
        oficina: Value(oficina),
        observacao: Value(observacao),
        anexoPath: Value(anexoPath),
      ),
    );
  }

  Future<void> deleteEvent(String eventId) {
    return (delete(maintenanceEvents)..where((e) => e.id.equals(eventId))).go();
  }

  Stream<List<MaintenanceEvent>> streamEventsForVehicle(String veiculoId) {
    return (select(maintenanceEvents)
          ..where((e) => e.veiculoId.equals(veiculoId))
          ..orderBy([(e) => OrderingTerm.desc(e.dataRealizada)]))
        .watch();
  }

  /// Todos os eventos de manutenção de um veículo (sem filtro de data) —
  /// usado no relatório de gastos, que agrupa por ano depois em memória.
  Future<List<MaintenanceEvent>> allEventsForVehicle(String veiculoId) {
    return (select(maintenanceEvents)..where((e) => e.veiculoId.equals(veiculoId))).get();
  }

  /// Histórico de km (data + km) derivado dos próprios eventos de manutenção,
  /// usado pela calculadora pra estimar a média de uso do veículo.
  Future<List<(DateTime, int)>> kmHistoryForVehicle(String veiculoId) async {
    final rows = await (select(maintenanceEvents)
          ..where((e) =>
              e.veiculoId.equals(veiculoId) & e.kmRealizado.isNotNull())
          ..orderBy([(e) => OrderingTerm.asc(e.dataRealizada)]))
        .get();
    return rows.map((r) => (r.dataRealizada, r.kmRealizado!)).toList();
  }

  // ---------- Lembretes ----------

  Future<String> insertReminder({
    required String veiculoId,
    required String categoriaId,
    required DateTime ultimaDataFeita,
    int? ultimoKmFeito,
    int? intervaloMeses,
    int? intervaloKm,
    DateTime? dataVencimentoManual,
    double? valorPago,
  }) async {
    final id = _uuid.v4();
    await into(reminders).insert(
      RemindersCompanion.insert(
        id: id,
        veiculoId: veiculoId,
        categoriaId: categoriaId,
        ultimaDataFeita: ultimaDataFeita,
        ultimoKmFeito: Value(ultimoKmFeito),
        intervaloMeses: Value(intervaloMeses),
        intervaloKm: Value(intervaloKm),
        dataVencimentoManual: Value(dataVencimentoManual),
        valorPago: Value(valorPago),
      ),
    );
    return id;
  }

  Future<void> updateReminder({
    required String reminderId,
    required DateTime ultimaDataFeita,
    int? ultimoKmFeito,
    int? intervaloMeses,
    int? intervaloKm,
    DateTime? dataVencimentoManual,
    double? valorPago,
  }) {
    return (update(reminders)..where((r) => r.id.equals(reminderId))).write(
      RemindersCompanion(
        ultimaDataFeita: Value(ultimaDataFeita),
        ultimoKmFeito: Value(ultimoKmFeito),
        intervaloMeses: Value(intervaloMeses),
        intervaloKm: Value(intervaloKm),
        dataVencimentoManual: Value(dataVencimentoManual),
        valorPago: Value(valorPago),
      ),
    );
  }

  /// Exclusão lógica — mantém o histórico no banco mas some da lista ativa
  /// e não deve mais ser notificado (quem chama também cancela a notificação
  /// via NotificationService).
  Future<void> deleteReminder(String reminderId) {
    return (update(reminders)..where((r) => r.id.equals(reminderId)))
        .write(const RemindersCompanion(ativo: Value(false)));
  }

  Stream<List<Reminder>> streamRemindersForVehicle(String veiculoId) {
    return (select(reminders)
          ..where((r) => r.veiculoId.equals(veiculoId) & r.ativo.equals(true)))
        .watch();
  }

  /// Observa TODOS os lembretes (de todos os veículos) — usado só pra saber
  /// quando algo mudou e disparar recálculo, ex: na Home.
  Stream<List<Reminder>> watchAllReminders() => select(reminders).watch();

  /// Lembretes de documento (IPVA, seguro, etc) que têm valor pago
  /// registrado — usado no relatório de gastos junto com os eventos de
  /// manutenção, já que também é dinheiro gasto de verdade com o veículo.
  Future<List<Reminder>> allRemindersWithPaymentForVehicle(String veiculoId) {
    return (select(reminders)
          ..where((r) => r.veiculoId.equals(veiculoId) & r.valorPago.isNotNull()))
        .get();
  }

  Future<void> updateReminderStatus(String reminderId, String status) {
    return (update(reminders)..where((r) => r.id.equals(reminderId)))
        .write(RemindersCompanion(status: Value(status)));
  }

  /// Apaga TODOS os dados do usuário (veículos, histórico, lembretes) —
  /// usado na exclusão de conta, exigência do Google Play. As categorias
  /// (catálogo padrão do app) não são apagadas, já que não são dado pessoal.
  Future<void> excluirTudoDoUsuario() async {
    await delete(maintenanceEvents).go();
    await delete(reminders).go();
    await delete(vehicles).go();
  }

  // ---------- Backup / Restauração ----------
  //
  // Formato simples de arquivo (JSON), pensado pra dar pra restaurar em
  // outro aparelho ou depois de reinstalar. NÃO inclui o arquivo das fotos
  // anexadas (só o caminho) — se o aparelho for outro, as fotos não vêm
  // junto, só o resto dos dados. Botar a imagem em base64 no JSON deixaria
  // o arquivo gigante pra pouco ganho prático.

  static const _versaoBackup = 1;

  Future<Map<String, dynamic>> exportarBackup() async {
    final veiculos = await select(vehicles).get();
    final categoriasCustomizadas =
        await (select(maintenanceCategories)..where((c) => c.customizada.equals(true)))
            .get();
    final eventos = await select(maintenanceEvents).get();
    final todosLembretes = await select(reminders).get();

    return {
      'versao': _versaoBackup,
      'exportadoEm': DateTime.now().toIso8601String(),
      'veiculos': veiculos.map((v) => {
            'id': v.id,
            'tipo': v.tipo,
            'nome': v.nome,
            'placa': v.placa,
            'fotoPath': v.fotoPath,
            'kmAtual': v.kmAtual,
            'kmAtualizadoEm': v.kmAtualizadoEm.toIso8601String(),
            'criadoEm': v.criadoEm.toIso8601String(),
          }).toList(),
      'categoriasCustomizadas': categoriasCustomizadas.map((c) => {
            'id': c.id,
            'nome': c.nome,
            'veiculoTipoAplicavel': c.veiculoTipoAplicavel,
            'icone': c.icone,
            'tipoCalculo': c.tipoCalculo,
          }).toList(),
      'eventos': eventos.map((e) => {
            'id': e.id,
            'veiculoId': e.veiculoId,
            'categoriaId': e.categoriaId,
            'dataRealizada': e.dataRealizada.toIso8601String(),
            'kmRealizado': e.kmRealizado,
            'valorGasto': e.valorGasto,
            'oficina': e.oficina,
            'observacao': e.observacao,
            'anexoPath': e.anexoPath,
            'criadoEm': e.criadoEm.toIso8601String(),
          }).toList(),
      'lembretes': todosLembretes.map((r) => {
            'id': r.id,
            'veiculoId': r.veiculoId,
            'categoriaId': r.categoriaId,
            'ultimaDataFeita': r.ultimaDataFeita.toIso8601String(),
            'ultimoKmFeito': r.ultimoKmFeito,
            'intervaloMeses': r.intervaloMeses,
            'intervaloKm': r.intervaloKm,
            'dataVencimentoManual': r.dataVencimentoManual?.toIso8601String(),
            'valorPago': r.valorPago,
            'ativo': r.ativo,
            'criadoEm': r.criadoEm.toIso8601String(),
          }).toList(),
    };
  }

  /// Restaura um backup — SUBSTITUI os dados atuais (não faz merge). Quem
  /// chama isso já deve ter confirmado com o usuário antes, é destrutivo.
  Future<void> restaurarBackup(Map<String, dynamic> dados) async {
    await transaction(() async {
      // Limpa dados atuais (mas não as categorias padrão do app).
      await delete(maintenanceEvents).go();
      await delete(reminders).go();
      await delete(vehicles).go();
      await (delete(maintenanceCategories)..where((c) => c.customizada.equals(true))).go();

      for (final c in (dados['categoriasCustomizadas'] as List)) {
        await into(maintenanceCategories).insert(
          MaintenanceCategoriesCompanion.insert(
            id: c['id'],
            nome: c['nome'],
            veiculoTipoAplicavel: c['veiculoTipoAplicavel'],
            icone: Value(c['icone']),
            customizada: const Value(true),
            tipoCalculo: Value(c['tipoCalculo']),
          ),
        );
      }

      for (final v in (dados['veiculos'] as List)) {
        await into(vehicles).insert(
          VehiclesCompanion.insert(
            id: v['id'],
            tipo: v['tipo'],
            nome: v['nome'],
            placa: Value(v['placa']),
            fotoPath: Value(v['fotoPath']),
            kmAtual: Value(v['kmAtual'] ?? 0),
            kmAtualizadoEm: Value(DateTime.parse(v['kmAtualizadoEm'])),
          ),
        );
      }

      for (final e in (dados['eventos'] as List)) {
        await into(maintenanceEvents).insert(
          MaintenanceEventsCompanion.insert(
            id: e['id'],
            veiculoId: e['veiculoId'],
            categoriaId: e['categoriaId'],
            dataRealizada: DateTime.parse(e['dataRealizada']),
            kmRealizado: Value(e['kmRealizado']),
            valorGasto: Value((e['valorGasto'] as num?)?.toDouble()),
            oficina: Value(e['oficina']),
            observacao: Value(e['observacao']),
            anexoPath: Value(e['anexoPath']),
          ),
        );
      }

      for (final r in (dados['lembretes'] as List)) {
        await into(reminders).insert(
          RemindersCompanion.insert(
            id: r['id'],
            veiculoId: r['veiculoId'],
            categoriaId: r['categoriaId'],
            ultimaDataFeita: DateTime.parse(r['ultimaDataFeita']),
            ultimoKmFeito: Value(r['ultimoKmFeito']),
            intervaloMeses: Value(r['intervaloMeses']),
            intervaloKm: Value(r['intervaloKm']),
            dataVencimentoManual: Value(
              r['dataVencimentoManual'] != null
                  ? DateTime.parse(r['dataVencimentoManual'])
                  : null,
            ),
            valorPago: Value((r['valorPago'] as num?)?.toDouble()),
            ativo: Value(r['ativo'] ?? true),
          ),
        );
      }
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'moto_carro.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}