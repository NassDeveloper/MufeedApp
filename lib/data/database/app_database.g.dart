// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LevelsTable extends Levels with TableInfo<$LevelsTable, Level> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LevelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<int> number = GeneratedColumn<int>(
    'number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameFrMeta = const VerificationMeta('nameFr');
  @override
  late final GeneratedColumn<String> nameFr = GeneratedColumn<String>(
    'name_fr',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
    'name_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitCountMeta = const VerificationMeta(
    'unitCount',
  );
  @override
  late final GeneratedColumn<int> unitCount = GeneratedColumn<int>(
    'unit_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    number,
    nameFr,
    nameEn,
    nameAr,
    unitCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'levels';
  @override
  VerificationContext validateIntegrity(
    Insertable<Level> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('number')) {
      context.handle(
        _numberMeta,
        number.isAcceptableOrUnknown(data['number']!, _numberMeta),
      );
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('name_fr')) {
      context.handle(
        _nameFrMeta,
        nameFr.isAcceptableOrUnknown(data['name_fr']!, _nameFrMeta),
      );
    } else if (isInserting) {
      context.missing(_nameFrMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    if (data.containsKey('name_ar')) {
      context.handle(
        _nameArMeta,
        nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta),
      );
    } else if (isInserting) {
      context.missing(_nameArMeta);
    }
    if (data.containsKey('unit_count')) {
      context.handle(
        _unitCountMeta,
        unitCount.isAcceptableOrUnknown(data['unit_count']!, _unitCountMeta),
      );
    } else if (isInserting) {
      context.missing(_unitCountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Level map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Level(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      number: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}number'],
      )!,
      nameFr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_fr'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      )!,
      nameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ar'],
      )!,
      unitCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_count'],
      )!,
    );
  }

  @override
  $LevelsTable createAlias(String alias) {
    return $LevelsTable(attachedDatabase, alias);
  }
}

class Level extends DataClass implements Insertable<Level> {
  final int id;
  final int number;
  final String nameFr;
  final String nameEn;
  final String nameAr;
  final int unitCount;
  const Level({
    required this.id,
    required this.number,
    required this.nameFr,
    required this.nameEn,
    required this.nameAr,
    required this.unitCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['number'] = Variable<int>(number);
    map['name_fr'] = Variable<String>(nameFr);
    map['name_en'] = Variable<String>(nameEn);
    map['name_ar'] = Variable<String>(nameAr);
    map['unit_count'] = Variable<int>(unitCount);
    return map;
  }

  LevelsCompanion toCompanion(bool nullToAbsent) {
    return LevelsCompanion(
      id: Value(id),
      number: Value(number),
      nameFr: Value(nameFr),
      nameEn: Value(nameEn),
      nameAr: Value(nameAr),
      unitCount: Value(unitCount),
    );
  }

  factory Level.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Level(
      id: serializer.fromJson<int>(json['id']),
      number: serializer.fromJson<int>(json['number']),
      nameFr: serializer.fromJson<String>(json['nameFr']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
      nameAr: serializer.fromJson<String>(json['nameAr']),
      unitCount: serializer.fromJson<int>(json['unitCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'number': serializer.toJson<int>(number),
      'nameFr': serializer.toJson<String>(nameFr),
      'nameEn': serializer.toJson<String>(nameEn),
      'nameAr': serializer.toJson<String>(nameAr),
      'unitCount': serializer.toJson<int>(unitCount),
    };
  }

  Level copyWith({
    int? id,
    int? number,
    String? nameFr,
    String? nameEn,
    String? nameAr,
    int? unitCount,
  }) => Level(
    id: id ?? this.id,
    number: number ?? this.number,
    nameFr: nameFr ?? this.nameFr,
    nameEn: nameEn ?? this.nameEn,
    nameAr: nameAr ?? this.nameAr,
    unitCount: unitCount ?? this.unitCount,
  );
  Level copyWithCompanion(LevelsCompanion data) {
    return Level(
      id: data.id.present ? data.id.value : this.id,
      number: data.number.present ? data.number.value : this.number,
      nameFr: data.nameFr.present ? data.nameFr.value : this.nameFr,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      unitCount: data.unitCount.present ? data.unitCount.value : this.unitCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Level(')
          ..write('id: $id, ')
          ..write('number: $number, ')
          ..write('nameFr: $nameFr, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameAr: $nameAr, ')
          ..write('unitCount: $unitCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, number, nameFr, nameEn, nameAr, unitCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Level &&
          other.id == this.id &&
          other.number == this.number &&
          other.nameFr == this.nameFr &&
          other.nameEn == this.nameEn &&
          other.nameAr == this.nameAr &&
          other.unitCount == this.unitCount);
}

class LevelsCompanion extends UpdateCompanion<Level> {
  final Value<int> id;
  final Value<int> number;
  final Value<String> nameFr;
  final Value<String> nameEn;
  final Value<String> nameAr;
  final Value<int> unitCount;
  const LevelsCompanion({
    this.id = const Value.absent(),
    this.number = const Value.absent(),
    this.nameFr = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.unitCount = const Value.absent(),
  });
  LevelsCompanion.insert({
    this.id = const Value.absent(),
    required int number,
    required String nameFr,
    required String nameEn,
    required String nameAr,
    required int unitCount,
  }) : number = Value(number),
       nameFr = Value(nameFr),
       nameEn = Value(nameEn),
       nameAr = Value(nameAr),
       unitCount = Value(unitCount);
  static Insertable<Level> custom({
    Expression<int>? id,
    Expression<int>? number,
    Expression<String>? nameFr,
    Expression<String>? nameEn,
    Expression<String>? nameAr,
    Expression<int>? unitCount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (number != null) 'number': number,
      if (nameFr != null) 'name_fr': nameFr,
      if (nameEn != null) 'name_en': nameEn,
      if (nameAr != null) 'name_ar': nameAr,
      if (unitCount != null) 'unit_count': unitCount,
    });
  }

  LevelsCompanion copyWith({
    Value<int>? id,
    Value<int>? number,
    Value<String>? nameFr,
    Value<String>? nameEn,
    Value<String>? nameAr,
    Value<int>? unitCount,
  }) {
    return LevelsCompanion(
      id: id ?? this.id,
      number: number ?? this.number,
      nameFr: nameFr ?? this.nameFr,
      nameEn: nameEn ?? this.nameEn,
      nameAr: nameAr ?? this.nameAr,
      unitCount: unitCount ?? this.unitCount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (number.present) {
      map['number'] = Variable<int>(number.value);
    }
    if (nameFr.present) {
      map['name_fr'] = Variable<String>(nameFr.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (unitCount.present) {
      map['unit_count'] = Variable<int>(unitCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LevelsCompanion(')
          ..write('id: $id, ')
          ..write('number: $number, ')
          ..write('nameFr: $nameFr, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameAr: $nameAr, ')
          ..write('unitCount: $unitCount')
          ..write(')'))
        .toString();
  }
}

class $UnitsTable extends Units with TableInfo<$UnitsTable, Unit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _levelIdMeta = const VerificationMeta(
    'levelId',
  );
  @override
  late final GeneratedColumn<int> levelId = GeneratedColumn<int>(
    'level_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES levels (id)',
    ),
  );
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<int> number = GeneratedColumn<int>(
    'number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameFrMeta = const VerificationMeta('nameFr');
  @override
  late final GeneratedColumn<String> nameFr = GeneratedColumn<String>(
    'name_fr',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, levelId, number, nameFr, nameEn];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'units';
  @override
  VerificationContext validateIntegrity(
    Insertable<Unit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('level_id')) {
      context.handle(
        _levelIdMeta,
        levelId.isAcceptableOrUnknown(data['level_id']!, _levelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_levelIdMeta);
    }
    if (data.containsKey('number')) {
      context.handle(
        _numberMeta,
        number.isAcceptableOrUnknown(data['number']!, _numberMeta),
      );
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('name_fr')) {
      context.handle(
        _nameFrMeta,
        nameFr.isAcceptableOrUnknown(data['name_fr']!, _nameFrMeta),
      );
    } else if (isInserting) {
      context.missing(_nameFrMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Unit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Unit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      levelId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level_id'],
      )!,
      number: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}number'],
      )!,
      nameFr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_fr'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      )!,
    );
  }

  @override
  $UnitsTable createAlias(String alias) {
    return $UnitsTable(attachedDatabase, alias);
  }
}

class Unit extends DataClass implements Insertable<Unit> {
  final int id;
  final int levelId;
  final int number;
  final String nameFr;
  final String nameEn;
  const Unit({
    required this.id,
    required this.levelId,
    required this.number,
    required this.nameFr,
    required this.nameEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['level_id'] = Variable<int>(levelId);
    map['number'] = Variable<int>(number);
    map['name_fr'] = Variable<String>(nameFr);
    map['name_en'] = Variable<String>(nameEn);
    return map;
  }

  UnitsCompanion toCompanion(bool nullToAbsent) {
    return UnitsCompanion(
      id: Value(id),
      levelId: Value(levelId),
      number: Value(number),
      nameFr: Value(nameFr),
      nameEn: Value(nameEn),
    );
  }

  factory Unit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Unit(
      id: serializer.fromJson<int>(json['id']),
      levelId: serializer.fromJson<int>(json['levelId']),
      number: serializer.fromJson<int>(json['number']),
      nameFr: serializer.fromJson<String>(json['nameFr']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'levelId': serializer.toJson<int>(levelId),
      'number': serializer.toJson<int>(number),
      'nameFr': serializer.toJson<String>(nameFr),
      'nameEn': serializer.toJson<String>(nameEn),
    };
  }

  Unit copyWith({
    int? id,
    int? levelId,
    int? number,
    String? nameFr,
    String? nameEn,
  }) => Unit(
    id: id ?? this.id,
    levelId: levelId ?? this.levelId,
    number: number ?? this.number,
    nameFr: nameFr ?? this.nameFr,
    nameEn: nameEn ?? this.nameEn,
  );
  Unit copyWithCompanion(UnitsCompanion data) {
    return Unit(
      id: data.id.present ? data.id.value : this.id,
      levelId: data.levelId.present ? data.levelId.value : this.levelId,
      number: data.number.present ? data.number.value : this.number,
      nameFr: data.nameFr.present ? data.nameFr.value : this.nameFr,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Unit(')
          ..write('id: $id, ')
          ..write('levelId: $levelId, ')
          ..write('number: $number, ')
          ..write('nameFr: $nameFr, ')
          ..write('nameEn: $nameEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, levelId, number, nameFr, nameEn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Unit &&
          other.id == this.id &&
          other.levelId == this.levelId &&
          other.number == this.number &&
          other.nameFr == this.nameFr &&
          other.nameEn == this.nameEn);
}

class UnitsCompanion extends UpdateCompanion<Unit> {
  final Value<int> id;
  final Value<int> levelId;
  final Value<int> number;
  final Value<String> nameFr;
  final Value<String> nameEn;
  const UnitsCompanion({
    this.id = const Value.absent(),
    this.levelId = const Value.absent(),
    this.number = const Value.absent(),
    this.nameFr = const Value.absent(),
    this.nameEn = const Value.absent(),
  });
  UnitsCompanion.insert({
    this.id = const Value.absent(),
    required int levelId,
    required int number,
    required String nameFr,
    required String nameEn,
  }) : levelId = Value(levelId),
       number = Value(number),
       nameFr = Value(nameFr),
       nameEn = Value(nameEn);
  static Insertable<Unit> custom({
    Expression<int>? id,
    Expression<int>? levelId,
    Expression<int>? number,
    Expression<String>? nameFr,
    Expression<String>? nameEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (levelId != null) 'level_id': levelId,
      if (number != null) 'number': number,
      if (nameFr != null) 'name_fr': nameFr,
      if (nameEn != null) 'name_en': nameEn,
    });
  }

  UnitsCompanion copyWith({
    Value<int>? id,
    Value<int>? levelId,
    Value<int>? number,
    Value<String>? nameFr,
    Value<String>? nameEn,
  }) {
    return UnitsCompanion(
      id: id ?? this.id,
      levelId: levelId ?? this.levelId,
      number: number ?? this.number,
      nameFr: nameFr ?? this.nameFr,
      nameEn: nameEn ?? this.nameEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (levelId.present) {
      map['level_id'] = Variable<int>(levelId.value);
    }
    if (number.present) {
      map['number'] = Variable<int>(number.value);
    }
    if (nameFr.present) {
      map['name_fr'] = Variable<String>(nameFr.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnitsCompanion(')
          ..write('id: $id, ')
          ..write('levelId: $levelId, ')
          ..write('number: $number, ')
          ..write('nameFr: $nameFr, ')
          ..write('nameEn: $nameEn')
          ..write(')'))
        .toString();
  }
}

class $LessonsTable extends Lessons with TableInfo<$LessonsTable, Lesson> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LessonsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _unitIdMeta = const VerificationMeta('unitId');
  @override
  late final GeneratedColumn<int> unitId = GeneratedColumn<int>(
    'unit_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES units (id)',
    ),
  );
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<int> number = GeneratedColumn<int>(
    'number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameFrMeta = const VerificationMeta('nameFr');
  @override
  late final GeneratedColumn<String> nameFr = GeneratedColumn<String>(
    'name_fr',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionFrMeta = const VerificationMeta(
    'descriptionFr',
  );
  @override
  late final GeneratedColumn<String> descriptionFr = GeneratedColumn<String>(
    'description_fr',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionEnMeta = const VerificationMeta(
    'descriptionEn',
  );
  @override
  late final GeneratedColumn<String> descriptionEn = GeneratedColumn<String>(
    'description_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    unitId,
    number,
    nameFr,
    nameEn,
    descriptionFr,
    descriptionEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lessons';
  @override
  VerificationContext validateIntegrity(
    Insertable<Lesson> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('unit_id')) {
      context.handle(
        _unitIdMeta,
        unitId.isAcceptableOrUnknown(data['unit_id']!, _unitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_unitIdMeta);
    }
    if (data.containsKey('number')) {
      context.handle(
        _numberMeta,
        number.isAcceptableOrUnknown(data['number']!, _numberMeta),
      );
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('name_fr')) {
      context.handle(
        _nameFrMeta,
        nameFr.isAcceptableOrUnknown(data['name_fr']!, _nameFrMeta),
      );
    } else if (isInserting) {
      context.missing(_nameFrMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    if (data.containsKey('description_fr')) {
      context.handle(
        _descriptionFrMeta,
        descriptionFr.isAcceptableOrUnknown(
          data['description_fr']!,
          _descriptionFrMeta,
        ),
      );
    }
    if (data.containsKey('description_en')) {
      context.handle(
        _descriptionEnMeta,
        descriptionEn.isAcceptableOrUnknown(
          data['description_en']!,
          _descriptionEnMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Lesson map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Lesson(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      unitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_id'],
      )!,
      number: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}number'],
      )!,
      nameFr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_fr'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      )!,
      descriptionFr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description_fr'],
      ),
      descriptionEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description_en'],
      ),
    );
  }

  @override
  $LessonsTable createAlias(String alias) {
    return $LessonsTable(attachedDatabase, alias);
  }
}

class Lesson extends DataClass implements Insertable<Lesson> {
  final int id;
  final int unitId;
  final int number;
  final String nameFr;
  final String nameEn;
  final String? descriptionFr;
  final String? descriptionEn;
  const Lesson({
    required this.id,
    required this.unitId,
    required this.number,
    required this.nameFr,
    required this.nameEn,
    this.descriptionFr,
    this.descriptionEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['unit_id'] = Variable<int>(unitId);
    map['number'] = Variable<int>(number);
    map['name_fr'] = Variable<String>(nameFr);
    map['name_en'] = Variable<String>(nameEn);
    if (!nullToAbsent || descriptionFr != null) {
      map['description_fr'] = Variable<String>(descriptionFr);
    }
    if (!nullToAbsent || descriptionEn != null) {
      map['description_en'] = Variable<String>(descriptionEn);
    }
    return map;
  }

  LessonsCompanion toCompanion(bool nullToAbsent) {
    return LessonsCompanion(
      id: Value(id),
      unitId: Value(unitId),
      number: Value(number),
      nameFr: Value(nameFr),
      nameEn: Value(nameEn),
      descriptionFr: descriptionFr == null && nullToAbsent
          ? const Value.absent()
          : Value(descriptionFr),
      descriptionEn: descriptionEn == null && nullToAbsent
          ? const Value.absent()
          : Value(descriptionEn),
    );
  }

  factory Lesson.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Lesson(
      id: serializer.fromJson<int>(json['id']),
      unitId: serializer.fromJson<int>(json['unitId']),
      number: serializer.fromJson<int>(json['number']),
      nameFr: serializer.fromJson<String>(json['nameFr']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
      descriptionFr: serializer.fromJson<String?>(json['descriptionFr']),
      descriptionEn: serializer.fromJson<String?>(json['descriptionEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'unitId': serializer.toJson<int>(unitId),
      'number': serializer.toJson<int>(number),
      'nameFr': serializer.toJson<String>(nameFr),
      'nameEn': serializer.toJson<String>(nameEn),
      'descriptionFr': serializer.toJson<String?>(descriptionFr),
      'descriptionEn': serializer.toJson<String?>(descriptionEn),
    };
  }

  Lesson copyWith({
    int? id,
    int? unitId,
    int? number,
    String? nameFr,
    String? nameEn,
    Value<String?> descriptionFr = const Value.absent(),
    Value<String?> descriptionEn = const Value.absent(),
  }) => Lesson(
    id: id ?? this.id,
    unitId: unitId ?? this.unitId,
    number: number ?? this.number,
    nameFr: nameFr ?? this.nameFr,
    nameEn: nameEn ?? this.nameEn,
    descriptionFr: descriptionFr.present
        ? descriptionFr.value
        : this.descriptionFr,
    descriptionEn: descriptionEn.present
        ? descriptionEn.value
        : this.descriptionEn,
  );
  Lesson copyWithCompanion(LessonsCompanion data) {
    return Lesson(
      id: data.id.present ? data.id.value : this.id,
      unitId: data.unitId.present ? data.unitId.value : this.unitId,
      number: data.number.present ? data.number.value : this.number,
      nameFr: data.nameFr.present ? data.nameFr.value : this.nameFr,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      descriptionFr: data.descriptionFr.present
          ? data.descriptionFr.value
          : this.descriptionFr,
      descriptionEn: data.descriptionEn.present
          ? data.descriptionEn.value
          : this.descriptionEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Lesson(')
          ..write('id: $id, ')
          ..write('unitId: $unitId, ')
          ..write('number: $number, ')
          ..write('nameFr: $nameFr, ')
          ..write('nameEn: $nameEn, ')
          ..write('descriptionFr: $descriptionFr, ')
          ..write('descriptionEn: $descriptionEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    unitId,
    number,
    nameFr,
    nameEn,
    descriptionFr,
    descriptionEn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Lesson &&
          other.id == this.id &&
          other.unitId == this.unitId &&
          other.number == this.number &&
          other.nameFr == this.nameFr &&
          other.nameEn == this.nameEn &&
          other.descriptionFr == this.descriptionFr &&
          other.descriptionEn == this.descriptionEn);
}

class LessonsCompanion extends UpdateCompanion<Lesson> {
  final Value<int> id;
  final Value<int> unitId;
  final Value<int> number;
  final Value<String> nameFr;
  final Value<String> nameEn;
  final Value<String?> descriptionFr;
  final Value<String?> descriptionEn;
  const LessonsCompanion({
    this.id = const Value.absent(),
    this.unitId = const Value.absent(),
    this.number = const Value.absent(),
    this.nameFr = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.descriptionFr = const Value.absent(),
    this.descriptionEn = const Value.absent(),
  });
  LessonsCompanion.insert({
    this.id = const Value.absent(),
    required int unitId,
    required int number,
    required String nameFr,
    required String nameEn,
    this.descriptionFr = const Value.absent(),
    this.descriptionEn = const Value.absent(),
  }) : unitId = Value(unitId),
       number = Value(number),
       nameFr = Value(nameFr),
       nameEn = Value(nameEn);
  static Insertable<Lesson> custom({
    Expression<int>? id,
    Expression<int>? unitId,
    Expression<int>? number,
    Expression<String>? nameFr,
    Expression<String>? nameEn,
    Expression<String>? descriptionFr,
    Expression<String>? descriptionEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (unitId != null) 'unit_id': unitId,
      if (number != null) 'number': number,
      if (nameFr != null) 'name_fr': nameFr,
      if (nameEn != null) 'name_en': nameEn,
      if (descriptionFr != null) 'description_fr': descriptionFr,
      if (descriptionEn != null) 'description_en': descriptionEn,
    });
  }

  LessonsCompanion copyWith({
    Value<int>? id,
    Value<int>? unitId,
    Value<int>? number,
    Value<String>? nameFr,
    Value<String>? nameEn,
    Value<String?>? descriptionFr,
    Value<String?>? descriptionEn,
  }) {
    return LessonsCompanion(
      id: id ?? this.id,
      unitId: unitId ?? this.unitId,
      number: number ?? this.number,
      nameFr: nameFr ?? this.nameFr,
      nameEn: nameEn ?? this.nameEn,
      descriptionFr: descriptionFr ?? this.descriptionFr,
      descriptionEn: descriptionEn ?? this.descriptionEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (unitId.present) {
      map['unit_id'] = Variable<int>(unitId.value);
    }
    if (number.present) {
      map['number'] = Variable<int>(number.value);
    }
    if (nameFr.present) {
      map['name_fr'] = Variable<String>(nameFr.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (descriptionFr.present) {
      map['description_fr'] = Variable<String>(descriptionFr.value);
    }
    if (descriptionEn.present) {
      map['description_en'] = Variable<String>(descriptionEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonsCompanion(')
          ..write('id: $id, ')
          ..write('unitId: $unitId, ')
          ..write('number: $number, ')
          ..write('nameFr: $nameFr, ')
          ..write('nameEn: $nameEn, ')
          ..write('descriptionFr: $descriptionFr, ')
          ..write('descriptionEn: $descriptionEn')
          ..write(')'))
        .toString();
  }
}

class $WordsTable extends Words with TableInfo<$WordsTable, Word> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _lessonIdMeta = const VerificationMeta(
    'lessonId',
  );
  @override
  late final GeneratedColumn<int> lessonId = GeneratedColumn<int>(
    'lesson_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES lessons (id)',
    ),
  );
  static const VerificationMeta _contentTypeMeta = const VerificationMeta(
    'contentType',
  );
  @override
  late final GeneratedColumn<String> contentType = GeneratedColumn<String>(
    'content_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('vocab'),
  );
  static const VerificationMeta _arabicMeta = const VerificationMeta('arabic');
  @override
  late final GeneratedColumn<String> arabic = GeneratedColumn<String>(
    'arabic',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _translationFrMeta = const VerificationMeta(
    'translationFr',
  );
  @override
  late final GeneratedColumn<String> translationFr = GeneratedColumn<String>(
    'translation_fr',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _translationEnMeta = const VerificationMeta(
    'translationEn',
  );
  @override
  late final GeneratedColumn<String> translationEn = GeneratedColumn<String>(
    'translation_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _grammaticalCategoryMeta =
      const VerificationMeta('grammaticalCategory');
  @override
  late final GeneratedColumn<String> grammaticalCategory =
      GeneratedColumn<String>(
        'grammatical_category',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _singularMeta = const VerificationMeta(
    'singular',
  );
  @override
  late final GeneratedColumn<String> singular = GeneratedColumn<String>(
    'singular',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pluralMeta = const VerificationMeta('plural');
  @override
  late final GeneratedColumn<String> plural = GeneratedColumn<String>(
    'plural',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _synonymMeta = const VerificationMeta(
    'synonym',
  );
  @override
  late final GeneratedColumn<String> synonym = GeneratedColumn<String>(
    'synonym',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _antonymMeta = const VerificationMeta(
    'antonym',
  );
  @override
  late final GeneratedColumn<String> antonym = GeneratedColumn<String>(
    'antonym',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _exampleSentenceMeta = const VerificationMeta(
    'exampleSentence',
  );
  @override
  late final GeneratedColumn<String> exampleSentence = GeneratedColumn<String>(
    'example_sentence',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _audioPathMeta = const VerificationMeta(
    'audioPath',
  );
  @override
  late final GeneratedColumn<String> audioPath = GeneratedColumn<String>(
    'audio_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    lessonId,
    contentType,
    arabic,
    translationFr,
    translationEn,
    grammaticalCategory,
    singular,
    plural,
    synonym,
    antonym,
    exampleSentence,
    audioPath,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'words';
  @override
  VerificationContext validateIntegrity(
    Insertable<Word> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('lesson_id')) {
      context.handle(
        _lessonIdMeta,
        lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta),
      );
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('content_type')) {
      context.handle(
        _contentTypeMeta,
        contentType.isAcceptableOrUnknown(
          data['content_type']!,
          _contentTypeMeta,
        ),
      );
    }
    if (data.containsKey('arabic')) {
      context.handle(
        _arabicMeta,
        arabic.isAcceptableOrUnknown(data['arabic']!, _arabicMeta),
      );
    } else if (isInserting) {
      context.missing(_arabicMeta);
    }
    if (data.containsKey('translation_fr')) {
      context.handle(
        _translationFrMeta,
        translationFr.isAcceptableOrUnknown(
          data['translation_fr']!,
          _translationFrMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_translationFrMeta);
    }
    if (data.containsKey('translation_en')) {
      context.handle(
        _translationEnMeta,
        translationEn.isAcceptableOrUnknown(
          data['translation_en']!,
          _translationEnMeta,
        ),
      );
    }
    if (data.containsKey('grammatical_category')) {
      context.handle(
        _grammaticalCategoryMeta,
        grammaticalCategory.isAcceptableOrUnknown(
          data['grammatical_category']!,
          _grammaticalCategoryMeta,
        ),
      );
    }
    if (data.containsKey('singular')) {
      context.handle(
        _singularMeta,
        singular.isAcceptableOrUnknown(data['singular']!, _singularMeta),
      );
    }
    if (data.containsKey('plural')) {
      context.handle(
        _pluralMeta,
        plural.isAcceptableOrUnknown(data['plural']!, _pluralMeta),
      );
    }
    if (data.containsKey('synonym')) {
      context.handle(
        _synonymMeta,
        synonym.isAcceptableOrUnknown(data['synonym']!, _synonymMeta),
      );
    }
    if (data.containsKey('antonym')) {
      context.handle(
        _antonymMeta,
        antonym.isAcceptableOrUnknown(data['antonym']!, _antonymMeta),
      );
    }
    if (data.containsKey('example_sentence')) {
      context.handle(
        _exampleSentenceMeta,
        exampleSentence.isAcceptableOrUnknown(
          data['example_sentence']!,
          _exampleSentenceMeta,
        ),
      );
    }
    if (data.containsKey('audio_path')) {
      context.handle(
        _audioPathMeta,
        audioPath.isAcceptableOrUnknown(data['audio_path']!, _audioPathMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Word map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Word(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      lessonId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lesson_id'],
      )!,
      contentType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_type'],
      )!,
      arabic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}arabic'],
      )!,
      translationFr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translation_fr'],
      )!,
      translationEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translation_en'],
      ),
      grammaticalCategory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}grammatical_category'],
      ),
      singular: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}singular'],
      ),
      plural: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plural'],
      ),
      synonym: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}synonym'],
      ),
      antonym: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}antonym'],
      ),
      exampleSentence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}example_sentence'],
      ),
      audioPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_path'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $WordsTable createAlias(String alias) {
    return $WordsTable(attachedDatabase, alias);
  }
}

class Word extends DataClass implements Insertable<Word> {
  final int id;
  final int lessonId;
  final String contentType;
  final String arabic;
  final String translationFr;
  final String? translationEn;
  final String? grammaticalCategory;
  final String? singular;
  final String? plural;
  final String? synonym;
  final String? antonym;
  final String? exampleSentence;
  final String? audioPath;
  final int sortOrder;
  const Word({
    required this.id,
    required this.lessonId,
    required this.contentType,
    required this.arabic,
    required this.translationFr,
    this.translationEn,
    this.grammaticalCategory,
    this.singular,
    this.plural,
    this.synonym,
    this.antonym,
    this.exampleSentence,
    this.audioPath,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['lesson_id'] = Variable<int>(lessonId);
    map['content_type'] = Variable<String>(contentType);
    map['arabic'] = Variable<String>(arabic);
    map['translation_fr'] = Variable<String>(translationFr);
    if (!nullToAbsent || translationEn != null) {
      map['translation_en'] = Variable<String>(translationEn);
    }
    if (!nullToAbsent || grammaticalCategory != null) {
      map['grammatical_category'] = Variable<String>(grammaticalCategory);
    }
    if (!nullToAbsent || singular != null) {
      map['singular'] = Variable<String>(singular);
    }
    if (!nullToAbsent || plural != null) {
      map['plural'] = Variable<String>(plural);
    }
    if (!nullToAbsent || synonym != null) {
      map['synonym'] = Variable<String>(synonym);
    }
    if (!nullToAbsent || antonym != null) {
      map['antonym'] = Variable<String>(antonym);
    }
    if (!nullToAbsent || exampleSentence != null) {
      map['example_sentence'] = Variable<String>(exampleSentence);
    }
    if (!nullToAbsent || audioPath != null) {
      map['audio_path'] = Variable<String>(audioPath);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  WordsCompanion toCompanion(bool nullToAbsent) {
    return WordsCompanion(
      id: Value(id),
      lessonId: Value(lessonId),
      contentType: Value(contentType),
      arabic: Value(arabic),
      translationFr: Value(translationFr),
      translationEn: translationEn == null && nullToAbsent
          ? const Value.absent()
          : Value(translationEn),
      grammaticalCategory: grammaticalCategory == null && nullToAbsent
          ? const Value.absent()
          : Value(grammaticalCategory),
      singular: singular == null && nullToAbsent
          ? const Value.absent()
          : Value(singular),
      plural: plural == null && nullToAbsent
          ? const Value.absent()
          : Value(plural),
      synonym: synonym == null && nullToAbsent
          ? const Value.absent()
          : Value(synonym),
      antonym: antonym == null && nullToAbsent
          ? const Value.absent()
          : Value(antonym),
      exampleSentence: exampleSentence == null && nullToAbsent
          ? const Value.absent()
          : Value(exampleSentence),
      audioPath: audioPath == null && nullToAbsent
          ? const Value.absent()
          : Value(audioPath),
      sortOrder: Value(sortOrder),
    );
  }

  factory Word.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Word(
      id: serializer.fromJson<int>(json['id']),
      lessonId: serializer.fromJson<int>(json['lessonId']),
      contentType: serializer.fromJson<String>(json['contentType']),
      arabic: serializer.fromJson<String>(json['arabic']),
      translationFr: serializer.fromJson<String>(json['translationFr']),
      translationEn: serializer.fromJson<String?>(json['translationEn']),
      grammaticalCategory: serializer.fromJson<String?>(
        json['grammaticalCategory'],
      ),
      singular: serializer.fromJson<String?>(json['singular']),
      plural: serializer.fromJson<String?>(json['plural']),
      synonym: serializer.fromJson<String?>(json['synonym']),
      antonym: serializer.fromJson<String?>(json['antonym']),
      exampleSentence: serializer.fromJson<String?>(json['exampleSentence']),
      audioPath: serializer.fromJson<String?>(json['audioPath']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'lessonId': serializer.toJson<int>(lessonId),
      'contentType': serializer.toJson<String>(contentType),
      'arabic': serializer.toJson<String>(arabic),
      'translationFr': serializer.toJson<String>(translationFr),
      'translationEn': serializer.toJson<String?>(translationEn),
      'grammaticalCategory': serializer.toJson<String?>(grammaticalCategory),
      'singular': serializer.toJson<String?>(singular),
      'plural': serializer.toJson<String?>(plural),
      'synonym': serializer.toJson<String?>(synonym),
      'antonym': serializer.toJson<String?>(antonym),
      'exampleSentence': serializer.toJson<String?>(exampleSentence),
      'audioPath': serializer.toJson<String?>(audioPath),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  Word copyWith({
    int? id,
    int? lessonId,
    String? contentType,
    String? arabic,
    String? translationFr,
    Value<String?> translationEn = const Value.absent(),
    Value<String?> grammaticalCategory = const Value.absent(),
    Value<String?> singular = const Value.absent(),
    Value<String?> plural = const Value.absent(),
    Value<String?> synonym = const Value.absent(),
    Value<String?> antonym = const Value.absent(),
    Value<String?> exampleSentence = const Value.absent(),
    Value<String?> audioPath = const Value.absent(),
    int? sortOrder,
  }) => Word(
    id: id ?? this.id,
    lessonId: lessonId ?? this.lessonId,
    contentType: contentType ?? this.contentType,
    arabic: arabic ?? this.arabic,
    translationFr: translationFr ?? this.translationFr,
    translationEn: translationEn.present
        ? translationEn.value
        : this.translationEn,
    grammaticalCategory: grammaticalCategory.present
        ? grammaticalCategory.value
        : this.grammaticalCategory,
    singular: singular.present ? singular.value : this.singular,
    plural: plural.present ? plural.value : this.plural,
    synonym: synonym.present ? synonym.value : this.synonym,
    antonym: antonym.present ? antonym.value : this.antonym,
    exampleSentence: exampleSentence.present
        ? exampleSentence.value
        : this.exampleSentence,
    audioPath: audioPath.present ? audioPath.value : this.audioPath,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  Word copyWithCompanion(WordsCompanion data) {
    return Word(
      id: data.id.present ? data.id.value : this.id,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      contentType: data.contentType.present
          ? data.contentType.value
          : this.contentType,
      arabic: data.arabic.present ? data.arabic.value : this.arabic,
      translationFr: data.translationFr.present
          ? data.translationFr.value
          : this.translationFr,
      translationEn: data.translationEn.present
          ? data.translationEn.value
          : this.translationEn,
      grammaticalCategory: data.grammaticalCategory.present
          ? data.grammaticalCategory.value
          : this.grammaticalCategory,
      singular: data.singular.present ? data.singular.value : this.singular,
      plural: data.plural.present ? data.plural.value : this.plural,
      synonym: data.synonym.present ? data.synonym.value : this.synonym,
      antonym: data.antonym.present ? data.antonym.value : this.antonym,
      exampleSentence: data.exampleSentence.present
          ? data.exampleSentence.value
          : this.exampleSentence,
      audioPath: data.audioPath.present ? data.audioPath.value : this.audioPath,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Word(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('contentType: $contentType, ')
          ..write('arabic: $arabic, ')
          ..write('translationFr: $translationFr, ')
          ..write('translationEn: $translationEn, ')
          ..write('grammaticalCategory: $grammaticalCategory, ')
          ..write('singular: $singular, ')
          ..write('plural: $plural, ')
          ..write('synonym: $synonym, ')
          ..write('antonym: $antonym, ')
          ..write('exampleSentence: $exampleSentence, ')
          ..write('audioPath: $audioPath, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    lessonId,
    contentType,
    arabic,
    translationFr,
    translationEn,
    grammaticalCategory,
    singular,
    plural,
    synonym,
    antonym,
    exampleSentence,
    audioPath,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Word &&
          other.id == this.id &&
          other.lessonId == this.lessonId &&
          other.contentType == this.contentType &&
          other.arabic == this.arabic &&
          other.translationFr == this.translationFr &&
          other.translationEn == this.translationEn &&
          other.grammaticalCategory == this.grammaticalCategory &&
          other.singular == this.singular &&
          other.plural == this.plural &&
          other.synonym == this.synonym &&
          other.antonym == this.antonym &&
          other.exampleSentence == this.exampleSentence &&
          other.audioPath == this.audioPath &&
          other.sortOrder == this.sortOrder);
}

class WordsCompanion extends UpdateCompanion<Word> {
  final Value<int> id;
  final Value<int> lessonId;
  final Value<String> contentType;
  final Value<String> arabic;
  final Value<String> translationFr;
  final Value<String?> translationEn;
  final Value<String?> grammaticalCategory;
  final Value<String?> singular;
  final Value<String?> plural;
  final Value<String?> synonym;
  final Value<String?> antonym;
  final Value<String?> exampleSentence;
  final Value<String?> audioPath;
  final Value<int> sortOrder;
  const WordsCompanion({
    this.id = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.contentType = const Value.absent(),
    this.arabic = const Value.absent(),
    this.translationFr = const Value.absent(),
    this.translationEn = const Value.absent(),
    this.grammaticalCategory = const Value.absent(),
    this.singular = const Value.absent(),
    this.plural = const Value.absent(),
    this.synonym = const Value.absent(),
    this.antonym = const Value.absent(),
    this.exampleSentence = const Value.absent(),
    this.audioPath = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  WordsCompanion.insert({
    this.id = const Value.absent(),
    required int lessonId,
    this.contentType = const Value.absent(),
    required String arabic,
    required String translationFr,
    this.translationEn = const Value.absent(),
    this.grammaticalCategory = const Value.absent(),
    this.singular = const Value.absent(),
    this.plural = const Value.absent(),
    this.synonym = const Value.absent(),
    this.antonym = const Value.absent(),
    this.exampleSentence = const Value.absent(),
    this.audioPath = const Value.absent(),
    required int sortOrder,
  }) : lessonId = Value(lessonId),
       arabic = Value(arabic),
       translationFr = Value(translationFr),
       sortOrder = Value(sortOrder);
  static Insertable<Word> custom({
    Expression<int>? id,
    Expression<int>? lessonId,
    Expression<String>? contentType,
    Expression<String>? arabic,
    Expression<String>? translationFr,
    Expression<String>? translationEn,
    Expression<String>? grammaticalCategory,
    Expression<String>? singular,
    Expression<String>? plural,
    Expression<String>? synonym,
    Expression<String>? antonym,
    Expression<String>? exampleSentence,
    Expression<String>? audioPath,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lessonId != null) 'lesson_id': lessonId,
      if (contentType != null) 'content_type': contentType,
      if (arabic != null) 'arabic': arabic,
      if (translationFr != null) 'translation_fr': translationFr,
      if (translationEn != null) 'translation_en': translationEn,
      if (grammaticalCategory != null)
        'grammatical_category': grammaticalCategory,
      if (singular != null) 'singular': singular,
      if (plural != null) 'plural': plural,
      if (synonym != null) 'synonym': synonym,
      if (antonym != null) 'antonym': antonym,
      if (exampleSentence != null) 'example_sentence': exampleSentence,
      if (audioPath != null) 'audio_path': audioPath,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  WordsCompanion copyWith({
    Value<int>? id,
    Value<int>? lessonId,
    Value<String>? contentType,
    Value<String>? arabic,
    Value<String>? translationFr,
    Value<String?>? translationEn,
    Value<String?>? grammaticalCategory,
    Value<String?>? singular,
    Value<String?>? plural,
    Value<String?>? synonym,
    Value<String?>? antonym,
    Value<String?>? exampleSentence,
    Value<String?>? audioPath,
    Value<int>? sortOrder,
  }) {
    return WordsCompanion(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      contentType: contentType ?? this.contentType,
      arabic: arabic ?? this.arabic,
      translationFr: translationFr ?? this.translationFr,
      translationEn: translationEn ?? this.translationEn,
      grammaticalCategory: grammaticalCategory ?? this.grammaticalCategory,
      singular: singular ?? this.singular,
      plural: plural ?? this.plural,
      synonym: synonym ?? this.synonym,
      antonym: antonym ?? this.antonym,
      exampleSentence: exampleSentence ?? this.exampleSentence,
      audioPath: audioPath ?? this.audioPath,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<int>(lessonId.value);
    }
    if (contentType.present) {
      map['content_type'] = Variable<String>(contentType.value);
    }
    if (arabic.present) {
      map['arabic'] = Variable<String>(arabic.value);
    }
    if (translationFr.present) {
      map['translation_fr'] = Variable<String>(translationFr.value);
    }
    if (translationEn.present) {
      map['translation_en'] = Variable<String>(translationEn.value);
    }
    if (grammaticalCategory.present) {
      map['grammatical_category'] = Variable<String>(grammaticalCategory.value);
    }
    if (singular.present) {
      map['singular'] = Variable<String>(singular.value);
    }
    if (plural.present) {
      map['plural'] = Variable<String>(plural.value);
    }
    if (synonym.present) {
      map['synonym'] = Variable<String>(synonym.value);
    }
    if (antonym.present) {
      map['antonym'] = Variable<String>(antonym.value);
    }
    if (exampleSentence.present) {
      map['example_sentence'] = Variable<String>(exampleSentence.value);
    }
    if (audioPath.present) {
      map['audio_path'] = Variable<String>(audioPath.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WordsCompanion(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('contentType: $contentType, ')
          ..write('arabic: $arabic, ')
          ..write('translationFr: $translationFr, ')
          ..write('translationEn: $translationEn, ')
          ..write('grammaticalCategory: $grammaticalCategory, ')
          ..write('singular: $singular, ')
          ..write('plural: $plural, ')
          ..write('synonym: $synonym, ')
          ..write('antonym: $antonym, ')
          ..write('exampleSentence: $exampleSentence, ')
          ..write('audioPath: $audioPath, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $VerbsTable extends Verbs with TableInfo<$VerbsTable, Verb> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VerbsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _lessonIdMeta = const VerificationMeta(
    'lessonId',
  );
  @override
  late final GeneratedColumn<int> lessonId = GeneratedColumn<int>(
    'lesson_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES lessons (id)',
    ),
  );
  static const VerificationMeta _contentTypeMeta = const VerificationMeta(
    'contentType',
  );
  @override
  late final GeneratedColumn<String> contentType = GeneratedColumn<String>(
    'content_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('verb'),
  );
  static const VerificationMeta _masdarMeta = const VerificationMeta('masdar');
  @override
  late final GeneratedColumn<String> masdar = GeneratedColumn<String>(
    'masdar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pastMeta = const VerificationMeta('past');
  @override
  late final GeneratedColumn<String> past = GeneratedColumn<String>(
    'past',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _presentMeta = const VerificationMeta(
    'present',
  );
  @override
  late final GeneratedColumn<String> present = GeneratedColumn<String>(
    'present',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imperativeMeta = const VerificationMeta(
    'imperative',
  );
  @override
  late final GeneratedColumn<String> imperative = GeneratedColumn<String>(
    'imperative',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _translationFrMeta = const VerificationMeta(
    'translationFr',
  );
  @override
  late final GeneratedColumn<String> translationFr = GeneratedColumn<String>(
    'translation_fr',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _translationEnMeta = const VerificationMeta(
    'translationEn',
  );
  @override
  late final GeneratedColumn<String> translationEn = GeneratedColumn<String>(
    'translation_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _exampleSentenceMeta = const VerificationMeta(
    'exampleSentence',
  );
  @override
  late final GeneratedColumn<String> exampleSentence = GeneratedColumn<String>(
    'example_sentence',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _audioPathMasdarMeta = const VerificationMeta(
    'audioPathMasdar',
  );
  @override
  late final GeneratedColumn<String> audioPathMasdar = GeneratedColumn<String>(
    'audio_path_masdar',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _audioPathPastMeta = const VerificationMeta(
    'audioPathPast',
  );
  @override
  late final GeneratedColumn<String> audioPathPast = GeneratedColumn<String>(
    'audio_path_past',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _audioPathPresentMeta = const VerificationMeta(
    'audioPathPresent',
  );
  @override
  late final GeneratedColumn<String> audioPathPresent = GeneratedColumn<String>(
    'audio_path_present',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _audioPathImperativeMeta =
      const VerificationMeta('audioPathImperative');
  @override
  late final GeneratedColumn<String> audioPathImperative =
      GeneratedColumn<String>(
        'audio_path_imperative',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    lessonId,
    contentType,
    masdar,
    past,
    present,
    imperative,
    translationFr,
    translationEn,
    exampleSentence,
    audioPathMasdar,
    audioPathPast,
    audioPathPresent,
    audioPathImperative,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'verbs';
  @override
  VerificationContext validateIntegrity(
    Insertable<Verb> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('lesson_id')) {
      context.handle(
        _lessonIdMeta,
        lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta),
      );
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('content_type')) {
      context.handle(
        _contentTypeMeta,
        contentType.isAcceptableOrUnknown(
          data['content_type']!,
          _contentTypeMeta,
        ),
      );
    }
    if (data.containsKey('masdar')) {
      context.handle(
        _masdarMeta,
        masdar.isAcceptableOrUnknown(data['masdar']!, _masdarMeta),
      );
    } else if (isInserting) {
      context.missing(_masdarMeta);
    }
    if (data.containsKey('past')) {
      context.handle(
        _pastMeta,
        past.isAcceptableOrUnknown(data['past']!, _pastMeta),
      );
    } else if (isInserting) {
      context.missing(_pastMeta);
    }
    if (data.containsKey('present')) {
      context.handle(
        _presentMeta,
        present.isAcceptableOrUnknown(data['present']!, _presentMeta),
      );
    } else if (isInserting) {
      context.missing(_presentMeta);
    }
    if (data.containsKey('imperative')) {
      context.handle(
        _imperativeMeta,
        imperative.isAcceptableOrUnknown(data['imperative']!, _imperativeMeta),
      );
    } else if (isInserting) {
      context.missing(_imperativeMeta);
    }
    if (data.containsKey('translation_fr')) {
      context.handle(
        _translationFrMeta,
        translationFr.isAcceptableOrUnknown(
          data['translation_fr']!,
          _translationFrMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_translationFrMeta);
    }
    if (data.containsKey('translation_en')) {
      context.handle(
        _translationEnMeta,
        translationEn.isAcceptableOrUnknown(
          data['translation_en']!,
          _translationEnMeta,
        ),
      );
    }
    if (data.containsKey('example_sentence')) {
      context.handle(
        _exampleSentenceMeta,
        exampleSentence.isAcceptableOrUnknown(
          data['example_sentence']!,
          _exampleSentenceMeta,
        ),
      );
    }
    if (data.containsKey('audio_path_masdar')) {
      context.handle(
        _audioPathMasdarMeta,
        audioPathMasdar.isAcceptableOrUnknown(
          data['audio_path_masdar']!,
          _audioPathMasdarMeta,
        ),
      );
    }
    if (data.containsKey('audio_path_past')) {
      context.handle(
        _audioPathPastMeta,
        audioPathPast.isAcceptableOrUnknown(
          data['audio_path_past']!,
          _audioPathPastMeta,
        ),
      );
    }
    if (data.containsKey('audio_path_present')) {
      context.handle(
        _audioPathPresentMeta,
        audioPathPresent.isAcceptableOrUnknown(
          data['audio_path_present']!,
          _audioPathPresentMeta,
        ),
      );
    }
    if (data.containsKey('audio_path_imperative')) {
      context.handle(
        _audioPathImperativeMeta,
        audioPathImperative.isAcceptableOrUnknown(
          data['audio_path_imperative']!,
          _audioPathImperativeMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Verb map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Verb(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      lessonId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lesson_id'],
      )!,
      contentType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_type'],
      )!,
      masdar: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}masdar'],
      )!,
      past: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}past'],
      )!,
      present: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}present'],
      )!,
      imperative: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}imperative'],
      )!,
      translationFr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translation_fr'],
      )!,
      translationEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translation_en'],
      ),
      exampleSentence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}example_sentence'],
      ),
      audioPathMasdar: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_path_masdar'],
      ),
      audioPathPast: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_path_past'],
      ),
      audioPathPresent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_path_present'],
      ),
      audioPathImperative: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_path_imperative'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $VerbsTable createAlias(String alias) {
    return $VerbsTable(attachedDatabase, alias);
  }
}

class Verb extends DataClass implements Insertable<Verb> {
  final int id;
  final int lessonId;
  final String contentType;
  final String masdar;
  final String past;
  final String present;
  final String imperative;
  final String translationFr;
  final String? translationEn;
  final String? exampleSentence;
  final String? audioPathMasdar;
  final String? audioPathPast;
  final String? audioPathPresent;
  final String? audioPathImperative;
  final int sortOrder;
  const Verb({
    required this.id,
    required this.lessonId,
    required this.contentType,
    required this.masdar,
    required this.past,
    required this.present,
    required this.imperative,
    required this.translationFr,
    this.translationEn,
    this.exampleSentence,
    this.audioPathMasdar,
    this.audioPathPast,
    this.audioPathPresent,
    this.audioPathImperative,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['lesson_id'] = Variable<int>(lessonId);
    map['content_type'] = Variable<String>(contentType);
    map['masdar'] = Variable<String>(masdar);
    map['past'] = Variable<String>(past);
    map['present'] = Variable<String>(present);
    map['imperative'] = Variable<String>(imperative);
    map['translation_fr'] = Variable<String>(translationFr);
    if (!nullToAbsent || translationEn != null) {
      map['translation_en'] = Variable<String>(translationEn);
    }
    if (!nullToAbsent || exampleSentence != null) {
      map['example_sentence'] = Variable<String>(exampleSentence);
    }
    if (!nullToAbsent || audioPathMasdar != null) {
      map['audio_path_masdar'] = Variable<String>(audioPathMasdar);
    }
    if (!nullToAbsent || audioPathPast != null) {
      map['audio_path_past'] = Variable<String>(audioPathPast);
    }
    if (!nullToAbsent || audioPathPresent != null) {
      map['audio_path_present'] = Variable<String>(audioPathPresent);
    }
    if (!nullToAbsent || audioPathImperative != null) {
      map['audio_path_imperative'] = Variable<String>(audioPathImperative);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  VerbsCompanion toCompanion(bool nullToAbsent) {
    return VerbsCompanion(
      id: Value(id),
      lessonId: Value(lessonId),
      contentType: Value(contentType),
      masdar: Value(masdar),
      past: Value(past),
      present: Value(present),
      imperative: Value(imperative),
      translationFr: Value(translationFr),
      translationEn: translationEn == null && nullToAbsent
          ? const Value.absent()
          : Value(translationEn),
      exampleSentence: exampleSentence == null && nullToAbsent
          ? const Value.absent()
          : Value(exampleSentence),
      audioPathMasdar: audioPathMasdar == null && nullToAbsent
          ? const Value.absent()
          : Value(audioPathMasdar),
      audioPathPast: audioPathPast == null && nullToAbsent
          ? const Value.absent()
          : Value(audioPathPast),
      audioPathPresent: audioPathPresent == null && nullToAbsent
          ? const Value.absent()
          : Value(audioPathPresent),
      audioPathImperative: audioPathImperative == null && nullToAbsent
          ? const Value.absent()
          : Value(audioPathImperative),
      sortOrder: Value(sortOrder),
    );
  }

  factory Verb.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Verb(
      id: serializer.fromJson<int>(json['id']),
      lessonId: serializer.fromJson<int>(json['lessonId']),
      contentType: serializer.fromJson<String>(json['contentType']),
      masdar: serializer.fromJson<String>(json['masdar']),
      past: serializer.fromJson<String>(json['past']),
      present: serializer.fromJson<String>(json['present']),
      imperative: serializer.fromJson<String>(json['imperative']),
      translationFr: serializer.fromJson<String>(json['translationFr']),
      translationEn: serializer.fromJson<String?>(json['translationEn']),
      exampleSentence: serializer.fromJson<String?>(json['exampleSentence']),
      audioPathMasdar: serializer.fromJson<String?>(json['audioPathMasdar']),
      audioPathPast: serializer.fromJson<String?>(json['audioPathPast']),
      audioPathPresent: serializer.fromJson<String?>(json['audioPathPresent']),
      audioPathImperative: serializer.fromJson<String?>(
        json['audioPathImperative'],
      ),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'lessonId': serializer.toJson<int>(lessonId),
      'contentType': serializer.toJson<String>(contentType),
      'masdar': serializer.toJson<String>(masdar),
      'past': serializer.toJson<String>(past),
      'present': serializer.toJson<String>(present),
      'imperative': serializer.toJson<String>(imperative),
      'translationFr': serializer.toJson<String>(translationFr),
      'translationEn': serializer.toJson<String?>(translationEn),
      'exampleSentence': serializer.toJson<String?>(exampleSentence),
      'audioPathMasdar': serializer.toJson<String?>(audioPathMasdar),
      'audioPathPast': serializer.toJson<String?>(audioPathPast),
      'audioPathPresent': serializer.toJson<String?>(audioPathPresent),
      'audioPathImperative': serializer.toJson<String?>(audioPathImperative),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  Verb copyWith({
    int? id,
    int? lessonId,
    String? contentType,
    String? masdar,
    String? past,
    String? present,
    String? imperative,
    String? translationFr,
    Value<String?> translationEn = const Value.absent(),
    Value<String?> exampleSentence = const Value.absent(),
    Value<String?> audioPathMasdar = const Value.absent(),
    Value<String?> audioPathPast = const Value.absent(),
    Value<String?> audioPathPresent = const Value.absent(),
    Value<String?> audioPathImperative = const Value.absent(),
    int? sortOrder,
  }) => Verb(
    id: id ?? this.id,
    lessonId: lessonId ?? this.lessonId,
    contentType: contentType ?? this.contentType,
    masdar: masdar ?? this.masdar,
    past: past ?? this.past,
    present: present ?? this.present,
    imperative: imperative ?? this.imperative,
    translationFr: translationFr ?? this.translationFr,
    translationEn: translationEn.present
        ? translationEn.value
        : this.translationEn,
    exampleSentence: exampleSentence.present
        ? exampleSentence.value
        : this.exampleSentence,
    audioPathMasdar: audioPathMasdar.present
        ? audioPathMasdar.value
        : this.audioPathMasdar,
    audioPathPast: audioPathPast.present
        ? audioPathPast.value
        : this.audioPathPast,
    audioPathPresent: audioPathPresent.present
        ? audioPathPresent.value
        : this.audioPathPresent,
    audioPathImperative: audioPathImperative.present
        ? audioPathImperative.value
        : this.audioPathImperative,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  Verb copyWithCompanion(VerbsCompanion data) {
    return Verb(
      id: data.id.present ? data.id.value : this.id,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      contentType: data.contentType.present
          ? data.contentType.value
          : this.contentType,
      masdar: data.masdar.present ? data.masdar.value : this.masdar,
      past: data.past.present ? data.past.value : this.past,
      present: data.present.present ? data.present.value : this.present,
      imperative: data.imperative.present
          ? data.imperative.value
          : this.imperative,
      translationFr: data.translationFr.present
          ? data.translationFr.value
          : this.translationFr,
      translationEn: data.translationEn.present
          ? data.translationEn.value
          : this.translationEn,
      exampleSentence: data.exampleSentence.present
          ? data.exampleSentence.value
          : this.exampleSentence,
      audioPathMasdar: data.audioPathMasdar.present
          ? data.audioPathMasdar.value
          : this.audioPathMasdar,
      audioPathPast: data.audioPathPast.present
          ? data.audioPathPast.value
          : this.audioPathPast,
      audioPathPresent: data.audioPathPresent.present
          ? data.audioPathPresent.value
          : this.audioPathPresent,
      audioPathImperative: data.audioPathImperative.present
          ? data.audioPathImperative.value
          : this.audioPathImperative,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Verb(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('contentType: $contentType, ')
          ..write('masdar: $masdar, ')
          ..write('past: $past, ')
          ..write('present: $present, ')
          ..write('imperative: $imperative, ')
          ..write('translationFr: $translationFr, ')
          ..write('translationEn: $translationEn, ')
          ..write('exampleSentence: $exampleSentence, ')
          ..write('audioPathMasdar: $audioPathMasdar, ')
          ..write('audioPathPast: $audioPathPast, ')
          ..write('audioPathPresent: $audioPathPresent, ')
          ..write('audioPathImperative: $audioPathImperative, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    lessonId,
    contentType,
    masdar,
    past,
    present,
    imperative,
    translationFr,
    translationEn,
    exampleSentence,
    audioPathMasdar,
    audioPathPast,
    audioPathPresent,
    audioPathImperative,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Verb &&
          other.id == this.id &&
          other.lessonId == this.lessonId &&
          other.contentType == this.contentType &&
          other.masdar == this.masdar &&
          other.past == this.past &&
          other.present == this.present &&
          other.imperative == this.imperative &&
          other.translationFr == this.translationFr &&
          other.translationEn == this.translationEn &&
          other.exampleSentence == this.exampleSentence &&
          other.audioPathMasdar == this.audioPathMasdar &&
          other.audioPathPast == this.audioPathPast &&
          other.audioPathPresent == this.audioPathPresent &&
          other.audioPathImperative == this.audioPathImperative &&
          other.sortOrder == this.sortOrder);
}

class VerbsCompanion extends UpdateCompanion<Verb> {
  final Value<int> id;
  final Value<int> lessonId;
  final Value<String> contentType;
  final Value<String> masdar;
  final Value<String> past;
  final Value<String> present;
  final Value<String> imperative;
  final Value<String> translationFr;
  final Value<String?> translationEn;
  final Value<String?> exampleSentence;
  final Value<String?> audioPathMasdar;
  final Value<String?> audioPathPast;
  final Value<String?> audioPathPresent;
  final Value<String?> audioPathImperative;
  final Value<int> sortOrder;
  const VerbsCompanion({
    this.id = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.contentType = const Value.absent(),
    this.masdar = const Value.absent(),
    this.past = const Value.absent(),
    this.present = const Value.absent(),
    this.imperative = const Value.absent(),
    this.translationFr = const Value.absent(),
    this.translationEn = const Value.absent(),
    this.exampleSentence = const Value.absent(),
    this.audioPathMasdar = const Value.absent(),
    this.audioPathPast = const Value.absent(),
    this.audioPathPresent = const Value.absent(),
    this.audioPathImperative = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  VerbsCompanion.insert({
    this.id = const Value.absent(),
    required int lessonId,
    this.contentType = const Value.absent(),
    required String masdar,
    required String past,
    required String present,
    required String imperative,
    required String translationFr,
    this.translationEn = const Value.absent(),
    this.exampleSentence = const Value.absent(),
    this.audioPathMasdar = const Value.absent(),
    this.audioPathPast = const Value.absent(),
    this.audioPathPresent = const Value.absent(),
    this.audioPathImperative = const Value.absent(),
    required int sortOrder,
  }) : lessonId = Value(lessonId),
       masdar = Value(masdar),
       past = Value(past),
       present = Value(present),
       imperative = Value(imperative),
       translationFr = Value(translationFr),
       sortOrder = Value(sortOrder);
  static Insertable<Verb> custom({
    Expression<int>? id,
    Expression<int>? lessonId,
    Expression<String>? contentType,
    Expression<String>? masdar,
    Expression<String>? past,
    Expression<String>? present,
    Expression<String>? imperative,
    Expression<String>? translationFr,
    Expression<String>? translationEn,
    Expression<String>? exampleSentence,
    Expression<String>? audioPathMasdar,
    Expression<String>? audioPathPast,
    Expression<String>? audioPathPresent,
    Expression<String>? audioPathImperative,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lessonId != null) 'lesson_id': lessonId,
      if (contentType != null) 'content_type': contentType,
      if (masdar != null) 'masdar': masdar,
      if (past != null) 'past': past,
      if (present != null) 'present': present,
      if (imperative != null) 'imperative': imperative,
      if (translationFr != null) 'translation_fr': translationFr,
      if (translationEn != null) 'translation_en': translationEn,
      if (exampleSentence != null) 'example_sentence': exampleSentence,
      if (audioPathMasdar != null) 'audio_path_masdar': audioPathMasdar,
      if (audioPathPast != null) 'audio_path_past': audioPathPast,
      if (audioPathPresent != null) 'audio_path_present': audioPathPresent,
      if (audioPathImperative != null)
        'audio_path_imperative': audioPathImperative,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  VerbsCompanion copyWith({
    Value<int>? id,
    Value<int>? lessonId,
    Value<String>? contentType,
    Value<String>? masdar,
    Value<String>? past,
    Value<String>? present,
    Value<String>? imperative,
    Value<String>? translationFr,
    Value<String?>? translationEn,
    Value<String?>? exampleSentence,
    Value<String?>? audioPathMasdar,
    Value<String?>? audioPathPast,
    Value<String?>? audioPathPresent,
    Value<String?>? audioPathImperative,
    Value<int>? sortOrder,
  }) {
    return VerbsCompanion(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      contentType: contentType ?? this.contentType,
      masdar: masdar ?? this.masdar,
      past: past ?? this.past,
      present: present ?? this.present,
      imperative: imperative ?? this.imperative,
      translationFr: translationFr ?? this.translationFr,
      translationEn: translationEn ?? this.translationEn,
      exampleSentence: exampleSentence ?? this.exampleSentence,
      audioPathMasdar: audioPathMasdar ?? this.audioPathMasdar,
      audioPathPast: audioPathPast ?? this.audioPathPast,
      audioPathPresent: audioPathPresent ?? this.audioPathPresent,
      audioPathImperative: audioPathImperative ?? this.audioPathImperative,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<int>(lessonId.value);
    }
    if (contentType.present) {
      map['content_type'] = Variable<String>(contentType.value);
    }
    if (masdar.present) {
      map['masdar'] = Variable<String>(masdar.value);
    }
    if (past.present) {
      map['past'] = Variable<String>(past.value);
    }
    if (present.present) {
      map['present'] = Variable<String>(present.value);
    }
    if (imperative.present) {
      map['imperative'] = Variable<String>(imperative.value);
    }
    if (translationFr.present) {
      map['translation_fr'] = Variable<String>(translationFr.value);
    }
    if (translationEn.present) {
      map['translation_en'] = Variable<String>(translationEn.value);
    }
    if (exampleSentence.present) {
      map['example_sentence'] = Variable<String>(exampleSentence.value);
    }
    if (audioPathMasdar.present) {
      map['audio_path_masdar'] = Variable<String>(audioPathMasdar.value);
    }
    if (audioPathPast.present) {
      map['audio_path_past'] = Variable<String>(audioPathPast.value);
    }
    if (audioPathPresent.present) {
      map['audio_path_present'] = Variable<String>(audioPathPresent.value);
    }
    if (audioPathImperative.present) {
      map['audio_path_imperative'] = Variable<String>(
        audioPathImperative.value,
      );
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VerbsCompanion(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('contentType: $contentType, ')
          ..write('masdar: $masdar, ')
          ..write('past: $past, ')
          ..write('present: $present, ')
          ..write('imperative: $imperative, ')
          ..write('translationFr: $translationFr, ')
          ..write('translationEn: $translationEn, ')
          ..write('exampleSentence: $exampleSentence, ')
          ..write('audioPathMasdar: $audioPathMasdar, ')
          ..write('audioPathPast: $audioPathPast, ')
          ..write('audioPathPresent: $audioPathPresent, ')
          ..write('audioPathImperative: $audioPathImperative, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $ErrorReportsTable extends ErrorReports
    with TableInfo<$ErrorReportsTable, ErrorReport> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ErrorReportsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentTypeMeta = const VerificationMeta(
    'contentType',
  );
  @override
  late final GeneratedColumn<String> contentType = GeneratedColumn<String>(
    'content_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _commentMeta = const VerificationMeta(
    'comment',
  );
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
    'comment',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    itemId,
    contentType,
    category,
    comment,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'error_reports';
  @override
  VerificationContext validateIntegrity(
    Insertable<ErrorReport> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('content_type')) {
      context.handle(
        _contentTypeMeta,
        contentType.isAcceptableOrUnknown(
          data['content_type']!,
          _contentTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentTypeMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('comment')) {
      context.handle(
        _commentMeta,
        comment.isAcceptableOrUnknown(data['comment']!, _commentMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ErrorReport map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ErrorReport(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}item_id'],
      )!,
      contentType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_type'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      comment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}comment'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ErrorReportsTable createAlias(String alias) {
    return $ErrorReportsTable(attachedDatabase, alias);
  }
}

class ErrorReport extends DataClass implements Insertable<ErrorReport> {
  final int id;
  final int itemId;
  final String contentType;
  final String category;
  final String? comment;
  final DateTime createdAt;
  const ErrorReport({
    required this.id,
    required this.itemId,
    required this.contentType,
    required this.category,
    this.comment,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['item_id'] = Variable<int>(itemId);
    map['content_type'] = Variable<String>(contentType);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || comment != null) {
      map['comment'] = Variable<String>(comment);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ErrorReportsCompanion toCompanion(bool nullToAbsent) {
    return ErrorReportsCompanion(
      id: Value(id),
      itemId: Value(itemId),
      contentType: Value(contentType),
      category: Value(category),
      comment: comment == null && nullToAbsent
          ? const Value.absent()
          : Value(comment),
      createdAt: Value(createdAt),
    );
  }

  factory ErrorReport.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ErrorReport(
      id: serializer.fromJson<int>(json['id']),
      itemId: serializer.fromJson<int>(json['itemId']),
      contentType: serializer.fromJson<String>(json['contentType']),
      category: serializer.fromJson<String>(json['category']),
      comment: serializer.fromJson<String?>(json['comment']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'itemId': serializer.toJson<int>(itemId),
      'contentType': serializer.toJson<String>(contentType),
      'category': serializer.toJson<String>(category),
      'comment': serializer.toJson<String?>(comment),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ErrorReport copyWith({
    int? id,
    int? itemId,
    String? contentType,
    String? category,
    Value<String?> comment = const Value.absent(),
    DateTime? createdAt,
  }) => ErrorReport(
    id: id ?? this.id,
    itemId: itemId ?? this.itemId,
    contentType: contentType ?? this.contentType,
    category: category ?? this.category,
    comment: comment.present ? comment.value : this.comment,
    createdAt: createdAt ?? this.createdAt,
  );
  ErrorReport copyWithCompanion(ErrorReportsCompanion data) {
    return ErrorReport(
      id: data.id.present ? data.id.value : this.id,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      contentType: data.contentType.present
          ? data.contentType.value
          : this.contentType,
      category: data.category.present ? data.category.value : this.category,
      comment: data.comment.present ? data.comment.value : this.comment,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ErrorReport(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('contentType: $contentType, ')
          ..write('category: $category, ')
          ..write('comment: $comment, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, itemId, contentType, category, comment, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ErrorReport &&
          other.id == this.id &&
          other.itemId == this.itemId &&
          other.contentType == this.contentType &&
          other.category == this.category &&
          other.comment == this.comment &&
          other.createdAt == this.createdAt);
}

class ErrorReportsCompanion extends UpdateCompanion<ErrorReport> {
  final Value<int> id;
  final Value<int> itemId;
  final Value<String> contentType;
  final Value<String> category;
  final Value<String?> comment;
  final Value<DateTime> createdAt;
  const ErrorReportsCompanion({
    this.id = const Value.absent(),
    this.itemId = const Value.absent(),
    this.contentType = const Value.absent(),
    this.category = const Value.absent(),
    this.comment = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ErrorReportsCompanion.insert({
    this.id = const Value.absent(),
    required int itemId,
    required String contentType,
    required String category,
    this.comment = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : itemId = Value(itemId),
       contentType = Value(contentType),
       category = Value(category);
  static Insertable<ErrorReport> custom({
    Expression<int>? id,
    Expression<int>? itemId,
    Expression<String>? contentType,
    Expression<String>? category,
    Expression<String>? comment,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemId != null) 'item_id': itemId,
      if (contentType != null) 'content_type': contentType,
      if (category != null) 'category': category,
      if (comment != null) 'comment': comment,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ErrorReportsCompanion copyWith({
    Value<int>? id,
    Value<int>? itemId,
    Value<String>? contentType,
    Value<String>? category,
    Value<String?>? comment,
    Value<DateTime>? createdAt,
  }) {
    return ErrorReportsCompanion(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      contentType: contentType ?? this.contentType,
      category: category ?? this.category,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (contentType.present) {
      map['content_type'] = Variable<String>(contentType.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ErrorReportsCompanion(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('contentType: $contentType, ')
          ..write('category: $category, ')
          ..write('comment: $comment, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $UserProgressTable extends UserProgress
    with TableInfo<$UserProgressTable, UserProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentTypeMeta = const VerificationMeta(
    'contentType',
  );
  @override
  late final GeneratedColumn<String> contentType = GeneratedColumn<String>(
    'content_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stabilityMeta = const VerificationMeta(
    'stability',
  );
  @override
  late final GeneratedColumn<double> stability = GeneratedColumn<double>(
    'stability',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<double> difficulty = GeneratedColumn<double>(
    'difficulty',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('new'),
  );
  static const VerificationMeta _lastReviewMeta = const VerificationMeta(
    'lastReview',
  );
  @override
  late final GeneratedColumn<DateTime> lastReview = GeneratedColumn<DateTime>(
    'last_review',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nextReviewMeta = const VerificationMeta(
    'nextReview',
  );
  @override
  late final GeneratedColumn<DateTime> nextReview = GeneratedColumn<DateTime>(
    'next_review',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reviewCountMeta = const VerificationMeta(
    'reviewCount',
  );
  @override
  late final GeneratedColumn<int> reviewCount = GeneratedColumn<int>(
    'review_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _elapsedDaysMeta = const VerificationMeta(
    'elapsedDays',
  );
  @override
  late final GeneratedColumn<int> elapsedDays = GeneratedColumn<int>(
    'elapsed_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _scheduledDaysMeta = const VerificationMeta(
    'scheduledDays',
  );
  @override
  late final GeneratedColumn<int> scheduledDays = GeneratedColumn<int>(
    'scheduled_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
    'reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    itemId,
    contentType,
    stability,
    difficulty,
    state,
    lastReview,
    nextReview,
    reviewCount,
    elapsedDays,
    scheduledDays,
    reps,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProgressData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('content_type')) {
      context.handle(
        _contentTypeMeta,
        contentType.isAcceptableOrUnknown(
          data['content_type']!,
          _contentTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentTypeMeta);
    }
    if (data.containsKey('stability')) {
      context.handle(
        _stabilityMeta,
        stability.isAcceptableOrUnknown(data['stability']!, _stabilityMeta),
      );
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    if (data.containsKey('last_review')) {
      context.handle(
        _lastReviewMeta,
        lastReview.isAcceptableOrUnknown(data['last_review']!, _lastReviewMeta),
      );
    }
    if (data.containsKey('next_review')) {
      context.handle(
        _nextReviewMeta,
        nextReview.isAcceptableOrUnknown(data['next_review']!, _nextReviewMeta),
      );
    }
    if (data.containsKey('review_count')) {
      context.handle(
        _reviewCountMeta,
        reviewCount.isAcceptableOrUnknown(
          data['review_count']!,
          _reviewCountMeta,
        ),
      );
    }
    if (data.containsKey('elapsed_days')) {
      context.handle(
        _elapsedDaysMeta,
        elapsedDays.isAcceptableOrUnknown(
          data['elapsed_days']!,
          _elapsedDaysMeta,
        ),
      );
    }
    if (data.containsKey('scheduled_days')) {
      context.handle(
        _scheduledDaysMeta,
        scheduledDays.isAcceptableOrUnknown(
          data['scheduled_days']!,
          _scheduledDaysMeta,
        ),
      );
    }
    if (data.containsKey('reps')) {
      context.handle(
        _repsMeta,
        reps.isAcceptableOrUnknown(data['reps']!, _repsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {itemId, contentType},
  ];
  @override
  UserProgressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProgressData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}item_id'],
      )!,
      contentType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_type'],
      )!,
      stability: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}stability'],
      )!,
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}difficulty'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      lastReview: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_review'],
      ),
      nextReview: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_review'],
      ),
      reviewCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}review_count'],
      )!,
      elapsedDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}elapsed_days'],
      )!,
      scheduledDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}scheduled_days'],
      )!,
      reps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps'],
      )!,
    );
  }

  @override
  $UserProgressTable createAlias(String alias) {
    return $UserProgressTable(attachedDatabase, alias);
  }
}

class UserProgressData extends DataClass
    implements Insertable<UserProgressData> {
  final int id;
  final int itemId;
  final String contentType;
  final double stability;
  final double difficulty;
  final String state;
  final DateTime? lastReview;
  final DateTime? nextReview;
  final int reviewCount;
  final int elapsedDays;
  final int scheduledDays;
  final int reps;
  const UserProgressData({
    required this.id,
    required this.itemId,
    required this.contentType,
    required this.stability,
    required this.difficulty,
    required this.state,
    this.lastReview,
    this.nextReview,
    required this.reviewCount,
    required this.elapsedDays,
    required this.scheduledDays,
    required this.reps,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['item_id'] = Variable<int>(itemId);
    map['content_type'] = Variable<String>(contentType);
    map['stability'] = Variable<double>(stability);
    map['difficulty'] = Variable<double>(difficulty);
    map['state'] = Variable<String>(state);
    if (!nullToAbsent || lastReview != null) {
      map['last_review'] = Variable<DateTime>(lastReview);
    }
    if (!nullToAbsent || nextReview != null) {
      map['next_review'] = Variable<DateTime>(nextReview);
    }
    map['review_count'] = Variable<int>(reviewCount);
    map['elapsed_days'] = Variable<int>(elapsedDays);
    map['scheduled_days'] = Variable<int>(scheduledDays);
    map['reps'] = Variable<int>(reps);
    return map;
  }

  UserProgressCompanion toCompanion(bool nullToAbsent) {
    return UserProgressCompanion(
      id: Value(id),
      itemId: Value(itemId),
      contentType: Value(contentType),
      stability: Value(stability),
      difficulty: Value(difficulty),
      state: Value(state),
      lastReview: lastReview == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReview),
      nextReview: nextReview == null && nullToAbsent
          ? const Value.absent()
          : Value(nextReview),
      reviewCount: Value(reviewCount),
      elapsedDays: Value(elapsedDays),
      scheduledDays: Value(scheduledDays),
      reps: Value(reps),
    );
  }

  factory UserProgressData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProgressData(
      id: serializer.fromJson<int>(json['id']),
      itemId: serializer.fromJson<int>(json['itemId']),
      contentType: serializer.fromJson<String>(json['contentType']),
      stability: serializer.fromJson<double>(json['stability']),
      difficulty: serializer.fromJson<double>(json['difficulty']),
      state: serializer.fromJson<String>(json['state']),
      lastReview: serializer.fromJson<DateTime?>(json['lastReview']),
      nextReview: serializer.fromJson<DateTime?>(json['nextReview']),
      reviewCount: serializer.fromJson<int>(json['reviewCount']),
      elapsedDays: serializer.fromJson<int>(json['elapsedDays']),
      scheduledDays: serializer.fromJson<int>(json['scheduledDays']),
      reps: serializer.fromJson<int>(json['reps']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'itemId': serializer.toJson<int>(itemId),
      'contentType': serializer.toJson<String>(contentType),
      'stability': serializer.toJson<double>(stability),
      'difficulty': serializer.toJson<double>(difficulty),
      'state': serializer.toJson<String>(state),
      'lastReview': serializer.toJson<DateTime?>(lastReview),
      'nextReview': serializer.toJson<DateTime?>(nextReview),
      'reviewCount': serializer.toJson<int>(reviewCount),
      'elapsedDays': serializer.toJson<int>(elapsedDays),
      'scheduledDays': serializer.toJson<int>(scheduledDays),
      'reps': serializer.toJson<int>(reps),
    };
  }

  UserProgressData copyWith({
    int? id,
    int? itemId,
    String? contentType,
    double? stability,
    double? difficulty,
    String? state,
    Value<DateTime?> lastReview = const Value.absent(),
    Value<DateTime?> nextReview = const Value.absent(),
    int? reviewCount,
    int? elapsedDays,
    int? scheduledDays,
    int? reps,
  }) => UserProgressData(
    id: id ?? this.id,
    itemId: itemId ?? this.itemId,
    contentType: contentType ?? this.contentType,
    stability: stability ?? this.stability,
    difficulty: difficulty ?? this.difficulty,
    state: state ?? this.state,
    lastReview: lastReview.present ? lastReview.value : this.lastReview,
    nextReview: nextReview.present ? nextReview.value : this.nextReview,
    reviewCount: reviewCount ?? this.reviewCount,
    elapsedDays: elapsedDays ?? this.elapsedDays,
    scheduledDays: scheduledDays ?? this.scheduledDays,
    reps: reps ?? this.reps,
  );
  UserProgressData copyWithCompanion(UserProgressCompanion data) {
    return UserProgressData(
      id: data.id.present ? data.id.value : this.id,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      contentType: data.contentType.present
          ? data.contentType.value
          : this.contentType,
      stability: data.stability.present ? data.stability.value : this.stability,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      state: data.state.present ? data.state.value : this.state,
      lastReview: data.lastReview.present
          ? data.lastReview.value
          : this.lastReview,
      nextReview: data.nextReview.present
          ? data.nextReview.value
          : this.nextReview,
      reviewCount: data.reviewCount.present
          ? data.reviewCount.value
          : this.reviewCount,
      elapsedDays: data.elapsedDays.present
          ? data.elapsedDays.value
          : this.elapsedDays,
      scheduledDays: data.scheduledDays.present
          ? data.scheduledDays.value
          : this.scheduledDays,
      reps: data.reps.present ? data.reps.value : this.reps,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProgressData(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('contentType: $contentType, ')
          ..write('stability: $stability, ')
          ..write('difficulty: $difficulty, ')
          ..write('state: $state, ')
          ..write('lastReview: $lastReview, ')
          ..write('nextReview: $nextReview, ')
          ..write('reviewCount: $reviewCount, ')
          ..write('elapsedDays: $elapsedDays, ')
          ..write('scheduledDays: $scheduledDays, ')
          ..write('reps: $reps')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    itemId,
    contentType,
    stability,
    difficulty,
    state,
    lastReview,
    nextReview,
    reviewCount,
    elapsedDays,
    scheduledDays,
    reps,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProgressData &&
          other.id == this.id &&
          other.itemId == this.itemId &&
          other.contentType == this.contentType &&
          other.stability == this.stability &&
          other.difficulty == this.difficulty &&
          other.state == this.state &&
          other.lastReview == this.lastReview &&
          other.nextReview == this.nextReview &&
          other.reviewCount == this.reviewCount &&
          other.elapsedDays == this.elapsedDays &&
          other.scheduledDays == this.scheduledDays &&
          other.reps == this.reps);
}

class UserProgressCompanion extends UpdateCompanion<UserProgressData> {
  final Value<int> id;
  final Value<int> itemId;
  final Value<String> contentType;
  final Value<double> stability;
  final Value<double> difficulty;
  final Value<String> state;
  final Value<DateTime?> lastReview;
  final Value<DateTime?> nextReview;
  final Value<int> reviewCount;
  final Value<int> elapsedDays;
  final Value<int> scheduledDays;
  final Value<int> reps;
  const UserProgressCompanion({
    this.id = const Value.absent(),
    this.itemId = const Value.absent(),
    this.contentType = const Value.absent(),
    this.stability = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.state = const Value.absent(),
    this.lastReview = const Value.absent(),
    this.nextReview = const Value.absent(),
    this.reviewCount = const Value.absent(),
    this.elapsedDays = const Value.absent(),
    this.scheduledDays = const Value.absent(),
    this.reps = const Value.absent(),
  });
  UserProgressCompanion.insert({
    this.id = const Value.absent(),
    required int itemId,
    required String contentType,
    this.stability = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.state = const Value.absent(),
    this.lastReview = const Value.absent(),
    this.nextReview = const Value.absent(),
    this.reviewCount = const Value.absent(),
    this.elapsedDays = const Value.absent(),
    this.scheduledDays = const Value.absent(),
    this.reps = const Value.absent(),
  }) : itemId = Value(itemId),
       contentType = Value(contentType);
  static Insertable<UserProgressData> custom({
    Expression<int>? id,
    Expression<int>? itemId,
    Expression<String>? contentType,
    Expression<double>? stability,
    Expression<double>? difficulty,
    Expression<String>? state,
    Expression<DateTime>? lastReview,
    Expression<DateTime>? nextReview,
    Expression<int>? reviewCount,
    Expression<int>? elapsedDays,
    Expression<int>? scheduledDays,
    Expression<int>? reps,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemId != null) 'item_id': itemId,
      if (contentType != null) 'content_type': contentType,
      if (stability != null) 'stability': stability,
      if (difficulty != null) 'difficulty': difficulty,
      if (state != null) 'state': state,
      if (lastReview != null) 'last_review': lastReview,
      if (nextReview != null) 'next_review': nextReview,
      if (reviewCount != null) 'review_count': reviewCount,
      if (elapsedDays != null) 'elapsed_days': elapsedDays,
      if (scheduledDays != null) 'scheduled_days': scheduledDays,
      if (reps != null) 'reps': reps,
    });
  }

  UserProgressCompanion copyWith({
    Value<int>? id,
    Value<int>? itemId,
    Value<String>? contentType,
    Value<double>? stability,
    Value<double>? difficulty,
    Value<String>? state,
    Value<DateTime?>? lastReview,
    Value<DateTime?>? nextReview,
    Value<int>? reviewCount,
    Value<int>? elapsedDays,
    Value<int>? scheduledDays,
    Value<int>? reps,
  }) {
    return UserProgressCompanion(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      contentType: contentType ?? this.contentType,
      stability: stability ?? this.stability,
      difficulty: difficulty ?? this.difficulty,
      state: state ?? this.state,
      lastReview: lastReview ?? this.lastReview,
      nextReview: nextReview ?? this.nextReview,
      reviewCount: reviewCount ?? this.reviewCount,
      elapsedDays: elapsedDays ?? this.elapsedDays,
      scheduledDays: scheduledDays ?? this.scheduledDays,
      reps: reps ?? this.reps,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (contentType.present) {
      map['content_type'] = Variable<String>(contentType.value);
    }
    if (stability.present) {
      map['stability'] = Variable<double>(stability.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<double>(difficulty.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (lastReview.present) {
      map['last_review'] = Variable<DateTime>(lastReview.value);
    }
    if (nextReview.present) {
      map['next_review'] = Variable<DateTime>(nextReview.value);
    }
    if (reviewCount.present) {
      map['review_count'] = Variable<int>(reviewCount.value);
    }
    if (elapsedDays.present) {
      map['elapsed_days'] = Variable<int>(elapsedDays.value);
    }
    if (scheduledDays.present) {
      map['scheduled_days'] = Variable<int>(scheduledDays.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProgressCompanion(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('contentType: $contentType, ')
          ..write('stability: $stability, ')
          ..write('difficulty: $difficulty, ')
          ..write('state: $state, ')
          ..write('lastReview: $lastReview, ')
          ..write('nextReview: $nextReview, ')
          ..write('reviewCount: $reviewCount, ')
          ..write('elapsedDays: $elapsedDays, ')
          ..write('scheduledDays: $scheduledDays, ')
          ..write('reps: $reps')
          ..write(')'))
        .toString();
  }
}

class $SessionsTable extends Sessions with TableInfo<$SessionsTable, Session> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sessionTypeMeta = const VerificationMeta(
    'sessionType',
  );
  @override
  late final GeneratedColumn<String> sessionType = GeneratedColumn<String>(
    'session_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _itemsReviewedMeta = const VerificationMeta(
    'itemsReviewed',
  );
  @override
  late final GeneratedColumn<int> itemsReviewed = GeneratedColumn<int>(
    'items_reviewed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _resultsJsonMeta = const VerificationMeta(
    'resultsJson',
  );
  @override
  late final GeneratedColumn<String> resultsJson = GeneratedColumn<String>(
    'results_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionType,
    startedAt,
    completedAt,
    itemsReviewed,
    resultsJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Session> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_type')) {
      context.handle(
        _sessionTypeMeta,
        sessionType.isAcceptableOrUnknown(
          data['session_type']!,
          _sessionTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sessionTypeMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('items_reviewed')) {
      context.handle(
        _itemsReviewedMeta,
        itemsReviewed.isAcceptableOrUnknown(
          data['items_reviewed']!,
          _itemsReviewedMeta,
        ),
      );
    }
    if (data.containsKey('results_json')) {
      context.handle(
        _resultsJsonMeta,
        resultsJson.isAcceptableOrUnknown(
          data['results_json']!,
          _resultsJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Session map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Session(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_type'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      itemsReviewed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}items_reviewed'],
      )!,
      resultsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}results_json'],
      ),
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }
}

class Session extends DataClass implements Insertable<Session> {
  final int id;
  final String sessionType;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int itemsReviewed;
  final String? resultsJson;
  const Session({
    required this.id,
    required this.sessionType,
    required this.startedAt,
    this.completedAt,
    required this.itemsReviewed,
    this.resultsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_type'] = Variable<String>(sessionType);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['items_reviewed'] = Variable<int>(itemsReviewed);
    if (!nullToAbsent || resultsJson != null) {
      map['results_json'] = Variable<String>(resultsJson);
    }
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      sessionType: Value(sessionType),
      startedAt: Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      itemsReviewed: Value(itemsReviewed),
      resultsJson: resultsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(resultsJson),
    );
  }

  factory Session.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Session(
      id: serializer.fromJson<int>(json['id']),
      sessionType: serializer.fromJson<String>(json['sessionType']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      itemsReviewed: serializer.fromJson<int>(json['itemsReviewed']),
      resultsJson: serializer.fromJson<String?>(json['resultsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionType': serializer.toJson<String>(sessionType),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'itemsReviewed': serializer.toJson<int>(itemsReviewed),
      'resultsJson': serializer.toJson<String?>(resultsJson),
    };
  }

  Session copyWith({
    int? id,
    String? sessionType,
    DateTime? startedAt,
    Value<DateTime?> completedAt = const Value.absent(),
    int? itemsReviewed,
    Value<String?> resultsJson = const Value.absent(),
  }) => Session(
    id: id ?? this.id,
    sessionType: sessionType ?? this.sessionType,
    startedAt: startedAt ?? this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    itemsReviewed: itemsReviewed ?? this.itemsReviewed,
    resultsJson: resultsJson.present ? resultsJson.value : this.resultsJson,
  );
  Session copyWithCompanion(SessionsCompanion data) {
    return Session(
      id: data.id.present ? data.id.value : this.id,
      sessionType: data.sessionType.present
          ? data.sessionType.value
          : this.sessionType,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      itemsReviewed: data.itemsReviewed.present
          ? data.itemsReviewed.value
          : this.itemsReviewed,
      resultsJson: data.resultsJson.present
          ? data.resultsJson.value
          : this.resultsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Session(')
          ..write('id: $id, ')
          ..write('sessionType: $sessionType, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('itemsReviewed: $itemsReviewed, ')
          ..write('resultsJson: $resultsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionType,
    startedAt,
    completedAt,
    itemsReviewed,
    resultsJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Session &&
          other.id == this.id &&
          other.sessionType == this.sessionType &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.itemsReviewed == this.itemsReviewed &&
          other.resultsJson == this.resultsJson);
}

class SessionsCompanion extends UpdateCompanion<Session> {
  final Value<int> id;
  final Value<String> sessionType;
  final Value<DateTime> startedAt;
  final Value<DateTime?> completedAt;
  final Value<int> itemsReviewed;
  final Value<String?> resultsJson;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.sessionType = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.itemsReviewed = const Value.absent(),
    this.resultsJson = const Value.absent(),
  });
  SessionsCompanion.insert({
    this.id = const Value.absent(),
    required String sessionType,
    required DateTime startedAt,
    this.completedAt = const Value.absent(),
    this.itemsReviewed = const Value.absent(),
    this.resultsJson = const Value.absent(),
  }) : sessionType = Value(sessionType),
       startedAt = Value(startedAt);
  static Insertable<Session> custom({
    Expression<int>? id,
    Expression<String>? sessionType,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<int>? itemsReviewed,
    Expression<String>? resultsJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionType != null) 'session_type': sessionType,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (itemsReviewed != null) 'items_reviewed': itemsReviewed,
      if (resultsJson != null) 'results_json': resultsJson,
    });
  }

  SessionsCompanion copyWith({
    Value<int>? id,
    Value<String>? sessionType,
    Value<DateTime>? startedAt,
    Value<DateTime?>? completedAt,
    Value<int>? itemsReviewed,
    Value<String?>? resultsJson,
  }) {
    return SessionsCompanion(
      id: id ?? this.id,
      sessionType: sessionType ?? this.sessionType,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      itemsReviewed: itemsReviewed ?? this.itemsReviewed,
      resultsJson: resultsJson ?? this.resultsJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionType.present) {
      map['session_type'] = Variable<String>(sessionType.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (itemsReviewed.present) {
      map['items_reviewed'] = Variable<int>(itemsReviewed.value);
    }
    if (resultsJson.present) {
      map['results_json'] = Variable<String>(resultsJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('sessionType: $sessionType, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('itemsReviewed: $itemsReviewed, ')
          ..write('resultsJson: $resultsJson')
          ..write(')'))
        .toString();
  }
}

class $StreaksTable extends Streaks with TableInfo<$StreaksTable, Streak> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StreaksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _currentStreakMeta = const VerificationMeta(
    'currentStreak',
  );
  @override
  late final GeneratedColumn<int> currentStreak = GeneratedColumn<int>(
    'current_streak',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _longestStreakMeta = const VerificationMeta(
    'longestStreak',
  );
  @override
  late final GeneratedColumn<int> longestStreak = GeneratedColumn<int>(
    'longest_streak',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastActivityDateMeta = const VerificationMeta(
    'lastActivityDate',
  );
  @override
  late final GeneratedColumn<DateTime> lastActivityDate =
      GeneratedColumn<DateTime>(
        'last_activity_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _freezeAvailableMeta = const VerificationMeta(
    'freezeAvailable',
  );
  @override
  late final GeneratedColumn<bool> freezeAvailable = GeneratedColumn<bool>(
    'freeze_available',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("freeze_available" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _freezeUsedDateMeta = const VerificationMeta(
    'freezeUsedDate',
  );
  @override
  late final GeneratedColumn<DateTime> freezeUsedDate =
      GeneratedColumn<DateTime>(
        'freeze_used_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    currentStreak,
    longestStreak,
    lastActivityDate,
    freezeAvailable,
    freezeUsedDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'streaks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Streak> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('current_streak')) {
      context.handle(
        _currentStreakMeta,
        currentStreak.isAcceptableOrUnknown(
          data['current_streak']!,
          _currentStreakMeta,
        ),
      );
    }
    if (data.containsKey('longest_streak')) {
      context.handle(
        _longestStreakMeta,
        longestStreak.isAcceptableOrUnknown(
          data['longest_streak']!,
          _longestStreakMeta,
        ),
      );
    }
    if (data.containsKey('last_activity_date')) {
      context.handle(
        _lastActivityDateMeta,
        lastActivityDate.isAcceptableOrUnknown(
          data['last_activity_date']!,
          _lastActivityDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastActivityDateMeta);
    }
    if (data.containsKey('freeze_available')) {
      context.handle(
        _freezeAvailableMeta,
        freezeAvailable.isAcceptableOrUnknown(
          data['freeze_available']!,
          _freezeAvailableMeta,
        ),
      );
    }
    if (data.containsKey('freeze_used_date')) {
      context.handle(
        _freezeUsedDateMeta,
        freezeUsedDate.isAcceptableOrUnknown(
          data['freeze_used_date']!,
          _freezeUsedDateMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Streak map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Streak(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      currentStreak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_streak'],
      )!,
      longestStreak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}longest_streak'],
      )!,
      lastActivityDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_activity_date'],
      )!,
      freezeAvailable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}freeze_available'],
      )!,
      freezeUsedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}freeze_used_date'],
      ),
    );
  }

  @override
  $StreaksTable createAlias(String alias) {
    return $StreaksTable(attachedDatabase, alias);
  }
}

class Streak extends DataClass implements Insertable<Streak> {
  final int id;
  final int currentStreak;
  final int longestStreak;
  final DateTime lastActivityDate;
  final bool freezeAvailable;
  final DateTime? freezeUsedDate;
  const Streak({
    required this.id,
    required this.currentStreak,
    required this.longestStreak,
    required this.lastActivityDate,
    required this.freezeAvailable,
    this.freezeUsedDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['current_streak'] = Variable<int>(currentStreak);
    map['longest_streak'] = Variable<int>(longestStreak);
    map['last_activity_date'] = Variable<DateTime>(lastActivityDate);
    map['freeze_available'] = Variable<bool>(freezeAvailable);
    if (!nullToAbsent || freezeUsedDate != null) {
      map['freeze_used_date'] = Variable<DateTime>(freezeUsedDate);
    }
    return map;
  }

  StreaksCompanion toCompanion(bool nullToAbsent) {
    return StreaksCompanion(
      id: Value(id),
      currentStreak: Value(currentStreak),
      longestStreak: Value(longestStreak),
      lastActivityDate: Value(lastActivityDate),
      freezeAvailable: Value(freezeAvailable),
      freezeUsedDate: freezeUsedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(freezeUsedDate),
    );
  }

  factory Streak.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Streak(
      id: serializer.fromJson<int>(json['id']),
      currentStreak: serializer.fromJson<int>(json['currentStreak']),
      longestStreak: serializer.fromJson<int>(json['longestStreak']),
      lastActivityDate: serializer.fromJson<DateTime>(json['lastActivityDate']),
      freezeAvailable: serializer.fromJson<bool>(json['freezeAvailable']),
      freezeUsedDate: serializer.fromJson<DateTime?>(json['freezeUsedDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'currentStreak': serializer.toJson<int>(currentStreak),
      'longestStreak': serializer.toJson<int>(longestStreak),
      'lastActivityDate': serializer.toJson<DateTime>(lastActivityDate),
      'freezeAvailable': serializer.toJson<bool>(freezeAvailable),
      'freezeUsedDate': serializer.toJson<DateTime?>(freezeUsedDate),
    };
  }

  Streak copyWith({
    int? id,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastActivityDate,
    bool? freezeAvailable,
    Value<DateTime?> freezeUsedDate = const Value.absent(),
  }) => Streak(
    id: id ?? this.id,
    currentStreak: currentStreak ?? this.currentStreak,
    longestStreak: longestStreak ?? this.longestStreak,
    lastActivityDate: lastActivityDate ?? this.lastActivityDate,
    freezeAvailable: freezeAvailable ?? this.freezeAvailable,
    freezeUsedDate: freezeUsedDate.present
        ? freezeUsedDate.value
        : this.freezeUsedDate,
  );
  Streak copyWithCompanion(StreaksCompanion data) {
    return Streak(
      id: data.id.present ? data.id.value : this.id,
      currentStreak: data.currentStreak.present
          ? data.currentStreak.value
          : this.currentStreak,
      longestStreak: data.longestStreak.present
          ? data.longestStreak.value
          : this.longestStreak,
      lastActivityDate: data.lastActivityDate.present
          ? data.lastActivityDate.value
          : this.lastActivityDate,
      freezeAvailable: data.freezeAvailable.present
          ? data.freezeAvailable.value
          : this.freezeAvailable,
      freezeUsedDate: data.freezeUsedDate.present
          ? data.freezeUsedDate.value
          : this.freezeUsedDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Streak(')
          ..write('id: $id, ')
          ..write('currentStreak: $currentStreak, ')
          ..write('longestStreak: $longestStreak, ')
          ..write('lastActivityDate: $lastActivityDate, ')
          ..write('freezeAvailable: $freezeAvailable, ')
          ..write('freezeUsedDate: $freezeUsedDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    currentStreak,
    longestStreak,
    lastActivityDate,
    freezeAvailable,
    freezeUsedDate,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Streak &&
          other.id == this.id &&
          other.currentStreak == this.currentStreak &&
          other.longestStreak == this.longestStreak &&
          other.lastActivityDate == this.lastActivityDate &&
          other.freezeAvailable == this.freezeAvailable &&
          other.freezeUsedDate == this.freezeUsedDate);
}

class StreaksCompanion extends UpdateCompanion<Streak> {
  final Value<int> id;
  final Value<int> currentStreak;
  final Value<int> longestStreak;
  final Value<DateTime> lastActivityDate;
  final Value<bool> freezeAvailable;
  final Value<DateTime?> freezeUsedDate;
  const StreaksCompanion({
    this.id = const Value.absent(),
    this.currentStreak = const Value.absent(),
    this.longestStreak = const Value.absent(),
    this.lastActivityDate = const Value.absent(),
    this.freezeAvailable = const Value.absent(),
    this.freezeUsedDate = const Value.absent(),
  });
  StreaksCompanion.insert({
    this.id = const Value.absent(),
    this.currentStreak = const Value.absent(),
    this.longestStreak = const Value.absent(),
    required DateTime lastActivityDate,
    this.freezeAvailable = const Value.absent(),
    this.freezeUsedDate = const Value.absent(),
  }) : lastActivityDate = Value(lastActivityDate);
  static Insertable<Streak> custom({
    Expression<int>? id,
    Expression<int>? currentStreak,
    Expression<int>? longestStreak,
    Expression<DateTime>? lastActivityDate,
    Expression<bool>? freezeAvailable,
    Expression<DateTime>? freezeUsedDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (currentStreak != null) 'current_streak': currentStreak,
      if (longestStreak != null) 'longest_streak': longestStreak,
      if (lastActivityDate != null) 'last_activity_date': lastActivityDate,
      if (freezeAvailable != null) 'freeze_available': freezeAvailable,
      if (freezeUsedDate != null) 'freeze_used_date': freezeUsedDate,
    });
  }

  StreaksCompanion copyWith({
    Value<int>? id,
    Value<int>? currentStreak,
    Value<int>? longestStreak,
    Value<DateTime>? lastActivityDate,
    Value<bool>? freezeAvailable,
    Value<DateTime?>? freezeUsedDate,
  }) {
    return StreaksCompanion(
      id: id ?? this.id,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
      freezeAvailable: freezeAvailable ?? this.freezeAvailable,
      freezeUsedDate: freezeUsedDate ?? this.freezeUsedDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (currentStreak.present) {
      map['current_streak'] = Variable<int>(currentStreak.value);
    }
    if (longestStreak.present) {
      map['longest_streak'] = Variable<int>(longestStreak.value);
    }
    if (lastActivityDate.present) {
      map['last_activity_date'] = Variable<DateTime>(lastActivityDate.value);
    }
    if (freezeAvailable.present) {
      map['freeze_available'] = Variable<bool>(freezeAvailable.value);
    }
    if (freezeUsedDate.present) {
      map['freeze_used_date'] = Variable<DateTime>(freezeUsedDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StreaksCompanion(')
          ..write('id: $id, ')
          ..write('currentStreak: $currentStreak, ')
          ..write('longestStreak: $longestStreak, ')
          ..write('lastActivityDate: $lastActivityDate, ')
          ..write('freezeAvailable: $freezeAvailable, ')
          ..write('freezeUsedDate: $freezeUsedDate')
          ..write(')'))
        .toString();
  }
}

class $BadgesTable extends Badges with TableInfo<$BadgesTable, Badge> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BadgesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _badgeTypeMeta = const VerificationMeta(
    'badgeType',
  );
  @override
  late final GeneratedColumn<String> badgeType = GeneratedColumn<String>(
    'badge_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _unlockedAtMeta = const VerificationMeta(
    'unlockedAt',
  );
  @override
  late final GeneratedColumn<DateTime> unlockedAt = GeneratedColumn<DateTime>(
    'unlocked_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _displayedMeta = const VerificationMeta(
    'displayed',
  );
  @override
  late final GeneratedColumn<bool> displayed = GeneratedColumn<bool>(
    'displayed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("displayed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, badgeType, unlockedAt, displayed];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'badges';
  @override
  VerificationContext validateIntegrity(
    Insertable<Badge> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('badge_type')) {
      context.handle(
        _badgeTypeMeta,
        badgeType.isAcceptableOrUnknown(data['badge_type']!, _badgeTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_badgeTypeMeta);
    }
    if (data.containsKey('unlocked_at')) {
      context.handle(
        _unlockedAtMeta,
        unlockedAt.isAcceptableOrUnknown(data['unlocked_at']!, _unlockedAtMeta),
      );
    }
    if (data.containsKey('displayed')) {
      context.handle(
        _displayedMeta,
        displayed.isAcceptableOrUnknown(data['displayed']!, _displayedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Badge map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Badge(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      badgeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}badge_type'],
      )!,
      unlockedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}unlocked_at'],
      ),
      displayed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}displayed'],
      )!,
    );
  }

  @override
  $BadgesTable createAlias(String alias) {
    return $BadgesTable(attachedDatabase, alias);
  }
}

class Badge extends DataClass implements Insertable<Badge> {
  final int id;
  final String badgeType;
  final DateTime? unlockedAt;
  final bool displayed;
  const Badge({
    required this.id,
    required this.badgeType,
    this.unlockedAt,
    required this.displayed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['badge_type'] = Variable<String>(badgeType);
    if (!nullToAbsent || unlockedAt != null) {
      map['unlocked_at'] = Variable<DateTime>(unlockedAt);
    }
    map['displayed'] = Variable<bool>(displayed);
    return map;
  }

  BadgesCompanion toCompanion(bool nullToAbsent) {
    return BadgesCompanion(
      id: Value(id),
      badgeType: Value(badgeType),
      unlockedAt: unlockedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(unlockedAt),
      displayed: Value(displayed),
    );
  }

  factory Badge.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Badge(
      id: serializer.fromJson<int>(json['id']),
      badgeType: serializer.fromJson<String>(json['badgeType']),
      unlockedAt: serializer.fromJson<DateTime?>(json['unlockedAt']),
      displayed: serializer.fromJson<bool>(json['displayed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'badgeType': serializer.toJson<String>(badgeType),
      'unlockedAt': serializer.toJson<DateTime?>(unlockedAt),
      'displayed': serializer.toJson<bool>(displayed),
    };
  }

  Badge copyWith({
    int? id,
    String? badgeType,
    Value<DateTime?> unlockedAt = const Value.absent(),
    bool? displayed,
  }) => Badge(
    id: id ?? this.id,
    badgeType: badgeType ?? this.badgeType,
    unlockedAt: unlockedAt.present ? unlockedAt.value : this.unlockedAt,
    displayed: displayed ?? this.displayed,
  );
  Badge copyWithCompanion(BadgesCompanion data) {
    return Badge(
      id: data.id.present ? data.id.value : this.id,
      badgeType: data.badgeType.present ? data.badgeType.value : this.badgeType,
      unlockedAt: data.unlockedAt.present
          ? data.unlockedAt.value
          : this.unlockedAt,
      displayed: data.displayed.present ? data.displayed.value : this.displayed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Badge(')
          ..write('id: $id, ')
          ..write('badgeType: $badgeType, ')
          ..write('unlockedAt: $unlockedAt, ')
          ..write('displayed: $displayed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, badgeType, unlockedAt, displayed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Badge &&
          other.id == this.id &&
          other.badgeType == this.badgeType &&
          other.unlockedAt == this.unlockedAt &&
          other.displayed == this.displayed);
}

class BadgesCompanion extends UpdateCompanion<Badge> {
  final Value<int> id;
  final Value<String> badgeType;
  final Value<DateTime?> unlockedAt;
  final Value<bool> displayed;
  const BadgesCompanion({
    this.id = const Value.absent(),
    this.badgeType = const Value.absent(),
    this.unlockedAt = const Value.absent(),
    this.displayed = const Value.absent(),
  });
  BadgesCompanion.insert({
    this.id = const Value.absent(),
    required String badgeType,
    this.unlockedAt = const Value.absent(),
    this.displayed = const Value.absent(),
  }) : badgeType = Value(badgeType);
  static Insertable<Badge> custom({
    Expression<int>? id,
    Expression<String>? badgeType,
    Expression<DateTime>? unlockedAt,
    Expression<bool>? displayed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (badgeType != null) 'badge_type': badgeType,
      if (unlockedAt != null) 'unlocked_at': unlockedAt,
      if (displayed != null) 'displayed': displayed,
    });
  }

  BadgesCompanion copyWith({
    Value<int>? id,
    Value<String>? badgeType,
    Value<DateTime?>? unlockedAt,
    Value<bool>? displayed,
  }) {
    return BadgesCompanion(
      id: id ?? this.id,
      badgeType: badgeType ?? this.badgeType,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      displayed: displayed ?? this.displayed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (badgeType.present) {
      map['badge_type'] = Variable<String>(badgeType.value);
    }
    if (unlockedAt.present) {
      map['unlocked_at'] = Variable<DateTime>(unlockedAt.value);
    }
    if (displayed.present) {
      map['displayed'] = Variable<bool>(displayed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BadgesCompanion(')
          ..write('id: $id, ')
          ..write('badgeType: $badgeType, ')
          ..write('unlockedAt: $unlockedAt, ')
          ..write('displayed: $displayed')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LevelsTable levels = $LevelsTable(this);
  late final $UnitsTable units = $UnitsTable(this);
  late final $LessonsTable lessons = $LessonsTable(this);
  late final $WordsTable words = $WordsTable(this);
  late final $VerbsTable verbs = $VerbsTable(this);
  late final $ErrorReportsTable errorReports = $ErrorReportsTable(this);
  late final $UserProgressTable userProgress = $UserProgressTable(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $StreaksTable streaks = $StreaksTable(this);
  late final $BadgesTable badges = $BadgesTable(this);
  late final Index idxUserProgressNextReview = Index(
    'idx_user_progress_next_review',
    'CREATE INDEX idx_user_progress_next_review ON user_progress (next_review)',
  );
  late final BadgeDao badgeDao = BadgeDao(this as AppDatabase);
  late final ContentDao contentDao = ContentDao(this as AppDatabase);
  late final ProgressDao progressDao = ProgressDao(this as AppDatabase);
  late final StreakDao streakDao = StreakDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    levels,
    units,
    lessons,
    words,
    verbs,
    errorReports,
    userProgress,
    sessions,
    streaks,
    badges,
    idxUserProgressNextReview,
  ];
}

typedef $$LevelsTableCreateCompanionBuilder =
    LevelsCompanion Function({
      Value<int> id,
      required int number,
      required String nameFr,
      required String nameEn,
      required String nameAr,
      required int unitCount,
    });
typedef $$LevelsTableUpdateCompanionBuilder =
    LevelsCompanion Function({
      Value<int> id,
      Value<int> number,
      Value<String> nameFr,
      Value<String> nameEn,
      Value<String> nameAr,
      Value<int> unitCount,
    });

final class $$LevelsTableReferences
    extends BaseReferences<_$AppDatabase, $LevelsTable, Level> {
  $$LevelsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$UnitsTable, List<Unit>> _unitsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.units,
    aliasName: $_aliasNameGenerator(db.levels.id, db.units.levelId),
  );

  $$UnitsTableProcessedTableManager get unitsRefs {
    final manager = $$UnitsTableTableManager(
      $_db,
      $_db.units,
    ).filter((f) => f.levelId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_unitsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LevelsTableFilterComposer
    extends Composer<_$AppDatabase, $LevelsTable> {
  $$LevelsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameFr => $composableBuilder(
    column: $table.nameFr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitCount => $composableBuilder(
    column: $table.unitCount,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> unitsRefs(
    Expression<bool> Function($$UnitsTableFilterComposer f) f,
  ) {
    final $$UnitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.levelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableFilterComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LevelsTableOrderingComposer
    extends Composer<_$AppDatabase, $LevelsTable> {
  $$LevelsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameFr => $composableBuilder(
    column: $table.nameFr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitCount => $composableBuilder(
    column: $table.unitCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LevelsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LevelsTable> {
  $$LevelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<String> get nameFr =>
      $composableBuilder(column: $table.nameFr, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<int> get unitCount =>
      $composableBuilder(column: $table.unitCount, builder: (column) => column);

  Expression<T> unitsRefs<T extends Object>(
    Expression<T> Function($$UnitsTableAnnotationComposer a) f,
  ) {
    final $$UnitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.levelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableAnnotationComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LevelsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LevelsTable,
          Level,
          $$LevelsTableFilterComposer,
          $$LevelsTableOrderingComposer,
          $$LevelsTableAnnotationComposer,
          $$LevelsTableCreateCompanionBuilder,
          $$LevelsTableUpdateCompanionBuilder,
          (Level, $$LevelsTableReferences),
          Level,
          PrefetchHooks Function({bool unitsRefs})
        > {
  $$LevelsTableTableManager(_$AppDatabase db, $LevelsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LevelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LevelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LevelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> number = const Value.absent(),
                Value<String> nameFr = const Value.absent(),
                Value<String> nameEn = const Value.absent(),
                Value<String> nameAr = const Value.absent(),
                Value<int> unitCount = const Value.absent(),
              }) => LevelsCompanion(
                id: id,
                number: number,
                nameFr: nameFr,
                nameEn: nameEn,
                nameAr: nameAr,
                unitCount: unitCount,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int number,
                required String nameFr,
                required String nameEn,
                required String nameAr,
                required int unitCount,
              }) => LevelsCompanion.insert(
                id: id,
                number: number,
                nameFr: nameFr,
                nameEn: nameEn,
                nameAr: nameAr,
                unitCount: unitCount,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$LevelsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({unitsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (unitsRefs) db.units],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (unitsRefs)
                    await $_getPrefetchedData<Level, $LevelsTable, Unit>(
                      currentTable: table,
                      referencedTable: $$LevelsTableReferences._unitsRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$LevelsTableReferences(db, table, p0).unitsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.levelId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$LevelsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LevelsTable,
      Level,
      $$LevelsTableFilterComposer,
      $$LevelsTableOrderingComposer,
      $$LevelsTableAnnotationComposer,
      $$LevelsTableCreateCompanionBuilder,
      $$LevelsTableUpdateCompanionBuilder,
      (Level, $$LevelsTableReferences),
      Level,
      PrefetchHooks Function({bool unitsRefs})
    >;
typedef $$UnitsTableCreateCompanionBuilder =
    UnitsCompanion Function({
      Value<int> id,
      required int levelId,
      required int number,
      required String nameFr,
      required String nameEn,
    });
typedef $$UnitsTableUpdateCompanionBuilder =
    UnitsCompanion Function({
      Value<int> id,
      Value<int> levelId,
      Value<int> number,
      Value<String> nameFr,
      Value<String> nameEn,
    });

final class $$UnitsTableReferences
    extends BaseReferences<_$AppDatabase, $UnitsTable, Unit> {
  $$UnitsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LevelsTable _levelIdTable(_$AppDatabase db) => db.levels.createAlias(
    $_aliasNameGenerator(db.units.levelId, db.levels.id),
  );

  $$LevelsTableProcessedTableManager get levelId {
    final $_column = $_itemColumn<int>('level_id')!;

    final manager = $$LevelsTableTableManager(
      $_db,
      $_db.levels,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_levelIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$LessonsTable, List<Lesson>> _lessonsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.lessons,
    aliasName: $_aliasNameGenerator(db.units.id, db.lessons.unitId),
  );

  $$LessonsTableProcessedTableManager get lessonsRefs {
    final manager = $$LessonsTableTableManager(
      $_db,
      $_db.lessons,
    ).filter((f) => f.unitId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_lessonsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UnitsTableFilterComposer extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameFr => $composableBuilder(
    column: $table.nameFr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );

  $$LevelsTableFilterComposer get levelId {
    final $$LevelsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.levelId,
      referencedTable: $db.levels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LevelsTableFilterComposer(
            $db: $db,
            $table: $db.levels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> lessonsRefs(
    Expression<bool> Function($$LessonsTableFilterComposer f) f,
  ) {
    final $$LessonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lessons,
      getReferencedColumn: (t) => t.unitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonsTableFilterComposer(
            $db: $db,
            $table: $db.lessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UnitsTableOrderingComposer
    extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameFr => $composableBuilder(
    column: $table.nameFr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );

  $$LevelsTableOrderingComposer get levelId {
    final $$LevelsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.levelId,
      referencedTable: $db.levels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LevelsTableOrderingComposer(
            $db: $db,
            $table: $db.levels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UnitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<String> get nameFr =>
      $composableBuilder(column: $table.nameFr, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  $$LevelsTableAnnotationComposer get levelId {
    final $$LevelsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.levelId,
      referencedTable: $db.levels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LevelsTableAnnotationComposer(
            $db: $db,
            $table: $db.levels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> lessonsRefs<T extends Object>(
    Expression<T> Function($$LessonsTableAnnotationComposer a) f,
  ) {
    final $$LessonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lessons,
      getReferencedColumn: (t) => t.unitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonsTableAnnotationComposer(
            $db: $db,
            $table: $db.lessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UnitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UnitsTable,
          Unit,
          $$UnitsTableFilterComposer,
          $$UnitsTableOrderingComposer,
          $$UnitsTableAnnotationComposer,
          $$UnitsTableCreateCompanionBuilder,
          $$UnitsTableUpdateCompanionBuilder,
          (Unit, $$UnitsTableReferences),
          Unit,
          PrefetchHooks Function({bool levelId, bool lessonsRefs})
        > {
  $$UnitsTableTableManager(_$AppDatabase db, $UnitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UnitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UnitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UnitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> levelId = const Value.absent(),
                Value<int> number = const Value.absent(),
                Value<String> nameFr = const Value.absent(),
                Value<String> nameEn = const Value.absent(),
              }) => UnitsCompanion(
                id: id,
                levelId: levelId,
                number: number,
                nameFr: nameFr,
                nameEn: nameEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int levelId,
                required int number,
                required String nameFr,
                required String nameEn,
              }) => UnitsCompanion.insert(
                id: id,
                levelId: levelId,
                number: number,
                nameFr: nameFr,
                nameEn: nameEn,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$UnitsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({levelId = false, lessonsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (lessonsRefs) db.lessons],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (levelId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.levelId,
                                referencedTable: $$UnitsTableReferences
                                    ._levelIdTable(db),
                                referencedColumn: $$UnitsTableReferences
                                    ._levelIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (lessonsRefs)
                    await $_getPrefetchedData<Unit, $UnitsTable, Lesson>(
                      currentTable: table,
                      referencedTable: $$UnitsTableReferences._lessonsRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$UnitsTableReferences(db, table, p0).lessonsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.unitId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$UnitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UnitsTable,
      Unit,
      $$UnitsTableFilterComposer,
      $$UnitsTableOrderingComposer,
      $$UnitsTableAnnotationComposer,
      $$UnitsTableCreateCompanionBuilder,
      $$UnitsTableUpdateCompanionBuilder,
      (Unit, $$UnitsTableReferences),
      Unit,
      PrefetchHooks Function({bool levelId, bool lessonsRefs})
    >;
typedef $$LessonsTableCreateCompanionBuilder =
    LessonsCompanion Function({
      Value<int> id,
      required int unitId,
      required int number,
      required String nameFr,
      required String nameEn,
      Value<String?> descriptionFr,
      Value<String?> descriptionEn,
    });
typedef $$LessonsTableUpdateCompanionBuilder =
    LessonsCompanion Function({
      Value<int> id,
      Value<int> unitId,
      Value<int> number,
      Value<String> nameFr,
      Value<String> nameEn,
      Value<String?> descriptionFr,
      Value<String?> descriptionEn,
    });

final class $$LessonsTableReferences
    extends BaseReferences<_$AppDatabase, $LessonsTable, Lesson> {
  $$LessonsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UnitsTable _unitIdTable(_$AppDatabase db) => db.units.createAlias(
    $_aliasNameGenerator(db.lessons.unitId, db.units.id),
  );

  $$UnitsTableProcessedTableManager get unitId {
    final $_column = $_itemColumn<int>('unit_id')!;

    final manager = $$UnitsTableTableManager(
      $_db,
      $_db.units,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_unitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$WordsTable, List<Word>> _wordsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.words,
    aliasName: $_aliasNameGenerator(db.lessons.id, db.words.lessonId),
  );

  $$WordsTableProcessedTableManager get wordsRefs {
    final manager = $$WordsTableTableManager(
      $_db,
      $_db.words,
    ).filter((f) => f.lessonId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_wordsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$VerbsTable, List<Verb>> _verbsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.verbs,
    aliasName: $_aliasNameGenerator(db.lessons.id, db.verbs.lessonId),
  );

  $$VerbsTableProcessedTableManager get verbsRefs {
    final manager = $$VerbsTableTableManager(
      $_db,
      $_db.verbs,
    ).filter((f) => f.lessonId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_verbsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LessonsTableFilterComposer
    extends Composer<_$AppDatabase, $LessonsTable> {
  $$LessonsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameFr => $composableBuilder(
    column: $table.nameFr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descriptionFr => $composableBuilder(
    column: $table.descriptionFr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descriptionEn => $composableBuilder(
    column: $table.descriptionEn,
    builder: (column) => ColumnFilters(column),
  );

  $$UnitsTableFilterComposer get unitId {
    final $$UnitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableFilterComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> wordsRefs(
    Expression<bool> Function($$WordsTableFilterComposer f) f,
  ) {
    final $$WordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.lessonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableFilterComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> verbsRefs(
    Expression<bool> Function($$VerbsTableFilterComposer f) f,
  ) {
    final $$VerbsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.verbs,
      getReferencedColumn: (t) => t.lessonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VerbsTableFilterComposer(
            $db: $db,
            $table: $db.verbs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LessonsTableOrderingComposer
    extends Composer<_$AppDatabase, $LessonsTable> {
  $$LessonsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameFr => $composableBuilder(
    column: $table.nameFr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descriptionFr => $composableBuilder(
    column: $table.descriptionFr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descriptionEn => $composableBuilder(
    column: $table.descriptionEn,
    builder: (column) => ColumnOrderings(column),
  );

  $$UnitsTableOrderingComposer get unitId {
    final $$UnitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableOrderingComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LessonsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LessonsTable> {
  $$LessonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<String> get nameFr =>
      $composableBuilder(column: $table.nameFr, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get descriptionFr => $composableBuilder(
    column: $table.descriptionFr,
    builder: (column) => column,
  );

  GeneratedColumn<String> get descriptionEn => $composableBuilder(
    column: $table.descriptionEn,
    builder: (column) => column,
  );

  $$UnitsTableAnnotationComposer get unitId {
    final $$UnitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableAnnotationComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> wordsRefs<T extends Object>(
    Expression<T> Function($$WordsTableAnnotationComposer a) f,
  ) {
    final $$WordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.lessonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableAnnotationComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> verbsRefs<T extends Object>(
    Expression<T> Function($$VerbsTableAnnotationComposer a) f,
  ) {
    final $$VerbsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.verbs,
      getReferencedColumn: (t) => t.lessonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VerbsTableAnnotationComposer(
            $db: $db,
            $table: $db.verbs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LessonsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LessonsTable,
          Lesson,
          $$LessonsTableFilterComposer,
          $$LessonsTableOrderingComposer,
          $$LessonsTableAnnotationComposer,
          $$LessonsTableCreateCompanionBuilder,
          $$LessonsTableUpdateCompanionBuilder,
          (Lesson, $$LessonsTableReferences),
          Lesson,
          PrefetchHooks Function({bool unitId, bool wordsRefs, bool verbsRefs})
        > {
  $$LessonsTableTableManager(_$AppDatabase db, $LessonsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LessonsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LessonsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LessonsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> unitId = const Value.absent(),
                Value<int> number = const Value.absent(),
                Value<String> nameFr = const Value.absent(),
                Value<String> nameEn = const Value.absent(),
                Value<String?> descriptionFr = const Value.absent(),
                Value<String?> descriptionEn = const Value.absent(),
              }) => LessonsCompanion(
                id: id,
                unitId: unitId,
                number: number,
                nameFr: nameFr,
                nameEn: nameEn,
                descriptionFr: descriptionFr,
                descriptionEn: descriptionEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int unitId,
                required int number,
                required String nameFr,
                required String nameEn,
                Value<String?> descriptionFr = const Value.absent(),
                Value<String?> descriptionEn = const Value.absent(),
              }) => LessonsCompanion.insert(
                id: id,
                unitId: unitId,
                number: number,
                nameFr: nameFr,
                nameEn: nameEn,
                descriptionFr: descriptionFr,
                descriptionEn: descriptionEn,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LessonsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({unitId = false, wordsRefs = false, verbsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (wordsRefs) db.words,
                    if (verbsRefs) db.verbs,
                  ],
                  addJoins:
                      <
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
                          dynamic
                        >
                      >(state) {
                        if (unitId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.unitId,
                                    referencedTable: $$LessonsTableReferences
                                        ._unitIdTable(db),
                                    referencedColumn: $$LessonsTableReferences
                                        ._unitIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (wordsRefs)
                        await $_getPrefetchedData<Lesson, $LessonsTable, Word>(
                          currentTable: table,
                          referencedTable: $$LessonsTableReferences
                              ._wordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LessonsTableReferences(db, table, p0).wordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.lessonId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (verbsRefs)
                        await $_getPrefetchedData<Lesson, $LessonsTable, Verb>(
                          currentTable: table,
                          referencedTable: $$LessonsTableReferences
                              ._verbsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LessonsTableReferences(db, table, p0).verbsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.lessonId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$LessonsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LessonsTable,
      Lesson,
      $$LessonsTableFilterComposer,
      $$LessonsTableOrderingComposer,
      $$LessonsTableAnnotationComposer,
      $$LessonsTableCreateCompanionBuilder,
      $$LessonsTableUpdateCompanionBuilder,
      (Lesson, $$LessonsTableReferences),
      Lesson,
      PrefetchHooks Function({bool unitId, bool wordsRefs, bool verbsRefs})
    >;
typedef $$WordsTableCreateCompanionBuilder =
    WordsCompanion Function({
      Value<int> id,
      required int lessonId,
      Value<String> contentType,
      required String arabic,
      required String translationFr,
      Value<String?> translationEn,
      Value<String?> grammaticalCategory,
      Value<String?> singular,
      Value<String?> plural,
      Value<String?> synonym,
      Value<String?> antonym,
      Value<String?> exampleSentence,
      Value<String?> audioPath,
      required int sortOrder,
    });
typedef $$WordsTableUpdateCompanionBuilder =
    WordsCompanion Function({
      Value<int> id,
      Value<int> lessonId,
      Value<String> contentType,
      Value<String> arabic,
      Value<String> translationFr,
      Value<String?> translationEn,
      Value<String?> grammaticalCategory,
      Value<String?> singular,
      Value<String?> plural,
      Value<String?> synonym,
      Value<String?> antonym,
      Value<String?> exampleSentence,
      Value<String?> audioPath,
      Value<int> sortOrder,
    });

final class $$WordsTableReferences
    extends BaseReferences<_$AppDatabase, $WordsTable, Word> {
  $$WordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LessonsTable _lessonIdTable(_$AppDatabase db) => db.lessons
      .createAlias($_aliasNameGenerator(db.words.lessonId, db.lessons.id));

  $$LessonsTableProcessedTableManager get lessonId {
    final $_column = $_itemColumn<int>('lesson_id')!;

    final manager = $$LessonsTableTableManager(
      $_db,
      $_db.lessons,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lessonIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WordsTableFilterComposer extends Composer<_$AppDatabase, $WordsTable> {
  $$WordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get arabic => $composableBuilder(
    column: $table.arabic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get translationFr => $composableBuilder(
    column: $table.translationFr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get translationEn => $composableBuilder(
    column: $table.translationEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get grammaticalCategory => $composableBuilder(
    column: $table.grammaticalCategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get singular => $composableBuilder(
    column: $table.singular,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get plural => $composableBuilder(
    column: $table.plural,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get synonym => $composableBuilder(
    column: $table.synonym,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get antonym => $composableBuilder(
    column: $table.antonym,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exampleSentence => $composableBuilder(
    column: $table.exampleSentence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioPath => $composableBuilder(
    column: $table.audioPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$LessonsTableFilterComposer get lessonId {
    final $$LessonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.lessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonsTableFilterComposer(
            $db: $db,
            $table: $db.lessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WordsTableOrderingComposer
    extends Composer<_$AppDatabase, $WordsTable> {
  $$WordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get arabic => $composableBuilder(
    column: $table.arabic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get translationFr => $composableBuilder(
    column: $table.translationFr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get translationEn => $composableBuilder(
    column: $table.translationEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get grammaticalCategory => $composableBuilder(
    column: $table.grammaticalCategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get singular => $composableBuilder(
    column: $table.singular,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get plural => $composableBuilder(
    column: $table.plural,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get synonym => $composableBuilder(
    column: $table.synonym,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get antonym => $composableBuilder(
    column: $table.antonym,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exampleSentence => $composableBuilder(
    column: $table.exampleSentence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioPath => $composableBuilder(
    column: $table.audioPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$LessonsTableOrderingComposer get lessonId {
    final $$LessonsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.lessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonsTableOrderingComposer(
            $db: $db,
            $table: $db.lessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WordsTable> {
  $$WordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get arabic =>
      $composableBuilder(column: $table.arabic, builder: (column) => column);

  GeneratedColumn<String> get translationFr => $composableBuilder(
    column: $table.translationFr,
    builder: (column) => column,
  );

  GeneratedColumn<String> get translationEn => $composableBuilder(
    column: $table.translationEn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get grammaticalCategory => $composableBuilder(
    column: $table.grammaticalCategory,
    builder: (column) => column,
  );

  GeneratedColumn<String> get singular =>
      $composableBuilder(column: $table.singular, builder: (column) => column);

  GeneratedColumn<String> get plural =>
      $composableBuilder(column: $table.plural, builder: (column) => column);

  GeneratedColumn<String> get synonym =>
      $composableBuilder(column: $table.synonym, builder: (column) => column);

  GeneratedColumn<String> get antonym =>
      $composableBuilder(column: $table.antonym, builder: (column) => column);

  GeneratedColumn<String> get exampleSentence => $composableBuilder(
    column: $table.exampleSentence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get audioPath =>
      $composableBuilder(column: $table.audioPath, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$LessonsTableAnnotationComposer get lessonId {
    final $$LessonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.lessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonsTableAnnotationComposer(
            $db: $db,
            $table: $db.lessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WordsTable,
          Word,
          $$WordsTableFilterComposer,
          $$WordsTableOrderingComposer,
          $$WordsTableAnnotationComposer,
          $$WordsTableCreateCompanionBuilder,
          $$WordsTableUpdateCompanionBuilder,
          (Word, $$WordsTableReferences),
          Word,
          PrefetchHooks Function({bool lessonId})
        > {
  $$WordsTableTableManager(_$AppDatabase db, $WordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> lessonId = const Value.absent(),
                Value<String> contentType = const Value.absent(),
                Value<String> arabic = const Value.absent(),
                Value<String> translationFr = const Value.absent(),
                Value<String?> translationEn = const Value.absent(),
                Value<String?> grammaticalCategory = const Value.absent(),
                Value<String?> singular = const Value.absent(),
                Value<String?> plural = const Value.absent(),
                Value<String?> synonym = const Value.absent(),
                Value<String?> antonym = const Value.absent(),
                Value<String?> exampleSentence = const Value.absent(),
                Value<String?> audioPath = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => WordsCompanion(
                id: id,
                lessonId: lessonId,
                contentType: contentType,
                arabic: arabic,
                translationFr: translationFr,
                translationEn: translationEn,
                grammaticalCategory: grammaticalCategory,
                singular: singular,
                plural: plural,
                synonym: synonym,
                antonym: antonym,
                exampleSentence: exampleSentence,
                audioPath: audioPath,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int lessonId,
                Value<String> contentType = const Value.absent(),
                required String arabic,
                required String translationFr,
                Value<String?> translationEn = const Value.absent(),
                Value<String?> grammaticalCategory = const Value.absent(),
                Value<String?> singular = const Value.absent(),
                Value<String?> plural = const Value.absent(),
                Value<String?> synonym = const Value.absent(),
                Value<String?> antonym = const Value.absent(),
                Value<String?> exampleSentence = const Value.absent(),
                Value<String?> audioPath = const Value.absent(),
                required int sortOrder,
              }) => WordsCompanion.insert(
                id: id,
                lessonId: lessonId,
                contentType: contentType,
                arabic: arabic,
                translationFr: translationFr,
                translationEn: translationEn,
                grammaticalCategory: grammaticalCategory,
                singular: singular,
                plural: plural,
                synonym: synonym,
                antonym: antonym,
                exampleSentence: exampleSentence,
                audioPath: audioPath,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$WordsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({lessonId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (lessonId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.lessonId,
                                referencedTable: $$WordsTableReferences
                                    ._lessonIdTable(db),
                                referencedColumn: $$WordsTableReferences
                                    ._lessonIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WordsTable,
      Word,
      $$WordsTableFilterComposer,
      $$WordsTableOrderingComposer,
      $$WordsTableAnnotationComposer,
      $$WordsTableCreateCompanionBuilder,
      $$WordsTableUpdateCompanionBuilder,
      (Word, $$WordsTableReferences),
      Word,
      PrefetchHooks Function({bool lessonId})
    >;
typedef $$VerbsTableCreateCompanionBuilder =
    VerbsCompanion Function({
      Value<int> id,
      required int lessonId,
      Value<String> contentType,
      required String masdar,
      required String past,
      required String present,
      required String imperative,
      required String translationFr,
      Value<String?> translationEn,
      Value<String?> exampleSentence,
      Value<String?> audioPathMasdar,
      Value<String?> audioPathPast,
      Value<String?> audioPathPresent,
      Value<String?> audioPathImperative,
      required int sortOrder,
    });
typedef $$VerbsTableUpdateCompanionBuilder =
    VerbsCompanion Function({
      Value<int> id,
      Value<int> lessonId,
      Value<String> contentType,
      Value<String> masdar,
      Value<String> past,
      Value<String> present,
      Value<String> imperative,
      Value<String> translationFr,
      Value<String?> translationEn,
      Value<String?> exampleSentence,
      Value<String?> audioPathMasdar,
      Value<String?> audioPathPast,
      Value<String?> audioPathPresent,
      Value<String?> audioPathImperative,
      Value<int> sortOrder,
    });

final class $$VerbsTableReferences
    extends BaseReferences<_$AppDatabase, $VerbsTable, Verb> {
  $$VerbsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LessonsTable _lessonIdTable(_$AppDatabase db) => db.lessons
      .createAlias($_aliasNameGenerator(db.verbs.lessonId, db.lessons.id));

  $$LessonsTableProcessedTableManager get lessonId {
    final $_column = $_itemColumn<int>('lesson_id')!;

    final manager = $$LessonsTableTableManager(
      $_db,
      $_db.lessons,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lessonIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$VerbsTableFilterComposer extends Composer<_$AppDatabase, $VerbsTable> {
  $$VerbsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get masdar => $composableBuilder(
    column: $table.masdar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get past => $composableBuilder(
    column: $table.past,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get present => $composableBuilder(
    column: $table.present,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imperative => $composableBuilder(
    column: $table.imperative,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get translationFr => $composableBuilder(
    column: $table.translationFr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get translationEn => $composableBuilder(
    column: $table.translationEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exampleSentence => $composableBuilder(
    column: $table.exampleSentence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioPathMasdar => $composableBuilder(
    column: $table.audioPathMasdar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioPathPast => $composableBuilder(
    column: $table.audioPathPast,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioPathPresent => $composableBuilder(
    column: $table.audioPathPresent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioPathImperative => $composableBuilder(
    column: $table.audioPathImperative,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$LessonsTableFilterComposer get lessonId {
    final $$LessonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.lessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonsTableFilterComposer(
            $db: $db,
            $table: $db.lessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VerbsTableOrderingComposer
    extends Composer<_$AppDatabase, $VerbsTable> {
  $$VerbsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get masdar => $composableBuilder(
    column: $table.masdar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get past => $composableBuilder(
    column: $table.past,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get present => $composableBuilder(
    column: $table.present,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imperative => $composableBuilder(
    column: $table.imperative,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get translationFr => $composableBuilder(
    column: $table.translationFr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get translationEn => $composableBuilder(
    column: $table.translationEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exampleSentence => $composableBuilder(
    column: $table.exampleSentence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioPathMasdar => $composableBuilder(
    column: $table.audioPathMasdar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioPathPast => $composableBuilder(
    column: $table.audioPathPast,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioPathPresent => $composableBuilder(
    column: $table.audioPathPresent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioPathImperative => $composableBuilder(
    column: $table.audioPathImperative,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$LessonsTableOrderingComposer get lessonId {
    final $$LessonsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.lessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonsTableOrderingComposer(
            $db: $db,
            $table: $db.lessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VerbsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VerbsTable> {
  $$VerbsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get masdar =>
      $composableBuilder(column: $table.masdar, builder: (column) => column);

  GeneratedColumn<String> get past =>
      $composableBuilder(column: $table.past, builder: (column) => column);

  GeneratedColumn<String> get present =>
      $composableBuilder(column: $table.present, builder: (column) => column);

  GeneratedColumn<String> get imperative => $composableBuilder(
    column: $table.imperative,
    builder: (column) => column,
  );

  GeneratedColumn<String> get translationFr => $composableBuilder(
    column: $table.translationFr,
    builder: (column) => column,
  );

  GeneratedColumn<String> get translationEn => $composableBuilder(
    column: $table.translationEn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exampleSentence => $composableBuilder(
    column: $table.exampleSentence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get audioPathMasdar => $composableBuilder(
    column: $table.audioPathMasdar,
    builder: (column) => column,
  );

  GeneratedColumn<String> get audioPathPast => $composableBuilder(
    column: $table.audioPathPast,
    builder: (column) => column,
  );

  GeneratedColumn<String> get audioPathPresent => $composableBuilder(
    column: $table.audioPathPresent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get audioPathImperative => $composableBuilder(
    column: $table.audioPathImperative,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$LessonsTableAnnotationComposer get lessonId {
    final $$LessonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.lessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonsTableAnnotationComposer(
            $db: $db,
            $table: $db.lessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VerbsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VerbsTable,
          Verb,
          $$VerbsTableFilterComposer,
          $$VerbsTableOrderingComposer,
          $$VerbsTableAnnotationComposer,
          $$VerbsTableCreateCompanionBuilder,
          $$VerbsTableUpdateCompanionBuilder,
          (Verb, $$VerbsTableReferences),
          Verb,
          PrefetchHooks Function({bool lessonId})
        > {
  $$VerbsTableTableManager(_$AppDatabase db, $VerbsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VerbsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VerbsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VerbsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> lessonId = const Value.absent(),
                Value<String> contentType = const Value.absent(),
                Value<String> masdar = const Value.absent(),
                Value<String> past = const Value.absent(),
                Value<String> present = const Value.absent(),
                Value<String> imperative = const Value.absent(),
                Value<String> translationFr = const Value.absent(),
                Value<String?> translationEn = const Value.absent(),
                Value<String?> exampleSentence = const Value.absent(),
                Value<String?> audioPathMasdar = const Value.absent(),
                Value<String?> audioPathPast = const Value.absent(),
                Value<String?> audioPathPresent = const Value.absent(),
                Value<String?> audioPathImperative = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => VerbsCompanion(
                id: id,
                lessonId: lessonId,
                contentType: contentType,
                masdar: masdar,
                past: past,
                present: present,
                imperative: imperative,
                translationFr: translationFr,
                translationEn: translationEn,
                exampleSentence: exampleSentence,
                audioPathMasdar: audioPathMasdar,
                audioPathPast: audioPathPast,
                audioPathPresent: audioPathPresent,
                audioPathImperative: audioPathImperative,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int lessonId,
                Value<String> contentType = const Value.absent(),
                required String masdar,
                required String past,
                required String present,
                required String imperative,
                required String translationFr,
                Value<String?> translationEn = const Value.absent(),
                Value<String?> exampleSentence = const Value.absent(),
                Value<String?> audioPathMasdar = const Value.absent(),
                Value<String?> audioPathPast = const Value.absent(),
                Value<String?> audioPathPresent = const Value.absent(),
                Value<String?> audioPathImperative = const Value.absent(),
                required int sortOrder,
              }) => VerbsCompanion.insert(
                id: id,
                lessonId: lessonId,
                contentType: contentType,
                masdar: masdar,
                past: past,
                present: present,
                imperative: imperative,
                translationFr: translationFr,
                translationEn: translationEn,
                exampleSentence: exampleSentence,
                audioPathMasdar: audioPathMasdar,
                audioPathPast: audioPathPast,
                audioPathPresent: audioPathPresent,
                audioPathImperative: audioPathImperative,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$VerbsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({lessonId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (lessonId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.lessonId,
                                referencedTable: $$VerbsTableReferences
                                    ._lessonIdTable(db),
                                referencedColumn: $$VerbsTableReferences
                                    ._lessonIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$VerbsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VerbsTable,
      Verb,
      $$VerbsTableFilterComposer,
      $$VerbsTableOrderingComposer,
      $$VerbsTableAnnotationComposer,
      $$VerbsTableCreateCompanionBuilder,
      $$VerbsTableUpdateCompanionBuilder,
      (Verb, $$VerbsTableReferences),
      Verb,
      PrefetchHooks Function({bool lessonId})
    >;
typedef $$ErrorReportsTableCreateCompanionBuilder =
    ErrorReportsCompanion Function({
      Value<int> id,
      required int itemId,
      required String contentType,
      required String category,
      Value<String?> comment,
      Value<DateTime> createdAt,
    });
typedef $$ErrorReportsTableUpdateCompanionBuilder =
    ErrorReportsCompanion Function({
      Value<int> id,
      Value<int> itemId,
      Value<String> contentType,
      Value<String> category,
      Value<String?> comment,
      Value<DateTime> createdAt,
    });

class $$ErrorReportsTableFilterComposer
    extends Composer<_$AppDatabase, $ErrorReportsTable> {
  $$ErrorReportsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ErrorReportsTableOrderingComposer
    extends Composer<_$AppDatabase, $ErrorReportsTable> {
  $$ErrorReportsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ErrorReportsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ErrorReportsTable> {
  $$ErrorReportsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get comment =>
      $composableBuilder(column: $table.comment, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ErrorReportsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ErrorReportsTable,
          ErrorReport,
          $$ErrorReportsTableFilterComposer,
          $$ErrorReportsTableOrderingComposer,
          $$ErrorReportsTableAnnotationComposer,
          $$ErrorReportsTableCreateCompanionBuilder,
          $$ErrorReportsTableUpdateCompanionBuilder,
          (
            ErrorReport,
            BaseReferences<_$AppDatabase, $ErrorReportsTable, ErrorReport>,
          ),
          ErrorReport,
          PrefetchHooks Function()
        > {
  $$ErrorReportsTableTableManager(_$AppDatabase db, $ErrorReportsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ErrorReportsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ErrorReportsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ErrorReportsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> itemId = const Value.absent(),
                Value<String> contentType = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String?> comment = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ErrorReportsCompanion(
                id: id,
                itemId: itemId,
                contentType: contentType,
                category: category,
                comment: comment,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int itemId,
                required String contentType,
                required String category,
                Value<String?> comment = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ErrorReportsCompanion.insert(
                id: id,
                itemId: itemId,
                contentType: contentType,
                category: category,
                comment: comment,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ErrorReportsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ErrorReportsTable,
      ErrorReport,
      $$ErrorReportsTableFilterComposer,
      $$ErrorReportsTableOrderingComposer,
      $$ErrorReportsTableAnnotationComposer,
      $$ErrorReportsTableCreateCompanionBuilder,
      $$ErrorReportsTableUpdateCompanionBuilder,
      (
        ErrorReport,
        BaseReferences<_$AppDatabase, $ErrorReportsTable, ErrorReport>,
      ),
      ErrorReport,
      PrefetchHooks Function()
    >;
typedef $$UserProgressTableCreateCompanionBuilder =
    UserProgressCompanion Function({
      Value<int> id,
      required int itemId,
      required String contentType,
      Value<double> stability,
      Value<double> difficulty,
      Value<String> state,
      Value<DateTime?> lastReview,
      Value<DateTime?> nextReview,
      Value<int> reviewCount,
      Value<int> elapsedDays,
      Value<int> scheduledDays,
      Value<int> reps,
    });
typedef $$UserProgressTableUpdateCompanionBuilder =
    UserProgressCompanion Function({
      Value<int> id,
      Value<int> itemId,
      Value<String> contentType,
      Value<double> stability,
      Value<double> difficulty,
      Value<String> state,
      Value<DateTime?> lastReview,
      Value<DateTime?> nextReview,
      Value<int> reviewCount,
      Value<int> elapsedDays,
      Value<int> scheduledDays,
      Value<int> reps,
    });

class $$UserProgressTableFilterComposer
    extends Composer<_$AppDatabase, $UserProgressTable> {
  $$UserProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get stability => $composableBuilder(
    column: $table.stability,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastReview => $composableBuilder(
    column: $table.lastReview,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextReview => $composableBuilder(
    column: $table.nextReview,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reviewCount => $composableBuilder(
    column: $table.reviewCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get elapsedDays => $composableBuilder(
    column: $table.elapsedDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get scheduledDays => $composableBuilder(
    column: $table.scheduledDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProgressTable> {
  $$UserProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get stability => $composableBuilder(
    column: $table.stability,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastReview => $composableBuilder(
    column: $table.lastReview,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextReview => $composableBuilder(
    column: $table.nextReview,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reviewCount => $composableBuilder(
    column: $table.reviewCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get elapsedDays => $composableBuilder(
    column: $table.elapsedDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get scheduledDays => $composableBuilder(
    column: $table.scheduledDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProgressTable> {
  $$UserProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => column,
  );

  GeneratedColumn<double> get stability =>
      $composableBuilder(column: $table.stability, builder: (column) => column);

  GeneratedColumn<double> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<DateTime> get lastReview => $composableBuilder(
    column: $table.lastReview,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get nextReview => $composableBuilder(
    column: $table.nextReview,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reviewCount => $composableBuilder(
    column: $table.reviewCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get elapsedDays => $composableBuilder(
    column: $table.elapsedDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get scheduledDays => $composableBuilder(
    column: $table.scheduledDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);
}

class $$UserProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProgressTable,
          UserProgressData,
          $$UserProgressTableFilterComposer,
          $$UserProgressTableOrderingComposer,
          $$UserProgressTableAnnotationComposer,
          $$UserProgressTableCreateCompanionBuilder,
          $$UserProgressTableUpdateCompanionBuilder,
          (
            UserProgressData,
            BaseReferences<_$AppDatabase, $UserProgressTable, UserProgressData>,
          ),
          UserProgressData,
          PrefetchHooks Function()
        > {
  $$UserProgressTableTableManager(_$AppDatabase db, $UserProgressTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> itemId = const Value.absent(),
                Value<String> contentType = const Value.absent(),
                Value<double> stability = const Value.absent(),
                Value<double> difficulty = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<DateTime?> lastReview = const Value.absent(),
                Value<DateTime?> nextReview = const Value.absent(),
                Value<int> reviewCount = const Value.absent(),
                Value<int> elapsedDays = const Value.absent(),
                Value<int> scheduledDays = const Value.absent(),
                Value<int> reps = const Value.absent(),
              }) => UserProgressCompanion(
                id: id,
                itemId: itemId,
                contentType: contentType,
                stability: stability,
                difficulty: difficulty,
                state: state,
                lastReview: lastReview,
                nextReview: nextReview,
                reviewCount: reviewCount,
                elapsedDays: elapsedDays,
                scheduledDays: scheduledDays,
                reps: reps,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int itemId,
                required String contentType,
                Value<double> stability = const Value.absent(),
                Value<double> difficulty = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<DateTime?> lastReview = const Value.absent(),
                Value<DateTime?> nextReview = const Value.absent(),
                Value<int> reviewCount = const Value.absent(),
                Value<int> elapsedDays = const Value.absent(),
                Value<int> scheduledDays = const Value.absent(),
                Value<int> reps = const Value.absent(),
              }) => UserProgressCompanion.insert(
                id: id,
                itemId: itemId,
                contentType: contentType,
                stability: stability,
                difficulty: difficulty,
                state: state,
                lastReview: lastReview,
                nextReview: nextReview,
                reviewCount: reviewCount,
                elapsedDays: elapsedDays,
                scheduledDays: scheduledDays,
                reps: reps,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProgressTable,
      UserProgressData,
      $$UserProgressTableFilterComposer,
      $$UserProgressTableOrderingComposer,
      $$UserProgressTableAnnotationComposer,
      $$UserProgressTableCreateCompanionBuilder,
      $$UserProgressTableUpdateCompanionBuilder,
      (
        UserProgressData,
        BaseReferences<_$AppDatabase, $UserProgressTable, UserProgressData>,
      ),
      UserProgressData,
      PrefetchHooks Function()
    >;
typedef $$SessionsTableCreateCompanionBuilder =
    SessionsCompanion Function({
      Value<int> id,
      required String sessionType,
      required DateTime startedAt,
      Value<DateTime?> completedAt,
      Value<int> itemsReviewed,
      Value<String?> resultsJson,
    });
typedef $$SessionsTableUpdateCompanionBuilder =
    SessionsCompanion Function({
      Value<int> id,
      Value<String> sessionType,
      Value<DateTime> startedAt,
      Value<DateTime?> completedAt,
      Value<int> itemsReviewed,
      Value<String?> resultsJson,
    });

class $$SessionsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionType => $composableBuilder(
    column: $table.sessionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get itemsReviewed => $composableBuilder(
    column: $table.itemsReviewed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get resultsJson => $composableBuilder(
    column: $table.resultsJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionType => $composableBuilder(
    column: $table.sessionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get itemsReviewed => $composableBuilder(
    column: $table.itemsReviewed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resultsJson => $composableBuilder(
    column: $table.resultsJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sessionType => $composableBuilder(
    column: $table.sessionType,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get itemsReviewed => $composableBuilder(
    column: $table.itemsReviewed,
    builder: (column) => column,
  );

  GeneratedColumn<String> get resultsJson => $composableBuilder(
    column: $table.resultsJson,
    builder: (column) => column,
  );
}

class $$SessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionsTable,
          Session,
          $$SessionsTableFilterComposer,
          $$SessionsTableOrderingComposer,
          $$SessionsTableAnnotationComposer,
          $$SessionsTableCreateCompanionBuilder,
          $$SessionsTableUpdateCompanionBuilder,
          (Session, BaseReferences<_$AppDatabase, $SessionsTable, Session>),
          Session,
          PrefetchHooks Function()
        > {
  $$SessionsTableTableManager(_$AppDatabase db, $SessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> sessionType = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> itemsReviewed = const Value.absent(),
                Value<String?> resultsJson = const Value.absent(),
              }) => SessionsCompanion(
                id: id,
                sessionType: sessionType,
                startedAt: startedAt,
                completedAt: completedAt,
                itemsReviewed: itemsReviewed,
                resultsJson: resultsJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String sessionType,
                required DateTime startedAt,
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> itemsReviewed = const Value.absent(),
                Value<String?> resultsJson = const Value.absent(),
              }) => SessionsCompanion.insert(
                id: id,
                sessionType: sessionType,
                startedAt: startedAt,
                completedAt: completedAt,
                itemsReviewed: itemsReviewed,
                resultsJson: resultsJson,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionsTable,
      Session,
      $$SessionsTableFilterComposer,
      $$SessionsTableOrderingComposer,
      $$SessionsTableAnnotationComposer,
      $$SessionsTableCreateCompanionBuilder,
      $$SessionsTableUpdateCompanionBuilder,
      (Session, BaseReferences<_$AppDatabase, $SessionsTable, Session>),
      Session,
      PrefetchHooks Function()
    >;
typedef $$StreaksTableCreateCompanionBuilder =
    StreaksCompanion Function({
      Value<int> id,
      Value<int> currentStreak,
      Value<int> longestStreak,
      required DateTime lastActivityDate,
      Value<bool> freezeAvailable,
      Value<DateTime?> freezeUsedDate,
    });
typedef $$StreaksTableUpdateCompanionBuilder =
    StreaksCompanion Function({
      Value<int> id,
      Value<int> currentStreak,
      Value<int> longestStreak,
      Value<DateTime> lastActivityDate,
      Value<bool> freezeAvailable,
      Value<DateTime?> freezeUsedDate,
    });

class $$StreaksTableFilterComposer
    extends Composer<_$AppDatabase, $StreaksTable> {
  $$StreaksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get longestStreak => $composableBuilder(
    column: $table.longestStreak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastActivityDate => $composableBuilder(
    column: $table.lastActivityDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get freezeAvailable => $composableBuilder(
    column: $table.freezeAvailable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get freezeUsedDate => $composableBuilder(
    column: $table.freezeUsedDate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StreaksTableOrderingComposer
    extends Composer<_$AppDatabase, $StreaksTable> {
  $$StreaksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get longestStreak => $composableBuilder(
    column: $table.longestStreak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastActivityDate => $composableBuilder(
    column: $table.lastActivityDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get freezeAvailable => $composableBuilder(
    column: $table.freezeAvailable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get freezeUsedDate => $composableBuilder(
    column: $table.freezeUsedDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StreaksTableAnnotationComposer
    extends Composer<_$AppDatabase, $StreaksTable> {
  $$StreaksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
    builder: (column) => column,
  );

  GeneratedColumn<int> get longestStreak => $composableBuilder(
    column: $table.longestStreak,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastActivityDate => $composableBuilder(
    column: $table.lastActivityDate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get freezeAvailable => $composableBuilder(
    column: $table.freezeAvailable,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get freezeUsedDate => $composableBuilder(
    column: $table.freezeUsedDate,
    builder: (column) => column,
  );
}

class $$StreaksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StreaksTable,
          Streak,
          $$StreaksTableFilterComposer,
          $$StreaksTableOrderingComposer,
          $$StreaksTableAnnotationComposer,
          $$StreaksTableCreateCompanionBuilder,
          $$StreaksTableUpdateCompanionBuilder,
          (Streak, BaseReferences<_$AppDatabase, $StreaksTable, Streak>),
          Streak,
          PrefetchHooks Function()
        > {
  $$StreaksTableTableManager(_$AppDatabase db, $StreaksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StreaksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StreaksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StreaksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> currentStreak = const Value.absent(),
                Value<int> longestStreak = const Value.absent(),
                Value<DateTime> lastActivityDate = const Value.absent(),
                Value<bool> freezeAvailable = const Value.absent(),
                Value<DateTime?> freezeUsedDate = const Value.absent(),
              }) => StreaksCompanion(
                id: id,
                currentStreak: currentStreak,
                longestStreak: longestStreak,
                lastActivityDate: lastActivityDate,
                freezeAvailable: freezeAvailable,
                freezeUsedDate: freezeUsedDate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> currentStreak = const Value.absent(),
                Value<int> longestStreak = const Value.absent(),
                required DateTime lastActivityDate,
                Value<bool> freezeAvailable = const Value.absent(),
                Value<DateTime?> freezeUsedDate = const Value.absent(),
              }) => StreaksCompanion.insert(
                id: id,
                currentStreak: currentStreak,
                longestStreak: longestStreak,
                lastActivityDate: lastActivityDate,
                freezeAvailable: freezeAvailable,
                freezeUsedDate: freezeUsedDate,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StreaksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StreaksTable,
      Streak,
      $$StreaksTableFilterComposer,
      $$StreaksTableOrderingComposer,
      $$StreaksTableAnnotationComposer,
      $$StreaksTableCreateCompanionBuilder,
      $$StreaksTableUpdateCompanionBuilder,
      (Streak, BaseReferences<_$AppDatabase, $StreaksTable, Streak>),
      Streak,
      PrefetchHooks Function()
    >;
typedef $$BadgesTableCreateCompanionBuilder =
    BadgesCompanion Function({
      Value<int> id,
      required String badgeType,
      Value<DateTime?> unlockedAt,
      Value<bool> displayed,
    });
typedef $$BadgesTableUpdateCompanionBuilder =
    BadgesCompanion Function({
      Value<int> id,
      Value<String> badgeType,
      Value<DateTime?> unlockedAt,
      Value<bool> displayed,
    });

class $$BadgesTableFilterComposer
    extends Composer<_$AppDatabase, $BadgesTable> {
  $$BadgesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get badgeType => $composableBuilder(
    column: $table.badgeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get displayed => $composableBuilder(
    column: $table.displayed,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BadgesTableOrderingComposer
    extends Composer<_$AppDatabase, $BadgesTable> {
  $$BadgesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get badgeType => $composableBuilder(
    column: $table.badgeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get displayed => $composableBuilder(
    column: $table.displayed,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BadgesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BadgesTable> {
  $$BadgesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get badgeType =>
      $composableBuilder(column: $table.badgeType, builder: (column) => column);

  GeneratedColumn<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get displayed =>
      $composableBuilder(column: $table.displayed, builder: (column) => column);
}

class $$BadgesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BadgesTable,
          Badge,
          $$BadgesTableFilterComposer,
          $$BadgesTableOrderingComposer,
          $$BadgesTableAnnotationComposer,
          $$BadgesTableCreateCompanionBuilder,
          $$BadgesTableUpdateCompanionBuilder,
          (Badge, BaseReferences<_$AppDatabase, $BadgesTable, Badge>),
          Badge,
          PrefetchHooks Function()
        > {
  $$BadgesTableTableManager(_$AppDatabase db, $BadgesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BadgesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BadgesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BadgesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> badgeType = const Value.absent(),
                Value<DateTime?> unlockedAt = const Value.absent(),
                Value<bool> displayed = const Value.absent(),
              }) => BadgesCompanion(
                id: id,
                badgeType: badgeType,
                unlockedAt: unlockedAt,
                displayed: displayed,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String badgeType,
                Value<DateTime?> unlockedAt = const Value.absent(),
                Value<bool> displayed = const Value.absent(),
              }) => BadgesCompanion.insert(
                id: id,
                badgeType: badgeType,
                unlockedAt: unlockedAt,
                displayed: displayed,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BadgesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BadgesTable,
      Badge,
      $$BadgesTableFilterComposer,
      $$BadgesTableOrderingComposer,
      $$BadgesTableAnnotationComposer,
      $$BadgesTableCreateCompanionBuilder,
      $$BadgesTableUpdateCompanionBuilder,
      (Badge, BaseReferences<_$AppDatabase, $BadgesTable, Badge>),
      Badge,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LevelsTableTableManager get levels =>
      $$LevelsTableTableManager(_db, _db.levels);
  $$UnitsTableTableManager get units =>
      $$UnitsTableTableManager(_db, _db.units);
  $$LessonsTableTableManager get lessons =>
      $$LessonsTableTableManager(_db, _db.lessons);
  $$WordsTableTableManager get words =>
      $$WordsTableTableManager(_db, _db.words);
  $$VerbsTableTableManager get verbs =>
      $$VerbsTableTableManager(_db, _db.verbs);
  $$ErrorReportsTableTableManager get errorReports =>
      $$ErrorReportsTableTableManager(_db, _db.errorReports);
  $$UserProgressTableTableManager get userProgress =>
      $$UserProgressTableTableManager(_db, _db.userProgress);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$StreaksTableTableManager get streaks =>
      $$StreaksTableTableManager(_db, _db.streaks);
  $$BadgesTableTableManager get badges =>
      $$BadgesTableTableManager(_db, _db.badges);
}
