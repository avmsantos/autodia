import 'package:drift/drift.dart';

/// Tipo de veículo. Guardado como texto pra ficar legível direto no banco.
class VehicleType {
  static const carro = 'carro';
  static const moto = 'moto';
}

/// Como a categoria calcula vencimento:
/// - `uso`: manutenção mecânica, baseada em desgaste (data e/ou km).
/// - `calendario`: documento/custo fixo (IPVA, seguro, licenciamento),
///   baseado só em data — não faz sentido perguntar km pra essas.
class CategoryCalculationType {
  static const uso = 'uso';
  static const calendario = 'calendario';
}

@DataClassName('Vehicle')
class Vehicles extends Table {
  TextColumn get id => text()();
  TextColumn get tipo => text()(); // VehicleType.carro | VehicleType.moto
  TextColumn get nome => text()(); // ex: "Onix 2020", "CG 160 Fan"
  TextColumn get placa => text().nullable()();
  TextColumn get fotoPath => text().nullable()();
  IntColumn get kmAtual => integer().withDefault(const Constant(0))();
  DateTimeColumn get kmAtualizadoEm => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get criadoEm => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Categorias de manutenção pré-cadastradas (seed) + eventuais customizadas
/// pelo usuário. `veiculoTipoAplicavel` filtra o que aparece pra carro vs moto.
@DataClassName('MaintenanceCategory')
class MaintenanceCategories extends Table {
  TextColumn get id => text()();
  TextColumn get nome => text()();
  TextColumn get veiculoTipoAplicavel => text()(); // carro | moto | ambos
  TextColumn get icone => text().withDefault(const Constant('build'))();
  BoolColumn get customizada => boolean().withDefault(const Constant(false))();
  TextColumn get tipoCalculo =>
      text().withDefault(const Constant(CategoryCalculationType.uso))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Histórico real de manutenções já realizadas.
@DataClassName('MaintenanceEvent')
class MaintenanceEvents extends Table {
  TextColumn get id => text()();
  TextColumn get veiculoId => text().references(Vehicles, #id)();
  TextColumn get categoriaId => text().references(MaintenanceCategories, #id)();
  DateTimeColumn get dataRealizada => dateTime()();
  IntColumn get kmRealizado => integer().nullable()();
  RealColumn get valorGasto => real().nullable()();
  TextColumn get oficina => text().nullable()();
  TextColumn get observacao => text().nullable()();
  TextColumn get anexoPath => text().nullable()();
  DateTimeColumn get criadoEm => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Lembretes configurados — o que o app deve avisar antes de vencer.
///
/// Duas formas de uso:
/// - Mecânico (categoria tipo `uso`): preenche `ultimaDataFeita` +
///   `ultimoKmFeito`, e um ou os dois de `intervaloMeses`/`intervaloKm`.
///   O vencimento é CALCULADO (ver maintenance_calculator.dart).
/// - Documento/calendário (categoria tipo `calendario`): preenche
///   `ultimaDataFeita` (data de pagamento) e `dataVencimentoManual`
///   diretamente — sem cálculo, é a data que o usuário informou.
@DataClassName('Reminder')
class Reminders extends Table {
  TextColumn get id => text()();
  TextColumn get veiculoId => text().references(Vehicles, #id)();
  TextColumn get categoriaId => text().references(MaintenanceCategories, #id)();

  DateTimeColumn get ultimaDataFeita => dateTime()();
  IntColumn get ultimoKmFeito => integer().nullable()();

  IntColumn get intervaloMeses => integer().nullable()();
  IntColumn get intervaloKm => integer().nullable()();

  /// Só usado por categorias `calendario` — data de vencimento informada
  /// diretamente pelo usuário (ex: vencimento do IPVA), sem cálculo.
  DateTimeColumn get dataVencimentoManual => dateTime().nullable()();

  /// Valor pago (opcional), útil pra IPVA/seguro/licenciamento.
  RealColumn get valorPago => real().nullable()();

  TextColumn get status =>
      text().withDefault(const Constant('em_dia'))(); // em_dia | proximo | atrasado
  BoolColumn get ativo => boolean().withDefault(const Constant(true))();
  DateTimeColumn get criadoEm => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
