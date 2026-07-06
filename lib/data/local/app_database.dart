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
  int get schemaVersion => 2;

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
        },
      );

  // ---------- Veículos ----------

  Future<List<Vehicle>> watchAllVehicles() => select(vehicles).get();

  Stream<List<Vehicle>> streamAllVehicles() => select(vehicles).watch();

  /// Observa um único veículo — usado na tela de detalhe pra refletir
  /// edições (nome, placa, km) feitas em qualquer lugar do app, sem precisar
  /// sair e voltar da tela pra ver a mudança.
  Stream<Vehicle> watchVehicleById(String id) {
    return (select(vehicles)..where((v) => v.id.equals(id))).watchSingle();
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
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'moto_carro.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}