// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $VaultMetasTable extends VaultMetas
    with TableInfo<$VaultMetasTable, VaultMeta> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VaultMetasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _saltMeta = const VerificationMeta('salt');
  @override
  late final GeneratedColumn<Uint8List> salt = GeneratedColumn<Uint8List>(
    'salt',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _verifierCiphertextMeta =
      const VerificationMeta('verifierCiphertext');
  @override
  late final GeneratedColumn<Uint8List> verifierCiphertext =
      GeneratedColumn<Uint8List>(
        'verifier_ciphertext',
        aliasedName,
        false,
        type: DriftSqlType.blob,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _verifierNonceMeta = const VerificationMeta(
    'verifierNonce',
  );
  @override
  late final GeneratedColumn<Uint8List> verifierNonce =
      GeneratedColumn<Uint8List>(
        'verifier_nonce',
        aliasedName,
        false,
        type: DriftSqlType.blob,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _verifierMacMeta = const VerificationMeta(
    'verifierMac',
  );
  @override
  late final GeneratedColumn<Uint8List> verifierMac =
      GeneratedColumn<Uint8List>(
        'verifier_mac',
        aliasedName,
        false,
        type: DriftSqlType.blob,
        requiredDuringInsert: true,
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
    salt,
    verifierCiphertext,
    verifierNonce,
    verifierMac,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vault_metas';
  @override
  VerificationContext validateIntegrity(
    Insertable<VaultMeta> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('salt')) {
      context.handle(
        _saltMeta,
        salt.isAcceptableOrUnknown(data['salt']!, _saltMeta),
      );
    } else if (isInserting) {
      context.missing(_saltMeta);
    }
    if (data.containsKey('verifier_ciphertext')) {
      context.handle(
        _verifierCiphertextMeta,
        verifierCiphertext.isAcceptableOrUnknown(
          data['verifier_ciphertext']!,
          _verifierCiphertextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_verifierCiphertextMeta);
    }
    if (data.containsKey('verifier_nonce')) {
      context.handle(
        _verifierNonceMeta,
        verifierNonce.isAcceptableOrUnknown(
          data['verifier_nonce']!,
          _verifierNonceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_verifierNonceMeta);
    }
    if (data.containsKey('verifier_mac')) {
      context.handle(
        _verifierMacMeta,
        verifierMac.isAcceptableOrUnknown(
          data['verifier_mac']!,
          _verifierMacMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_verifierMacMeta);
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
  VaultMeta map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VaultMeta(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      salt: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}salt'],
      )!,
      verifierCiphertext: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}verifier_ciphertext'],
      )!,
      verifierNonce: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}verifier_nonce'],
      )!,
      verifierMac: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}verifier_mac'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $VaultMetasTable createAlias(String alias) {
    return $VaultMetasTable(attachedDatabase, alias);
  }
}

class VaultMeta extends DataClass implements Insertable<VaultMeta> {
  final int id;
  final Uint8List salt;
  final Uint8List verifierCiphertext;
  final Uint8List verifierNonce;
  final Uint8List verifierMac;
  final DateTime createdAt;
  const VaultMeta({
    required this.id,
    required this.salt,
    required this.verifierCiphertext,
    required this.verifierNonce,
    required this.verifierMac,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['salt'] = Variable<Uint8List>(salt);
    map['verifier_ciphertext'] = Variable<Uint8List>(verifierCiphertext);
    map['verifier_nonce'] = Variable<Uint8List>(verifierNonce);
    map['verifier_mac'] = Variable<Uint8List>(verifierMac);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  VaultMetasCompanion toCompanion(bool nullToAbsent) {
    return VaultMetasCompanion(
      id: Value(id),
      salt: Value(salt),
      verifierCiphertext: Value(verifierCiphertext),
      verifierNonce: Value(verifierNonce),
      verifierMac: Value(verifierMac),
      createdAt: Value(createdAt),
    );
  }

  factory VaultMeta.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VaultMeta(
      id: serializer.fromJson<int>(json['id']),
      salt: serializer.fromJson<Uint8List>(json['salt']),
      verifierCiphertext: serializer.fromJson<Uint8List>(
        json['verifierCiphertext'],
      ),
      verifierNonce: serializer.fromJson<Uint8List>(json['verifierNonce']),
      verifierMac: serializer.fromJson<Uint8List>(json['verifierMac']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'salt': serializer.toJson<Uint8List>(salt),
      'verifierCiphertext': serializer.toJson<Uint8List>(verifierCiphertext),
      'verifierNonce': serializer.toJson<Uint8List>(verifierNonce),
      'verifierMac': serializer.toJson<Uint8List>(verifierMac),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  VaultMeta copyWith({
    int? id,
    Uint8List? salt,
    Uint8List? verifierCiphertext,
    Uint8List? verifierNonce,
    Uint8List? verifierMac,
    DateTime? createdAt,
  }) => VaultMeta(
    id: id ?? this.id,
    salt: salt ?? this.salt,
    verifierCiphertext: verifierCiphertext ?? this.verifierCiphertext,
    verifierNonce: verifierNonce ?? this.verifierNonce,
    verifierMac: verifierMac ?? this.verifierMac,
    createdAt: createdAt ?? this.createdAt,
  );
  VaultMeta copyWithCompanion(VaultMetasCompanion data) {
    return VaultMeta(
      id: data.id.present ? data.id.value : this.id,
      salt: data.salt.present ? data.salt.value : this.salt,
      verifierCiphertext: data.verifierCiphertext.present
          ? data.verifierCiphertext.value
          : this.verifierCiphertext,
      verifierNonce: data.verifierNonce.present
          ? data.verifierNonce.value
          : this.verifierNonce,
      verifierMac: data.verifierMac.present
          ? data.verifierMac.value
          : this.verifierMac,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VaultMeta(')
          ..write('id: $id, ')
          ..write('salt: $salt, ')
          ..write('verifierCiphertext: $verifierCiphertext, ')
          ..write('verifierNonce: $verifierNonce, ')
          ..write('verifierMac: $verifierMac, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    $driftBlobEquality.hash(salt),
    $driftBlobEquality.hash(verifierCiphertext),
    $driftBlobEquality.hash(verifierNonce),
    $driftBlobEquality.hash(verifierMac),
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VaultMeta &&
          other.id == this.id &&
          $driftBlobEquality.equals(other.salt, this.salt) &&
          $driftBlobEquality.equals(
            other.verifierCiphertext,
            this.verifierCiphertext,
          ) &&
          $driftBlobEquality.equals(other.verifierNonce, this.verifierNonce) &&
          $driftBlobEquality.equals(other.verifierMac, this.verifierMac) &&
          other.createdAt == this.createdAt);
}

class VaultMetasCompanion extends UpdateCompanion<VaultMeta> {
  final Value<int> id;
  final Value<Uint8List> salt;
  final Value<Uint8List> verifierCiphertext;
  final Value<Uint8List> verifierNonce;
  final Value<Uint8List> verifierMac;
  final Value<DateTime> createdAt;
  const VaultMetasCompanion({
    this.id = const Value.absent(),
    this.salt = const Value.absent(),
    this.verifierCiphertext = const Value.absent(),
    this.verifierNonce = const Value.absent(),
    this.verifierMac = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  VaultMetasCompanion.insert({
    this.id = const Value.absent(),
    required Uint8List salt,
    required Uint8List verifierCiphertext,
    required Uint8List verifierNonce,
    required Uint8List verifierMac,
    this.createdAt = const Value.absent(),
  }) : salt = Value(salt),
       verifierCiphertext = Value(verifierCiphertext),
       verifierNonce = Value(verifierNonce),
       verifierMac = Value(verifierMac);
  static Insertable<VaultMeta> custom({
    Expression<int>? id,
    Expression<Uint8List>? salt,
    Expression<Uint8List>? verifierCiphertext,
    Expression<Uint8List>? verifierNonce,
    Expression<Uint8List>? verifierMac,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (salt != null) 'salt': salt,
      if (verifierCiphertext != null) 'verifier_ciphertext': verifierCiphertext,
      if (verifierNonce != null) 'verifier_nonce': verifierNonce,
      if (verifierMac != null) 'verifier_mac': verifierMac,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  VaultMetasCompanion copyWith({
    Value<int>? id,
    Value<Uint8List>? salt,
    Value<Uint8List>? verifierCiphertext,
    Value<Uint8List>? verifierNonce,
    Value<Uint8List>? verifierMac,
    Value<DateTime>? createdAt,
  }) {
    return VaultMetasCompanion(
      id: id ?? this.id,
      salt: salt ?? this.salt,
      verifierCiphertext: verifierCiphertext ?? this.verifierCiphertext,
      verifierNonce: verifierNonce ?? this.verifierNonce,
      verifierMac: verifierMac ?? this.verifierMac,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (salt.present) {
      map['salt'] = Variable<Uint8List>(salt.value);
    }
    if (verifierCiphertext.present) {
      map['verifier_ciphertext'] = Variable<Uint8List>(
        verifierCiphertext.value,
      );
    }
    if (verifierNonce.present) {
      map['verifier_nonce'] = Variable<Uint8List>(verifierNonce.value);
    }
    if (verifierMac.present) {
      map['verifier_mac'] = Variable<Uint8List>(verifierMac.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VaultMetasCompanion(')
          ..write('id: $id, ')
          ..write('salt: $salt, ')
          ..write('verifierCiphertext: $verifierCiphertext, ')
          ..write('verifierNonce: $verifierNonce, ')
          ..write('verifierMac: $verifierMac, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $VaultEntriesTable extends VaultEntries
    with TableInfo<$VaultEntriesTable, VaultEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VaultEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ciphertextMeta = const VerificationMeta(
    'ciphertext',
  );
  @override
  late final GeneratedColumn<Uint8List> ciphertext = GeneratedColumn<Uint8List>(
    'ciphertext',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nonceMeta = const VerificationMeta('nonce');
  @override
  late final GeneratedColumn<Uint8List> nonce = GeneratedColumn<Uint8List>(
    'nonce',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _macMeta = const VerificationMeta('mac');
  @override
  late final GeneratedColumn<Uint8List> mac = GeneratedColumn<Uint8List>(
    'mac',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _favoriteMeta = const VerificationMeta(
    'favorite',
  );
  @override
  late final GeneratedColumn<bool> favorite = GeneratedColumn<bool>(
    'favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ciphertext,
    nonce,
    mac,
    createdAt,
    updatedAt,
    favorite,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vault_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<VaultEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('ciphertext')) {
      context.handle(
        _ciphertextMeta,
        ciphertext.isAcceptableOrUnknown(data['ciphertext']!, _ciphertextMeta),
      );
    } else if (isInserting) {
      context.missing(_ciphertextMeta);
    }
    if (data.containsKey('nonce')) {
      context.handle(
        _nonceMeta,
        nonce.isAcceptableOrUnknown(data['nonce']!, _nonceMeta),
      );
    } else if (isInserting) {
      context.missing(_nonceMeta);
    }
    if (data.containsKey('mac')) {
      context.handle(
        _macMeta,
        mac.isAcceptableOrUnknown(data['mac']!, _macMeta),
      );
    } else if (isInserting) {
      context.missing(_macMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('favorite')) {
      context.handle(
        _favoriteMeta,
        favorite.isAcceptableOrUnknown(data['favorite']!, _favoriteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VaultEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VaultEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ciphertext: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}ciphertext'],
      )!,
      nonce: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}nonce'],
      )!,
      mac: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}mac'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      favorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}favorite'],
      )!,
    );
  }

  @override
  $VaultEntriesTable createAlias(String alias) {
    return $VaultEntriesTable(attachedDatabase, alias);
  }
}

class VaultEntry extends DataClass implements Insertable<VaultEntry> {
  final String id;
  final Uint8List ciphertext;
  final Uint8List nonce;
  final Uint8List mac;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool favorite;
  const VaultEntry({
    required this.id,
    required this.ciphertext,
    required this.nonce,
    required this.mac,
    required this.createdAt,
    required this.updatedAt,
    required this.favorite,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['ciphertext'] = Variable<Uint8List>(ciphertext);
    map['nonce'] = Variable<Uint8List>(nonce);
    map['mac'] = Variable<Uint8List>(mac);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['favorite'] = Variable<bool>(favorite);
    return map;
  }

  VaultEntriesCompanion toCompanion(bool nullToAbsent) {
    return VaultEntriesCompanion(
      id: Value(id),
      ciphertext: Value(ciphertext),
      nonce: Value(nonce),
      mac: Value(mac),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      favorite: Value(favorite),
    );
  }

  factory VaultEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VaultEntry(
      id: serializer.fromJson<String>(json['id']),
      ciphertext: serializer.fromJson<Uint8List>(json['ciphertext']),
      nonce: serializer.fromJson<Uint8List>(json['nonce']),
      mac: serializer.fromJson<Uint8List>(json['mac']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      favorite: serializer.fromJson<bool>(json['favorite']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ciphertext': serializer.toJson<Uint8List>(ciphertext),
      'nonce': serializer.toJson<Uint8List>(nonce),
      'mac': serializer.toJson<Uint8List>(mac),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'favorite': serializer.toJson<bool>(favorite),
    };
  }

  VaultEntry copyWith({
    String? id,
    Uint8List? ciphertext,
    Uint8List? nonce,
    Uint8List? mac,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? favorite,
  }) => VaultEntry(
    id: id ?? this.id,
    ciphertext: ciphertext ?? this.ciphertext,
    nonce: nonce ?? this.nonce,
    mac: mac ?? this.mac,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    favorite: favorite ?? this.favorite,
  );
  VaultEntry copyWithCompanion(VaultEntriesCompanion data) {
    return VaultEntry(
      id: data.id.present ? data.id.value : this.id,
      ciphertext: data.ciphertext.present
          ? data.ciphertext.value
          : this.ciphertext,
      nonce: data.nonce.present ? data.nonce.value : this.nonce,
      mac: data.mac.present ? data.mac.value : this.mac,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      favorite: data.favorite.present ? data.favorite.value : this.favorite,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VaultEntry(')
          ..write('id: $id, ')
          ..write('ciphertext: $ciphertext, ')
          ..write('nonce: $nonce, ')
          ..write('mac: $mac, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('favorite: $favorite')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    $driftBlobEquality.hash(ciphertext),
    $driftBlobEquality.hash(nonce),
    $driftBlobEquality.hash(mac),
    createdAt,
    updatedAt,
    favorite,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VaultEntry &&
          other.id == this.id &&
          $driftBlobEquality.equals(other.ciphertext, this.ciphertext) &&
          $driftBlobEquality.equals(other.nonce, this.nonce) &&
          $driftBlobEquality.equals(other.mac, this.mac) &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.favorite == this.favorite);
}

class VaultEntriesCompanion extends UpdateCompanion<VaultEntry> {
  final Value<String> id;
  final Value<Uint8List> ciphertext;
  final Value<Uint8List> nonce;
  final Value<Uint8List> mac;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> favorite;
  final Value<int> rowid;
  const VaultEntriesCompanion({
    this.id = const Value.absent(),
    this.ciphertext = const Value.absent(),
    this.nonce = const Value.absent(),
    this.mac = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.favorite = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VaultEntriesCompanion.insert({
    required String id,
    required Uint8List ciphertext,
    required Uint8List nonce,
    required Uint8List mac,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.favorite = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ciphertext = Value(ciphertext),
       nonce = Value(nonce),
       mac = Value(mac),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<VaultEntry> custom({
    Expression<String>? id,
    Expression<Uint8List>? ciphertext,
    Expression<Uint8List>? nonce,
    Expression<Uint8List>? mac,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? favorite,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ciphertext != null) 'ciphertext': ciphertext,
      if (nonce != null) 'nonce': nonce,
      if (mac != null) 'mac': mac,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (favorite != null) 'favorite': favorite,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VaultEntriesCompanion copyWith({
    Value<String>? id,
    Value<Uint8List>? ciphertext,
    Value<Uint8List>? nonce,
    Value<Uint8List>? mac,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? favorite,
    Value<int>? rowid,
  }) {
    return VaultEntriesCompanion(
      id: id ?? this.id,
      ciphertext: ciphertext ?? this.ciphertext,
      nonce: nonce ?? this.nonce,
      mac: mac ?? this.mac,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      favorite: favorite ?? this.favorite,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ciphertext.present) {
      map['ciphertext'] = Variable<Uint8List>(ciphertext.value);
    }
    if (nonce.present) {
      map['nonce'] = Variable<Uint8List>(nonce.value);
    }
    if (mac.present) {
      map['mac'] = Variable<Uint8List>(mac.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (favorite.present) {
      map['favorite'] = Variable<bool>(favorite.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VaultEntriesCompanion(')
          ..write('id: $id, ')
          ..write('ciphertext: $ciphertext, ')
          ..write('nonce: $nonce, ')
          ..write('mac: $mac, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('favorite: $favorite, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $VaultMetasTable vaultMetas = $VaultMetasTable(this);
  late final $VaultEntriesTable vaultEntries = $VaultEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    vaultMetas,
    vaultEntries,
  ];
}

typedef $$VaultMetasTableCreateCompanionBuilder =
    VaultMetasCompanion Function({
      Value<int> id,
      required Uint8List salt,
      required Uint8List verifierCiphertext,
      required Uint8List verifierNonce,
      required Uint8List verifierMac,
      Value<DateTime> createdAt,
    });
typedef $$VaultMetasTableUpdateCompanionBuilder =
    VaultMetasCompanion Function({
      Value<int> id,
      Value<Uint8List> salt,
      Value<Uint8List> verifierCiphertext,
      Value<Uint8List> verifierNonce,
      Value<Uint8List> verifierMac,
      Value<DateTime> createdAt,
    });

class $$VaultMetasTableFilterComposer
    extends Composer<_$AppDatabase, $VaultMetasTable> {
  $$VaultMetasTableFilterComposer({
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

  ColumnFilters<Uint8List> get salt => $composableBuilder(
    column: $table.salt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get verifierCiphertext => $composableBuilder(
    column: $table.verifierCiphertext,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get verifierNonce => $composableBuilder(
    column: $table.verifierNonce,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get verifierMac => $composableBuilder(
    column: $table.verifierMac,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VaultMetasTableOrderingComposer
    extends Composer<_$AppDatabase, $VaultMetasTable> {
  $$VaultMetasTableOrderingComposer({
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

  ColumnOrderings<Uint8List> get salt => $composableBuilder(
    column: $table.salt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get verifierCiphertext => $composableBuilder(
    column: $table.verifierCiphertext,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get verifierNonce => $composableBuilder(
    column: $table.verifierNonce,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get verifierMac => $composableBuilder(
    column: $table.verifierMac,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VaultMetasTableAnnotationComposer
    extends Composer<_$AppDatabase, $VaultMetasTable> {
  $$VaultMetasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<Uint8List> get salt =>
      $composableBuilder(column: $table.salt, builder: (column) => column);

  GeneratedColumn<Uint8List> get verifierCiphertext => $composableBuilder(
    column: $table.verifierCiphertext,
    builder: (column) => column,
  );

  GeneratedColumn<Uint8List> get verifierNonce => $composableBuilder(
    column: $table.verifierNonce,
    builder: (column) => column,
  );

  GeneratedColumn<Uint8List> get verifierMac => $composableBuilder(
    column: $table.verifierMac,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$VaultMetasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VaultMetasTable,
          VaultMeta,
          $$VaultMetasTableFilterComposer,
          $$VaultMetasTableOrderingComposer,
          $$VaultMetasTableAnnotationComposer,
          $$VaultMetasTableCreateCompanionBuilder,
          $$VaultMetasTableUpdateCompanionBuilder,
          (
            VaultMeta,
            BaseReferences<_$AppDatabase, $VaultMetasTable, VaultMeta>,
          ),
          VaultMeta,
          PrefetchHooks Function()
        > {
  $$VaultMetasTableTableManager(_$AppDatabase db, $VaultMetasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VaultMetasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VaultMetasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VaultMetasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<Uint8List> salt = const Value.absent(),
                Value<Uint8List> verifierCiphertext = const Value.absent(),
                Value<Uint8List> verifierNonce = const Value.absent(),
                Value<Uint8List> verifierMac = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => VaultMetasCompanion(
                id: id,
                salt: salt,
                verifierCiphertext: verifierCiphertext,
                verifierNonce: verifierNonce,
                verifierMac: verifierMac,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required Uint8List salt,
                required Uint8List verifierCiphertext,
                required Uint8List verifierNonce,
                required Uint8List verifierMac,
                Value<DateTime> createdAt = const Value.absent(),
              }) => VaultMetasCompanion.insert(
                id: id,
                salt: salt,
                verifierCiphertext: verifierCiphertext,
                verifierNonce: verifierNonce,
                verifierMac: verifierMac,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VaultMetasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VaultMetasTable,
      VaultMeta,
      $$VaultMetasTableFilterComposer,
      $$VaultMetasTableOrderingComposer,
      $$VaultMetasTableAnnotationComposer,
      $$VaultMetasTableCreateCompanionBuilder,
      $$VaultMetasTableUpdateCompanionBuilder,
      (VaultMeta, BaseReferences<_$AppDatabase, $VaultMetasTable, VaultMeta>),
      VaultMeta,
      PrefetchHooks Function()
    >;
typedef $$VaultEntriesTableCreateCompanionBuilder =
    VaultEntriesCompanion Function({
      required String id,
      required Uint8List ciphertext,
      required Uint8List nonce,
      required Uint8List mac,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<bool> favorite,
      Value<int> rowid,
    });
typedef $$VaultEntriesTableUpdateCompanionBuilder =
    VaultEntriesCompanion Function({
      Value<String> id,
      Value<Uint8List> ciphertext,
      Value<Uint8List> nonce,
      Value<Uint8List> mac,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> favorite,
      Value<int> rowid,
    });

class $$VaultEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $VaultEntriesTable> {
  $$VaultEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get ciphertext => $composableBuilder(
    column: $table.ciphertext,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get nonce => $composableBuilder(
    column: $table.nonce,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get mac => $composableBuilder(
    column: $table.mac,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get favorite => $composableBuilder(
    column: $table.favorite,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VaultEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $VaultEntriesTable> {
  $$VaultEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get ciphertext => $composableBuilder(
    column: $table.ciphertext,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get nonce => $composableBuilder(
    column: $table.nonce,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get mac => $composableBuilder(
    column: $table.mac,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get favorite => $composableBuilder(
    column: $table.favorite,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VaultEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $VaultEntriesTable> {
  $$VaultEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<Uint8List> get ciphertext => $composableBuilder(
    column: $table.ciphertext,
    builder: (column) => column,
  );

  GeneratedColumn<Uint8List> get nonce =>
      $composableBuilder(column: $table.nonce, builder: (column) => column);

  GeneratedColumn<Uint8List> get mac =>
      $composableBuilder(column: $table.mac, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get favorite =>
      $composableBuilder(column: $table.favorite, builder: (column) => column);
}

class $$VaultEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VaultEntriesTable,
          VaultEntry,
          $$VaultEntriesTableFilterComposer,
          $$VaultEntriesTableOrderingComposer,
          $$VaultEntriesTableAnnotationComposer,
          $$VaultEntriesTableCreateCompanionBuilder,
          $$VaultEntriesTableUpdateCompanionBuilder,
          (
            VaultEntry,
            BaseReferences<_$AppDatabase, $VaultEntriesTable, VaultEntry>,
          ),
          VaultEntry,
          PrefetchHooks Function()
        > {
  $$VaultEntriesTableTableManager(_$AppDatabase db, $VaultEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VaultEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VaultEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VaultEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<Uint8List> ciphertext = const Value.absent(),
                Value<Uint8List> nonce = const Value.absent(),
                Value<Uint8List> mac = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> favorite = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VaultEntriesCompanion(
                id: id,
                ciphertext: ciphertext,
                nonce: nonce,
                mac: mac,
                createdAt: createdAt,
                updatedAt: updatedAt,
                favorite: favorite,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required Uint8List ciphertext,
                required Uint8List nonce,
                required Uint8List mac,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> favorite = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VaultEntriesCompanion.insert(
                id: id,
                ciphertext: ciphertext,
                nonce: nonce,
                mac: mac,
                createdAt: createdAt,
                updatedAt: updatedAt,
                favorite: favorite,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VaultEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VaultEntriesTable,
      VaultEntry,
      $$VaultEntriesTableFilterComposer,
      $$VaultEntriesTableOrderingComposer,
      $$VaultEntriesTableAnnotationComposer,
      $$VaultEntriesTableCreateCompanionBuilder,
      $$VaultEntriesTableUpdateCompanionBuilder,
      (
        VaultEntry,
        BaseReferences<_$AppDatabase, $VaultEntriesTable, VaultEntry>,
      ),
      VaultEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$VaultMetasTableTableManager get vaultMetas =>
      $$VaultMetasTableTableManager(_db, _db.vaultMetas);
  $$VaultEntriesTableTableManager get vaultEntries =>
      $$VaultEntriesTableTableManager(_db, _db.vaultEntries);
}
