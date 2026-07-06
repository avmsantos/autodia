// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $VehiclesTable extends Vehicles with TableInfo<$VehiclesTable, Vehicle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VehiclesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
      'tipo', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
      'nome', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _placaMeta = const VerificationMeta('placa');
  @override
  late final GeneratedColumn<String> placa = GeneratedColumn<String>(
      'placa', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fotoPathMeta =
      const VerificationMeta('fotoPath');
  @override
  late final GeneratedColumn<String> fotoPath = GeneratedColumn<String>(
      'foto_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _kmAtualMeta =
      const VerificationMeta('kmAtual');
  @override
  late final GeneratedColumn<int> kmAtual = GeneratedColumn<int>(
      'km_atual', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _kmAtualizadoEmMeta =
      const VerificationMeta('kmAtualizadoEm');
  @override
  late final GeneratedColumn<DateTime> kmAtualizadoEm =
      GeneratedColumn<DateTime>('km_atualizado_em', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  static const VerificationMeta _criadoEmMeta =
      const VerificationMeta('criadoEm');
  @override
  late final GeneratedColumn<DateTime> criadoEm = GeneratedColumn<DateTime>(
      'criado_em', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, tipo, nome, placa, fotoPath, kmAtual, kmAtualizadoEm, criadoEm];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vehicles';
  @override
  VerificationContext validateIntegrity(Insertable<Vehicle> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
          _tipoMeta, tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta));
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('nome')) {
      context.handle(
          _nomeMeta, nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta));
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('placa')) {
      context.handle(
          _placaMeta, placa.isAcceptableOrUnknown(data['placa']!, _placaMeta));
    }
    if (data.containsKey('foto_path')) {
      context.handle(_fotoPathMeta,
          fotoPath.isAcceptableOrUnknown(data['foto_path']!, _fotoPathMeta));
    }
    if (data.containsKey('km_atual')) {
      context.handle(_kmAtualMeta,
          kmAtual.isAcceptableOrUnknown(data['km_atual']!, _kmAtualMeta));
    }
    if (data.containsKey('km_atualizado_em')) {
      context.handle(
          _kmAtualizadoEmMeta,
          kmAtualizadoEm.isAcceptableOrUnknown(
              data['km_atualizado_em']!, _kmAtualizadoEmMeta));
    }
    if (data.containsKey('criado_em')) {
      context.handle(_criadoEmMeta,
          criadoEm.isAcceptableOrUnknown(data['criado_em']!, _criadoEmMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Vehicle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Vehicle(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      tipo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tipo'])!,
      nome: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nome'])!,
      placa: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}placa']),
      fotoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}foto_path']),
      kmAtual: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}km_atual'])!,
      kmAtualizadoEm: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}km_atualizado_em'])!,
      criadoEm: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}criado_em'])!,
    );
  }

  @override
  $VehiclesTable createAlias(String alias) {
    return $VehiclesTable(attachedDatabase, alias);
  }
}

class Vehicle extends DataClass implements Insertable<Vehicle> {
  final String id;
  final String tipo;
  final String nome;
  final String? placa;
  final String? fotoPath;
  final int kmAtual;
  final DateTime kmAtualizadoEm;
  final DateTime criadoEm;
  const Vehicle(
      {required this.id,
      required this.tipo,
      required this.nome,
      this.placa,
      this.fotoPath,
      required this.kmAtual,
      required this.kmAtualizadoEm,
      required this.criadoEm});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tipo'] = Variable<String>(tipo);
    map['nome'] = Variable<String>(nome);
    if (!nullToAbsent || placa != null) {
      map['placa'] = Variable<String>(placa);
    }
    if (!nullToAbsent || fotoPath != null) {
      map['foto_path'] = Variable<String>(fotoPath);
    }
    map['km_atual'] = Variable<int>(kmAtual);
    map['km_atualizado_em'] = Variable<DateTime>(kmAtualizadoEm);
    map['criado_em'] = Variable<DateTime>(criadoEm);
    return map;
  }

  VehiclesCompanion toCompanion(bool nullToAbsent) {
    return VehiclesCompanion(
      id: Value(id),
      tipo: Value(tipo),
      nome: Value(nome),
      placa:
          placa == null && nullToAbsent ? const Value.absent() : Value(placa),
      fotoPath: fotoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(fotoPath),
      kmAtual: Value(kmAtual),
      kmAtualizadoEm: Value(kmAtualizadoEm),
      criadoEm: Value(criadoEm),
    );
  }

  factory Vehicle.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Vehicle(
      id: serializer.fromJson<String>(json['id']),
      tipo: serializer.fromJson<String>(json['tipo']),
      nome: serializer.fromJson<String>(json['nome']),
      placa: serializer.fromJson<String?>(json['placa']),
      fotoPath: serializer.fromJson<String?>(json['fotoPath']),
      kmAtual: serializer.fromJson<int>(json['kmAtual']),
      kmAtualizadoEm: serializer.fromJson<DateTime>(json['kmAtualizadoEm']),
      criadoEm: serializer.fromJson<DateTime>(json['criadoEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tipo': serializer.toJson<String>(tipo),
      'nome': serializer.toJson<String>(nome),
      'placa': serializer.toJson<String?>(placa),
      'fotoPath': serializer.toJson<String?>(fotoPath),
      'kmAtual': serializer.toJson<int>(kmAtual),
      'kmAtualizadoEm': serializer.toJson<DateTime>(kmAtualizadoEm),
      'criadoEm': serializer.toJson<DateTime>(criadoEm),
    };
  }

  Vehicle copyWith(
          {String? id,
          String? tipo,
          String? nome,
          Value<String?> placa = const Value.absent(),
          Value<String?> fotoPath = const Value.absent(),
          int? kmAtual,
          DateTime? kmAtualizadoEm,
          DateTime? criadoEm}) =>
      Vehicle(
        id: id ?? this.id,
        tipo: tipo ?? this.tipo,
        nome: nome ?? this.nome,
        placa: placa.present ? placa.value : this.placa,
        fotoPath: fotoPath.present ? fotoPath.value : this.fotoPath,
        kmAtual: kmAtual ?? this.kmAtual,
        kmAtualizadoEm: kmAtualizadoEm ?? this.kmAtualizadoEm,
        criadoEm: criadoEm ?? this.criadoEm,
      );
  Vehicle copyWithCompanion(VehiclesCompanion data) {
    return Vehicle(
      id: data.id.present ? data.id.value : this.id,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      nome: data.nome.present ? data.nome.value : this.nome,
      placa: data.placa.present ? data.placa.value : this.placa,
      fotoPath: data.fotoPath.present ? data.fotoPath.value : this.fotoPath,
      kmAtual: data.kmAtual.present ? data.kmAtual.value : this.kmAtual,
      kmAtualizadoEm: data.kmAtualizadoEm.present
          ? data.kmAtualizadoEm.value
          : this.kmAtualizadoEm,
      criadoEm: data.criadoEm.present ? data.criadoEm.value : this.criadoEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Vehicle(')
          ..write('id: $id, ')
          ..write('tipo: $tipo, ')
          ..write('nome: $nome, ')
          ..write('placa: $placa, ')
          ..write('fotoPath: $fotoPath, ')
          ..write('kmAtual: $kmAtual, ')
          ..write('kmAtualizadoEm: $kmAtualizadoEm, ')
          ..write('criadoEm: $criadoEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, tipo, nome, placa, fotoPath, kmAtual, kmAtualizadoEm, criadoEm);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Vehicle &&
          other.id == this.id &&
          other.tipo == this.tipo &&
          other.nome == this.nome &&
          other.placa == this.placa &&
          other.fotoPath == this.fotoPath &&
          other.kmAtual == this.kmAtual &&
          other.kmAtualizadoEm == this.kmAtualizadoEm &&
          other.criadoEm == this.criadoEm);
}

class VehiclesCompanion extends UpdateCompanion<Vehicle> {
  final Value<String> id;
  final Value<String> tipo;
  final Value<String> nome;
  final Value<String?> placa;
  final Value<String?> fotoPath;
  final Value<int> kmAtual;
  final Value<DateTime> kmAtualizadoEm;
  final Value<DateTime> criadoEm;
  final Value<int> rowid;
  const VehiclesCompanion({
    this.id = const Value.absent(),
    this.tipo = const Value.absent(),
    this.nome = const Value.absent(),
    this.placa = const Value.absent(),
    this.fotoPath = const Value.absent(),
    this.kmAtual = const Value.absent(),
    this.kmAtualizadoEm = const Value.absent(),
    this.criadoEm = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VehiclesCompanion.insert({
    required String id,
    required String tipo,
    required String nome,
    this.placa = const Value.absent(),
    this.fotoPath = const Value.absent(),
    this.kmAtual = const Value.absent(),
    this.kmAtualizadoEm = const Value.absent(),
    this.criadoEm = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        tipo = Value(tipo),
        nome = Value(nome);
  static Insertable<Vehicle> custom({
    Expression<String>? id,
    Expression<String>? tipo,
    Expression<String>? nome,
    Expression<String>? placa,
    Expression<String>? fotoPath,
    Expression<int>? kmAtual,
    Expression<DateTime>? kmAtualizadoEm,
    Expression<DateTime>? criadoEm,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tipo != null) 'tipo': tipo,
      if (nome != null) 'nome': nome,
      if (placa != null) 'placa': placa,
      if (fotoPath != null) 'foto_path': fotoPath,
      if (kmAtual != null) 'km_atual': kmAtual,
      if (kmAtualizadoEm != null) 'km_atualizado_em': kmAtualizadoEm,
      if (criadoEm != null) 'criado_em': criadoEm,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VehiclesCompanion copyWith(
      {Value<String>? id,
      Value<String>? tipo,
      Value<String>? nome,
      Value<String?>? placa,
      Value<String?>? fotoPath,
      Value<int>? kmAtual,
      Value<DateTime>? kmAtualizadoEm,
      Value<DateTime>? criadoEm,
      Value<int>? rowid}) {
    return VehiclesCompanion(
      id: id ?? this.id,
      tipo: tipo ?? this.tipo,
      nome: nome ?? this.nome,
      placa: placa ?? this.placa,
      fotoPath: fotoPath ?? this.fotoPath,
      kmAtual: kmAtual ?? this.kmAtual,
      kmAtualizadoEm: kmAtualizadoEm ?? this.kmAtualizadoEm,
      criadoEm: criadoEm ?? this.criadoEm,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (placa.present) {
      map['placa'] = Variable<String>(placa.value);
    }
    if (fotoPath.present) {
      map['foto_path'] = Variable<String>(fotoPath.value);
    }
    if (kmAtual.present) {
      map['km_atual'] = Variable<int>(kmAtual.value);
    }
    if (kmAtualizadoEm.present) {
      map['km_atualizado_em'] = Variable<DateTime>(kmAtualizadoEm.value);
    }
    if (criadoEm.present) {
      map['criado_em'] = Variable<DateTime>(criadoEm.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VehiclesCompanion(')
          ..write('id: $id, ')
          ..write('tipo: $tipo, ')
          ..write('nome: $nome, ')
          ..write('placa: $placa, ')
          ..write('fotoPath: $fotoPath, ')
          ..write('kmAtual: $kmAtual, ')
          ..write('kmAtualizadoEm: $kmAtualizadoEm, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MaintenanceCategoriesTable extends MaintenanceCategories
    with TableInfo<$MaintenanceCategoriesTable, MaintenanceCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MaintenanceCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
      'nome', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _veiculoTipoAplicavelMeta =
      const VerificationMeta('veiculoTipoAplicavel');
  @override
  late final GeneratedColumn<String> veiculoTipoAplicavel =
      GeneratedColumn<String>('veiculo_tipo_aplicavel', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _iconeMeta = const VerificationMeta('icone');
  @override
  late final GeneratedColumn<String> icone = GeneratedColumn<String>(
      'icone', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('build'));
  static const VerificationMeta _customizadaMeta =
      const VerificationMeta('customizada');
  @override
  late final GeneratedColumn<bool> customizada = GeneratedColumn<bool>(
      'customizada', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("customizada" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _tipoCalculoMeta =
      const VerificationMeta('tipoCalculo');
  @override
  late final GeneratedColumn<String> tipoCalculo = GeneratedColumn<String>(
      'tipo_calculo', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(CategoryCalculationType.uso));
  @override
  List<GeneratedColumn> get $columns =>
      [id, nome, veiculoTipoAplicavel, icone, customizada, tipoCalculo];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'maintenance_categories';
  @override
  VerificationContext validateIntegrity(
      Insertable<MaintenanceCategory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nome')) {
      context.handle(
          _nomeMeta, nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta));
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('veiculo_tipo_aplicavel')) {
      context.handle(
          _veiculoTipoAplicavelMeta,
          veiculoTipoAplicavel.isAcceptableOrUnknown(
              data['veiculo_tipo_aplicavel']!, _veiculoTipoAplicavelMeta));
    } else if (isInserting) {
      context.missing(_veiculoTipoAplicavelMeta);
    }
    if (data.containsKey('icone')) {
      context.handle(
          _iconeMeta, icone.isAcceptableOrUnknown(data['icone']!, _iconeMeta));
    }
    if (data.containsKey('customizada')) {
      context.handle(
          _customizadaMeta,
          customizada.isAcceptableOrUnknown(
              data['customizada']!, _customizadaMeta));
    }
    if (data.containsKey('tipo_calculo')) {
      context.handle(
          _tipoCalculoMeta,
          tipoCalculo.isAcceptableOrUnknown(
              data['tipo_calculo']!, _tipoCalculoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MaintenanceCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MaintenanceCategory(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      nome: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nome'])!,
      veiculoTipoAplicavel: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}veiculo_tipo_aplicavel'])!,
      icone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icone'])!,
      customizada: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}customizada'])!,
      tipoCalculo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tipo_calculo'])!,
    );
  }

  @override
  $MaintenanceCategoriesTable createAlias(String alias) {
    return $MaintenanceCategoriesTable(attachedDatabase, alias);
  }
}

class MaintenanceCategory extends DataClass
    implements Insertable<MaintenanceCategory> {
  final String id;
  final String nome;
  final String veiculoTipoAplicavel;
  final String icone;
  final bool customizada;
  final String tipoCalculo;
  const MaintenanceCategory(
      {required this.id,
      required this.nome,
      required this.veiculoTipoAplicavel,
      required this.icone,
      required this.customizada,
      required this.tipoCalculo});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nome'] = Variable<String>(nome);
    map['veiculo_tipo_aplicavel'] = Variable<String>(veiculoTipoAplicavel);
    map['icone'] = Variable<String>(icone);
    map['customizada'] = Variable<bool>(customizada);
    map['tipo_calculo'] = Variable<String>(tipoCalculo);
    return map;
  }

  MaintenanceCategoriesCompanion toCompanion(bool nullToAbsent) {
    return MaintenanceCategoriesCompanion(
      id: Value(id),
      nome: Value(nome),
      veiculoTipoAplicavel: Value(veiculoTipoAplicavel),
      icone: Value(icone),
      customizada: Value(customizada),
      tipoCalculo: Value(tipoCalculo),
    );
  }

  factory MaintenanceCategory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MaintenanceCategory(
      id: serializer.fromJson<String>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      veiculoTipoAplicavel:
          serializer.fromJson<String>(json['veiculoTipoAplicavel']),
      icone: serializer.fromJson<String>(json['icone']),
      customizada: serializer.fromJson<bool>(json['customizada']),
      tipoCalculo: serializer.fromJson<String>(json['tipoCalculo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nome': serializer.toJson<String>(nome),
      'veiculoTipoAplicavel': serializer.toJson<String>(veiculoTipoAplicavel),
      'icone': serializer.toJson<String>(icone),
      'customizada': serializer.toJson<bool>(customizada),
      'tipoCalculo': serializer.toJson<String>(tipoCalculo),
    };
  }

  MaintenanceCategory copyWith(
          {String? id,
          String? nome,
          String? veiculoTipoAplicavel,
          String? icone,
          bool? customizada,
          String? tipoCalculo}) =>
      MaintenanceCategory(
        id: id ?? this.id,
        nome: nome ?? this.nome,
        veiculoTipoAplicavel: veiculoTipoAplicavel ?? this.veiculoTipoAplicavel,
        icone: icone ?? this.icone,
        customizada: customizada ?? this.customizada,
        tipoCalculo: tipoCalculo ?? this.tipoCalculo,
      );
  MaintenanceCategory copyWithCompanion(MaintenanceCategoriesCompanion data) {
    return MaintenanceCategory(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      veiculoTipoAplicavel: data.veiculoTipoAplicavel.present
          ? data.veiculoTipoAplicavel.value
          : this.veiculoTipoAplicavel,
      icone: data.icone.present ? data.icone.value : this.icone,
      customizada:
          data.customizada.present ? data.customizada.value : this.customizada,
      tipoCalculo:
          data.tipoCalculo.present ? data.tipoCalculo.value : this.tipoCalculo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceCategory(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('veiculoTipoAplicavel: $veiculoTipoAplicavel, ')
          ..write('icone: $icone, ')
          ..write('customizada: $customizada, ')
          ..write('tipoCalculo: $tipoCalculo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, nome, veiculoTipoAplicavel, icone, customizada, tipoCalculo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MaintenanceCategory &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.veiculoTipoAplicavel == this.veiculoTipoAplicavel &&
          other.icone == this.icone &&
          other.customizada == this.customizada &&
          other.tipoCalculo == this.tipoCalculo);
}

class MaintenanceCategoriesCompanion
    extends UpdateCompanion<MaintenanceCategory> {
  final Value<String> id;
  final Value<String> nome;
  final Value<String> veiculoTipoAplicavel;
  final Value<String> icone;
  final Value<bool> customizada;
  final Value<String> tipoCalculo;
  final Value<int> rowid;
  const MaintenanceCategoriesCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.veiculoTipoAplicavel = const Value.absent(),
    this.icone = const Value.absent(),
    this.customizada = const Value.absent(),
    this.tipoCalculo = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MaintenanceCategoriesCompanion.insert({
    required String id,
    required String nome,
    required String veiculoTipoAplicavel,
    this.icone = const Value.absent(),
    this.customizada = const Value.absent(),
    this.tipoCalculo = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        nome = Value(nome),
        veiculoTipoAplicavel = Value(veiculoTipoAplicavel);
  static Insertable<MaintenanceCategory> custom({
    Expression<String>? id,
    Expression<String>? nome,
    Expression<String>? veiculoTipoAplicavel,
    Expression<String>? icone,
    Expression<bool>? customizada,
    Expression<String>? tipoCalculo,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (veiculoTipoAplicavel != null)
        'veiculo_tipo_aplicavel': veiculoTipoAplicavel,
      if (icone != null) 'icone': icone,
      if (customizada != null) 'customizada': customizada,
      if (tipoCalculo != null) 'tipo_calculo': tipoCalculo,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MaintenanceCategoriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? nome,
      Value<String>? veiculoTipoAplicavel,
      Value<String>? icone,
      Value<bool>? customizada,
      Value<String>? tipoCalculo,
      Value<int>? rowid}) {
    return MaintenanceCategoriesCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      veiculoTipoAplicavel: veiculoTipoAplicavel ?? this.veiculoTipoAplicavel,
      icone: icone ?? this.icone,
      customizada: customizada ?? this.customizada,
      tipoCalculo: tipoCalculo ?? this.tipoCalculo,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (veiculoTipoAplicavel.present) {
      map['veiculo_tipo_aplicavel'] =
          Variable<String>(veiculoTipoAplicavel.value);
    }
    if (icone.present) {
      map['icone'] = Variable<String>(icone.value);
    }
    if (customizada.present) {
      map['customizada'] = Variable<bool>(customizada.value);
    }
    if (tipoCalculo.present) {
      map['tipo_calculo'] = Variable<String>(tipoCalculo.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('veiculoTipoAplicavel: $veiculoTipoAplicavel, ')
          ..write('icone: $icone, ')
          ..write('customizada: $customizada, ')
          ..write('tipoCalculo: $tipoCalculo, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MaintenanceEventsTable extends MaintenanceEvents
    with TableInfo<$MaintenanceEventsTable, MaintenanceEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MaintenanceEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _veiculoIdMeta =
      const VerificationMeta('veiculoId');
  @override
  late final GeneratedColumn<String> veiculoId = GeneratedColumn<String>(
      'veiculo_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES vehicles (id)'));
  static const VerificationMeta _categoriaIdMeta =
      const VerificationMeta('categoriaId');
  @override
  late final GeneratedColumn<String> categoriaId = GeneratedColumn<String>(
      'categoria_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES maintenance_categories (id)'));
  static const VerificationMeta _dataRealizadaMeta =
      const VerificationMeta('dataRealizada');
  @override
  late final GeneratedColumn<DateTime> dataRealizada =
      GeneratedColumn<DateTime>('data_realizada', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _kmRealizadoMeta =
      const VerificationMeta('kmRealizado');
  @override
  late final GeneratedColumn<int> kmRealizado = GeneratedColumn<int>(
      'km_realizado', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _valorGastoMeta =
      const VerificationMeta('valorGasto');
  @override
  late final GeneratedColumn<double> valorGasto = GeneratedColumn<double>(
      'valor_gasto', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _oficinaMeta =
      const VerificationMeta('oficina');
  @override
  late final GeneratedColumn<String> oficina = GeneratedColumn<String>(
      'oficina', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _observacaoMeta =
      const VerificationMeta('observacao');
  @override
  late final GeneratedColumn<String> observacao = GeneratedColumn<String>(
      'observacao', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _anexoPathMeta =
      const VerificationMeta('anexoPath');
  @override
  late final GeneratedColumn<String> anexoPath = GeneratedColumn<String>(
      'anexo_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _criadoEmMeta =
      const VerificationMeta('criadoEm');
  @override
  late final GeneratedColumn<DateTime> criadoEm = GeneratedColumn<DateTime>(
      'criado_em', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        veiculoId,
        categoriaId,
        dataRealizada,
        kmRealizado,
        valorGasto,
        oficina,
        observacao,
        anexoPath,
        criadoEm
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'maintenance_events';
  @override
  VerificationContext validateIntegrity(Insertable<MaintenanceEvent> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('veiculo_id')) {
      context.handle(_veiculoIdMeta,
          veiculoId.isAcceptableOrUnknown(data['veiculo_id']!, _veiculoIdMeta));
    } else if (isInserting) {
      context.missing(_veiculoIdMeta);
    }
    if (data.containsKey('categoria_id')) {
      context.handle(
          _categoriaIdMeta,
          categoriaId.isAcceptableOrUnknown(
              data['categoria_id']!, _categoriaIdMeta));
    } else if (isInserting) {
      context.missing(_categoriaIdMeta);
    }
    if (data.containsKey('data_realizada')) {
      context.handle(
          _dataRealizadaMeta,
          dataRealizada.isAcceptableOrUnknown(
              data['data_realizada']!, _dataRealizadaMeta));
    } else if (isInserting) {
      context.missing(_dataRealizadaMeta);
    }
    if (data.containsKey('km_realizado')) {
      context.handle(
          _kmRealizadoMeta,
          kmRealizado.isAcceptableOrUnknown(
              data['km_realizado']!, _kmRealizadoMeta));
    }
    if (data.containsKey('valor_gasto')) {
      context.handle(
          _valorGastoMeta,
          valorGasto.isAcceptableOrUnknown(
              data['valor_gasto']!, _valorGastoMeta));
    }
    if (data.containsKey('oficina')) {
      context.handle(_oficinaMeta,
          oficina.isAcceptableOrUnknown(data['oficina']!, _oficinaMeta));
    }
    if (data.containsKey('observacao')) {
      context.handle(
          _observacaoMeta,
          observacao.isAcceptableOrUnknown(
              data['observacao']!, _observacaoMeta));
    }
    if (data.containsKey('anexo_path')) {
      context.handle(_anexoPathMeta,
          anexoPath.isAcceptableOrUnknown(data['anexo_path']!, _anexoPathMeta));
    }
    if (data.containsKey('criado_em')) {
      context.handle(_criadoEmMeta,
          criadoEm.isAcceptableOrUnknown(data['criado_em']!, _criadoEmMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MaintenanceEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MaintenanceEvent(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      veiculoId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}veiculo_id'])!,
      categoriaId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}categoria_id'])!,
      dataRealizada: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}data_realizada'])!,
      kmRealizado: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}km_realizado']),
      valorGasto: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}valor_gasto']),
      oficina: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}oficina']),
      observacao: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}observacao']),
      anexoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}anexo_path']),
      criadoEm: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}criado_em'])!,
    );
  }

  @override
  $MaintenanceEventsTable createAlias(String alias) {
    return $MaintenanceEventsTable(attachedDatabase, alias);
  }
}

class MaintenanceEvent extends DataClass
    implements Insertable<MaintenanceEvent> {
  final String id;
  final String veiculoId;
  final String categoriaId;
  final DateTime dataRealizada;
  final int? kmRealizado;
  final double? valorGasto;
  final String? oficina;
  final String? observacao;
  final String? anexoPath;
  final DateTime criadoEm;
  const MaintenanceEvent(
      {required this.id,
      required this.veiculoId,
      required this.categoriaId,
      required this.dataRealizada,
      this.kmRealizado,
      this.valorGasto,
      this.oficina,
      this.observacao,
      this.anexoPath,
      required this.criadoEm});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['veiculo_id'] = Variable<String>(veiculoId);
    map['categoria_id'] = Variable<String>(categoriaId);
    map['data_realizada'] = Variable<DateTime>(dataRealizada);
    if (!nullToAbsent || kmRealizado != null) {
      map['km_realizado'] = Variable<int>(kmRealizado);
    }
    if (!nullToAbsent || valorGasto != null) {
      map['valor_gasto'] = Variable<double>(valorGasto);
    }
    if (!nullToAbsent || oficina != null) {
      map['oficina'] = Variable<String>(oficina);
    }
    if (!nullToAbsent || observacao != null) {
      map['observacao'] = Variable<String>(observacao);
    }
    if (!nullToAbsent || anexoPath != null) {
      map['anexo_path'] = Variable<String>(anexoPath);
    }
    map['criado_em'] = Variable<DateTime>(criadoEm);
    return map;
  }

  MaintenanceEventsCompanion toCompanion(bool nullToAbsent) {
    return MaintenanceEventsCompanion(
      id: Value(id),
      veiculoId: Value(veiculoId),
      categoriaId: Value(categoriaId),
      dataRealizada: Value(dataRealizada),
      kmRealizado: kmRealizado == null && nullToAbsent
          ? const Value.absent()
          : Value(kmRealizado),
      valorGasto: valorGasto == null && nullToAbsent
          ? const Value.absent()
          : Value(valorGasto),
      oficina: oficina == null && nullToAbsent
          ? const Value.absent()
          : Value(oficina),
      observacao: observacao == null && nullToAbsent
          ? const Value.absent()
          : Value(observacao),
      anexoPath: anexoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(anexoPath),
      criadoEm: Value(criadoEm),
    );
  }

  factory MaintenanceEvent.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MaintenanceEvent(
      id: serializer.fromJson<String>(json['id']),
      veiculoId: serializer.fromJson<String>(json['veiculoId']),
      categoriaId: serializer.fromJson<String>(json['categoriaId']),
      dataRealizada: serializer.fromJson<DateTime>(json['dataRealizada']),
      kmRealizado: serializer.fromJson<int?>(json['kmRealizado']),
      valorGasto: serializer.fromJson<double?>(json['valorGasto']),
      oficina: serializer.fromJson<String?>(json['oficina']),
      observacao: serializer.fromJson<String?>(json['observacao']),
      anexoPath: serializer.fromJson<String?>(json['anexoPath']),
      criadoEm: serializer.fromJson<DateTime>(json['criadoEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'veiculoId': serializer.toJson<String>(veiculoId),
      'categoriaId': serializer.toJson<String>(categoriaId),
      'dataRealizada': serializer.toJson<DateTime>(dataRealizada),
      'kmRealizado': serializer.toJson<int?>(kmRealizado),
      'valorGasto': serializer.toJson<double?>(valorGasto),
      'oficina': serializer.toJson<String?>(oficina),
      'observacao': serializer.toJson<String?>(observacao),
      'anexoPath': serializer.toJson<String?>(anexoPath),
      'criadoEm': serializer.toJson<DateTime>(criadoEm),
    };
  }

  MaintenanceEvent copyWith(
          {String? id,
          String? veiculoId,
          String? categoriaId,
          DateTime? dataRealizada,
          Value<int?> kmRealizado = const Value.absent(),
          Value<double?> valorGasto = const Value.absent(),
          Value<String?> oficina = const Value.absent(),
          Value<String?> observacao = const Value.absent(),
          Value<String?> anexoPath = const Value.absent(),
          DateTime? criadoEm}) =>
      MaintenanceEvent(
        id: id ?? this.id,
        veiculoId: veiculoId ?? this.veiculoId,
        categoriaId: categoriaId ?? this.categoriaId,
        dataRealizada: dataRealizada ?? this.dataRealizada,
        kmRealizado: kmRealizado.present ? kmRealizado.value : this.kmRealizado,
        valorGasto: valorGasto.present ? valorGasto.value : this.valorGasto,
        oficina: oficina.present ? oficina.value : this.oficina,
        observacao: observacao.present ? observacao.value : this.observacao,
        anexoPath: anexoPath.present ? anexoPath.value : this.anexoPath,
        criadoEm: criadoEm ?? this.criadoEm,
      );
  MaintenanceEvent copyWithCompanion(MaintenanceEventsCompanion data) {
    return MaintenanceEvent(
      id: data.id.present ? data.id.value : this.id,
      veiculoId: data.veiculoId.present ? data.veiculoId.value : this.veiculoId,
      categoriaId:
          data.categoriaId.present ? data.categoriaId.value : this.categoriaId,
      dataRealizada: data.dataRealizada.present
          ? data.dataRealizada.value
          : this.dataRealizada,
      kmRealizado:
          data.kmRealizado.present ? data.kmRealizado.value : this.kmRealizado,
      valorGasto:
          data.valorGasto.present ? data.valorGasto.value : this.valorGasto,
      oficina: data.oficina.present ? data.oficina.value : this.oficina,
      observacao:
          data.observacao.present ? data.observacao.value : this.observacao,
      anexoPath: data.anexoPath.present ? data.anexoPath.value : this.anexoPath,
      criadoEm: data.criadoEm.present ? data.criadoEm.value : this.criadoEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceEvent(')
          ..write('id: $id, ')
          ..write('veiculoId: $veiculoId, ')
          ..write('categoriaId: $categoriaId, ')
          ..write('dataRealizada: $dataRealizada, ')
          ..write('kmRealizado: $kmRealizado, ')
          ..write('valorGasto: $valorGasto, ')
          ..write('oficina: $oficina, ')
          ..write('observacao: $observacao, ')
          ..write('anexoPath: $anexoPath, ')
          ..write('criadoEm: $criadoEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, veiculoId, categoriaId, dataRealizada,
      kmRealizado, valorGasto, oficina, observacao, anexoPath, criadoEm);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MaintenanceEvent &&
          other.id == this.id &&
          other.veiculoId == this.veiculoId &&
          other.categoriaId == this.categoriaId &&
          other.dataRealizada == this.dataRealizada &&
          other.kmRealizado == this.kmRealizado &&
          other.valorGasto == this.valorGasto &&
          other.oficina == this.oficina &&
          other.observacao == this.observacao &&
          other.anexoPath == this.anexoPath &&
          other.criadoEm == this.criadoEm);
}

class MaintenanceEventsCompanion extends UpdateCompanion<MaintenanceEvent> {
  final Value<String> id;
  final Value<String> veiculoId;
  final Value<String> categoriaId;
  final Value<DateTime> dataRealizada;
  final Value<int?> kmRealizado;
  final Value<double?> valorGasto;
  final Value<String?> oficina;
  final Value<String?> observacao;
  final Value<String?> anexoPath;
  final Value<DateTime> criadoEm;
  final Value<int> rowid;
  const MaintenanceEventsCompanion({
    this.id = const Value.absent(),
    this.veiculoId = const Value.absent(),
    this.categoriaId = const Value.absent(),
    this.dataRealizada = const Value.absent(),
    this.kmRealizado = const Value.absent(),
    this.valorGasto = const Value.absent(),
    this.oficina = const Value.absent(),
    this.observacao = const Value.absent(),
    this.anexoPath = const Value.absent(),
    this.criadoEm = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MaintenanceEventsCompanion.insert({
    required String id,
    required String veiculoId,
    required String categoriaId,
    required DateTime dataRealizada,
    this.kmRealizado = const Value.absent(),
    this.valorGasto = const Value.absent(),
    this.oficina = const Value.absent(),
    this.observacao = const Value.absent(),
    this.anexoPath = const Value.absent(),
    this.criadoEm = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        veiculoId = Value(veiculoId),
        categoriaId = Value(categoriaId),
        dataRealizada = Value(dataRealizada);
  static Insertable<MaintenanceEvent> custom({
    Expression<String>? id,
    Expression<String>? veiculoId,
    Expression<String>? categoriaId,
    Expression<DateTime>? dataRealizada,
    Expression<int>? kmRealizado,
    Expression<double>? valorGasto,
    Expression<String>? oficina,
    Expression<String>? observacao,
    Expression<String>? anexoPath,
    Expression<DateTime>? criadoEm,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (veiculoId != null) 'veiculo_id': veiculoId,
      if (categoriaId != null) 'categoria_id': categoriaId,
      if (dataRealizada != null) 'data_realizada': dataRealizada,
      if (kmRealizado != null) 'km_realizado': kmRealizado,
      if (valorGasto != null) 'valor_gasto': valorGasto,
      if (oficina != null) 'oficina': oficina,
      if (observacao != null) 'observacao': observacao,
      if (anexoPath != null) 'anexo_path': anexoPath,
      if (criadoEm != null) 'criado_em': criadoEm,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MaintenanceEventsCompanion copyWith(
      {Value<String>? id,
      Value<String>? veiculoId,
      Value<String>? categoriaId,
      Value<DateTime>? dataRealizada,
      Value<int?>? kmRealizado,
      Value<double?>? valorGasto,
      Value<String?>? oficina,
      Value<String?>? observacao,
      Value<String?>? anexoPath,
      Value<DateTime>? criadoEm,
      Value<int>? rowid}) {
    return MaintenanceEventsCompanion(
      id: id ?? this.id,
      veiculoId: veiculoId ?? this.veiculoId,
      categoriaId: categoriaId ?? this.categoriaId,
      dataRealizada: dataRealizada ?? this.dataRealizada,
      kmRealizado: kmRealizado ?? this.kmRealizado,
      valorGasto: valorGasto ?? this.valorGasto,
      oficina: oficina ?? this.oficina,
      observacao: observacao ?? this.observacao,
      anexoPath: anexoPath ?? this.anexoPath,
      criadoEm: criadoEm ?? this.criadoEm,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (veiculoId.present) {
      map['veiculo_id'] = Variable<String>(veiculoId.value);
    }
    if (categoriaId.present) {
      map['categoria_id'] = Variable<String>(categoriaId.value);
    }
    if (dataRealizada.present) {
      map['data_realizada'] = Variable<DateTime>(dataRealizada.value);
    }
    if (kmRealizado.present) {
      map['km_realizado'] = Variable<int>(kmRealizado.value);
    }
    if (valorGasto.present) {
      map['valor_gasto'] = Variable<double>(valorGasto.value);
    }
    if (oficina.present) {
      map['oficina'] = Variable<String>(oficina.value);
    }
    if (observacao.present) {
      map['observacao'] = Variable<String>(observacao.value);
    }
    if (anexoPath.present) {
      map['anexo_path'] = Variable<String>(anexoPath.value);
    }
    if (criadoEm.present) {
      map['criado_em'] = Variable<DateTime>(criadoEm.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceEventsCompanion(')
          ..write('id: $id, ')
          ..write('veiculoId: $veiculoId, ')
          ..write('categoriaId: $categoriaId, ')
          ..write('dataRealizada: $dataRealizada, ')
          ..write('kmRealizado: $kmRealizado, ')
          ..write('valorGasto: $valorGasto, ')
          ..write('oficina: $oficina, ')
          ..write('observacao: $observacao, ')
          ..write('anexoPath: $anexoPath, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RemindersTable extends Reminders
    with TableInfo<$RemindersTable, Reminder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _veiculoIdMeta =
      const VerificationMeta('veiculoId');
  @override
  late final GeneratedColumn<String> veiculoId = GeneratedColumn<String>(
      'veiculo_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES vehicles (id)'));
  static const VerificationMeta _categoriaIdMeta =
      const VerificationMeta('categoriaId');
  @override
  late final GeneratedColumn<String> categoriaId = GeneratedColumn<String>(
      'categoria_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES maintenance_categories (id)'));
  static const VerificationMeta _ultimaDataFeitaMeta =
      const VerificationMeta('ultimaDataFeita');
  @override
  late final GeneratedColumn<DateTime> ultimaDataFeita =
      GeneratedColumn<DateTime>('ultima_data_feita', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _ultimoKmFeitoMeta =
      const VerificationMeta('ultimoKmFeito');
  @override
  late final GeneratedColumn<int> ultimoKmFeito = GeneratedColumn<int>(
      'ultimo_km_feito', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _intervaloMesesMeta =
      const VerificationMeta('intervaloMeses');
  @override
  late final GeneratedColumn<int> intervaloMeses = GeneratedColumn<int>(
      'intervalo_meses', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _intervaloKmMeta =
      const VerificationMeta('intervaloKm');
  @override
  late final GeneratedColumn<int> intervaloKm = GeneratedColumn<int>(
      'intervalo_km', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _dataVencimentoManualMeta =
      const VerificationMeta('dataVencimentoManual');
  @override
  late final GeneratedColumn<DateTime> dataVencimentoManual =
      GeneratedColumn<DateTime>('data_vencimento_manual', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _valorPagoMeta =
      const VerificationMeta('valorPago');
  @override
  late final GeneratedColumn<double> valorPago = GeneratedColumn<double>(
      'valor_pago', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('em_dia'));
  static const VerificationMeta _ativoMeta = const VerificationMeta('ativo');
  @override
  late final GeneratedColumn<bool> ativo = GeneratedColumn<bool>(
      'ativo', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("ativo" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _criadoEmMeta =
      const VerificationMeta('criadoEm');
  @override
  late final GeneratedColumn<DateTime> criadoEm = GeneratedColumn<DateTime>(
      'criado_em', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        veiculoId,
        categoriaId,
        ultimaDataFeita,
        ultimoKmFeito,
        intervaloMeses,
        intervaloKm,
        dataVencimentoManual,
        valorPago,
        status,
        ativo,
        criadoEm
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(Insertable<Reminder> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('veiculo_id')) {
      context.handle(_veiculoIdMeta,
          veiculoId.isAcceptableOrUnknown(data['veiculo_id']!, _veiculoIdMeta));
    } else if (isInserting) {
      context.missing(_veiculoIdMeta);
    }
    if (data.containsKey('categoria_id')) {
      context.handle(
          _categoriaIdMeta,
          categoriaId.isAcceptableOrUnknown(
              data['categoria_id']!, _categoriaIdMeta));
    } else if (isInserting) {
      context.missing(_categoriaIdMeta);
    }
    if (data.containsKey('ultima_data_feita')) {
      context.handle(
          _ultimaDataFeitaMeta,
          ultimaDataFeita.isAcceptableOrUnknown(
              data['ultima_data_feita']!, _ultimaDataFeitaMeta));
    } else if (isInserting) {
      context.missing(_ultimaDataFeitaMeta);
    }
    if (data.containsKey('ultimo_km_feito')) {
      context.handle(
          _ultimoKmFeitoMeta,
          ultimoKmFeito.isAcceptableOrUnknown(
              data['ultimo_km_feito']!, _ultimoKmFeitoMeta));
    }
    if (data.containsKey('intervalo_meses')) {
      context.handle(
          _intervaloMesesMeta,
          intervaloMeses.isAcceptableOrUnknown(
              data['intervalo_meses']!, _intervaloMesesMeta));
    }
    if (data.containsKey('intervalo_km')) {
      context.handle(
          _intervaloKmMeta,
          intervaloKm.isAcceptableOrUnknown(
              data['intervalo_km']!, _intervaloKmMeta));
    }
    if (data.containsKey('data_vencimento_manual')) {
      context.handle(
          _dataVencimentoManualMeta,
          dataVencimentoManual.isAcceptableOrUnknown(
              data['data_vencimento_manual']!, _dataVencimentoManualMeta));
    }
    if (data.containsKey('valor_pago')) {
      context.handle(_valorPagoMeta,
          valorPago.isAcceptableOrUnknown(data['valor_pago']!, _valorPagoMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('ativo')) {
      context.handle(
          _ativoMeta, ativo.isAcceptableOrUnknown(data['ativo']!, _ativoMeta));
    }
    if (data.containsKey('criado_em')) {
      context.handle(_criadoEmMeta,
          criadoEm.isAcceptableOrUnknown(data['criado_em']!, _criadoEmMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reminder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reminder(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      veiculoId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}veiculo_id'])!,
      categoriaId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}categoria_id'])!,
      ultimaDataFeita: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}ultima_data_feita'])!,
      ultimoKmFeito: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ultimo_km_feito']),
      intervaloMeses: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}intervalo_meses']),
      intervaloKm: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}intervalo_km']),
      dataVencimentoManual: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}data_vencimento_manual']),
      valorPago: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}valor_pago']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      ativo: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}ativo'])!,
      criadoEm: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}criado_em'])!,
    );
  }

  @override
  $RemindersTable createAlias(String alias) {
    return $RemindersTable(attachedDatabase, alias);
  }
}

class Reminder extends DataClass implements Insertable<Reminder> {
  final String id;
  final String veiculoId;
  final String categoriaId;
  final DateTime ultimaDataFeita;
  final int? ultimoKmFeito;
  final int? intervaloMeses;
  final int? intervaloKm;

  /// Só usado por categorias `calendario` — data de vencimento informada
  /// diretamente pelo usuário (ex: vencimento do IPVA), sem cálculo.
  final DateTime? dataVencimentoManual;

  /// Valor pago (opcional), útil pra IPVA/seguro/licenciamento.
  final double? valorPago;
  final String status;
  final bool ativo;
  final DateTime criadoEm;
  const Reminder(
      {required this.id,
      required this.veiculoId,
      required this.categoriaId,
      required this.ultimaDataFeita,
      this.ultimoKmFeito,
      this.intervaloMeses,
      this.intervaloKm,
      this.dataVencimentoManual,
      this.valorPago,
      required this.status,
      required this.ativo,
      required this.criadoEm});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['veiculo_id'] = Variable<String>(veiculoId);
    map['categoria_id'] = Variable<String>(categoriaId);
    map['ultima_data_feita'] = Variable<DateTime>(ultimaDataFeita);
    if (!nullToAbsent || ultimoKmFeito != null) {
      map['ultimo_km_feito'] = Variable<int>(ultimoKmFeito);
    }
    if (!nullToAbsent || intervaloMeses != null) {
      map['intervalo_meses'] = Variable<int>(intervaloMeses);
    }
    if (!nullToAbsent || intervaloKm != null) {
      map['intervalo_km'] = Variable<int>(intervaloKm);
    }
    if (!nullToAbsent || dataVencimentoManual != null) {
      map['data_vencimento_manual'] = Variable<DateTime>(dataVencimentoManual);
    }
    if (!nullToAbsent || valorPago != null) {
      map['valor_pago'] = Variable<double>(valorPago);
    }
    map['status'] = Variable<String>(status);
    map['ativo'] = Variable<bool>(ativo);
    map['criado_em'] = Variable<DateTime>(criadoEm);
    return map;
  }

  RemindersCompanion toCompanion(bool nullToAbsent) {
    return RemindersCompanion(
      id: Value(id),
      veiculoId: Value(veiculoId),
      categoriaId: Value(categoriaId),
      ultimaDataFeita: Value(ultimaDataFeita),
      ultimoKmFeito: ultimoKmFeito == null && nullToAbsent
          ? const Value.absent()
          : Value(ultimoKmFeito),
      intervaloMeses: intervaloMeses == null && nullToAbsent
          ? const Value.absent()
          : Value(intervaloMeses),
      intervaloKm: intervaloKm == null && nullToAbsent
          ? const Value.absent()
          : Value(intervaloKm),
      dataVencimentoManual: dataVencimentoManual == null && nullToAbsent
          ? const Value.absent()
          : Value(dataVencimentoManual),
      valorPago: valorPago == null && nullToAbsent
          ? const Value.absent()
          : Value(valorPago),
      status: Value(status),
      ativo: Value(ativo),
      criadoEm: Value(criadoEm),
    );
  }

  factory Reminder.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reminder(
      id: serializer.fromJson<String>(json['id']),
      veiculoId: serializer.fromJson<String>(json['veiculoId']),
      categoriaId: serializer.fromJson<String>(json['categoriaId']),
      ultimaDataFeita: serializer.fromJson<DateTime>(json['ultimaDataFeita']),
      ultimoKmFeito: serializer.fromJson<int?>(json['ultimoKmFeito']),
      intervaloMeses: serializer.fromJson<int?>(json['intervaloMeses']),
      intervaloKm: serializer.fromJson<int?>(json['intervaloKm']),
      dataVencimentoManual:
          serializer.fromJson<DateTime?>(json['dataVencimentoManual']),
      valorPago: serializer.fromJson<double?>(json['valorPago']),
      status: serializer.fromJson<String>(json['status']),
      ativo: serializer.fromJson<bool>(json['ativo']),
      criadoEm: serializer.fromJson<DateTime>(json['criadoEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'veiculoId': serializer.toJson<String>(veiculoId),
      'categoriaId': serializer.toJson<String>(categoriaId),
      'ultimaDataFeita': serializer.toJson<DateTime>(ultimaDataFeita),
      'ultimoKmFeito': serializer.toJson<int?>(ultimoKmFeito),
      'intervaloMeses': serializer.toJson<int?>(intervaloMeses),
      'intervaloKm': serializer.toJson<int?>(intervaloKm),
      'dataVencimentoManual':
          serializer.toJson<DateTime?>(dataVencimentoManual),
      'valorPago': serializer.toJson<double?>(valorPago),
      'status': serializer.toJson<String>(status),
      'ativo': serializer.toJson<bool>(ativo),
      'criadoEm': serializer.toJson<DateTime>(criadoEm),
    };
  }

  Reminder copyWith(
          {String? id,
          String? veiculoId,
          String? categoriaId,
          DateTime? ultimaDataFeita,
          Value<int?> ultimoKmFeito = const Value.absent(),
          Value<int?> intervaloMeses = const Value.absent(),
          Value<int?> intervaloKm = const Value.absent(),
          Value<DateTime?> dataVencimentoManual = const Value.absent(),
          Value<double?> valorPago = const Value.absent(),
          String? status,
          bool? ativo,
          DateTime? criadoEm}) =>
      Reminder(
        id: id ?? this.id,
        veiculoId: veiculoId ?? this.veiculoId,
        categoriaId: categoriaId ?? this.categoriaId,
        ultimaDataFeita: ultimaDataFeita ?? this.ultimaDataFeita,
        ultimoKmFeito:
            ultimoKmFeito.present ? ultimoKmFeito.value : this.ultimoKmFeito,
        intervaloMeses:
            intervaloMeses.present ? intervaloMeses.value : this.intervaloMeses,
        intervaloKm: intervaloKm.present ? intervaloKm.value : this.intervaloKm,
        dataVencimentoManual: dataVencimentoManual.present
            ? dataVencimentoManual.value
            : this.dataVencimentoManual,
        valorPago: valorPago.present ? valorPago.value : this.valorPago,
        status: status ?? this.status,
        ativo: ativo ?? this.ativo,
        criadoEm: criadoEm ?? this.criadoEm,
      );
  Reminder copyWithCompanion(RemindersCompanion data) {
    return Reminder(
      id: data.id.present ? data.id.value : this.id,
      veiculoId: data.veiculoId.present ? data.veiculoId.value : this.veiculoId,
      categoriaId:
          data.categoriaId.present ? data.categoriaId.value : this.categoriaId,
      ultimaDataFeita: data.ultimaDataFeita.present
          ? data.ultimaDataFeita.value
          : this.ultimaDataFeita,
      ultimoKmFeito: data.ultimoKmFeito.present
          ? data.ultimoKmFeito.value
          : this.ultimoKmFeito,
      intervaloMeses: data.intervaloMeses.present
          ? data.intervaloMeses.value
          : this.intervaloMeses,
      intervaloKm:
          data.intervaloKm.present ? data.intervaloKm.value : this.intervaloKm,
      dataVencimentoManual: data.dataVencimentoManual.present
          ? data.dataVencimentoManual.value
          : this.dataVencimentoManual,
      valorPago: data.valorPago.present ? data.valorPago.value : this.valorPago,
      status: data.status.present ? data.status.value : this.status,
      ativo: data.ativo.present ? data.ativo.value : this.ativo,
      criadoEm: data.criadoEm.present ? data.criadoEm.value : this.criadoEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reminder(')
          ..write('id: $id, ')
          ..write('veiculoId: $veiculoId, ')
          ..write('categoriaId: $categoriaId, ')
          ..write('ultimaDataFeita: $ultimaDataFeita, ')
          ..write('ultimoKmFeito: $ultimoKmFeito, ')
          ..write('intervaloMeses: $intervaloMeses, ')
          ..write('intervaloKm: $intervaloKm, ')
          ..write('dataVencimentoManual: $dataVencimentoManual, ')
          ..write('valorPago: $valorPago, ')
          ..write('status: $status, ')
          ..write('ativo: $ativo, ')
          ..write('criadoEm: $criadoEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      veiculoId,
      categoriaId,
      ultimaDataFeita,
      ultimoKmFeito,
      intervaloMeses,
      intervaloKm,
      dataVencimentoManual,
      valorPago,
      status,
      ativo,
      criadoEm);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reminder &&
          other.id == this.id &&
          other.veiculoId == this.veiculoId &&
          other.categoriaId == this.categoriaId &&
          other.ultimaDataFeita == this.ultimaDataFeita &&
          other.ultimoKmFeito == this.ultimoKmFeito &&
          other.intervaloMeses == this.intervaloMeses &&
          other.intervaloKm == this.intervaloKm &&
          other.dataVencimentoManual == this.dataVencimentoManual &&
          other.valorPago == this.valorPago &&
          other.status == this.status &&
          other.ativo == this.ativo &&
          other.criadoEm == this.criadoEm);
}

class RemindersCompanion extends UpdateCompanion<Reminder> {
  final Value<String> id;
  final Value<String> veiculoId;
  final Value<String> categoriaId;
  final Value<DateTime> ultimaDataFeita;
  final Value<int?> ultimoKmFeito;
  final Value<int?> intervaloMeses;
  final Value<int?> intervaloKm;
  final Value<DateTime?> dataVencimentoManual;
  final Value<double?> valorPago;
  final Value<String> status;
  final Value<bool> ativo;
  final Value<DateTime> criadoEm;
  final Value<int> rowid;
  const RemindersCompanion({
    this.id = const Value.absent(),
    this.veiculoId = const Value.absent(),
    this.categoriaId = const Value.absent(),
    this.ultimaDataFeita = const Value.absent(),
    this.ultimoKmFeito = const Value.absent(),
    this.intervaloMeses = const Value.absent(),
    this.intervaloKm = const Value.absent(),
    this.dataVencimentoManual = const Value.absent(),
    this.valorPago = const Value.absent(),
    this.status = const Value.absent(),
    this.ativo = const Value.absent(),
    this.criadoEm = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RemindersCompanion.insert({
    required String id,
    required String veiculoId,
    required String categoriaId,
    required DateTime ultimaDataFeita,
    this.ultimoKmFeito = const Value.absent(),
    this.intervaloMeses = const Value.absent(),
    this.intervaloKm = const Value.absent(),
    this.dataVencimentoManual = const Value.absent(),
    this.valorPago = const Value.absent(),
    this.status = const Value.absent(),
    this.ativo = const Value.absent(),
    this.criadoEm = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        veiculoId = Value(veiculoId),
        categoriaId = Value(categoriaId),
        ultimaDataFeita = Value(ultimaDataFeita);
  static Insertable<Reminder> custom({
    Expression<String>? id,
    Expression<String>? veiculoId,
    Expression<String>? categoriaId,
    Expression<DateTime>? ultimaDataFeita,
    Expression<int>? ultimoKmFeito,
    Expression<int>? intervaloMeses,
    Expression<int>? intervaloKm,
    Expression<DateTime>? dataVencimentoManual,
    Expression<double>? valorPago,
    Expression<String>? status,
    Expression<bool>? ativo,
    Expression<DateTime>? criadoEm,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (veiculoId != null) 'veiculo_id': veiculoId,
      if (categoriaId != null) 'categoria_id': categoriaId,
      if (ultimaDataFeita != null) 'ultima_data_feita': ultimaDataFeita,
      if (ultimoKmFeito != null) 'ultimo_km_feito': ultimoKmFeito,
      if (intervaloMeses != null) 'intervalo_meses': intervaloMeses,
      if (intervaloKm != null) 'intervalo_km': intervaloKm,
      if (dataVencimentoManual != null)
        'data_vencimento_manual': dataVencimentoManual,
      if (valorPago != null) 'valor_pago': valorPago,
      if (status != null) 'status': status,
      if (ativo != null) 'ativo': ativo,
      if (criadoEm != null) 'criado_em': criadoEm,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RemindersCompanion copyWith(
      {Value<String>? id,
      Value<String>? veiculoId,
      Value<String>? categoriaId,
      Value<DateTime>? ultimaDataFeita,
      Value<int?>? ultimoKmFeito,
      Value<int?>? intervaloMeses,
      Value<int?>? intervaloKm,
      Value<DateTime?>? dataVencimentoManual,
      Value<double?>? valorPago,
      Value<String>? status,
      Value<bool>? ativo,
      Value<DateTime>? criadoEm,
      Value<int>? rowid}) {
    return RemindersCompanion(
      id: id ?? this.id,
      veiculoId: veiculoId ?? this.veiculoId,
      categoriaId: categoriaId ?? this.categoriaId,
      ultimaDataFeita: ultimaDataFeita ?? this.ultimaDataFeita,
      ultimoKmFeito: ultimoKmFeito ?? this.ultimoKmFeito,
      intervaloMeses: intervaloMeses ?? this.intervaloMeses,
      intervaloKm: intervaloKm ?? this.intervaloKm,
      dataVencimentoManual: dataVencimentoManual ?? this.dataVencimentoManual,
      valorPago: valorPago ?? this.valorPago,
      status: status ?? this.status,
      ativo: ativo ?? this.ativo,
      criadoEm: criadoEm ?? this.criadoEm,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (veiculoId.present) {
      map['veiculo_id'] = Variable<String>(veiculoId.value);
    }
    if (categoriaId.present) {
      map['categoria_id'] = Variable<String>(categoriaId.value);
    }
    if (ultimaDataFeita.present) {
      map['ultima_data_feita'] = Variable<DateTime>(ultimaDataFeita.value);
    }
    if (ultimoKmFeito.present) {
      map['ultimo_km_feito'] = Variable<int>(ultimoKmFeito.value);
    }
    if (intervaloMeses.present) {
      map['intervalo_meses'] = Variable<int>(intervaloMeses.value);
    }
    if (intervaloKm.present) {
      map['intervalo_km'] = Variable<int>(intervaloKm.value);
    }
    if (dataVencimentoManual.present) {
      map['data_vencimento_manual'] =
          Variable<DateTime>(dataVencimentoManual.value);
    }
    if (valorPago.present) {
      map['valor_pago'] = Variable<double>(valorPago.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (ativo.present) {
      map['ativo'] = Variable<bool>(ativo.value);
    }
    if (criadoEm.present) {
      map['criado_em'] = Variable<DateTime>(criadoEm.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersCompanion(')
          ..write('id: $id, ')
          ..write('veiculoId: $veiculoId, ')
          ..write('categoriaId: $categoriaId, ')
          ..write('ultimaDataFeita: $ultimaDataFeita, ')
          ..write('ultimoKmFeito: $ultimoKmFeito, ')
          ..write('intervaloMeses: $intervaloMeses, ')
          ..write('intervaloKm: $intervaloKm, ')
          ..write('dataVencimentoManual: $dataVencimentoManual, ')
          ..write('valorPago: $valorPago, ')
          ..write('status: $status, ')
          ..write('ativo: $ativo, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $VehiclesTable vehicles = $VehiclesTable(this);
  late final $MaintenanceCategoriesTable maintenanceCategories =
      $MaintenanceCategoriesTable(this);
  late final $MaintenanceEventsTable maintenanceEvents =
      $MaintenanceEventsTable(this);
  late final $RemindersTable reminders = $RemindersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [vehicles, maintenanceCategories, maintenanceEvents, reminders];
}

typedef $$VehiclesTableCreateCompanionBuilder = VehiclesCompanion Function({
  required String id,
  required String tipo,
  required String nome,
  Value<String?> placa,
  Value<String?> fotoPath,
  Value<int> kmAtual,
  Value<DateTime> kmAtualizadoEm,
  Value<DateTime> criadoEm,
  Value<int> rowid,
});
typedef $$VehiclesTableUpdateCompanionBuilder = VehiclesCompanion Function({
  Value<String> id,
  Value<String> tipo,
  Value<String> nome,
  Value<String?> placa,
  Value<String?> fotoPath,
  Value<int> kmAtual,
  Value<DateTime> kmAtualizadoEm,
  Value<DateTime> criadoEm,
  Value<int> rowid,
});

final class $$VehiclesTableReferences
    extends BaseReferences<_$AppDatabase, $VehiclesTable, Vehicle> {
  $$VehiclesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MaintenanceEventsTable, List<MaintenanceEvent>>
      _maintenanceEventsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.maintenanceEvents,
              aliasName: 'vehicles__id__maintenance_events__veiculo_id');

  $$MaintenanceEventsTableProcessedTableManager get maintenanceEventsRefs {
    final manager = $$MaintenanceEventsTableTableManager(
            $_db, $_db.maintenanceEvents)
        .filter((f) => f.veiculoId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_maintenanceEventsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$RemindersTable, List<Reminder>>
      _remindersRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.reminders,
              aliasName: 'vehicles__id__reminders__veiculo_id');

  $$RemindersTableProcessedTableManager get remindersRefs {
    final manager = $$RemindersTableTableManager($_db, $_db.reminders)
        .filter((f) => f.veiculoId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_remindersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$VehiclesTableFilterComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tipo => $composableBuilder(
      column: $table.tipo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get placa => $composableBuilder(
      column: $table.placa, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fotoPath => $composableBuilder(
      column: $table.fotoPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get kmAtual => $composableBuilder(
      column: $table.kmAtual, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get kmAtualizadoEm => $composableBuilder(
      column: $table.kmAtualizadoEm,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get criadoEm => $composableBuilder(
      column: $table.criadoEm, builder: (column) => ColumnFilters(column));

  Expression<bool> maintenanceEventsRefs(
      Expression<bool> Function($$MaintenanceEventsTableFilterComposer f) f) {
    final $$MaintenanceEventsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.maintenanceEvents,
        getReferencedColumn: (t) => t.veiculoId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceEventsTableFilterComposer(
              $db: $db,
              $table: $db.maintenanceEvents,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> remindersRefs(
      Expression<bool> Function($$RemindersTableFilterComposer f) f) {
    final $$RemindersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.reminders,
        getReferencedColumn: (t) => t.veiculoId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RemindersTableFilterComposer(
              $db: $db,
              $table: $db.reminders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$VehiclesTableOrderingComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tipo => $composableBuilder(
      column: $table.tipo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get placa => $composableBuilder(
      column: $table.placa, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fotoPath => $composableBuilder(
      column: $table.fotoPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get kmAtual => $composableBuilder(
      column: $table.kmAtual, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get kmAtualizadoEm => $composableBuilder(
      column: $table.kmAtualizadoEm,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get criadoEm => $composableBuilder(
      column: $table.criadoEm, builder: (column) => ColumnOrderings(column));
}

class $$VehiclesTableAnnotationComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get placa =>
      $composableBuilder(column: $table.placa, builder: (column) => column);

  GeneratedColumn<String> get fotoPath =>
      $composableBuilder(column: $table.fotoPath, builder: (column) => column);

  GeneratedColumn<int> get kmAtual =>
      $composableBuilder(column: $table.kmAtual, builder: (column) => column);

  GeneratedColumn<DateTime> get kmAtualizadoEm => $composableBuilder(
      column: $table.kmAtualizadoEm, builder: (column) => column);

  GeneratedColumn<DateTime> get criadoEm =>
      $composableBuilder(column: $table.criadoEm, builder: (column) => column);

  Expression<T> maintenanceEventsRefs<T extends Object>(
      Expression<T> Function($$MaintenanceEventsTableAnnotationComposer a) f) {
    final $$MaintenanceEventsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.maintenanceEvents,
            getReferencedColumn: (t) => t.veiculoId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MaintenanceEventsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.maintenanceEvents,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> remindersRefs<T extends Object>(
      Expression<T> Function($$RemindersTableAnnotationComposer a) f) {
    final $$RemindersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.reminders,
        getReferencedColumn: (t) => t.veiculoId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RemindersTableAnnotationComposer(
              $db: $db,
              $table: $db.reminders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$VehiclesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $VehiclesTable,
    Vehicle,
    $$VehiclesTableFilterComposer,
    $$VehiclesTableOrderingComposer,
    $$VehiclesTableAnnotationComposer,
    $$VehiclesTableCreateCompanionBuilder,
    $$VehiclesTableUpdateCompanionBuilder,
    (Vehicle, $$VehiclesTableReferences),
    Vehicle,
    PrefetchHooks Function({bool maintenanceEventsRefs, bool remindersRefs})> {
  $$VehiclesTableTableManager(_$AppDatabase db, $VehiclesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VehiclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VehiclesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VehiclesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> tipo = const Value.absent(),
            Value<String> nome = const Value.absent(),
            Value<String?> placa = const Value.absent(),
            Value<String?> fotoPath = const Value.absent(),
            Value<int> kmAtual = const Value.absent(),
            Value<DateTime> kmAtualizadoEm = const Value.absent(),
            Value<DateTime> criadoEm = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VehiclesCompanion(
            id: id,
            tipo: tipo,
            nome: nome,
            placa: placa,
            fotoPath: fotoPath,
            kmAtual: kmAtual,
            kmAtualizadoEm: kmAtualizadoEm,
            criadoEm: criadoEm,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String tipo,
            required String nome,
            Value<String?> placa = const Value.absent(),
            Value<String?> fotoPath = const Value.absent(),
            Value<int> kmAtual = const Value.absent(),
            Value<DateTime> kmAtualizadoEm = const Value.absent(),
            Value<DateTime> criadoEm = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VehiclesCompanion.insert(
            id: id,
            tipo: tipo,
            nome: nome,
            placa: placa,
            fotoPath: fotoPath,
            kmAtual: kmAtual,
            kmAtualizadoEm: kmAtualizadoEm,
            criadoEm: criadoEm,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$VehiclesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {maintenanceEventsRefs = false, remindersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (maintenanceEventsRefs) db.maintenanceEvents,
                if (remindersRefs) db.reminders
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (maintenanceEventsRefs)
                    await $_getPrefetchedData<Vehicle, $VehiclesTable,
                            MaintenanceEvent>(
                        currentTable: table,
                        referencedTable: $$VehiclesTableReferences
                            ._maintenanceEventsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$VehiclesTableReferences(db, table, p0)
                                .maintenanceEventsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.veiculoId == item.id),
                        typedResults: items),
                  if (remindersRefs)
                    await $_getPrefetchedData<Vehicle, $VehiclesTable,
                            Reminder>(
                        currentTable: table,
                        referencedTable:
                            $$VehiclesTableReferences._remindersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$VehiclesTableReferences(db, table, p0)
                                .remindersRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.veiculoId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$VehiclesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $VehiclesTable,
    Vehicle,
    $$VehiclesTableFilterComposer,
    $$VehiclesTableOrderingComposer,
    $$VehiclesTableAnnotationComposer,
    $$VehiclesTableCreateCompanionBuilder,
    $$VehiclesTableUpdateCompanionBuilder,
    (Vehicle, $$VehiclesTableReferences),
    Vehicle,
    PrefetchHooks Function({bool maintenanceEventsRefs, bool remindersRefs})>;
typedef $$MaintenanceCategoriesTableCreateCompanionBuilder
    = MaintenanceCategoriesCompanion Function({
  required String id,
  required String nome,
  required String veiculoTipoAplicavel,
  Value<String> icone,
  Value<bool> customizada,
  Value<String> tipoCalculo,
  Value<int> rowid,
});
typedef $$MaintenanceCategoriesTableUpdateCompanionBuilder
    = MaintenanceCategoriesCompanion Function({
  Value<String> id,
  Value<String> nome,
  Value<String> veiculoTipoAplicavel,
  Value<String> icone,
  Value<bool> customizada,
  Value<String> tipoCalculo,
  Value<int> rowid,
});

final class $$MaintenanceCategoriesTableReferences extends BaseReferences<
    _$AppDatabase, $MaintenanceCategoriesTable, MaintenanceCategory> {
  $$MaintenanceCategoriesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MaintenanceEventsTable,
      List<MaintenanceEvent>> _maintenanceEventsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.maintenanceEvents,
          aliasName:
              'maintenance_categories__id__maintenance_events__categoria_id');

  $$MaintenanceEventsTableProcessedTableManager get maintenanceEventsRefs {
    final manager = $$MaintenanceEventsTableTableManager(
            $_db, $_db.maintenanceEvents)
        .filter((f) => f.categoriaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_maintenanceEventsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$RemindersTable, List<Reminder>>
      _remindersRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.reminders,
              aliasName: 'maintenance_categories__id__reminders__categoria_id');

  $$RemindersTableProcessedTableManager get remindersRefs {
    final manager = $$RemindersTableTableManager($_db, $_db.reminders)
        .filter((f) => f.categoriaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_remindersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$MaintenanceCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $MaintenanceCategoriesTable> {
  $$MaintenanceCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get veiculoTipoAplicavel => $composableBuilder(
      column: $table.veiculoTipoAplicavel,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get icone => $composableBuilder(
      column: $table.icone, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get customizada => $composableBuilder(
      column: $table.customizada, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tipoCalculo => $composableBuilder(
      column: $table.tipoCalculo, builder: (column) => ColumnFilters(column));

  Expression<bool> maintenanceEventsRefs(
      Expression<bool> Function($$MaintenanceEventsTableFilterComposer f) f) {
    final $$MaintenanceEventsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.maintenanceEvents,
        getReferencedColumn: (t) => t.categoriaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaintenanceEventsTableFilterComposer(
              $db: $db,
              $table: $db.maintenanceEvents,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> remindersRefs(
      Expression<bool> Function($$RemindersTableFilterComposer f) f) {
    final $$RemindersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.reminders,
        getReferencedColumn: (t) => t.categoriaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RemindersTableFilterComposer(
              $db: $db,
              $table: $db.reminders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MaintenanceCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $MaintenanceCategoriesTable> {
  $$MaintenanceCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get veiculoTipoAplicavel => $composableBuilder(
      column: $table.veiculoTipoAplicavel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get icone => $composableBuilder(
      column: $table.icone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get customizada => $composableBuilder(
      column: $table.customizada, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tipoCalculo => $composableBuilder(
      column: $table.tipoCalculo, builder: (column) => ColumnOrderings(column));
}

class $$MaintenanceCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MaintenanceCategoriesTable> {
  $$MaintenanceCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get veiculoTipoAplicavel => $composableBuilder(
      column: $table.veiculoTipoAplicavel, builder: (column) => column);

  GeneratedColumn<String> get icone =>
      $composableBuilder(column: $table.icone, builder: (column) => column);

  GeneratedColumn<bool> get customizada => $composableBuilder(
      column: $table.customizada, builder: (column) => column);

  GeneratedColumn<String> get tipoCalculo => $composableBuilder(
      column: $table.tipoCalculo, builder: (column) => column);

  Expression<T> maintenanceEventsRefs<T extends Object>(
      Expression<T> Function($$MaintenanceEventsTableAnnotationComposer a) f) {
    final $$MaintenanceEventsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.maintenanceEvents,
            getReferencedColumn: (t) => t.categoriaId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MaintenanceEventsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.maintenanceEvents,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> remindersRefs<T extends Object>(
      Expression<T> Function($$RemindersTableAnnotationComposer a) f) {
    final $$RemindersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.reminders,
        getReferencedColumn: (t) => t.categoriaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RemindersTableAnnotationComposer(
              $db: $db,
              $table: $db.reminders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MaintenanceCategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MaintenanceCategoriesTable,
    MaintenanceCategory,
    $$MaintenanceCategoriesTableFilterComposer,
    $$MaintenanceCategoriesTableOrderingComposer,
    $$MaintenanceCategoriesTableAnnotationComposer,
    $$MaintenanceCategoriesTableCreateCompanionBuilder,
    $$MaintenanceCategoriesTableUpdateCompanionBuilder,
    (MaintenanceCategory, $$MaintenanceCategoriesTableReferences),
    MaintenanceCategory,
    PrefetchHooks Function({bool maintenanceEventsRefs, bool remindersRefs})> {
  $$MaintenanceCategoriesTableTableManager(
      _$AppDatabase db, $MaintenanceCategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MaintenanceCategoriesTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$MaintenanceCategoriesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MaintenanceCategoriesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> nome = const Value.absent(),
            Value<String> veiculoTipoAplicavel = const Value.absent(),
            Value<String> icone = const Value.absent(),
            Value<bool> customizada = const Value.absent(),
            Value<String> tipoCalculo = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MaintenanceCategoriesCompanion(
            id: id,
            nome: nome,
            veiculoTipoAplicavel: veiculoTipoAplicavel,
            icone: icone,
            customizada: customizada,
            tipoCalculo: tipoCalculo,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String nome,
            required String veiculoTipoAplicavel,
            Value<String> icone = const Value.absent(),
            Value<bool> customizada = const Value.absent(),
            Value<String> tipoCalculo = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MaintenanceCategoriesCompanion.insert(
            id: id,
            nome: nome,
            veiculoTipoAplicavel: veiculoTipoAplicavel,
            icone: icone,
            customizada: customizada,
            tipoCalculo: tipoCalculo,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MaintenanceCategoriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {maintenanceEventsRefs = false, remindersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (maintenanceEventsRefs) db.maintenanceEvents,
                if (remindersRefs) db.reminders
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (maintenanceEventsRefs)
                    await $_getPrefetchedData<MaintenanceCategory,
                            $MaintenanceCategoriesTable, MaintenanceEvent>(
                        currentTable: table,
                        referencedTable: $$MaintenanceCategoriesTableReferences
                            ._maintenanceEventsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MaintenanceCategoriesTableReferences(
                                    db, table, p0)
                                .maintenanceEventsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoriaId == item.id),
                        typedResults: items),
                  if (remindersRefs)
                    await $_getPrefetchedData<MaintenanceCategory,
                            $MaintenanceCategoriesTable, Reminder>(
                        currentTable: table,
                        referencedTable: $$MaintenanceCategoriesTableReferences
                            ._remindersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MaintenanceCategoriesTableReferences(
                                    db, table, p0)
                                .remindersRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoriaId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$MaintenanceCategoriesTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $MaintenanceCategoriesTable,
        MaintenanceCategory,
        $$MaintenanceCategoriesTableFilterComposer,
        $$MaintenanceCategoriesTableOrderingComposer,
        $$MaintenanceCategoriesTableAnnotationComposer,
        $$MaintenanceCategoriesTableCreateCompanionBuilder,
        $$MaintenanceCategoriesTableUpdateCompanionBuilder,
        (MaintenanceCategory, $$MaintenanceCategoriesTableReferences),
        MaintenanceCategory,
        PrefetchHooks Function(
            {bool maintenanceEventsRefs, bool remindersRefs})>;
typedef $$MaintenanceEventsTableCreateCompanionBuilder
    = MaintenanceEventsCompanion Function({
  required String id,
  required String veiculoId,
  required String categoriaId,
  required DateTime dataRealizada,
  Value<int?> kmRealizado,
  Value<double?> valorGasto,
  Value<String?> oficina,
  Value<String?> observacao,
  Value<String?> anexoPath,
  Value<DateTime> criadoEm,
  Value<int> rowid,
});
typedef $$MaintenanceEventsTableUpdateCompanionBuilder
    = MaintenanceEventsCompanion Function({
  Value<String> id,
  Value<String> veiculoId,
  Value<String> categoriaId,
  Value<DateTime> dataRealizada,
  Value<int?> kmRealizado,
  Value<double?> valorGasto,
  Value<String?> oficina,
  Value<String?> observacao,
  Value<String?> anexoPath,
  Value<DateTime> criadoEm,
  Value<int> rowid,
});

final class $$MaintenanceEventsTableReferences extends BaseReferences<
    _$AppDatabase, $MaintenanceEventsTable, MaintenanceEvent> {
  $$MaintenanceEventsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $VehiclesTable _veiculoIdTable(_$AppDatabase db) =>
      db.vehicles.createAlias('maintenance_events__veiculo_id__vehicles__id');

  $$VehiclesTableProcessedTableManager get veiculoId {
    final $_column = $_itemColumn<String>('veiculo_id')!;

    final manager = $$VehiclesTableTableManager($_db, $_db.vehicles)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_veiculoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $MaintenanceCategoriesTable _categoriaIdTable(_$AppDatabase db) =>
      db.maintenanceCategories.createAlias(
          'maintenance_events__categoria_id__maintenance_categories__id');

  $$MaintenanceCategoriesTableProcessedTableManager get categoriaId {
    final $_column = $_itemColumn<String>('categoria_id')!;

    final manager = $$MaintenanceCategoriesTableTableManager(
            $_db, $_db.maintenanceCategories)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoriaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MaintenanceEventsTableFilterComposer
    extends Composer<_$AppDatabase, $MaintenanceEventsTable> {
  $$MaintenanceEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dataRealizada => $composableBuilder(
      column: $table.dataRealizada, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get kmRealizado => $composableBuilder(
      column: $table.kmRealizado, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get valorGasto => $composableBuilder(
      column: $table.valorGasto, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get oficina => $composableBuilder(
      column: $table.oficina, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get observacao => $composableBuilder(
      column: $table.observacao, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get anexoPath => $composableBuilder(
      column: $table.anexoPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get criadoEm => $composableBuilder(
      column: $table.criadoEm, builder: (column) => ColumnFilters(column));

  $$VehiclesTableFilterComposer get veiculoId {
    final $$VehiclesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.veiculoId,
        referencedTable: $db.vehicles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$VehiclesTableFilterComposer(
              $db: $db,
              $table: $db.vehicles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MaintenanceCategoriesTableFilterComposer get categoriaId {
    final $$MaintenanceCategoriesTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.categoriaId,
            referencedTable: $db.maintenanceCategories,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MaintenanceCategoriesTableFilterComposer(
                  $db: $db,
                  $table: $db.maintenanceCategories,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$MaintenanceEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $MaintenanceEventsTable> {
  $$MaintenanceEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dataRealizada => $composableBuilder(
      column: $table.dataRealizada,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get kmRealizado => $composableBuilder(
      column: $table.kmRealizado, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get valorGasto => $composableBuilder(
      column: $table.valorGasto, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get oficina => $composableBuilder(
      column: $table.oficina, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get observacao => $composableBuilder(
      column: $table.observacao, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get anexoPath => $composableBuilder(
      column: $table.anexoPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get criadoEm => $composableBuilder(
      column: $table.criadoEm, builder: (column) => ColumnOrderings(column));

  $$VehiclesTableOrderingComposer get veiculoId {
    final $$VehiclesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.veiculoId,
        referencedTable: $db.vehicles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$VehiclesTableOrderingComposer(
              $db: $db,
              $table: $db.vehicles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MaintenanceCategoriesTableOrderingComposer get categoriaId {
    final $$MaintenanceCategoriesTableOrderingComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.categoriaId,
            referencedTable: $db.maintenanceCategories,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MaintenanceCategoriesTableOrderingComposer(
                  $db: $db,
                  $table: $db.maintenanceCategories,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$MaintenanceEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MaintenanceEventsTable> {
  $$MaintenanceEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get dataRealizada => $composableBuilder(
      column: $table.dataRealizada, builder: (column) => column);

  GeneratedColumn<int> get kmRealizado => $composableBuilder(
      column: $table.kmRealizado, builder: (column) => column);

  GeneratedColumn<double> get valorGasto => $composableBuilder(
      column: $table.valorGasto, builder: (column) => column);

  GeneratedColumn<String> get oficina =>
      $composableBuilder(column: $table.oficina, builder: (column) => column);

  GeneratedColumn<String> get observacao => $composableBuilder(
      column: $table.observacao, builder: (column) => column);

  GeneratedColumn<String> get anexoPath =>
      $composableBuilder(column: $table.anexoPath, builder: (column) => column);

  GeneratedColumn<DateTime> get criadoEm =>
      $composableBuilder(column: $table.criadoEm, builder: (column) => column);

  $$VehiclesTableAnnotationComposer get veiculoId {
    final $$VehiclesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.veiculoId,
        referencedTable: $db.vehicles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$VehiclesTableAnnotationComposer(
              $db: $db,
              $table: $db.vehicles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MaintenanceCategoriesTableAnnotationComposer get categoriaId {
    final $$MaintenanceCategoriesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.categoriaId,
            referencedTable: $db.maintenanceCategories,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MaintenanceCategoriesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.maintenanceCategories,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$MaintenanceEventsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MaintenanceEventsTable,
    MaintenanceEvent,
    $$MaintenanceEventsTableFilterComposer,
    $$MaintenanceEventsTableOrderingComposer,
    $$MaintenanceEventsTableAnnotationComposer,
    $$MaintenanceEventsTableCreateCompanionBuilder,
    $$MaintenanceEventsTableUpdateCompanionBuilder,
    (MaintenanceEvent, $$MaintenanceEventsTableReferences),
    MaintenanceEvent,
    PrefetchHooks Function({bool veiculoId, bool categoriaId})> {
  $$MaintenanceEventsTableTableManager(
      _$AppDatabase db, $MaintenanceEventsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MaintenanceEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MaintenanceEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MaintenanceEventsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> veiculoId = const Value.absent(),
            Value<String> categoriaId = const Value.absent(),
            Value<DateTime> dataRealizada = const Value.absent(),
            Value<int?> kmRealizado = const Value.absent(),
            Value<double?> valorGasto = const Value.absent(),
            Value<String?> oficina = const Value.absent(),
            Value<String?> observacao = const Value.absent(),
            Value<String?> anexoPath = const Value.absent(),
            Value<DateTime> criadoEm = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MaintenanceEventsCompanion(
            id: id,
            veiculoId: veiculoId,
            categoriaId: categoriaId,
            dataRealizada: dataRealizada,
            kmRealizado: kmRealizado,
            valorGasto: valorGasto,
            oficina: oficina,
            observacao: observacao,
            anexoPath: anexoPath,
            criadoEm: criadoEm,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String veiculoId,
            required String categoriaId,
            required DateTime dataRealizada,
            Value<int?> kmRealizado = const Value.absent(),
            Value<double?> valorGasto = const Value.absent(),
            Value<String?> oficina = const Value.absent(),
            Value<String?> observacao = const Value.absent(),
            Value<String?> anexoPath = const Value.absent(),
            Value<DateTime> criadoEm = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MaintenanceEventsCompanion.insert(
            id: id,
            veiculoId: veiculoId,
            categoriaId: categoriaId,
            dataRealizada: dataRealizada,
            kmRealizado: kmRealizado,
            valorGasto: valorGasto,
            oficina: oficina,
            observacao: observacao,
            anexoPath: anexoPath,
            criadoEm: criadoEm,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MaintenanceEventsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({veiculoId = false, categoriaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (veiculoId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.veiculoId,
                    referencedTable:
                        $$MaintenanceEventsTableReferences._veiculoIdTable(db),
                    referencedColumn: $$MaintenanceEventsTableReferences
                        ._veiculoIdTable(db)
                        .id,
                  ) as T;
                }
                if (categoriaId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoriaId,
                    referencedTable: $$MaintenanceEventsTableReferences
                        ._categoriaIdTable(db),
                    referencedColumn: $$MaintenanceEventsTableReferences
                        ._categoriaIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MaintenanceEventsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MaintenanceEventsTable,
    MaintenanceEvent,
    $$MaintenanceEventsTableFilterComposer,
    $$MaintenanceEventsTableOrderingComposer,
    $$MaintenanceEventsTableAnnotationComposer,
    $$MaintenanceEventsTableCreateCompanionBuilder,
    $$MaintenanceEventsTableUpdateCompanionBuilder,
    (MaintenanceEvent, $$MaintenanceEventsTableReferences),
    MaintenanceEvent,
    PrefetchHooks Function({bool veiculoId, bool categoriaId})>;
typedef $$RemindersTableCreateCompanionBuilder = RemindersCompanion Function({
  required String id,
  required String veiculoId,
  required String categoriaId,
  required DateTime ultimaDataFeita,
  Value<int?> ultimoKmFeito,
  Value<int?> intervaloMeses,
  Value<int?> intervaloKm,
  Value<DateTime?> dataVencimentoManual,
  Value<double?> valorPago,
  Value<String> status,
  Value<bool> ativo,
  Value<DateTime> criadoEm,
  Value<int> rowid,
});
typedef $$RemindersTableUpdateCompanionBuilder = RemindersCompanion Function({
  Value<String> id,
  Value<String> veiculoId,
  Value<String> categoriaId,
  Value<DateTime> ultimaDataFeita,
  Value<int?> ultimoKmFeito,
  Value<int?> intervaloMeses,
  Value<int?> intervaloKm,
  Value<DateTime?> dataVencimentoManual,
  Value<double?> valorPago,
  Value<String> status,
  Value<bool> ativo,
  Value<DateTime> criadoEm,
  Value<int> rowid,
});

final class $$RemindersTableReferences
    extends BaseReferences<_$AppDatabase, $RemindersTable, Reminder> {
  $$RemindersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $VehiclesTable _veiculoIdTable(_$AppDatabase db) =>
      db.vehicles.createAlias('reminders__veiculo_id__vehicles__id');

  $$VehiclesTableProcessedTableManager get veiculoId {
    final $_column = $_itemColumn<String>('veiculo_id')!;

    final manager = $$VehiclesTableTableManager($_db, $_db.vehicles)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_veiculoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $MaintenanceCategoriesTable _categoriaIdTable(_$AppDatabase db) =>
      db.maintenanceCategories
          .createAlias('reminders__categoria_id__maintenance_categories__id');

  $$MaintenanceCategoriesTableProcessedTableManager get categoriaId {
    final $_column = $_itemColumn<String>('categoria_id')!;

    final manager = $$MaintenanceCategoriesTableTableManager(
            $_db, $_db.maintenanceCategories)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoriaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$RemindersTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get ultimaDataFeita => $composableBuilder(
      column: $table.ultimaDataFeita,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ultimoKmFeito => $composableBuilder(
      column: $table.ultimoKmFeito, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get intervaloMeses => $composableBuilder(
      column: $table.intervaloMeses,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get intervaloKm => $composableBuilder(
      column: $table.intervaloKm, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dataVencimentoManual => $composableBuilder(
      column: $table.dataVencimentoManual,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get valorPago => $composableBuilder(
      column: $table.valorPago, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get ativo => $composableBuilder(
      column: $table.ativo, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get criadoEm => $composableBuilder(
      column: $table.criadoEm, builder: (column) => ColumnFilters(column));

  $$VehiclesTableFilterComposer get veiculoId {
    final $$VehiclesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.veiculoId,
        referencedTable: $db.vehicles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$VehiclesTableFilterComposer(
              $db: $db,
              $table: $db.vehicles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MaintenanceCategoriesTableFilterComposer get categoriaId {
    final $$MaintenanceCategoriesTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.categoriaId,
            referencedTable: $db.maintenanceCategories,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MaintenanceCategoriesTableFilterComposer(
                  $db: $db,
                  $table: $db.maintenanceCategories,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$RemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get ultimaDataFeita => $composableBuilder(
      column: $table.ultimaDataFeita,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ultimoKmFeito => $composableBuilder(
      column: $table.ultimoKmFeito,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get intervaloMeses => $composableBuilder(
      column: $table.intervaloMeses,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get intervaloKm => $composableBuilder(
      column: $table.intervaloKm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dataVencimentoManual => $composableBuilder(
      column: $table.dataVencimentoManual,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get valorPago => $composableBuilder(
      column: $table.valorPago, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get ativo => $composableBuilder(
      column: $table.ativo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get criadoEm => $composableBuilder(
      column: $table.criadoEm, builder: (column) => ColumnOrderings(column));

  $$VehiclesTableOrderingComposer get veiculoId {
    final $$VehiclesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.veiculoId,
        referencedTable: $db.vehicles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$VehiclesTableOrderingComposer(
              $db: $db,
              $table: $db.vehicles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MaintenanceCategoriesTableOrderingComposer get categoriaId {
    final $$MaintenanceCategoriesTableOrderingComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.categoriaId,
            referencedTable: $db.maintenanceCategories,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MaintenanceCategoriesTableOrderingComposer(
                  $db: $db,
                  $table: $db.maintenanceCategories,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$RemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get ultimaDataFeita => $composableBuilder(
      column: $table.ultimaDataFeita, builder: (column) => column);

  GeneratedColumn<int> get ultimoKmFeito => $composableBuilder(
      column: $table.ultimoKmFeito, builder: (column) => column);

  GeneratedColumn<int> get intervaloMeses => $composableBuilder(
      column: $table.intervaloMeses, builder: (column) => column);

  GeneratedColumn<int> get intervaloKm => $composableBuilder(
      column: $table.intervaloKm, builder: (column) => column);

  GeneratedColumn<DateTime> get dataVencimentoManual => $composableBuilder(
      column: $table.dataVencimentoManual, builder: (column) => column);

  GeneratedColumn<double> get valorPago =>
      $composableBuilder(column: $table.valorPago, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get ativo =>
      $composableBuilder(column: $table.ativo, builder: (column) => column);

  GeneratedColumn<DateTime> get criadoEm =>
      $composableBuilder(column: $table.criadoEm, builder: (column) => column);

  $$VehiclesTableAnnotationComposer get veiculoId {
    final $$VehiclesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.veiculoId,
        referencedTable: $db.vehicles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$VehiclesTableAnnotationComposer(
              $db: $db,
              $table: $db.vehicles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MaintenanceCategoriesTableAnnotationComposer get categoriaId {
    final $$MaintenanceCategoriesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.categoriaId,
            referencedTable: $db.maintenanceCategories,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MaintenanceCategoriesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.maintenanceCategories,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$RemindersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RemindersTable,
    Reminder,
    $$RemindersTableFilterComposer,
    $$RemindersTableOrderingComposer,
    $$RemindersTableAnnotationComposer,
    $$RemindersTableCreateCompanionBuilder,
    $$RemindersTableUpdateCompanionBuilder,
    (Reminder, $$RemindersTableReferences),
    Reminder,
    PrefetchHooks Function({bool veiculoId, bool categoriaId})> {
  $$RemindersTableTableManager(_$AppDatabase db, $RemindersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> veiculoId = const Value.absent(),
            Value<String> categoriaId = const Value.absent(),
            Value<DateTime> ultimaDataFeita = const Value.absent(),
            Value<int?> ultimoKmFeito = const Value.absent(),
            Value<int?> intervaloMeses = const Value.absent(),
            Value<int?> intervaloKm = const Value.absent(),
            Value<DateTime?> dataVencimentoManual = const Value.absent(),
            Value<double?> valorPago = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<bool> ativo = const Value.absent(),
            Value<DateTime> criadoEm = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RemindersCompanion(
            id: id,
            veiculoId: veiculoId,
            categoriaId: categoriaId,
            ultimaDataFeita: ultimaDataFeita,
            ultimoKmFeito: ultimoKmFeito,
            intervaloMeses: intervaloMeses,
            intervaloKm: intervaloKm,
            dataVencimentoManual: dataVencimentoManual,
            valorPago: valorPago,
            status: status,
            ativo: ativo,
            criadoEm: criadoEm,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String veiculoId,
            required String categoriaId,
            required DateTime ultimaDataFeita,
            Value<int?> ultimoKmFeito = const Value.absent(),
            Value<int?> intervaloMeses = const Value.absent(),
            Value<int?> intervaloKm = const Value.absent(),
            Value<DateTime?> dataVencimentoManual = const Value.absent(),
            Value<double?> valorPago = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<bool> ativo = const Value.absent(),
            Value<DateTime> criadoEm = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RemindersCompanion.insert(
            id: id,
            veiculoId: veiculoId,
            categoriaId: categoriaId,
            ultimaDataFeita: ultimaDataFeita,
            ultimoKmFeito: ultimoKmFeito,
            intervaloMeses: intervaloMeses,
            intervaloKm: intervaloKm,
            dataVencimentoManual: dataVencimentoManual,
            valorPago: valorPago,
            status: status,
            ativo: ativo,
            criadoEm: criadoEm,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$RemindersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({veiculoId = false, categoriaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (veiculoId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.veiculoId,
                    referencedTable:
                        $$RemindersTableReferences._veiculoIdTable(db),
                    referencedColumn:
                        $$RemindersTableReferences._veiculoIdTable(db).id,
                  ) as T;
                }
                if (categoriaId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoriaId,
                    referencedTable:
                        $$RemindersTableReferences._categoriaIdTable(db),
                    referencedColumn:
                        $$RemindersTableReferences._categoriaIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$RemindersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RemindersTable,
    Reminder,
    $$RemindersTableFilterComposer,
    $$RemindersTableOrderingComposer,
    $$RemindersTableAnnotationComposer,
    $$RemindersTableCreateCompanionBuilder,
    $$RemindersTableUpdateCompanionBuilder,
    (Reminder, $$RemindersTableReferences),
    Reminder,
    PrefetchHooks Function({bool veiculoId, bool categoriaId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$VehiclesTableTableManager get vehicles =>
      $$VehiclesTableTableManager(_db, _db.vehicles);
  $$MaintenanceCategoriesTableTableManager get maintenanceCategories =>
      $$MaintenanceCategoriesTableTableManager(_db, _db.maintenanceCategories);
  $$MaintenanceEventsTableTableManager get maintenanceEvents =>
      $$MaintenanceEventsTableTableManager(_db, _db.maintenanceEvents);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db, _db.reminders);
}
