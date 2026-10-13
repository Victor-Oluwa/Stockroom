// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $BusinessProfileTable extends BusinessProfile
    with TableInfo<$BusinessProfileTable, BusinessProfileData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BusinessProfileTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _businessNameMeta = const VerificationMeta(
    'businessName',
  );
  @override
  late final GeneratedColumn<String> businessName = GeneratedColumn<String>(
    'business_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _logoPathMeta = const VerificationMeta(
    'logoPath',
  );
  @override
  late final GeneratedColumn<String> logoPath = GeneratedColumn<String>(
    'logo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _receiptFooterMeta = const VerificationMeta(
    'receiptFooter',
  );
  @override
  late final GeneratedColumn<String> receiptFooter = GeneratedColumn<String>(
    'receipt_footer',
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    businessName,
    phone,
    address,
    logoPath,
    receiptFooter,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'business_profile';
  @override
  VerificationContext validateIntegrity(
    Insertable<BusinessProfileData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('business_name')) {
      context.handle(
        _businessNameMeta,
        businessName.isAcceptableOrUnknown(
          data['business_name']!,
          _businessNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_businessNameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('logo_path')) {
      context.handle(
        _logoPathMeta,
        logoPath.isAcceptableOrUnknown(data['logo_path']!, _logoPathMeta),
      );
    }
    if (data.containsKey('receipt_footer')) {
      context.handle(
        _receiptFooterMeta,
        receiptFooter.isAcceptableOrUnknown(
          data['receipt_footer']!,
          _receiptFooterMeta,
        ),
      );
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BusinessProfileData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BusinessProfileData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      businessName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}business_name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      logoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logo_path'],
      ),
      receiptFooter: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_footer'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $BusinessProfileTable createAlias(String alias) {
    return $BusinessProfileTable(attachedDatabase, alias);
  }
}

class BusinessProfileData extends DataClass
    implements Insertable<BusinessProfileData> {
  final String id;
  final String businessName;
  final String? phone;
  final String? address;
  final String? logoPath;
  final String? receiptFooter;
  final DateTime createdAt;
  final DateTime updatedAt;
  const BusinessProfileData({
    required this.id,
    required this.businessName,
    this.phone,
    this.address,
    this.logoPath,
    this.receiptFooter,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['business_name'] = Variable<String>(businessName);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || logoPath != null) {
      map['logo_path'] = Variable<String>(logoPath);
    }
    if (!nullToAbsent || receiptFooter != null) {
      map['receipt_footer'] = Variable<String>(receiptFooter);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BusinessProfileCompanion toCompanion(bool nullToAbsent) {
    return BusinessProfileCompanion(
      id: Value(id),
      businessName: Value(businessName),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      logoPath: logoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(logoPath),
      receiptFooter: receiptFooter == null && nullToAbsent
          ? const Value.absent()
          : Value(receiptFooter),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory BusinessProfileData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BusinessProfileData(
      id: serializer.fromJson<String>(json['id']),
      businessName: serializer.fromJson<String>(json['businessName']),
      phone: serializer.fromJson<String?>(json['phone']),
      address: serializer.fromJson<String?>(json['address']),
      logoPath: serializer.fromJson<String?>(json['logoPath']),
      receiptFooter: serializer.fromJson<String?>(json['receiptFooter']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'businessName': serializer.toJson<String>(businessName),
      'phone': serializer.toJson<String?>(phone),
      'address': serializer.toJson<String?>(address),
      'logoPath': serializer.toJson<String?>(logoPath),
      'receiptFooter': serializer.toJson<String?>(receiptFooter),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BusinessProfileData copyWith({
    String? id,
    String? businessName,
    Value<String?> phone = const Value.absent(),
    Value<String?> address = const Value.absent(),
    Value<String?> logoPath = const Value.absent(),
    Value<String?> receiptFooter = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => BusinessProfileData(
    id: id ?? this.id,
    businessName: businessName ?? this.businessName,
    phone: phone.present ? phone.value : this.phone,
    address: address.present ? address.value : this.address,
    logoPath: logoPath.present ? logoPath.value : this.logoPath,
    receiptFooter: receiptFooter.present
        ? receiptFooter.value
        : this.receiptFooter,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  BusinessProfileData copyWithCompanion(BusinessProfileCompanion data) {
    return BusinessProfileData(
      id: data.id.present ? data.id.value : this.id,
      businessName: data.businessName.present
          ? data.businessName.value
          : this.businessName,
      phone: data.phone.present ? data.phone.value : this.phone,
      address: data.address.present ? data.address.value : this.address,
      logoPath: data.logoPath.present ? data.logoPath.value : this.logoPath,
      receiptFooter: data.receiptFooter.present
          ? data.receiptFooter.value
          : this.receiptFooter,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BusinessProfileData(')
          ..write('id: $id, ')
          ..write('businessName: $businessName, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('logoPath: $logoPath, ')
          ..write('receiptFooter: $receiptFooter, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    businessName,
    phone,
    address,
    logoPath,
    receiptFooter,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BusinessProfileData &&
          other.id == this.id &&
          other.businessName == this.businessName &&
          other.phone == this.phone &&
          other.address == this.address &&
          other.logoPath == this.logoPath &&
          other.receiptFooter == this.receiptFooter &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BusinessProfileCompanion extends UpdateCompanion<BusinessProfileData> {
  final Value<String> id;
  final Value<String> businessName;
  final Value<String?> phone;
  final Value<String?> address;
  final Value<String?> logoPath;
  final Value<String?> receiptFooter;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const BusinessProfileCompanion({
    this.id = const Value.absent(),
    this.businessName = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.receiptFooter = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BusinessProfileCompanion.insert({
    required String id,
    required String businessName,
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.receiptFooter = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       businessName = Value(businessName),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<BusinessProfileData> custom({
    Expression<String>? id,
    Expression<String>? businessName,
    Expression<String>? phone,
    Expression<String>? address,
    Expression<String>? logoPath,
    Expression<String>? receiptFooter,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (businessName != null) 'business_name': businessName,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (logoPath != null) 'logo_path': logoPath,
      if (receiptFooter != null) 'receipt_footer': receiptFooter,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BusinessProfileCompanion copyWith({
    Value<String>? id,
    Value<String>? businessName,
    Value<String?>? phone,
    Value<String?>? address,
    Value<String?>? logoPath,
    Value<String?>? receiptFooter,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return BusinessProfileCompanion(
      id: id ?? this.id,
      businessName: businessName ?? this.businessName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      logoPath: logoPath ?? this.logoPath,
      receiptFooter: receiptFooter ?? this.receiptFooter,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (businessName.present) {
      map['business_name'] = Variable<String>(businessName.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (logoPath.present) {
      map['logo_path'] = Variable<String>(logoPath.value);
    }
    if (receiptFooter.present) {
      map['receipt_footer'] = Variable<String>(receiptFooter.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BusinessProfileCompanion(')
          ..write('id: $id, ')
          ..write('businessName: $businessName, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('logoPath: $logoPath, ')
          ..write('receiptFooter: $receiptFooter, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _defaultLowStockThresholdMilliMeta =
      const VerificationMeta('defaultLowStockThresholdMilli');
  @override
  late final GeneratedColumn<int> defaultLowStockThresholdMilli =
      GeneratedColumn<int>(
        'default_low_stock_threshold_milli',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(5000),
      );
  static const VerificationMeta _notificationsEnabledMeta =
      const VerificationMeta('notificationsEnabled');
  @override
  late final GeneratedColumn<bool> notificationsEnabled = GeneratedColumn<bool>(
    'notifications_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notifications_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _receiptLayoutMeta = const VerificationMeta(
    'receiptLayout',
  );
  @override
  late final GeneratedColumn<String> receiptLayout = GeneratedColumn<String>(
    'receipt_layout',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('compact80'),
  );
  static const VerificationMeta _lastSaleSeqMeta = const VerificationMeta(
    'lastSaleSeq',
  );
  @override
  late final GeneratedColumn<int> lastSaleSeq = GeneratedColumn<int>(
    'last_sale_seq',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastReceiptSeqMeta = const VerificationMeta(
    'lastReceiptSeq',
  );
  @override
  late final GeneratedColumn<int> lastReceiptSeq = GeneratedColumn<int>(
    'last_receipt_seq',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastAdjustmentSeqMeta = const VerificationMeta(
    'lastAdjustmentSeq',
  );
  @override
  late final GeneratedColumn<int> lastAdjustmentSeq = GeneratedColumn<int>(
    'last_adjustment_seq',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _settingsVersionMeta = const VerificationMeta(
    'settingsVersion',
  );
  @override
  late final GeneratedColumn<int> settingsVersion = GeneratedColumn<int>(
    'settings_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    defaultLowStockThresholdMilli,
    notificationsEnabled,
    receiptLayout,
    lastSaleSeq,
    lastReceiptSeq,
    lastAdjustmentSeq,
    settingsVersion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('default_low_stock_threshold_milli')) {
      context.handle(
        _defaultLowStockThresholdMilliMeta,
        defaultLowStockThresholdMilli.isAcceptableOrUnknown(
          data['default_low_stock_threshold_milli']!,
          _defaultLowStockThresholdMilliMeta,
        ),
      );
    }
    if (data.containsKey('notifications_enabled')) {
      context.handle(
        _notificationsEnabledMeta,
        notificationsEnabled.isAcceptableOrUnknown(
          data['notifications_enabled']!,
          _notificationsEnabledMeta,
        ),
      );
    }
    if (data.containsKey('receipt_layout')) {
      context.handle(
        _receiptLayoutMeta,
        receiptLayout.isAcceptableOrUnknown(
          data['receipt_layout']!,
          _receiptLayoutMeta,
        ),
      );
    }
    if (data.containsKey('last_sale_seq')) {
      context.handle(
        _lastSaleSeqMeta,
        lastSaleSeq.isAcceptableOrUnknown(
          data['last_sale_seq']!,
          _lastSaleSeqMeta,
        ),
      );
    }
    if (data.containsKey('last_receipt_seq')) {
      context.handle(
        _lastReceiptSeqMeta,
        lastReceiptSeq.isAcceptableOrUnknown(
          data['last_receipt_seq']!,
          _lastReceiptSeqMeta,
        ),
      );
    }
    if (data.containsKey('last_adjustment_seq')) {
      context.handle(
        _lastAdjustmentSeqMeta,
        lastAdjustmentSeq.isAcceptableOrUnknown(
          data['last_adjustment_seq']!,
          _lastAdjustmentSeqMeta,
        ),
      );
    }
    if (data.containsKey('settings_version')) {
      context.handle(
        _settingsVersionMeta,
        settingsVersion.isAcceptableOrUnknown(
          data['settings_version']!,
          _settingsVersionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      defaultLowStockThresholdMilli: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}default_low_stock_threshold_milli'],
      )!,
      notificationsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notifications_enabled'],
      )!,
      receiptLayout: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_layout'],
      )!,
      lastSaleSeq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_sale_seq'],
      )!,
      lastReceiptSeq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_receipt_seq'],
      )!,
      lastAdjustmentSeq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_adjustment_seq'],
      )!,
      settingsVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}settings_version'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String id;
  final int defaultLowStockThresholdMilli;
  final bool notificationsEnabled;
  final String receiptLayout;
  final int lastSaleSeq;
  final int lastReceiptSeq;
  final int lastAdjustmentSeq;
  final int settingsVersion;
  const AppSetting({
    required this.id,
    required this.defaultLowStockThresholdMilli,
    required this.notificationsEnabled,
    required this.receiptLayout,
    required this.lastSaleSeq,
    required this.lastReceiptSeq,
    required this.lastAdjustmentSeq,
    required this.settingsVersion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['default_low_stock_threshold_milli'] = Variable<int>(
      defaultLowStockThresholdMilli,
    );
    map['notifications_enabled'] = Variable<bool>(notificationsEnabled);
    map['receipt_layout'] = Variable<String>(receiptLayout);
    map['last_sale_seq'] = Variable<int>(lastSaleSeq);
    map['last_receipt_seq'] = Variable<int>(lastReceiptSeq);
    map['last_adjustment_seq'] = Variable<int>(lastAdjustmentSeq);
    map['settings_version'] = Variable<int>(settingsVersion);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      id: Value(id),
      defaultLowStockThresholdMilli: Value(defaultLowStockThresholdMilli),
      notificationsEnabled: Value(notificationsEnabled),
      receiptLayout: Value(receiptLayout),
      lastSaleSeq: Value(lastSaleSeq),
      lastReceiptSeq: Value(lastReceiptSeq),
      lastAdjustmentSeq: Value(lastAdjustmentSeq),
      settingsVersion: Value(settingsVersion),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      id: serializer.fromJson<String>(json['id']),
      defaultLowStockThresholdMilli: serializer.fromJson<int>(
        json['defaultLowStockThresholdMilli'],
      ),
      notificationsEnabled: serializer.fromJson<bool>(
        json['notificationsEnabled'],
      ),
      receiptLayout: serializer.fromJson<String>(json['receiptLayout']),
      lastSaleSeq: serializer.fromJson<int>(json['lastSaleSeq']),
      lastReceiptSeq: serializer.fromJson<int>(json['lastReceiptSeq']),
      lastAdjustmentSeq: serializer.fromJson<int>(json['lastAdjustmentSeq']),
      settingsVersion: serializer.fromJson<int>(json['settingsVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'defaultLowStockThresholdMilli': serializer.toJson<int>(
        defaultLowStockThresholdMilli,
      ),
      'notificationsEnabled': serializer.toJson<bool>(notificationsEnabled),
      'receiptLayout': serializer.toJson<String>(receiptLayout),
      'lastSaleSeq': serializer.toJson<int>(lastSaleSeq),
      'lastReceiptSeq': serializer.toJson<int>(lastReceiptSeq),
      'lastAdjustmentSeq': serializer.toJson<int>(lastAdjustmentSeq),
      'settingsVersion': serializer.toJson<int>(settingsVersion),
    };
  }

  AppSetting copyWith({
    String? id,
    int? defaultLowStockThresholdMilli,
    bool? notificationsEnabled,
    String? receiptLayout,
    int? lastSaleSeq,
    int? lastReceiptSeq,
    int? lastAdjustmentSeq,
    int? settingsVersion,
  }) => AppSetting(
    id: id ?? this.id,
    defaultLowStockThresholdMilli:
        defaultLowStockThresholdMilli ?? this.defaultLowStockThresholdMilli,
    notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    receiptLayout: receiptLayout ?? this.receiptLayout,
    lastSaleSeq: lastSaleSeq ?? this.lastSaleSeq,
    lastReceiptSeq: lastReceiptSeq ?? this.lastReceiptSeq,
    lastAdjustmentSeq: lastAdjustmentSeq ?? this.lastAdjustmentSeq,
    settingsVersion: settingsVersion ?? this.settingsVersion,
  );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      id: data.id.present ? data.id.value : this.id,
      defaultLowStockThresholdMilli: data.defaultLowStockThresholdMilli.present
          ? data.defaultLowStockThresholdMilli.value
          : this.defaultLowStockThresholdMilli,
      notificationsEnabled: data.notificationsEnabled.present
          ? data.notificationsEnabled.value
          : this.notificationsEnabled,
      receiptLayout: data.receiptLayout.present
          ? data.receiptLayout.value
          : this.receiptLayout,
      lastSaleSeq: data.lastSaleSeq.present
          ? data.lastSaleSeq.value
          : this.lastSaleSeq,
      lastReceiptSeq: data.lastReceiptSeq.present
          ? data.lastReceiptSeq.value
          : this.lastReceiptSeq,
      lastAdjustmentSeq: data.lastAdjustmentSeq.present
          ? data.lastAdjustmentSeq.value
          : this.lastAdjustmentSeq,
      settingsVersion: data.settingsVersion.present
          ? data.settingsVersion.value
          : this.settingsVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('id: $id, ')
          ..write(
            'defaultLowStockThresholdMilli: $defaultLowStockThresholdMilli, ',
          )
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('receiptLayout: $receiptLayout, ')
          ..write('lastSaleSeq: $lastSaleSeq, ')
          ..write('lastReceiptSeq: $lastReceiptSeq, ')
          ..write('lastAdjustmentSeq: $lastAdjustmentSeq, ')
          ..write('settingsVersion: $settingsVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    defaultLowStockThresholdMilli,
    notificationsEnabled,
    receiptLayout,
    lastSaleSeq,
    lastReceiptSeq,
    lastAdjustmentSeq,
    settingsVersion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.id == this.id &&
          other.defaultLowStockThresholdMilli ==
              this.defaultLowStockThresholdMilli &&
          other.notificationsEnabled == this.notificationsEnabled &&
          other.receiptLayout == this.receiptLayout &&
          other.lastSaleSeq == this.lastSaleSeq &&
          other.lastReceiptSeq == this.lastReceiptSeq &&
          other.lastAdjustmentSeq == this.lastAdjustmentSeq &&
          other.settingsVersion == this.settingsVersion);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> id;
  final Value<int> defaultLowStockThresholdMilli;
  final Value<bool> notificationsEnabled;
  final Value<String> receiptLayout;
  final Value<int> lastSaleSeq;
  final Value<int> lastReceiptSeq;
  final Value<int> lastAdjustmentSeq;
  final Value<int> settingsVersion;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.defaultLowStockThresholdMilli = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.receiptLayout = const Value.absent(),
    this.lastSaleSeq = const Value.absent(),
    this.lastReceiptSeq = const Value.absent(),
    this.lastAdjustmentSeq = const Value.absent(),
    this.settingsVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String id,
    this.defaultLowStockThresholdMilli = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.receiptLayout = const Value.absent(),
    this.lastSaleSeq = const Value.absent(),
    this.lastReceiptSeq = const Value.absent(),
    this.lastAdjustmentSeq = const Value.absent(),
    this.settingsVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<AppSetting> custom({
    Expression<String>? id,
    Expression<int>? defaultLowStockThresholdMilli,
    Expression<bool>? notificationsEnabled,
    Expression<String>? receiptLayout,
    Expression<int>? lastSaleSeq,
    Expression<int>? lastReceiptSeq,
    Expression<int>? lastAdjustmentSeq,
    Expression<int>? settingsVersion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (defaultLowStockThresholdMilli != null)
        'default_low_stock_threshold_milli': defaultLowStockThresholdMilli,
      if (notificationsEnabled != null)
        'notifications_enabled': notificationsEnabled,
      if (receiptLayout != null) 'receipt_layout': receiptLayout,
      if (lastSaleSeq != null) 'last_sale_seq': lastSaleSeq,
      if (lastReceiptSeq != null) 'last_receipt_seq': lastReceiptSeq,
      if (lastAdjustmentSeq != null) 'last_adjustment_seq': lastAdjustmentSeq,
      if (settingsVersion != null) 'settings_version': settingsVersion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? id,
    Value<int>? defaultLowStockThresholdMilli,
    Value<bool>? notificationsEnabled,
    Value<String>? receiptLayout,
    Value<int>? lastSaleSeq,
    Value<int>? lastReceiptSeq,
    Value<int>? lastAdjustmentSeq,
    Value<int>? settingsVersion,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      defaultLowStockThresholdMilli:
          defaultLowStockThresholdMilli ?? this.defaultLowStockThresholdMilli,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      receiptLayout: receiptLayout ?? this.receiptLayout,
      lastSaleSeq: lastSaleSeq ?? this.lastSaleSeq,
      lastReceiptSeq: lastReceiptSeq ?? this.lastReceiptSeq,
      lastAdjustmentSeq: lastAdjustmentSeq ?? this.lastAdjustmentSeq,
      settingsVersion: settingsVersion ?? this.settingsVersion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (defaultLowStockThresholdMilli.present) {
      map['default_low_stock_threshold_milli'] = Variable<int>(
        defaultLowStockThresholdMilli.value,
      );
    }
    if (notificationsEnabled.present) {
      map['notifications_enabled'] = Variable<bool>(notificationsEnabled.value);
    }
    if (receiptLayout.present) {
      map['receipt_layout'] = Variable<String>(receiptLayout.value);
    }
    if (lastSaleSeq.present) {
      map['last_sale_seq'] = Variable<int>(lastSaleSeq.value);
    }
    if (lastReceiptSeq.present) {
      map['last_receipt_seq'] = Variable<int>(lastReceiptSeq.value);
    }
    if (lastAdjustmentSeq.present) {
      map['last_adjustment_seq'] = Variable<int>(lastAdjustmentSeq.value);
    }
    if (settingsVersion.present) {
      map['settings_version'] = Variable<int>(settingsVersion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write(
            'defaultLowStockThresholdMilli: $defaultLowStockThresholdMilli, ',
          )
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('receiptLayout: $receiptLayout, ')
          ..write('lastSaleSeq: $lastSaleSeq, ')
          ..write('lastReceiptSeq: $lastReceiptSeq, ')
          ..write('lastAdjustmentSeq: $lastAdjustmentSeq, ')
          ..write('settingsVersion: $settingsVersion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductCategoriesTable extends ProductCategories
    with TableInfo<$ProductCategoriesTable, ProductCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _normalizedNameMeta = const VerificationMeta(
    'normalizedName',
  );
  @override
  late final GeneratedColumn<String> normalizedName = GeneratedColumn<String>(
    'normalized_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    normalizedName,
    isArchived,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('normalized_name')) {
      context.handle(
        _normalizedNameMeta,
        normalizedName.isAcceptableOrUnknown(
          data['normalized_name']!,
          _normalizedNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_normalizedNameMeta);
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductCategory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      normalizedName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}normalized_name'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ProductCategoriesTable createAlias(String alias) {
    return $ProductCategoriesTable(attachedDatabase, alias);
  }
}

class ProductCategory extends DataClass implements Insertable<ProductCategory> {
  final String id;
  final String name;
  final String normalizedName;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ProductCategory({
    required this.id,
    required this.name,
    required this.normalizedName,
    required this.isArchived,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['normalized_name'] = Variable<String>(normalizedName);
    map['is_archived'] = Variable<bool>(isArchived);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProductCategoriesCompanion toCompanion(bool nullToAbsent) {
    return ProductCategoriesCompanion(
      id: Value(id),
      name: Value(name),
      normalizedName: Value(normalizedName),
      isArchived: Value(isArchived),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ProductCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductCategory(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      normalizedName: serializer.fromJson<String>(json['normalizedName']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'normalizedName': serializer.toJson<String>(normalizedName),
      'isArchived': serializer.toJson<bool>(isArchived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ProductCategory copyWith({
    String? id,
    String? name,
    String? normalizedName,
    bool? isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ProductCategory(
    id: id ?? this.id,
    name: name ?? this.name,
    normalizedName: normalizedName ?? this.normalizedName,
    isArchived: isArchived ?? this.isArchived,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ProductCategory copyWithCompanion(ProductCategoriesCompanion data) {
    return ProductCategory(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      normalizedName: data.normalizedName.present
          ? data.normalizedName.value
          : this.normalizedName,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductCategory(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('normalizedName: $normalizedName, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, normalizedName, isArchived, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductCategory &&
          other.id == this.id &&
          other.name == this.name &&
          other.normalizedName == this.normalizedName &&
          other.isArchived == this.isArchived &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProductCategoriesCompanion extends UpdateCompanion<ProductCategory> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> normalizedName;
  final Value<bool> isArchived;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ProductCategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.normalizedName = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductCategoriesCompanion.insert({
    required String id,
    required String name,
    required String normalizedName,
    this.isArchived = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       normalizedName = Value(normalizedName),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ProductCategory> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? normalizedName,
    Expression<bool>? isArchived,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (normalizedName != null) 'normalized_name': normalizedName,
      if (isArchived != null) 'is_archived': isArchived,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductCategoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? normalizedName,
    Value<bool>? isArchived,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ProductCategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      normalizedName: normalizedName ?? this.normalizedName,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (normalizedName.present) {
      map['normalized_name'] = Variable<String>(normalizedName.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('normalizedName: $normalizedName, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SuppliersTable extends Suppliers
    with TableInfo<$SuppliersTable, Supplier> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SuppliersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contactNameMeta = const VerificationMeta(
    'contactName',
  );
  @override
  late final GeneratedColumn<String> contactName = GeneratedColumn<String>(
    'contact_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    contactName,
    phone,
    email,
    address,
    notes,
    isArchived,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'suppliers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Supplier> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('contact_name')) {
      context.handle(
        _contactNameMeta,
        contactName.isAcceptableOrUnknown(
          data['contact_name']!,
          _contactNameMeta,
        ),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Supplier map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Supplier(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      contactName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact_name'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SuppliersTable createAlias(String alias) {
    return $SuppliersTable(attachedDatabase, alias);
  }
}

class Supplier extends DataClass implements Insertable<Supplier> {
  final String id;
  final String name;
  final String? contactName;
  final String? phone;
  final String? email;
  final String? address;
  final String? notes;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Supplier({
    required this.id,
    required this.name,
    this.contactName,
    this.phone,
    this.email,
    this.address,
    this.notes,
    required this.isArchived,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || contactName != null) {
      map['contact_name'] = Variable<String>(contactName);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_archived'] = Variable<bool>(isArchived);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SuppliersCompanion toCompanion(bool nullToAbsent) {
    return SuppliersCompanion(
      id: Value(id),
      name: Value(name),
      contactName: contactName == null && nullToAbsent
          ? const Value.absent()
          : Value(contactName),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      isArchived: Value(isArchived),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Supplier.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Supplier(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      contactName: serializer.fromJson<String?>(json['contactName']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      address: serializer.fromJson<String?>(json['address']),
      notes: serializer.fromJson<String?>(json['notes']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'contactName': serializer.toJson<String?>(contactName),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'address': serializer.toJson<String?>(address),
      'notes': serializer.toJson<String?>(notes),
      'isArchived': serializer.toJson<bool>(isArchived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Supplier copyWith({
    String? id,
    String? name,
    Value<String?> contactName = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> address = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    bool? isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Supplier(
    id: id ?? this.id,
    name: name ?? this.name,
    contactName: contactName.present ? contactName.value : this.contactName,
    phone: phone.present ? phone.value : this.phone,
    email: email.present ? email.value : this.email,
    address: address.present ? address.value : this.address,
    notes: notes.present ? notes.value : this.notes,
    isArchived: isArchived ?? this.isArchived,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Supplier copyWithCompanion(SuppliersCompanion data) {
    return Supplier(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      contactName: data.contactName.present
          ? data.contactName.value
          : this.contactName,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      address: data.address.present ? data.address.value : this.address,
      notes: data.notes.present ? data.notes.value : this.notes,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Supplier(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('contactName: $contactName, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    contactName,
    phone,
    email,
    address,
    notes,
    isArchived,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Supplier &&
          other.id == this.id &&
          other.name == this.name &&
          other.contactName == this.contactName &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.address == this.address &&
          other.notes == this.notes &&
          other.isArchived == this.isArchived &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SuppliersCompanion extends UpdateCompanion<Supplier> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> contactName;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<String?> address;
  final Value<String?> notes;
  final Value<bool> isArchived;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SuppliersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.contactName = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SuppliersCompanion.insert({
    required String id,
    required String name,
    this.contactName = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    this.isArchived = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Supplier> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? contactName,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? address,
    Expression<String>? notes,
    Expression<bool>? isArchived,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (contactName != null) 'contact_name': contactName,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (notes != null) 'notes': notes,
      if (isArchived != null) 'is_archived': isArchived,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SuppliersCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? contactName,
    Value<String?>? phone,
    Value<String?>? email,
    Value<String?>? address,
    Value<String?>? notes,
    Value<bool>? isArchived,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SuppliersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      contactName: contactName ?? this.contactName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (contactName.present) {
      map['contact_name'] = Variable<String>(contactName.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SuppliersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('contactName: $contactName, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _normalizedNameMeta = const VerificationMeta(
    'normalizedName',
  );
  @override
  late final GeneratedColumn<String> normalizedName = GeneratedColumn<String>(
    'normalized_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _skuMeta = const VerificationMeta('sku');
  @override
  late final GeneratedColumn<String> sku = GeneratedColumn<String>(
    'sku',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES product_categories (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _unitLabelMeta = const VerificationMeta(
    'unitLabel',
  );
  @override
  late final GeneratedColumn<String> unitLabel = GeneratedColumn<String>(
    'unit_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sellingPriceKoboMeta = const VerificationMeta(
    'sellingPriceKobo',
  );
  @override
  late final GeneratedColumn<int> sellingPriceKobo = GeneratedColumn<int>(
    'selling_price_kobo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _averageCostKoboMeta = const VerificationMeta(
    'averageCostKobo',
  );
  @override
  late final GeneratedColumn<int> averageCostKobo = GeneratedColumn<int>(
    'average_cost_kobo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _quantityOnHandMilliMeta =
      const VerificationMeta('quantityOnHandMilli');
  @override
  late final GeneratedColumn<int> quantityOnHandMilli = GeneratedColumn<int>(
    'quantity_on_hand_milli',
    aliasedName,
    false,
    check: () => ComparableExpr(quantityOnHandMilli).isBiggerOrEqualValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lowStockThresholdMilliMeta =
      const VerificationMeta('lowStockThresholdMilli');
  @override
  late final GeneratedColumn<int> lowStockThresholdMilli = GeneratedColumn<int>(
    'low_stock_threshold_milli',
    aliasedName,
    false,
    check: () => ComparableExpr(lowStockThresholdMilli).isBiggerOrEqualValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(5000),
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    normalizedName,
    sku,
    barcode,
    categoryId,
    unitLabel,
    sellingPriceKobo,
    averageCostKobo,
    quantityOnHandMilli,
    lowStockThresholdMilli,
    imagePath,
    description,
    isArchived,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<Product> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('normalized_name')) {
      context.handle(
        _normalizedNameMeta,
        normalizedName.isAcceptableOrUnknown(
          data['normalized_name']!,
          _normalizedNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_normalizedNameMeta);
    }
    if (data.containsKey('sku')) {
      context.handle(
        _skuMeta,
        sku.isAcceptableOrUnknown(data['sku']!, _skuMeta),
      );
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('unit_label')) {
      context.handle(
        _unitLabelMeta,
        unitLabel.isAcceptableOrUnknown(data['unit_label']!, _unitLabelMeta),
      );
    } else if (isInserting) {
      context.missing(_unitLabelMeta);
    }
    if (data.containsKey('selling_price_kobo')) {
      context.handle(
        _sellingPriceKoboMeta,
        sellingPriceKobo.isAcceptableOrUnknown(
          data['selling_price_kobo']!,
          _sellingPriceKoboMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sellingPriceKoboMeta);
    }
    if (data.containsKey('average_cost_kobo')) {
      context.handle(
        _averageCostKoboMeta,
        averageCostKobo.isAcceptableOrUnknown(
          data['average_cost_kobo']!,
          _averageCostKoboMeta,
        ),
      );
    }
    if (data.containsKey('quantity_on_hand_milli')) {
      context.handle(
        _quantityOnHandMilliMeta,
        quantityOnHandMilli.isAcceptableOrUnknown(
          data['quantity_on_hand_milli']!,
          _quantityOnHandMilliMeta,
        ),
      );
    }
    if (data.containsKey('low_stock_threshold_milli')) {
      context.handle(
        _lowStockThresholdMilliMeta,
        lowStockThresholdMilli.isAcceptableOrUnknown(
          data['low_stock_threshold_milli']!,
          _lowStockThresholdMilliMeta,
        ),
      );
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      normalizedName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}normalized_name'],
      )!,
      sku: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sku'],
      ),
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      unitLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_label'],
      )!,
      sellingPriceKobo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}selling_price_kobo'],
      )!,
      averageCostKobo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}average_cost_kobo'],
      )!,
      quantityOnHandMilli: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity_on_hand_milli'],
      )!,
      lowStockThresholdMilli: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}low_stock_threshold_milli'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final String id;
  final String name;
  final String normalizedName;
  final String? sku;
  final String? barcode;
  final String? categoryId;
  final String unitLabel;
  final int sellingPriceKobo;
  final int averageCostKobo;
  final int quantityOnHandMilli;
  final int lowStockThresholdMilli;
  final String? imagePath;
  final String? description;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Product({
    required this.id,
    required this.name,
    required this.normalizedName,
    this.sku,
    this.barcode,
    this.categoryId,
    required this.unitLabel,
    required this.sellingPriceKobo,
    required this.averageCostKobo,
    required this.quantityOnHandMilli,
    required this.lowStockThresholdMilli,
    this.imagePath,
    this.description,
    required this.isArchived,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['normalized_name'] = Variable<String>(normalizedName);
    if (!nullToAbsent || sku != null) {
      map['sku'] = Variable<String>(sku);
    }
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    map['unit_label'] = Variable<String>(unitLabel);
    map['selling_price_kobo'] = Variable<int>(sellingPriceKobo);
    map['average_cost_kobo'] = Variable<int>(averageCostKobo);
    map['quantity_on_hand_milli'] = Variable<int>(quantityOnHandMilli);
    map['low_stock_threshold_milli'] = Variable<int>(lowStockThresholdMilli);
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['is_archived'] = Variable<bool>(isArchived);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      name: Value(name),
      normalizedName: Value(normalizedName),
      sku: sku == null && nullToAbsent ? const Value.absent() : Value(sku),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      unitLabel: Value(unitLabel),
      sellingPriceKobo: Value(sellingPriceKobo),
      averageCostKobo: Value(averageCostKobo),
      quantityOnHandMilli: Value(quantityOnHandMilli),
      lowStockThresholdMilli: Value(lowStockThresholdMilli),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      isArchived: Value(isArchived),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Product.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      normalizedName: serializer.fromJson<String>(json['normalizedName']),
      sku: serializer.fromJson<String?>(json['sku']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      unitLabel: serializer.fromJson<String>(json['unitLabel']),
      sellingPriceKobo: serializer.fromJson<int>(json['sellingPriceKobo']),
      averageCostKobo: serializer.fromJson<int>(json['averageCostKobo']),
      quantityOnHandMilli: serializer.fromJson<int>(
        json['quantityOnHandMilli'],
      ),
      lowStockThresholdMilli: serializer.fromJson<int>(
        json['lowStockThresholdMilli'],
      ),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      description: serializer.fromJson<String?>(json['description']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'normalizedName': serializer.toJson<String>(normalizedName),
      'sku': serializer.toJson<String?>(sku),
      'barcode': serializer.toJson<String?>(barcode),
      'categoryId': serializer.toJson<String?>(categoryId),
      'unitLabel': serializer.toJson<String>(unitLabel),
      'sellingPriceKobo': serializer.toJson<int>(sellingPriceKobo),
      'averageCostKobo': serializer.toJson<int>(averageCostKobo),
      'quantityOnHandMilli': serializer.toJson<int>(quantityOnHandMilli),
      'lowStockThresholdMilli': serializer.toJson<int>(lowStockThresholdMilli),
      'imagePath': serializer.toJson<String?>(imagePath),
      'description': serializer.toJson<String?>(description),
      'isArchived': serializer.toJson<bool>(isArchived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? normalizedName,
    Value<String?> sku = const Value.absent(),
    Value<String?> barcode = const Value.absent(),
    Value<String?> categoryId = const Value.absent(),
    String? unitLabel,
    int? sellingPriceKobo,
    int? averageCostKobo,
    int? quantityOnHandMilli,
    int? lowStockThresholdMilli,
    Value<String?> imagePath = const Value.absent(),
    Value<String?> description = const Value.absent(),
    bool? isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Product(
    id: id ?? this.id,
    name: name ?? this.name,
    normalizedName: normalizedName ?? this.normalizedName,
    sku: sku.present ? sku.value : this.sku,
    barcode: barcode.present ? barcode.value : this.barcode,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    unitLabel: unitLabel ?? this.unitLabel,
    sellingPriceKobo: sellingPriceKobo ?? this.sellingPriceKobo,
    averageCostKobo: averageCostKobo ?? this.averageCostKobo,
    quantityOnHandMilli: quantityOnHandMilli ?? this.quantityOnHandMilli,
    lowStockThresholdMilli:
        lowStockThresholdMilli ?? this.lowStockThresholdMilli,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    description: description.present ? description.value : this.description,
    isArchived: isArchived ?? this.isArchived,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      normalizedName: data.normalizedName.present
          ? data.normalizedName.value
          : this.normalizedName,
      sku: data.sku.present ? data.sku.value : this.sku,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      unitLabel: data.unitLabel.present ? data.unitLabel.value : this.unitLabel,
      sellingPriceKobo: data.sellingPriceKobo.present
          ? data.sellingPriceKobo.value
          : this.sellingPriceKobo,
      averageCostKobo: data.averageCostKobo.present
          ? data.averageCostKobo.value
          : this.averageCostKobo,
      quantityOnHandMilli: data.quantityOnHandMilli.present
          ? data.quantityOnHandMilli.value
          : this.quantityOnHandMilli,
      lowStockThresholdMilli: data.lowStockThresholdMilli.present
          ? data.lowStockThresholdMilli.value
          : this.lowStockThresholdMilli,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      description: data.description.present
          ? data.description.value
          : this.description,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('normalizedName: $normalizedName, ')
          ..write('sku: $sku, ')
          ..write('barcode: $barcode, ')
          ..write('categoryId: $categoryId, ')
          ..write('unitLabel: $unitLabel, ')
          ..write('sellingPriceKobo: $sellingPriceKobo, ')
          ..write('averageCostKobo: $averageCostKobo, ')
          ..write('quantityOnHandMilli: $quantityOnHandMilli, ')
          ..write('lowStockThresholdMilli: $lowStockThresholdMilli, ')
          ..write('imagePath: $imagePath, ')
          ..write('description: $description, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    normalizedName,
    sku,
    barcode,
    categoryId,
    unitLabel,
    sellingPriceKobo,
    averageCostKobo,
    quantityOnHandMilli,
    lowStockThresholdMilli,
    imagePath,
    description,
    isArchived,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.name == this.name &&
          other.normalizedName == this.normalizedName &&
          other.sku == this.sku &&
          other.barcode == this.barcode &&
          other.categoryId == this.categoryId &&
          other.unitLabel == this.unitLabel &&
          other.sellingPriceKobo == this.sellingPriceKobo &&
          other.averageCostKobo == this.averageCostKobo &&
          other.quantityOnHandMilli == this.quantityOnHandMilli &&
          other.lowStockThresholdMilli == this.lowStockThresholdMilli &&
          other.imagePath == this.imagePath &&
          other.description == this.description &&
          other.isArchived == this.isArchived &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> normalizedName;
  final Value<String?> sku;
  final Value<String?> barcode;
  final Value<String?> categoryId;
  final Value<String> unitLabel;
  final Value<int> sellingPriceKobo;
  final Value<int> averageCostKobo;
  final Value<int> quantityOnHandMilli;
  final Value<int> lowStockThresholdMilli;
  final Value<String?> imagePath;
  final Value<String?> description;
  final Value<bool> isArchived;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.normalizedName = const Value.absent(),
    this.sku = const Value.absent(),
    this.barcode = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.unitLabel = const Value.absent(),
    this.sellingPriceKobo = const Value.absent(),
    this.averageCostKobo = const Value.absent(),
    this.quantityOnHandMilli = const Value.absent(),
    this.lowStockThresholdMilli = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.description = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductsCompanion.insert({
    required String id,
    required String name,
    required String normalizedName,
    this.sku = const Value.absent(),
    this.barcode = const Value.absent(),
    this.categoryId = const Value.absent(),
    required String unitLabel,
    required int sellingPriceKobo,
    this.averageCostKobo = const Value.absent(),
    this.quantityOnHandMilli = const Value.absent(),
    this.lowStockThresholdMilli = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.description = const Value.absent(),
    this.isArchived = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       normalizedName = Value(normalizedName),
       unitLabel = Value(unitLabel),
       sellingPriceKobo = Value(sellingPriceKobo),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Product> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? normalizedName,
    Expression<String>? sku,
    Expression<String>? barcode,
    Expression<String>? categoryId,
    Expression<String>? unitLabel,
    Expression<int>? sellingPriceKobo,
    Expression<int>? averageCostKobo,
    Expression<int>? quantityOnHandMilli,
    Expression<int>? lowStockThresholdMilli,
    Expression<String>? imagePath,
    Expression<String>? description,
    Expression<bool>? isArchived,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (normalizedName != null) 'normalized_name': normalizedName,
      if (sku != null) 'sku': sku,
      if (barcode != null) 'barcode': barcode,
      if (categoryId != null) 'category_id': categoryId,
      if (unitLabel != null) 'unit_label': unitLabel,
      if (sellingPriceKobo != null) 'selling_price_kobo': sellingPriceKobo,
      if (averageCostKobo != null) 'average_cost_kobo': averageCostKobo,
      if (quantityOnHandMilli != null)
        'quantity_on_hand_milli': quantityOnHandMilli,
      if (lowStockThresholdMilli != null)
        'low_stock_threshold_milli': lowStockThresholdMilli,
      if (imagePath != null) 'image_path': imagePath,
      if (description != null) 'description': description,
      if (isArchived != null) 'is_archived': isArchived,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? normalizedName,
    Value<String?>? sku,
    Value<String?>? barcode,
    Value<String?>? categoryId,
    Value<String>? unitLabel,
    Value<int>? sellingPriceKobo,
    Value<int>? averageCostKobo,
    Value<int>? quantityOnHandMilli,
    Value<int>? lowStockThresholdMilli,
    Value<String?>? imagePath,
    Value<String?>? description,
    Value<bool>? isArchived,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ProductsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      normalizedName: normalizedName ?? this.normalizedName,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      categoryId: categoryId ?? this.categoryId,
      unitLabel: unitLabel ?? this.unitLabel,
      sellingPriceKobo: sellingPriceKobo ?? this.sellingPriceKobo,
      averageCostKobo: averageCostKobo ?? this.averageCostKobo,
      quantityOnHandMilli: quantityOnHandMilli ?? this.quantityOnHandMilli,
      lowStockThresholdMilli:
          lowStockThresholdMilli ?? this.lowStockThresholdMilli,
      imagePath: imagePath ?? this.imagePath,
      description: description ?? this.description,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (normalizedName.present) {
      map['normalized_name'] = Variable<String>(normalizedName.value);
    }
    if (sku.present) {
      map['sku'] = Variable<String>(sku.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (unitLabel.present) {
      map['unit_label'] = Variable<String>(unitLabel.value);
    }
    if (sellingPriceKobo.present) {
      map['selling_price_kobo'] = Variable<int>(sellingPriceKobo.value);
    }
    if (averageCostKobo.present) {
      map['average_cost_kobo'] = Variable<int>(averageCostKobo.value);
    }
    if (quantityOnHandMilli.present) {
      map['quantity_on_hand_milli'] = Variable<int>(quantityOnHandMilli.value);
    }
    if (lowStockThresholdMilli.present) {
      map['low_stock_threshold_milli'] = Variable<int>(
        lowStockThresholdMilli.value,
      );
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('normalizedName: $normalizedName, ')
          ..write('sku: $sku, ')
          ..write('barcode: $barcode, ')
          ..write('categoryId: $categoryId, ')
          ..write('unitLabel: $unitLabel, ')
          ..write('sellingPriceKobo: $sellingPriceKobo, ')
          ..write('averageCostKobo: $averageCostKobo, ')
          ..write('quantityOnHandMilli: $quantityOnHandMilli, ')
          ..write('lowStockThresholdMilli: $lowStockThresholdMilli, ')
          ..write('imagePath: $imagePath, ')
          ..write('description: $description, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StockReceiptsTable extends StockReceipts
    with TableInfo<$StockReceiptsTable, StockReceipt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockReceiptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _receiptNumberMeta = const VerificationMeta(
    'receiptNumber',
  );
  @override
  late final GeneratedColumn<String> receiptNumber = GeneratedColumn<String>(
    'receipt_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _supplierIdMeta = const VerificationMeta(
    'supplierId',
  );
  @override
  late final GeneratedColumn<String> supplierId = GeneratedColumn<String>(
    'supplier_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES suppliers (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _supplierNameSnapshotMeta =
      const VerificationMeta('supplierNameSnapshot');
  @override
  late final GeneratedColumn<String> supplierNameSnapshot =
      GeneratedColumn<String>(
        'supplier_name_snapshot',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _supplierReferenceMeta = const VerificationMeta(
    'supplierReference',
  );
  @override
  late final GeneratedColumn<String> supplierReference =
      GeneratedColumn<String>(
        'supplier_reference',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _receivedAtMeta = const VerificationMeta(
    'receivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> receivedAt = GeneratedColumn<DateTime>(
    'received_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalCostKoboMeta = const VerificationMeta(
    'totalCostKobo',
  );
  @override
  late final GeneratedColumn<int> totalCostKobo = GeneratedColumn<int>(
    'total_cost_kobo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idempotencyKeyMeta = const VerificationMeta(
    'idempotencyKey',
  );
  @override
  late final GeneratedColumn<String> idempotencyKey = GeneratedColumn<String>(
    'idempotency_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    receiptNumber,
    supplierId,
    supplierNameSnapshot,
    supplierReference,
    receivedAt,
    notes,
    totalCostKobo,
    idempotencyKey,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_receipts';
  @override
  VerificationContext validateIntegrity(
    Insertable<StockReceipt> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('receipt_number')) {
      context.handle(
        _receiptNumberMeta,
        receiptNumber.isAcceptableOrUnknown(
          data['receipt_number']!,
          _receiptNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_receiptNumberMeta);
    }
    if (data.containsKey('supplier_id')) {
      context.handle(
        _supplierIdMeta,
        supplierId.isAcceptableOrUnknown(data['supplier_id']!, _supplierIdMeta),
      );
    }
    if (data.containsKey('supplier_name_snapshot')) {
      context.handle(
        _supplierNameSnapshotMeta,
        supplierNameSnapshot.isAcceptableOrUnknown(
          data['supplier_name_snapshot']!,
          _supplierNameSnapshotMeta,
        ),
      );
    }
    if (data.containsKey('supplier_reference')) {
      context.handle(
        _supplierReferenceMeta,
        supplierReference.isAcceptableOrUnknown(
          data['supplier_reference']!,
          _supplierReferenceMeta,
        ),
      );
    }
    if (data.containsKey('received_at')) {
      context.handle(
        _receivedAtMeta,
        receivedAt.isAcceptableOrUnknown(data['received_at']!, _receivedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_receivedAtMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('total_cost_kobo')) {
      context.handle(
        _totalCostKoboMeta,
        totalCostKobo.isAcceptableOrUnknown(
          data['total_cost_kobo']!,
          _totalCostKoboMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalCostKoboMeta);
    }
    if (data.containsKey('idempotency_key')) {
      context.handle(
        _idempotencyKeyMeta,
        idempotencyKey.isAcceptableOrUnknown(
          data['idempotency_key']!,
          _idempotencyKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_idempotencyKeyMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StockReceipt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockReceipt(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      receiptNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_number'],
      )!,
      supplierId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplier_id'],
      ),
      supplierNameSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplier_name_snapshot'],
      ),
      supplierReference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplier_reference'],
      ),
      receivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}received_at'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      totalCostKobo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_cost_kobo'],
      )!,
      idempotencyKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}idempotency_key'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $StockReceiptsTable createAlias(String alias) {
    return $StockReceiptsTable(attachedDatabase, alias);
  }
}

class StockReceipt extends DataClass implements Insertable<StockReceipt> {
  final String id;
  final String receiptNumber;
  final String? supplierId;
  final String? supplierNameSnapshot;
  final String? supplierReference;
  final DateTime receivedAt;
  final String? notes;
  final int totalCostKobo;
  final String idempotencyKey;
  final DateTime createdAt;
  const StockReceipt({
    required this.id,
    required this.receiptNumber,
    this.supplierId,
    this.supplierNameSnapshot,
    this.supplierReference,
    required this.receivedAt,
    this.notes,
    required this.totalCostKobo,
    required this.idempotencyKey,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['receipt_number'] = Variable<String>(receiptNumber);
    if (!nullToAbsent || supplierId != null) {
      map['supplier_id'] = Variable<String>(supplierId);
    }
    if (!nullToAbsent || supplierNameSnapshot != null) {
      map['supplier_name_snapshot'] = Variable<String>(supplierNameSnapshot);
    }
    if (!nullToAbsent || supplierReference != null) {
      map['supplier_reference'] = Variable<String>(supplierReference);
    }
    map['received_at'] = Variable<DateTime>(receivedAt);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['total_cost_kobo'] = Variable<int>(totalCostKobo);
    map['idempotency_key'] = Variable<String>(idempotencyKey);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  StockReceiptsCompanion toCompanion(bool nullToAbsent) {
    return StockReceiptsCompanion(
      id: Value(id),
      receiptNumber: Value(receiptNumber),
      supplierId: supplierId == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierId),
      supplierNameSnapshot: supplierNameSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierNameSnapshot),
      supplierReference: supplierReference == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierReference),
      receivedAt: Value(receivedAt),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      totalCostKobo: Value(totalCostKobo),
      idempotencyKey: Value(idempotencyKey),
      createdAt: Value(createdAt),
    );
  }

  factory StockReceipt.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockReceipt(
      id: serializer.fromJson<String>(json['id']),
      receiptNumber: serializer.fromJson<String>(json['receiptNumber']),
      supplierId: serializer.fromJson<String?>(json['supplierId']),
      supplierNameSnapshot: serializer.fromJson<String?>(
        json['supplierNameSnapshot'],
      ),
      supplierReference: serializer.fromJson<String?>(
        json['supplierReference'],
      ),
      receivedAt: serializer.fromJson<DateTime>(json['receivedAt']),
      notes: serializer.fromJson<String?>(json['notes']),
      totalCostKobo: serializer.fromJson<int>(json['totalCostKobo']),
      idempotencyKey: serializer.fromJson<String>(json['idempotencyKey']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'receiptNumber': serializer.toJson<String>(receiptNumber),
      'supplierId': serializer.toJson<String?>(supplierId),
      'supplierNameSnapshot': serializer.toJson<String?>(supplierNameSnapshot),
      'supplierReference': serializer.toJson<String?>(supplierReference),
      'receivedAt': serializer.toJson<DateTime>(receivedAt),
      'notes': serializer.toJson<String?>(notes),
      'totalCostKobo': serializer.toJson<int>(totalCostKobo),
      'idempotencyKey': serializer.toJson<String>(idempotencyKey),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  StockReceipt copyWith({
    String? id,
    String? receiptNumber,
    Value<String?> supplierId = const Value.absent(),
    Value<String?> supplierNameSnapshot = const Value.absent(),
    Value<String?> supplierReference = const Value.absent(),
    DateTime? receivedAt,
    Value<String?> notes = const Value.absent(),
    int? totalCostKobo,
    String? idempotencyKey,
    DateTime? createdAt,
  }) => StockReceipt(
    id: id ?? this.id,
    receiptNumber: receiptNumber ?? this.receiptNumber,
    supplierId: supplierId.present ? supplierId.value : this.supplierId,
    supplierNameSnapshot: supplierNameSnapshot.present
        ? supplierNameSnapshot.value
        : this.supplierNameSnapshot,
    supplierReference: supplierReference.present
        ? supplierReference.value
        : this.supplierReference,
    receivedAt: receivedAt ?? this.receivedAt,
    notes: notes.present ? notes.value : this.notes,
    totalCostKobo: totalCostKobo ?? this.totalCostKobo,
    idempotencyKey: idempotencyKey ?? this.idempotencyKey,
    createdAt: createdAt ?? this.createdAt,
  );
  StockReceipt copyWithCompanion(StockReceiptsCompanion data) {
    return StockReceipt(
      id: data.id.present ? data.id.value : this.id,
      receiptNumber: data.receiptNumber.present
          ? data.receiptNumber.value
          : this.receiptNumber,
      supplierId: data.supplierId.present
          ? data.supplierId.value
          : this.supplierId,
      supplierNameSnapshot: data.supplierNameSnapshot.present
          ? data.supplierNameSnapshot.value
          : this.supplierNameSnapshot,
      supplierReference: data.supplierReference.present
          ? data.supplierReference.value
          : this.supplierReference,
      receivedAt: data.receivedAt.present
          ? data.receivedAt.value
          : this.receivedAt,
      notes: data.notes.present ? data.notes.value : this.notes,
      totalCostKobo: data.totalCostKobo.present
          ? data.totalCostKobo.value
          : this.totalCostKobo,
      idempotencyKey: data.idempotencyKey.present
          ? data.idempotencyKey.value
          : this.idempotencyKey,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StockReceipt(')
          ..write('id: $id, ')
          ..write('receiptNumber: $receiptNumber, ')
          ..write('supplierId: $supplierId, ')
          ..write('supplierNameSnapshot: $supplierNameSnapshot, ')
          ..write('supplierReference: $supplierReference, ')
          ..write('receivedAt: $receivedAt, ')
          ..write('notes: $notes, ')
          ..write('totalCostKobo: $totalCostKobo, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    receiptNumber,
    supplierId,
    supplierNameSnapshot,
    supplierReference,
    receivedAt,
    notes,
    totalCostKobo,
    idempotencyKey,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockReceipt &&
          other.id == this.id &&
          other.receiptNumber == this.receiptNumber &&
          other.supplierId == this.supplierId &&
          other.supplierNameSnapshot == this.supplierNameSnapshot &&
          other.supplierReference == this.supplierReference &&
          other.receivedAt == this.receivedAt &&
          other.notes == this.notes &&
          other.totalCostKobo == this.totalCostKobo &&
          other.idempotencyKey == this.idempotencyKey &&
          other.createdAt == this.createdAt);
}

class StockReceiptsCompanion extends UpdateCompanion<StockReceipt> {
  final Value<String> id;
  final Value<String> receiptNumber;
  final Value<String?> supplierId;
  final Value<String?> supplierNameSnapshot;
  final Value<String?> supplierReference;
  final Value<DateTime> receivedAt;
  final Value<String?> notes;
  final Value<int> totalCostKobo;
  final Value<String> idempotencyKey;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const StockReceiptsCompanion({
    this.id = const Value.absent(),
    this.receiptNumber = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.supplierNameSnapshot = const Value.absent(),
    this.supplierReference = const Value.absent(),
    this.receivedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.totalCostKobo = const Value.absent(),
    this.idempotencyKey = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StockReceiptsCompanion.insert({
    required String id,
    required String receiptNumber,
    this.supplierId = const Value.absent(),
    this.supplierNameSnapshot = const Value.absent(),
    this.supplierReference = const Value.absent(),
    required DateTime receivedAt,
    this.notes = const Value.absent(),
    required int totalCostKobo,
    required String idempotencyKey,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       receiptNumber = Value(receiptNumber),
       receivedAt = Value(receivedAt),
       totalCostKobo = Value(totalCostKobo),
       idempotencyKey = Value(idempotencyKey),
       createdAt = Value(createdAt);
  static Insertable<StockReceipt> custom({
    Expression<String>? id,
    Expression<String>? receiptNumber,
    Expression<String>? supplierId,
    Expression<String>? supplierNameSnapshot,
    Expression<String>? supplierReference,
    Expression<DateTime>? receivedAt,
    Expression<String>? notes,
    Expression<int>? totalCostKobo,
    Expression<String>? idempotencyKey,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (receiptNumber != null) 'receipt_number': receiptNumber,
      if (supplierId != null) 'supplier_id': supplierId,
      if (supplierNameSnapshot != null)
        'supplier_name_snapshot': supplierNameSnapshot,
      if (supplierReference != null) 'supplier_reference': supplierReference,
      if (receivedAt != null) 'received_at': receivedAt,
      if (notes != null) 'notes': notes,
      if (totalCostKobo != null) 'total_cost_kobo': totalCostKobo,
      if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StockReceiptsCompanion copyWith({
    Value<String>? id,
    Value<String>? receiptNumber,
    Value<String?>? supplierId,
    Value<String?>? supplierNameSnapshot,
    Value<String?>? supplierReference,
    Value<DateTime>? receivedAt,
    Value<String?>? notes,
    Value<int>? totalCostKobo,
    Value<String>? idempotencyKey,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return StockReceiptsCompanion(
      id: id ?? this.id,
      receiptNumber: receiptNumber ?? this.receiptNumber,
      supplierId: supplierId ?? this.supplierId,
      supplierNameSnapshot: supplierNameSnapshot ?? this.supplierNameSnapshot,
      supplierReference: supplierReference ?? this.supplierReference,
      receivedAt: receivedAt ?? this.receivedAt,
      notes: notes ?? this.notes,
      totalCostKobo: totalCostKobo ?? this.totalCostKobo,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (receiptNumber.present) {
      map['receipt_number'] = Variable<String>(receiptNumber.value);
    }
    if (supplierId.present) {
      map['supplier_id'] = Variable<String>(supplierId.value);
    }
    if (supplierNameSnapshot.present) {
      map['supplier_name_snapshot'] = Variable<String>(
        supplierNameSnapshot.value,
      );
    }
    if (supplierReference.present) {
      map['supplier_reference'] = Variable<String>(supplierReference.value);
    }
    if (receivedAt.present) {
      map['received_at'] = Variable<DateTime>(receivedAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (totalCostKobo.present) {
      map['total_cost_kobo'] = Variable<int>(totalCostKobo.value);
    }
    if (idempotencyKey.present) {
      map['idempotency_key'] = Variable<String>(idempotencyKey.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockReceiptsCompanion(')
          ..write('id: $id, ')
          ..write('receiptNumber: $receiptNumber, ')
          ..write('supplierId: $supplierId, ')
          ..write('supplierNameSnapshot: $supplierNameSnapshot, ')
          ..write('supplierReference: $supplierReference, ')
          ..write('receivedAt: $receivedAt, ')
          ..write('notes: $notes, ')
          ..write('totalCostKobo: $totalCostKobo, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StockReceiptLinesTable extends StockReceiptLines
    with TableInfo<$StockReceiptLinesTable, StockReceiptLine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockReceiptLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _receiptIdMeta = const VerificationMeta(
    'receiptId',
  );
  @override
  late final GeneratedColumn<String> receiptId = GeneratedColumn<String>(
    'receipt_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES stock_receipts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id)',
    ),
  );
  static const VerificationMeta _quantityMilliMeta = const VerificationMeta(
    'quantityMilli',
  );
  @override
  late final GeneratedColumn<int> quantityMilli = GeneratedColumn<int>(
    'quantity_milli',
    aliasedName,
    false,
    check: () => ComparableExpr(quantityMilli).isBiggerThanValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitCostKoboMeta = const VerificationMeta(
    'unitCostKobo',
  );
  @override
  late final GeneratedColumn<int> unitCostKobo = GeneratedColumn<int>(
    'unit_cost_kobo',
    aliasedName,
    false,
    check: () => ComparableExpr(unitCostKobo).isBiggerOrEqualValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lineCostKoboMeta = const VerificationMeta(
    'lineCostKobo',
  );
  @override
  late final GeneratedColumn<int> lineCostKobo = GeneratedColumn<int>(
    'line_cost_kobo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productNameSnapshotMeta =
      const VerificationMeta('productNameSnapshot');
  @override
  late final GeneratedColumn<String> productNameSnapshot =
      GeneratedColumn<String>(
        'product_name_snapshot',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _unitLabelSnapshotMeta = const VerificationMeta(
    'unitLabelSnapshot',
  );
  @override
  late final GeneratedColumn<String> unitLabelSnapshot =
      GeneratedColumn<String>(
        'unit_label_snapshot',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    receiptId,
    productId,
    quantityMilli,
    unitCostKobo,
    lineCostKobo,
    productNameSnapshot,
    unitLabelSnapshot,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_receipt_lines';
  @override
  VerificationContext validateIntegrity(
    Insertable<StockReceiptLine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('receipt_id')) {
      context.handle(
        _receiptIdMeta,
        receiptId.isAcceptableOrUnknown(data['receipt_id']!, _receiptIdMeta),
      );
    } else if (isInserting) {
      context.missing(_receiptIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('quantity_milli')) {
      context.handle(
        _quantityMilliMeta,
        quantityMilli.isAcceptableOrUnknown(
          data['quantity_milli']!,
          _quantityMilliMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_quantityMilliMeta);
    }
    if (data.containsKey('unit_cost_kobo')) {
      context.handle(
        _unitCostKoboMeta,
        unitCostKobo.isAcceptableOrUnknown(
          data['unit_cost_kobo']!,
          _unitCostKoboMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unitCostKoboMeta);
    }
    if (data.containsKey('line_cost_kobo')) {
      context.handle(
        _lineCostKoboMeta,
        lineCostKobo.isAcceptableOrUnknown(
          data['line_cost_kobo']!,
          _lineCostKoboMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lineCostKoboMeta);
    }
    if (data.containsKey('product_name_snapshot')) {
      context.handle(
        _productNameSnapshotMeta,
        productNameSnapshot.isAcceptableOrUnknown(
          data['product_name_snapshot']!,
          _productNameSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productNameSnapshotMeta);
    }
    if (data.containsKey('unit_label_snapshot')) {
      context.handle(
        _unitLabelSnapshotMeta,
        unitLabelSnapshot.isAcceptableOrUnknown(
          data['unit_label_snapshot']!,
          _unitLabelSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unitLabelSnapshotMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StockReceiptLine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockReceiptLine(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      receiptId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      quantityMilli: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity_milli'],
      )!,
      unitCostKobo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_cost_kobo'],
      )!,
      lineCostKobo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}line_cost_kobo'],
      )!,
      productNameSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_name_snapshot'],
      )!,
      unitLabelSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_label_snapshot'],
      )!,
    );
  }

  @override
  $StockReceiptLinesTable createAlias(String alias) {
    return $StockReceiptLinesTable(attachedDatabase, alias);
  }
}

class StockReceiptLine extends DataClass
    implements Insertable<StockReceiptLine> {
  final String id;
  final String receiptId;
  final String productId;
  final int quantityMilli;
  final int unitCostKobo;
  final int lineCostKobo;
  final String productNameSnapshot;
  final String unitLabelSnapshot;
  const StockReceiptLine({
    required this.id,
    required this.receiptId,
    required this.productId,
    required this.quantityMilli,
    required this.unitCostKobo,
    required this.lineCostKobo,
    required this.productNameSnapshot,
    required this.unitLabelSnapshot,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['receipt_id'] = Variable<String>(receiptId);
    map['product_id'] = Variable<String>(productId);
    map['quantity_milli'] = Variable<int>(quantityMilli);
    map['unit_cost_kobo'] = Variable<int>(unitCostKobo);
    map['line_cost_kobo'] = Variable<int>(lineCostKobo);
    map['product_name_snapshot'] = Variable<String>(productNameSnapshot);
    map['unit_label_snapshot'] = Variable<String>(unitLabelSnapshot);
    return map;
  }

  StockReceiptLinesCompanion toCompanion(bool nullToAbsent) {
    return StockReceiptLinesCompanion(
      id: Value(id),
      receiptId: Value(receiptId),
      productId: Value(productId),
      quantityMilli: Value(quantityMilli),
      unitCostKobo: Value(unitCostKobo),
      lineCostKobo: Value(lineCostKobo),
      productNameSnapshot: Value(productNameSnapshot),
      unitLabelSnapshot: Value(unitLabelSnapshot),
    );
  }

  factory StockReceiptLine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockReceiptLine(
      id: serializer.fromJson<String>(json['id']),
      receiptId: serializer.fromJson<String>(json['receiptId']),
      productId: serializer.fromJson<String>(json['productId']),
      quantityMilli: serializer.fromJson<int>(json['quantityMilli']),
      unitCostKobo: serializer.fromJson<int>(json['unitCostKobo']),
      lineCostKobo: serializer.fromJson<int>(json['lineCostKobo']),
      productNameSnapshot: serializer.fromJson<String>(
        json['productNameSnapshot'],
      ),
      unitLabelSnapshot: serializer.fromJson<String>(json['unitLabelSnapshot']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'receiptId': serializer.toJson<String>(receiptId),
      'productId': serializer.toJson<String>(productId),
      'quantityMilli': serializer.toJson<int>(quantityMilli),
      'unitCostKobo': serializer.toJson<int>(unitCostKobo),
      'lineCostKobo': serializer.toJson<int>(lineCostKobo),
      'productNameSnapshot': serializer.toJson<String>(productNameSnapshot),
      'unitLabelSnapshot': serializer.toJson<String>(unitLabelSnapshot),
    };
  }

  StockReceiptLine copyWith({
    String? id,
    String? receiptId,
    String? productId,
    int? quantityMilli,
    int? unitCostKobo,
    int? lineCostKobo,
    String? productNameSnapshot,
    String? unitLabelSnapshot,
  }) => StockReceiptLine(
    id: id ?? this.id,
    receiptId: receiptId ?? this.receiptId,
    productId: productId ?? this.productId,
    quantityMilli: quantityMilli ?? this.quantityMilli,
    unitCostKobo: unitCostKobo ?? this.unitCostKobo,
    lineCostKobo: lineCostKobo ?? this.lineCostKobo,
    productNameSnapshot: productNameSnapshot ?? this.productNameSnapshot,
    unitLabelSnapshot: unitLabelSnapshot ?? this.unitLabelSnapshot,
  );
  StockReceiptLine copyWithCompanion(StockReceiptLinesCompanion data) {
    return StockReceiptLine(
      id: data.id.present ? data.id.value : this.id,
      receiptId: data.receiptId.present ? data.receiptId.value : this.receiptId,
      productId: data.productId.present ? data.productId.value : this.productId,
      quantityMilli: data.quantityMilli.present
          ? data.quantityMilli.value
          : this.quantityMilli,
      unitCostKobo: data.unitCostKobo.present
          ? data.unitCostKobo.value
          : this.unitCostKobo,
      lineCostKobo: data.lineCostKobo.present
          ? data.lineCostKobo.value
          : this.lineCostKobo,
      productNameSnapshot: data.productNameSnapshot.present
          ? data.productNameSnapshot.value
          : this.productNameSnapshot,
      unitLabelSnapshot: data.unitLabelSnapshot.present
          ? data.unitLabelSnapshot.value
          : this.unitLabelSnapshot,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StockReceiptLine(')
          ..write('id: $id, ')
          ..write('receiptId: $receiptId, ')
          ..write('productId: $productId, ')
          ..write('quantityMilli: $quantityMilli, ')
          ..write('unitCostKobo: $unitCostKobo, ')
          ..write('lineCostKobo: $lineCostKobo, ')
          ..write('productNameSnapshot: $productNameSnapshot, ')
          ..write('unitLabelSnapshot: $unitLabelSnapshot')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    receiptId,
    productId,
    quantityMilli,
    unitCostKobo,
    lineCostKobo,
    productNameSnapshot,
    unitLabelSnapshot,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockReceiptLine &&
          other.id == this.id &&
          other.receiptId == this.receiptId &&
          other.productId == this.productId &&
          other.quantityMilli == this.quantityMilli &&
          other.unitCostKobo == this.unitCostKobo &&
          other.lineCostKobo == this.lineCostKobo &&
          other.productNameSnapshot == this.productNameSnapshot &&
          other.unitLabelSnapshot == this.unitLabelSnapshot);
}

class StockReceiptLinesCompanion extends UpdateCompanion<StockReceiptLine> {
  final Value<String> id;
  final Value<String> receiptId;
  final Value<String> productId;
  final Value<int> quantityMilli;
  final Value<int> unitCostKobo;
  final Value<int> lineCostKobo;
  final Value<String> productNameSnapshot;
  final Value<String> unitLabelSnapshot;
  final Value<int> rowid;
  const StockReceiptLinesCompanion({
    this.id = const Value.absent(),
    this.receiptId = const Value.absent(),
    this.productId = const Value.absent(),
    this.quantityMilli = const Value.absent(),
    this.unitCostKobo = const Value.absent(),
    this.lineCostKobo = const Value.absent(),
    this.productNameSnapshot = const Value.absent(),
    this.unitLabelSnapshot = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StockReceiptLinesCompanion.insert({
    required String id,
    required String receiptId,
    required String productId,
    required int quantityMilli,
    required int unitCostKobo,
    required int lineCostKobo,
    required String productNameSnapshot,
    required String unitLabelSnapshot,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       receiptId = Value(receiptId),
       productId = Value(productId),
       quantityMilli = Value(quantityMilli),
       unitCostKobo = Value(unitCostKobo),
       lineCostKobo = Value(lineCostKobo),
       productNameSnapshot = Value(productNameSnapshot),
       unitLabelSnapshot = Value(unitLabelSnapshot);
  static Insertable<StockReceiptLine> custom({
    Expression<String>? id,
    Expression<String>? receiptId,
    Expression<String>? productId,
    Expression<int>? quantityMilli,
    Expression<int>? unitCostKobo,
    Expression<int>? lineCostKobo,
    Expression<String>? productNameSnapshot,
    Expression<String>? unitLabelSnapshot,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (receiptId != null) 'receipt_id': receiptId,
      if (productId != null) 'product_id': productId,
      if (quantityMilli != null) 'quantity_milli': quantityMilli,
      if (unitCostKobo != null) 'unit_cost_kobo': unitCostKobo,
      if (lineCostKobo != null) 'line_cost_kobo': lineCostKobo,
      if (productNameSnapshot != null)
        'product_name_snapshot': productNameSnapshot,
      if (unitLabelSnapshot != null) 'unit_label_snapshot': unitLabelSnapshot,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StockReceiptLinesCompanion copyWith({
    Value<String>? id,
    Value<String>? receiptId,
    Value<String>? productId,
    Value<int>? quantityMilli,
    Value<int>? unitCostKobo,
    Value<int>? lineCostKobo,
    Value<String>? productNameSnapshot,
    Value<String>? unitLabelSnapshot,
    Value<int>? rowid,
  }) {
    return StockReceiptLinesCompanion(
      id: id ?? this.id,
      receiptId: receiptId ?? this.receiptId,
      productId: productId ?? this.productId,
      quantityMilli: quantityMilli ?? this.quantityMilli,
      unitCostKobo: unitCostKobo ?? this.unitCostKobo,
      lineCostKobo: lineCostKobo ?? this.lineCostKobo,
      productNameSnapshot: productNameSnapshot ?? this.productNameSnapshot,
      unitLabelSnapshot: unitLabelSnapshot ?? this.unitLabelSnapshot,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (receiptId.present) {
      map['receipt_id'] = Variable<String>(receiptId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (quantityMilli.present) {
      map['quantity_milli'] = Variable<int>(quantityMilli.value);
    }
    if (unitCostKobo.present) {
      map['unit_cost_kobo'] = Variable<int>(unitCostKobo.value);
    }
    if (lineCostKobo.present) {
      map['line_cost_kobo'] = Variable<int>(lineCostKobo.value);
    }
    if (productNameSnapshot.present) {
      map['product_name_snapshot'] = Variable<String>(
        productNameSnapshot.value,
      );
    }
    if (unitLabelSnapshot.present) {
      map['unit_label_snapshot'] = Variable<String>(unitLabelSnapshot.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockReceiptLinesCompanion(')
          ..write('id: $id, ')
          ..write('receiptId: $receiptId, ')
          ..write('productId: $productId, ')
          ..write('quantityMilli: $quantityMilli, ')
          ..write('unitCostKobo: $unitCostKobo, ')
          ..write('lineCostKobo: $lineCostKobo, ')
          ..write('productNameSnapshot: $productNameSnapshot, ')
          ..write('unitLabelSnapshot: $unitLabelSnapshot, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SalesTable extends Sales with TableInfo<$SalesTable, Sale> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SalesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _saleNumberMeta = const VerificationMeta(
    'saleNumber',
  );
  @override
  late final GeneratedColumn<String> saleNumber = GeneratedColumn<String>(
    'sale_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('COMPLETED'),
  );
  static const VerificationMeta _soldAtMeta = const VerificationMeta('soldAt');
  @override
  late final GeneratedColumn<DateTime> soldAt = GeneratedColumn<DateTime>(
    'sold_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentMethodMeta = const VerificationMeta(
    'paymentMethod',
  );
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
    'payment_method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerNameMeta = const VerificationMeta(
    'customerName',
  );
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
    'customer_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _subtotalKoboMeta = const VerificationMeta(
    'subtotalKobo',
  );
  @override
  late final GeneratedColumn<int> subtotalKobo = GeneratedColumn<int>(
    'subtotal_kobo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _discountTotalKoboMeta = const VerificationMeta(
    'discountTotalKobo',
  );
  @override
  late final GeneratedColumn<int> discountTotalKobo = GeneratedColumn<int>(
    'discount_total_kobo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalKoboMeta = const VerificationMeta(
    'totalKobo',
  );
  @override
  late final GeneratedColumn<int> totalKobo = GeneratedColumn<int>(
    'total_kobo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _voidedAtMeta = const VerificationMeta(
    'voidedAt',
  );
  @override
  late final GeneratedColumn<DateTime> voidedAt = GeneratedColumn<DateTime>(
    'voided_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _voidReasonMeta = const VerificationMeta(
    'voidReason',
  );
  @override
  late final GeneratedColumn<String> voidReason = GeneratedColumn<String>(
    'void_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _idempotencyKeyMeta = const VerificationMeta(
    'idempotencyKey',
  );
  @override
  late final GeneratedColumn<String> idempotencyKey = GeneratedColumn<String>(
    'idempotency_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    saleNumber,
    status,
    soldAt,
    paymentMethod,
    customerName,
    note,
    subtotalKobo,
    discountTotalKobo,
    totalKobo,
    voidedAt,
    voidReason,
    idempotencyKey,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sales';
  @override
  VerificationContext validateIntegrity(
    Insertable<Sale> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('sale_number')) {
      context.handle(
        _saleNumberMeta,
        saleNumber.isAcceptableOrUnknown(data['sale_number']!, _saleNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_saleNumberMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('sold_at')) {
      context.handle(
        _soldAtMeta,
        soldAt.isAcceptableOrUnknown(data['sold_at']!, _soldAtMeta),
      );
    } else if (isInserting) {
      context.missing(_soldAtMeta);
    }
    if (data.containsKey('payment_method')) {
      context.handle(
        _paymentMethodMeta,
        paymentMethod.isAcceptableOrUnknown(
          data['payment_method']!,
          _paymentMethodMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentMethodMeta);
    }
    if (data.containsKey('customer_name')) {
      context.handle(
        _customerNameMeta,
        customerName.isAcceptableOrUnknown(
          data['customer_name']!,
          _customerNameMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('subtotal_kobo')) {
      context.handle(
        _subtotalKoboMeta,
        subtotalKobo.isAcceptableOrUnknown(
          data['subtotal_kobo']!,
          _subtotalKoboMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_subtotalKoboMeta);
    }
    if (data.containsKey('discount_total_kobo')) {
      context.handle(
        _discountTotalKoboMeta,
        discountTotalKobo.isAcceptableOrUnknown(
          data['discount_total_kobo']!,
          _discountTotalKoboMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_discountTotalKoboMeta);
    }
    if (data.containsKey('total_kobo')) {
      context.handle(
        _totalKoboMeta,
        totalKobo.isAcceptableOrUnknown(data['total_kobo']!, _totalKoboMeta),
      );
    } else if (isInserting) {
      context.missing(_totalKoboMeta);
    }
    if (data.containsKey('voided_at')) {
      context.handle(
        _voidedAtMeta,
        voidedAt.isAcceptableOrUnknown(data['voided_at']!, _voidedAtMeta),
      );
    }
    if (data.containsKey('void_reason')) {
      context.handle(
        _voidReasonMeta,
        voidReason.isAcceptableOrUnknown(data['void_reason']!, _voidReasonMeta),
      );
    }
    if (data.containsKey('idempotency_key')) {
      context.handle(
        _idempotencyKeyMeta,
        idempotencyKey.isAcceptableOrUnknown(
          data['idempotency_key']!,
          _idempotencyKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_idempotencyKeyMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Sale map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Sale(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      saleNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sale_number'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      soldAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sold_at'],
      )!,
      paymentMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_method'],
      )!,
      customerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_name'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      subtotalKobo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subtotal_kobo'],
      )!,
      discountTotalKobo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}discount_total_kobo'],
      )!,
      totalKobo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_kobo'],
      )!,
      voidedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}voided_at'],
      ),
      voidReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}void_reason'],
      ),
      idempotencyKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}idempotency_key'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SalesTable createAlias(String alias) {
    return $SalesTable(attachedDatabase, alias);
  }
}

class Sale extends DataClass implements Insertable<Sale> {
  final String id;
  final String saleNumber;
  final String status;
  final DateTime soldAt;
  final String paymentMethod;
  final String? customerName;
  final String? note;
  final int subtotalKobo;
  final int discountTotalKobo;
  final int totalKobo;
  final DateTime? voidedAt;
  final String? voidReason;
  final String idempotencyKey;
  final DateTime createdAt;
  const Sale({
    required this.id,
    required this.saleNumber,
    required this.status,
    required this.soldAt,
    required this.paymentMethod,
    this.customerName,
    this.note,
    required this.subtotalKobo,
    required this.discountTotalKobo,
    required this.totalKobo,
    this.voidedAt,
    this.voidReason,
    required this.idempotencyKey,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sale_number'] = Variable<String>(saleNumber);
    map['status'] = Variable<String>(status);
    map['sold_at'] = Variable<DateTime>(soldAt);
    map['payment_method'] = Variable<String>(paymentMethod);
    if (!nullToAbsent || customerName != null) {
      map['customer_name'] = Variable<String>(customerName);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['subtotal_kobo'] = Variable<int>(subtotalKobo);
    map['discount_total_kobo'] = Variable<int>(discountTotalKobo);
    map['total_kobo'] = Variable<int>(totalKobo);
    if (!nullToAbsent || voidedAt != null) {
      map['voided_at'] = Variable<DateTime>(voidedAt);
    }
    if (!nullToAbsent || voidReason != null) {
      map['void_reason'] = Variable<String>(voidReason);
    }
    map['idempotency_key'] = Variable<String>(idempotencyKey);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SalesCompanion toCompanion(bool nullToAbsent) {
    return SalesCompanion(
      id: Value(id),
      saleNumber: Value(saleNumber),
      status: Value(status),
      soldAt: Value(soldAt),
      paymentMethod: Value(paymentMethod),
      customerName: customerName == null && nullToAbsent
          ? const Value.absent()
          : Value(customerName),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      subtotalKobo: Value(subtotalKobo),
      discountTotalKobo: Value(discountTotalKobo),
      totalKobo: Value(totalKobo),
      voidedAt: voidedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(voidedAt),
      voidReason: voidReason == null && nullToAbsent
          ? const Value.absent()
          : Value(voidReason),
      idempotencyKey: Value(idempotencyKey),
      createdAt: Value(createdAt),
    );
  }

  factory Sale.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Sale(
      id: serializer.fromJson<String>(json['id']),
      saleNumber: serializer.fromJson<String>(json['saleNumber']),
      status: serializer.fromJson<String>(json['status']),
      soldAt: serializer.fromJson<DateTime>(json['soldAt']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      customerName: serializer.fromJson<String?>(json['customerName']),
      note: serializer.fromJson<String?>(json['note']),
      subtotalKobo: serializer.fromJson<int>(json['subtotalKobo']),
      discountTotalKobo: serializer.fromJson<int>(json['discountTotalKobo']),
      totalKobo: serializer.fromJson<int>(json['totalKobo']),
      voidedAt: serializer.fromJson<DateTime?>(json['voidedAt']),
      voidReason: serializer.fromJson<String?>(json['voidReason']),
      idempotencyKey: serializer.fromJson<String>(json['idempotencyKey']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'saleNumber': serializer.toJson<String>(saleNumber),
      'status': serializer.toJson<String>(status),
      'soldAt': serializer.toJson<DateTime>(soldAt),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'customerName': serializer.toJson<String?>(customerName),
      'note': serializer.toJson<String?>(note),
      'subtotalKobo': serializer.toJson<int>(subtotalKobo),
      'discountTotalKobo': serializer.toJson<int>(discountTotalKobo),
      'totalKobo': serializer.toJson<int>(totalKobo),
      'voidedAt': serializer.toJson<DateTime?>(voidedAt),
      'voidReason': serializer.toJson<String?>(voidReason),
      'idempotencyKey': serializer.toJson<String>(idempotencyKey),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Sale copyWith({
    String? id,
    String? saleNumber,
    String? status,
    DateTime? soldAt,
    String? paymentMethod,
    Value<String?> customerName = const Value.absent(),
    Value<String?> note = const Value.absent(),
    int? subtotalKobo,
    int? discountTotalKobo,
    int? totalKobo,
    Value<DateTime?> voidedAt = const Value.absent(),
    Value<String?> voidReason = const Value.absent(),
    String? idempotencyKey,
    DateTime? createdAt,
  }) => Sale(
    id: id ?? this.id,
    saleNumber: saleNumber ?? this.saleNumber,
    status: status ?? this.status,
    soldAt: soldAt ?? this.soldAt,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    customerName: customerName.present ? customerName.value : this.customerName,
    note: note.present ? note.value : this.note,
    subtotalKobo: subtotalKobo ?? this.subtotalKobo,
    discountTotalKobo: discountTotalKobo ?? this.discountTotalKobo,
    totalKobo: totalKobo ?? this.totalKobo,
    voidedAt: voidedAt.present ? voidedAt.value : this.voidedAt,
    voidReason: voidReason.present ? voidReason.value : this.voidReason,
    idempotencyKey: idempotencyKey ?? this.idempotencyKey,
    createdAt: createdAt ?? this.createdAt,
  );
  Sale copyWithCompanion(SalesCompanion data) {
    return Sale(
      id: data.id.present ? data.id.value : this.id,
      saleNumber: data.saleNumber.present
          ? data.saleNumber.value
          : this.saleNumber,
      status: data.status.present ? data.status.value : this.status,
      soldAt: data.soldAt.present ? data.soldAt.value : this.soldAt,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      note: data.note.present ? data.note.value : this.note,
      subtotalKobo: data.subtotalKobo.present
          ? data.subtotalKobo.value
          : this.subtotalKobo,
      discountTotalKobo: data.discountTotalKobo.present
          ? data.discountTotalKobo.value
          : this.discountTotalKobo,
      totalKobo: data.totalKobo.present ? data.totalKobo.value : this.totalKobo,
      voidedAt: data.voidedAt.present ? data.voidedAt.value : this.voidedAt,
      voidReason: data.voidReason.present
          ? data.voidReason.value
          : this.voidReason,
      idempotencyKey: data.idempotencyKey.present
          ? data.idempotencyKey.value
          : this.idempotencyKey,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Sale(')
          ..write('id: $id, ')
          ..write('saleNumber: $saleNumber, ')
          ..write('status: $status, ')
          ..write('soldAt: $soldAt, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('customerName: $customerName, ')
          ..write('note: $note, ')
          ..write('subtotalKobo: $subtotalKobo, ')
          ..write('discountTotalKobo: $discountTotalKobo, ')
          ..write('totalKobo: $totalKobo, ')
          ..write('voidedAt: $voidedAt, ')
          ..write('voidReason: $voidReason, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    saleNumber,
    status,
    soldAt,
    paymentMethod,
    customerName,
    note,
    subtotalKobo,
    discountTotalKobo,
    totalKobo,
    voidedAt,
    voidReason,
    idempotencyKey,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Sale &&
          other.id == this.id &&
          other.saleNumber == this.saleNumber &&
          other.status == this.status &&
          other.soldAt == this.soldAt &&
          other.paymentMethod == this.paymentMethod &&
          other.customerName == this.customerName &&
          other.note == this.note &&
          other.subtotalKobo == this.subtotalKobo &&
          other.discountTotalKobo == this.discountTotalKobo &&
          other.totalKobo == this.totalKobo &&
          other.voidedAt == this.voidedAt &&
          other.voidReason == this.voidReason &&
          other.idempotencyKey == this.idempotencyKey &&
          other.createdAt == this.createdAt);
}

class SalesCompanion extends UpdateCompanion<Sale> {
  final Value<String> id;
  final Value<String> saleNumber;
  final Value<String> status;
  final Value<DateTime> soldAt;
  final Value<String> paymentMethod;
  final Value<String?> customerName;
  final Value<String?> note;
  final Value<int> subtotalKobo;
  final Value<int> discountTotalKobo;
  final Value<int> totalKobo;
  final Value<DateTime?> voidedAt;
  final Value<String?> voidReason;
  final Value<String> idempotencyKey;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SalesCompanion({
    this.id = const Value.absent(),
    this.saleNumber = const Value.absent(),
    this.status = const Value.absent(),
    this.soldAt = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.customerName = const Value.absent(),
    this.note = const Value.absent(),
    this.subtotalKobo = const Value.absent(),
    this.discountTotalKobo = const Value.absent(),
    this.totalKobo = const Value.absent(),
    this.voidedAt = const Value.absent(),
    this.voidReason = const Value.absent(),
    this.idempotencyKey = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SalesCompanion.insert({
    required String id,
    required String saleNumber,
    this.status = const Value.absent(),
    required DateTime soldAt,
    required String paymentMethod,
    this.customerName = const Value.absent(),
    this.note = const Value.absent(),
    required int subtotalKobo,
    required int discountTotalKobo,
    required int totalKobo,
    this.voidedAt = const Value.absent(),
    this.voidReason = const Value.absent(),
    required String idempotencyKey,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       saleNumber = Value(saleNumber),
       soldAt = Value(soldAt),
       paymentMethod = Value(paymentMethod),
       subtotalKobo = Value(subtotalKobo),
       discountTotalKobo = Value(discountTotalKobo),
       totalKobo = Value(totalKobo),
       idempotencyKey = Value(idempotencyKey),
       createdAt = Value(createdAt);
  static Insertable<Sale> custom({
    Expression<String>? id,
    Expression<String>? saleNumber,
    Expression<String>? status,
    Expression<DateTime>? soldAt,
    Expression<String>? paymentMethod,
    Expression<String>? customerName,
    Expression<String>? note,
    Expression<int>? subtotalKobo,
    Expression<int>? discountTotalKobo,
    Expression<int>? totalKobo,
    Expression<DateTime>? voidedAt,
    Expression<String>? voidReason,
    Expression<String>? idempotencyKey,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (saleNumber != null) 'sale_number': saleNumber,
      if (status != null) 'status': status,
      if (soldAt != null) 'sold_at': soldAt,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (customerName != null) 'customer_name': customerName,
      if (note != null) 'note': note,
      if (subtotalKobo != null) 'subtotal_kobo': subtotalKobo,
      if (discountTotalKobo != null) 'discount_total_kobo': discountTotalKobo,
      if (totalKobo != null) 'total_kobo': totalKobo,
      if (voidedAt != null) 'voided_at': voidedAt,
      if (voidReason != null) 'void_reason': voidReason,
      if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SalesCompanion copyWith({
    Value<String>? id,
    Value<String>? saleNumber,
    Value<String>? status,
    Value<DateTime>? soldAt,
    Value<String>? paymentMethod,
    Value<String?>? customerName,
    Value<String?>? note,
    Value<int>? subtotalKobo,
    Value<int>? discountTotalKobo,
    Value<int>? totalKobo,
    Value<DateTime?>? voidedAt,
    Value<String?>? voidReason,
    Value<String>? idempotencyKey,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return SalesCompanion(
      id: id ?? this.id,
      saleNumber: saleNumber ?? this.saleNumber,
      status: status ?? this.status,
      soldAt: soldAt ?? this.soldAt,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      customerName: customerName ?? this.customerName,
      note: note ?? this.note,
      subtotalKobo: subtotalKobo ?? this.subtotalKobo,
      discountTotalKobo: discountTotalKobo ?? this.discountTotalKobo,
      totalKobo: totalKobo ?? this.totalKobo,
      voidedAt: voidedAt ?? this.voidedAt,
      voidReason: voidReason ?? this.voidReason,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (saleNumber.present) {
      map['sale_number'] = Variable<String>(saleNumber.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (soldAt.present) {
      map['sold_at'] = Variable<DateTime>(soldAt.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (subtotalKobo.present) {
      map['subtotal_kobo'] = Variable<int>(subtotalKobo.value);
    }
    if (discountTotalKobo.present) {
      map['discount_total_kobo'] = Variable<int>(discountTotalKobo.value);
    }
    if (totalKobo.present) {
      map['total_kobo'] = Variable<int>(totalKobo.value);
    }
    if (voidedAt.present) {
      map['voided_at'] = Variable<DateTime>(voidedAt.value);
    }
    if (voidReason.present) {
      map['void_reason'] = Variable<String>(voidReason.value);
    }
    if (idempotencyKey.present) {
      map['idempotency_key'] = Variable<String>(idempotencyKey.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SalesCompanion(')
          ..write('id: $id, ')
          ..write('saleNumber: $saleNumber, ')
          ..write('status: $status, ')
          ..write('soldAt: $soldAt, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('customerName: $customerName, ')
          ..write('note: $note, ')
          ..write('subtotalKobo: $subtotalKobo, ')
          ..write('discountTotalKobo: $discountTotalKobo, ')
          ..write('totalKobo: $totalKobo, ')
          ..write('voidedAt: $voidedAt, ')
          ..write('voidReason: $voidReason, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SaleLinesTable extends SaleLines
    with TableInfo<$SaleLinesTable, SaleLine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SaleLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<String> saleId = GeneratedColumn<String>(
    'sale_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sales (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id)',
    ),
  );
  static const VerificationMeta _productNameSnapshotMeta =
      const VerificationMeta('productNameSnapshot');
  @override
  late final GeneratedColumn<String> productNameSnapshot =
      GeneratedColumn<String>(
        'product_name_snapshot',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _skuSnapshotMeta = const VerificationMeta(
    'skuSnapshot',
  );
  @override
  late final GeneratedColumn<String> skuSnapshot = GeneratedColumn<String>(
    'sku_snapshot',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitLabelSnapshotMeta = const VerificationMeta(
    'unitLabelSnapshot',
  );
  @override
  late final GeneratedColumn<String> unitLabelSnapshot =
      GeneratedColumn<String>(
        'unit_label_snapshot',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _quantityMilliMeta = const VerificationMeta(
    'quantityMilli',
  );
  @override
  late final GeneratedColumn<int> quantityMilli = GeneratedColumn<int>(
    'quantity_milli',
    aliasedName,
    false,
    check: () => ComparableExpr(quantityMilli).isBiggerThanValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitPriceKoboMeta = const VerificationMeta(
    'unitPriceKobo',
  );
  @override
  late final GeneratedColumn<int> unitPriceKobo = GeneratedColumn<int>(
    'unit_price_kobo',
    aliasedName,
    false,
    check: () => ComparableExpr(unitPriceKobo).isBiggerOrEqualValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _grossLineTotalKoboMeta =
      const VerificationMeta('grossLineTotalKobo');
  @override
  late final GeneratedColumn<int> grossLineTotalKobo = GeneratedColumn<int>(
    'gross_line_total_kobo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _discountKoboMeta = const VerificationMeta(
    'discountKobo',
  );
  @override
  late final GeneratedColumn<int> discountKobo = GeneratedColumn<int>(
    'discount_kobo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _netLineTotalKoboMeta = const VerificationMeta(
    'netLineTotalKobo',
  );
  @override
  late final GeneratedColumn<int> netLineTotalKobo = GeneratedColumn<int>(
    'net_line_total_kobo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitCostSnapshotKoboMeta =
      const VerificationMeta('unitCostSnapshotKobo');
  @override
  late final GeneratedColumn<int> unitCostSnapshotKobo = GeneratedColumn<int>(
    'unit_cost_snapshot_kobo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cogsTotalKoboMeta = const VerificationMeta(
    'cogsTotalKobo',
  );
  @override
  late final GeneratedColumn<int> cogsTotalKobo = GeneratedColumn<int>(
    'cogs_total_kobo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    saleId,
    productId,
    productNameSnapshot,
    skuSnapshot,
    unitLabelSnapshot,
    quantityMilli,
    unitPriceKobo,
    grossLineTotalKobo,
    discountKobo,
    netLineTotalKobo,
    unitCostSnapshotKobo,
    cogsTotalKobo,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sale_lines';
  @override
  VerificationContext validateIntegrity(
    Insertable<SaleLine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('sale_id')) {
      context.handle(
        _saleIdMeta,
        saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_saleIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('product_name_snapshot')) {
      context.handle(
        _productNameSnapshotMeta,
        productNameSnapshot.isAcceptableOrUnknown(
          data['product_name_snapshot']!,
          _productNameSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productNameSnapshotMeta);
    }
    if (data.containsKey('sku_snapshot')) {
      context.handle(
        _skuSnapshotMeta,
        skuSnapshot.isAcceptableOrUnknown(
          data['sku_snapshot']!,
          _skuSnapshotMeta,
        ),
      );
    }
    if (data.containsKey('unit_label_snapshot')) {
      context.handle(
        _unitLabelSnapshotMeta,
        unitLabelSnapshot.isAcceptableOrUnknown(
          data['unit_label_snapshot']!,
          _unitLabelSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unitLabelSnapshotMeta);
    }
    if (data.containsKey('quantity_milli')) {
      context.handle(
        _quantityMilliMeta,
        quantityMilli.isAcceptableOrUnknown(
          data['quantity_milli']!,
          _quantityMilliMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_quantityMilliMeta);
    }
    if (data.containsKey('unit_price_kobo')) {
      context.handle(
        _unitPriceKoboMeta,
        unitPriceKobo.isAcceptableOrUnknown(
          data['unit_price_kobo']!,
          _unitPriceKoboMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unitPriceKoboMeta);
    }
    if (data.containsKey('gross_line_total_kobo')) {
      context.handle(
        _grossLineTotalKoboMeta,
        grossLineTotalKobo.isAcceptableOrUnknown(
          data['gross_line_total_kobo']!,
          _grossLineTotalKoboMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_grossLineTotalKoboMeta);
    }
    if (data.containsKey('discount_kobo')) {
      context.handle(
        _discountKoboMeta,
        discountKobo.isAcceptableOrUnknown(
          data['discount_kobo']!,
          _discountKoboMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_discountKoboMeta);
    }
    if (data.containsKey('net_line_total_kobo')) {
      context.handle(
        _netLineTotalKoboMeta,
        netLineTotalKobo.isAcceptableOrUnknown(
          data['net_line_total_kobo']!,
          _netLineTotalKoboMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_netLineTotalKoboMeta);
    }
    if (data.containsKey('unit_cost_snapshot_kobo')) {
      context.handle(
        _unitCostSnapshotKoboMeta,
        unitCostSnapshotKobo.isAcceptableOrUnknown(
          data['unit_cost_snapshot_kobo']!,
          _unitCostSnapshotKoboMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unitCostSnapshotKoboMeta);
    }
    if (data.containsKey('cogs_total_kobo')) {
      context.handle(
        _cogsTotalKoboMeta,
        cogsTotalKobo.isAcceptableOrUnknown(
          data['cogs_total_kobo']!,
          _cogsTotalKoboMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cogsTotalKoboMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SaleLine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SaleLine(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      saleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sale_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      productNameSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_name_snapshot'],
      )!,
      skuSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sku_snapshot'],
      ),
      unitLabelSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_label_snapshot'],
      )!,
      quantityMilli: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity_milli'],
      )!,
      unitPriceKobo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_price_kobo'],
      )!,
      grossLineTotalKobo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gross_line_total_kobo'],
      )!,
      discountKobo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}discount_kobo'],
      )!,
      netLineTotalKobo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}net_line_total_kobo'],
      )!,
      unitCostSnapshotKobo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_cost_snapshot_kobo'],
      )!,
      cogsTotalKobo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cogs_total_kobo'],
      )!,
    );
  }

  @override
  $SaleLinesTable createAlias(String alias) {
    return $SaleLinesTable(attachedDatabase, alias);
  }
}

class SaleLine extends DataClass implements Insertable<SaleLine> {
  final String id;
  final String saleId;
  final String productId;
  final String productNameSnapshot;
  final String? skuSnapshot;
  final String unitLabelSnapshot;
  final int quantityMilli;
  final int unitPriceKobo;
  final int grossLineTotalKobo;
  final int discountKobo;
  final int netLineTotalKobo;
  final int unitCostSnapshotKobo;
  final int cogsTotalKobo;
  const SaleLine({
    required this.id,
    required this.saleId,
    required this.productId,
    required this.productNameSnapshot,
    this.skuSnapshot,
    required this.unitLabelSnapshot,
    required this.quantityMilli,
    required this.unitPriceKobo,
    required this.grossLineTotalKobo,
    required this.discountKobo,
    required this.netLineTotalKobo,
    required this.unitCostSnapshotKobo,
    required this.cogsTotalKobo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sale_id'] = Variable<String>(saleId);
    map['product_id'] = Variable<String>(productId);
    map['product_name_snapshot'] = Variable<String>(productNameSnapshot);
    if (!nullToAbsent || skuSnapshot != null) {
      map['sku_snapshot'] = Variable<String>(skuSnapshot);
    }
    map['unit_label_snapshot'] = Variable<String>(unitLabelSnapshot);
    map['quantity_milli'] = Variable<int>(quantityMilli);
    map['unit_price_kobo'] = Variable<int>(unitPriceKobo);
    map['gross_line_total_kobo'] = Variable<int>(grossLineTotalKobo);
    map['discount_kobo'] = Variable<int>(discountKobo);
    map['net_line_total_kobo'] = Variable<int>(netLineTotalKobo);
    map['unit_cost_snapshot_kobo'] = Variable<int>(unitCostSnapshotKobo);
    map['cogs_total_kobo'] = Variable<int>(cogsTotalKobo);
    return map;
  }

  SaleLinesCompanion toCompanion(bool nullToAbsent) {
    return SaleLinesCompanion(
      id: Value(id),
      saleId: Value(saleId),
      productId: Value(productId),
      productNameSnapshot: Value(productNameSnapshot),
      skuSnapshot: skuSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(skuSnapshot),
      unitLabelSnapshot: Value(unitLabelSnapshot),
      quantityMilli: Value(quantityMilli),
      unitPriceKobo: Value(unitPriceKobo),
      grossLineTotalKobo: Value(grossLineTotalKobo),
      discountKobo: Value(discountKobo),
      netLineTotalKobo: Value(netLineTotalKobo),
      unitCostSnapshotKobo: Value(unitCostSnapshotKobo),
      cogsTotalKobo: Value(cogsTotalKobo),
    );
  }

  factory SaleLine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SaleLine(
      id: serializer.fromJson<String>(json['id']),
      saleId: serializer.fromJson<String>(json['saleId']),
      productId: serializer.fromJson<String>(json['productId']),
      productNameSnapshot: serializer.fromJson<String>(
        json['productNameSnapshot'],
      ),
      skuSnapshot: serializer.fromJson<String?>(json['skuSnapshot']),
      unitLabelSnapshot: serializer.fromJson<String>(json['unitLabelSnapshot']),
      quantityMilli: serializer.fromJson<int>(json['quantityMilli']),
      unitPriceKobo: serializer.fromJson<int>(json['unitPriceKobo']),
      grossLineTotalKobo: serializer.fromJson<int>(json['grossLineTotalKobo']),
      discountKobo: serializer.fromJson<int>(json['discountKobo']),
      netLineTotalKobo: serializer.fromJson<int>(json['netLineTotalKobo']),
      unitCostSnapshotKobo: serializer.fromJson<int>(
        json['unitCostSnapshotKobo'],
      ),
      cogsTotalKobo: serializer.fromJson<int>(json['cogsTotalKobo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'saleId': serializer.toJson<String>(saleId),
      'productId': serializer.toJson<String>(productId),
      'productNameSnapshot': serializer.toJson<String>(productNameSnapshot),
      'skuSnapshot': serializer.toJson<String?>(skuSnapshot),
      'unitLabelSnapshot': serializer.toJson<String>(unitLabelSnapshot),
      'quantityMilli': serializer.toJson<int>(quantityMilli),
      'unitPriceKobo': serializer.toJson<int>(unitPriceKobo),
      'grossLineTotalKobo': serializer.toJson<int>(grossLineTotalKobo),
      'discountKobo': serializer.toJson<int>(discountKobo),
      'netLineTotalKobo': serializer.toJson<int>(netLineTotalKobo),
      'unitCostSnapshotKobo': serializer.toJson<int>(unitCostSnapshotKobo),
      'cogsTotalKobo': serializer.toJson<int>(cogsTotalKobo),
    };
  }

  SaleLine copyWith({
    String? id,
    String? saleId,
    String? productId,
    String? productNameSnapshot,
    Value<String?> skuSnapshot = const Value.absent(),
    String? unitLabelSnapshot,
    int? quantityMilli,
    int? unitPriceKobo,
    int? grossLineTotalKobo,
    int? discountKobo,
    int? netLineTotalKobo,
    int? unitCostSnapshotKobo,
    int? cogsTotalKobo,
  }) => SaleLine(
    id: id ?? this.id,
    saleId: saleId ?? this.saleId,
    productId: productId ?? this.productId,
    productNameSnapshot: productNameSnapshot ?? this.productNameSnapshot,
    skuSnapshot: skuSnapshot.present ? skuSnapshot.value : this.skuSnapshot,
    unitLabelSnapshot: unitLabelSnapshot ?? this.unitLabelSnapshot,
    quantityMilli: quantityMilli ?? this.quantityMilli,
    unitPriceKobo: unitPriceKobo ?? this.unitPriceKobo,
    grossLineTotalKobo: grossLineTotalKobo ?? this.grossLineTotalKobo,
    discountKobo: discountKobo ?? this.discountKobo,
    netLineTotalKobo: netLineTotalKobo ?? this.netLineTotalKobo,
    unitCostSnapshotKobo: unitCostSnapshotKobo ?? this.unitCostSnapshotKobo,
    cogsTotalKobo: cogsTotalKobo ?? this.cogsTotalKobo,
  );
  SaleLine copyWithCompanion(SaleLinesCompanion data) {
    return SaleLine(
      id: data.id.present ? data.id.value : this.id,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      productId: data.productId.present ? data.productId.value : this.productId,
      productNameSnapshot: data.productNameSnapshot.present
          ? data.productNameSnapshot.value
          : this.productNameSnapshot,
      skuSnapshot: data.skuSnapshot.present
          ? data.skuSnapshot.value
          : this.skuSnapshot,
      unitLabelSnapshot: data.unitLabelSnapshot.present
          ? data.unitLabelSnapshot.value
          : this.unitLabelSnapshot,
      quantityMilli: data.quantityMilli.present
          ? data.quantityMilli.value
          : this.quantityMilli,
      unitPriceKobo: data.unitPriceKobo.present
          ? data.unitPriceKobo.value
          : this.unitPriceKobo,
      grossLineTotalKobo: data.grossLineTotalKobo.present
          ? data.grossLineTotalKobo.value
          : this.grossLineTotalKobo,
      discountKobo: data.discountKobo.present
          ? data.discountKobo.value
          : this.discountKobo,
      netLineTotalKobo: data.netLineTotalKobo.present
          ? data.netLineTotalKobo.value
          : this.netLineTotalKobo,
      unitCostSnapshotKobo: data.unitCostSnapshotKobo.present
          ? data.unitCostSnapshotKobo.value
          : this.unitCostSnapshotKobo,
      cogsTotalKobo: data.cogsTotalKobo.present
          ? data.cogsTotalKobo.value
          : this.cogsTotalKobo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SaleLine(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('productId: $productId, ')
          ..write('productNameSnapshot: $productNameSnapshot, ')
          ..write('skuSnapshot: $skuSnapshot, ')
          ..write('unitLabelSnapshot: $unitLabelSnapshot, ')
          ..write('quantityMilli: $quantityMilli, ')
          ..write('unitPriceKobo: $unitPriceKobo, ')
          ..write('grossLineTotalKobo: $grossLineTotalKobo, ')
          ..write('discountKobo: $discountKobo, ')
          ..write('netLineTotalKobo: $netLineTotalKobo, ')
          ..write('unitCostSnapshotKobo: $unitCostSnapshotKobo, ')
          ..write('cogsTotalKobo: $cogsTotalKobo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    saleId,
    productId,
    productNameSnapshot,
    skuSnapshot,
    unitLabelSnapshot,
    quantityMilli,
    unitPriceKobo,
    grossLineTotalKobo,
    discountKobo,
    netLineTotalKobo,
    unitCostSnapshotKobo,
    cogsTotalKobo,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SaleLine &&
          other.id == this.id &&
          other.saleId == this.saleId &&
          other.productId == this.productId &&
          other.productNameSnapshot == this.productNameSnapshot &&
          other.skuSnapshot == this.skuSnapshot &&
          other.unitLabelSnapshot == this.unitLabelSnapshot &&
          other.quantityMilli == this.quantityMilli &&
          other.unitPriceKobo == this.unitPriceKobo &&
          other.grossLineTotalKobo == this.grossLineTotalKobo &&
          other.discountKobo == this.discountKobo &&
          other.netLineTotalKobo == this.netLineTotalKobo &&
          other.unitCostSnapshotKobo == this.unitCostSnapshotKobo &&
          other.cogsTotalKobo == this.cogsTotalKobo);
}

class SaleLinesCompanion extends UpdateCompanion<SaleLine> {
  final Value<String> id;
  final Value<String> saleId;
  final Value<String> productId;
  final Value<String> productNameSnapshot;
  final Value<String?> skuSnapshot;
  final Value<String> unitLabelSnapshot;
  final Value<int> quantityMilli;
  final Value<int> unitPriceKobo;
  final Value<int> grossLineTotalKobo;
  final Value<int> discountKobo;
  final Value<int> netLineTotalKobo;
  final Value<int> unitCostSnapshotKobo;
  final Value<int> cogsTotalKobo;
  final Value<int> rowid;
  const SaleLinesCompanion({
    this.id = const Value.absent(),
    this.saleId = const Value.absent(),
    this.productId = const Value.absent(),
    this.productNameSnapshot = const Value.absent(),
    this.skuSnapshot = const Value.absent(),
    this.unitLabelSnapshot = const Value.absent(),
    this.quantityMilli = const Value.absent(),
    this.unitPriceKobo = const Value.absent(),
    this.grossLineTotalKobo = const Value.absent(),
    this.discountKobo = const Value.absent(),
    this.netLineTotalKobo = const Value.absent(),
    this.unitCostSnapshotKobo = const Value.absent(),
    this.cogsTotalKobo = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SaleLinesCompanion.insert({
    required String id,
    required String saleId,
    required String productId,
    required String productNameSnapshot,
    this.skuSnapshot = const Value.absent(),
    required String unitLabelSnapshot,
    required int quantityMilli,
    required int unitPriceKobo,
    required int grossLineTotalKobo,
    required int discountKobo,
    required int netLineTotalKobo,
    required int unitCostSnapshotKobo,
    required int cogsTotalKobo,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       saleId = Value(saleId),
       productId = Value(productId),
       productNameSnapshot = Value(productNameSnapshot),
       unitLabelSnapshot = Value(unitLabelSnapshot),
       quantityMilli = Value(quantityMilli),
       unitPriceKobo = Value(unitPriceKobo),
       grossLineTotalKobo = Value(grossLineTotalKobo),
       discountKobo = Value(discountKobo),
       netLineTotalKobo = Value(netLineTotalKobo),
       unitCostSnapshotKobo = Value(unitCostSnapshotKobo),
       cogsTotalKobo = Value(cogsTotalKobo);
  static Insertable<SaleLine> custom({
    Expression<String>? id,
    Expression<String>? saleId,
    Expression<String>? productId,
    Expression<String>? productNameSnapshot,
    Expression<String>? skuSnapshot,
    Expression<String>? unitLabelSnapshot,
    Expression<int>? quantityMilli,
    Expression<int>? unitPriceKobo,
    Expression<int>? grossLineTotalKobo,
    Expression<int>? discountKobo,
    Expression<int>? netLineTotalKobo,
    Expression<int>? unitCostSnapshotKobo,
    Expression<int>? cogsTotalKobo,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (saleId != null) 'sale_id': saleId,
      if (productId != null) 'product_id': productId,
      if (productNameSnapshot != null)
        'product_name_snapshot': productNameSnapshot,
      if (skuSnapshot != null) 'sku_snapshot': skuSnapshot,
      if (unitLabelSnapshot != null) 'unit_label_snapshot': unitLabelSnapshot,
      if (quantityMilli != null) 'quantity_milli': quantityMilli,
      if (unitPriceKobo != null) 'unit_price_kobo': unitPriceKobo,
      if (grossLineTotalKobo != null)
        'gross_line_total_kobo': grossLineTotalKobo,
      if (discountKobo != null) 'discount_kobo': discountKobo,
      if (netLineTotalKobo != null) 'net_line_total_kobo': netLineTotalKobo,
      if (unitCostSnapshotKobo != null)
        'unit_cost_snapshot_kobo': unitCostSnapshotKobo,
      if (cogsTotalKobo != null) 'cogs_total_kobo': cogsTotalKobo,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SaleLinesCompanion copyWith({
    Value<String>? id,
    Value<String>? saleId,
    Value<String>? productId,
    Value<String>? productNameSnapshot,
    Value<String?>? skuSnapshot,
    Value<String>? unitLabelSnapshot,
    Value<int>? quantityMilli,
    Value<int>? unitPriceKobo,
    Value<int>? grossLineTotalKobo,
    Value<int>? discountKobo,
    Value<int>? netLineTotalKobo,
    Value<int>? unitCostSnapshotKobo,
    Value<int>? cogsTotalKobo,
    Value<int>? rowid,
  }) {
    return SaleLinesCompanion(
      id: id ?? this.id,
      saleId: saleId ?? this.saleId,
      productId: productId ?? this.productId,
      productNameSnapshot: productNameSnapshot ?? this.productNameSnapshot,
      skuSnapshot: skuSnapshot ?? this.skuSnapshot,
      unitLabelSnapshot: unitLabelSnapshot ?? this.unitLabelSnapshot,
      quantityMilli: quantityMilli ?? this.quantityMilli,
      unitPriceKobo: unitPriceKobo ?? this.unitPriceKobo,
      grossLineTotalKobo: grossLineTotalKobo ?? this.grossLineTotalKobo,
      discountKobo: discountKobo ?? this.discountKobo,
      netLineTotalKobo: netLineTotalKobo ?? this.netLineTotalKobo,
      unitCostSnapshotKobo: unitCostSnapshotKobo ?? this.unitCostSnapshotKobo,
      cogsTotalKobo: cogsTotalKobo ?? this.cogsTotalKobo,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (saleId.present) {
      map['sale_id'] = Variable<String>(saleId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (productNameSnapshot.present) {
      map['product_name_snapshot'] = Variable<String>(
        productNameSnapshot.value,
      );
    }
    if (skuSnapshot.present) {
      map['sku_snapshot'] = Variable<String>(skuSnapshot.value);
    }
    if (unitLabelSnapshot.present) {
      map['unit_label_snapshot'] = Variable<String>(unitLabelSnapshot.value);
    }
    if (quantityMilli.present) {
      map['quantity_milli'] = Variable<int>(quantityMilli.value);
    }
    if (unitPriceKobo.present) {
      map['unit_price_kobo'] = Variable<int>(unitPriceKobo.value);
    }
    if (grossLineTotalKobo.present) {
      map['gross_line_total_kobo'] = Variable<int>(grossLineTotalKobo.value);
    }
    if (discountKobo.present) {
      map['discount_kobo'] = Variable<int>(discountKobo.value);
    }
    if (netLineTotalKobo.present) {
      map['net_line_total_kobo'] = Variable<int>(netLineTotalKobo.value);
    }
    if (unitCostSnapshotKobo.present) {
      map['unit_cost_snapshot_kobo'] = Variable<int>(
        unitCostSnapshotKobo.value,
      );
    }
    if (cogsTotalKobo.present) {
      map['cogs_total_kobo'] = Variable<int>(cogsTotalKobo.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SaleLinesCompanion(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('productId: $productId, ')
          ..write('productNameSnapshot: $productNameSnapshot, ')
          ..write('skuSnapshot: $skuSnapshot, ')
          ..write('unitLabelSnapshot: $unitLabelSnapshot, ')
          ..write('quantityMilli: $quantityMilli, ')
          ..write('unitPriceKobo: $unitPriceKobo, ')
          ..write('grossLineTotalKobo: $grossLineTotalKobo, ')
          ..write('discountKobo: $discountKobo, ')
          ..write('netLineTotalKobo: $netLineTotalKobo, ')
          ..write('unitCostSnapshotKobo: $unitCostSnapshotKobo, ')
          ..write('cogsTotalKobo: $cogsTotalKobo, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StockMovementsTable extends StockMovements
    with TableInfo<$StockMovementsTable, StockMovement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockMovementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id)',
    ),
  );
  static const VerificationMeta _movementTypeMeta = const VerificationMeta(
    'movementType',
  );
  @override
  late final GeneratedColumn<String> movementType = GeneratedColumn<String>(
    'movement_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityDeltaMilliMeta =
      const VerificationMeta('quantityDeltaMilli');
  @override
  late final GeneratedColumn<int> quantityDeltaMilli = GeneratedColumn<int>(
    'quantity_delta_milli',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitCostKoboMeta = const VerificationMeta(
    'unitCostKobo',
  );
  @override
  late final GeneratedColumn<int> unitCostKobo = GeneratedColumn<int>(
    'unit_cost_kobo',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _referenceTypeMeta = const VerificationMeta(
    'referenceType',
  );
  @override
  late final GeneratedColumn<String> referenceType = GeneratedColumn<String>(
    'reference_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _referenceIdMeta = const VerificationMeta(
    'referenceId',
  );
  @override
  late final GeneratedColumn<String> referenceId = GeneratedColumn<String>(
    'reference_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _idempotencyKeyMeta = const VerificationMeta(
    'idempotencyKey',
  );
  @override
  late final GeneratedColumn<String> idempotencyKey = GeneratedColumn<String>(
    'idempotency_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productId,
    movementType,
    quantityDeltaMilli,
    unitCostKobo,
    occurredAt,
    referenceType,
    referenceId,
    reason,
    note,
    idempotencyKey,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_movements';
  @override
  VerificationContext validateIntegrity(
    Insertable<StockMovement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('movement_type')) {
      context.handle(
        _movementTypeMeta,
        movementType.isAcceptableOrUnknown(
          data['movement_type']!,
          _movementTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_movementTypeMeta);
    }
    if (data.containsKey('quantity_delta_milli')) {
      context.handle(
        _quantityDeltaMilliMeta,
        quantityDeltaMilli.isAcceptableOrUnknown(
          data['quantity_delta_milli']!,
          _quantityDeltaMilliMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_quantityDeltaMilliMeta);
    }
    if (data.containsKey('unit_cost_kobo')) {
      context.handle(
        _unitCostKoboMeta,
        unitCostKobo.isAcceptableOrUnknown(
          data['unit_cost_kobo']!,
          _unitCostKoboMeta,
        ),
      );
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('reference_type')) {
      context.handle(
        _referenceTypeMeta,
        referenceType.isAcceptableOrUnknown(
          data['reference_type']!,
          _referenceTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_referenceTypeMeta);
    }
    if (data.containsKey('reference_id')) {
      context.handle(
        _referenceIdMeta,
        referenceId.isAcceptableOrUnknown(
          data['reference_id']!,
          _referenceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_referenceIdMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('idempotency_key')) {
      context.handle(
        _idempotencyKeyMeta,
        idempotencyKey.isAcceptableOrUnknown(
          data['idempotency_key']!,
          _idempotencyKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_idempotencyKeyMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StockMovement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockMovement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      movementType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}movement_type'],
      )!,
      quantityDeltaMilli: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity_delta_milli'],
      )!,
      unitCostKobo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_cost_kobo'],
      ),
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      referenceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference_type'],
      )!,
      referenceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference_id'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      idempotencyKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}idempotency_key'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $StockMovementsTable createAlias(String alias) {
    return $StockMovementsTable(attachedDatabase, alias);
  }
}

class StockMovement extends DataClass implements Insertable<StockMovement> {
  final String id;
  final String productId;
  final String movementType;
  final int quantityDeltaMilli;
  final int? unitCostKobo;
  final DateTime occurredAt;
  final String referenceType;
  final String referenceId;
  final String? reason;
  final String? note;
  final String idempotencyKey;
  final DateTime createdAt;
  const StockMovement({
    required this.id,
    required this.productId,
    required this.movementType,
    required this.quantityDeltaMilli,
    this.unitCostKobo,
    required this.occurredAt,
    required this.referenceType,
    required this.referenceId,
    this.reason,
    this.note,
    required this.idempotencyKey,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['product_id'] = Variable<String>(productId);
    map['movement_type'] = Variable<String>(movementType);
    map['quantity_delta_milli'] = Variable<int>(quantityDeltaMilli);
    if (!nullToAbsent || unitCostKobo != null) {
      map['unit_cost_kobo'] = Variable<int>(unitCostKobo);
    }
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    map['reference_type'] = Variable<String>(referenceType);
    map['reference_id'] = Variable<String>(referenceId);
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['idempotency_key'] = Variable<String>(idempotencyKey);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  StockMovementsCompanion toCompanion(bool nullToAbsent) {
    return StockMovementsCompanion(
      id: Value(id),
      productId: Value(productId),
      movementType: Value(movementType),
      quantityDeltaMilli: Value(quantityDeltaMilli),
      unitCostKobo: unitCostKobo == null && nullToAbsent
          ? const Value.absent()
          : Value(unitCostKobo),
      occurredAt: Value(occurredAt),
      referenceType: Value(referenceType),
      referenceId: Value(referenceId),
      reason: reason == null && nullToAbsent
          ? const Value.absent()
          : Value(reason),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      idempotencyKey: Value(idempotencyKey),
      createdAt: Value(createdAt),
    );
  }

  factory StockMovement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockMovement(
      id: serializer.fromJson<String>(json['id']),
      productId: serializer.fromJson<String>(json['productId']),
      movementType: serializer.fromJson<String>(json['movementType']),
      quantityDeltaMilli: serializer.fromJson<int>(json['quantityDeltaMilli']),
      unitCostKobo: serializer.fromJson<int?>(json['unitCostKobo']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      referenceType: serializer.fromJson<String>(json['referenceType']),
      referenceId: serializer.fromJson<String>(json['referenceId']),
      reason: serializer.fromJson<String?>(json['reason']),
      note: serializer.fromJson<String?>(json['note']),
      idempotencyKey: serializer.fromJson<String>(json['idempotencyKey']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productId': serializer.toJson<String>(productId),
      'movementType': serializer.toJson<String>(movementType),
      'quantityDeltaMilli': serializer.toJson<int>(quantityDeltaMilli),
      'unitCostKobo': serializer.toJson<int?>(unitCostKobo),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'referenceType': serializer.toJson<String>(referenceType),
      'referenceId': serializer.toJson<String>(referenceId),
      'reason': serializer.toJson<String?>(reason),
      'note': serializer.toJson<String?>(note),
      'idempotencyKey': serializer.toJson<String>(idempotencyKey),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  StockMovement copyWith({
    String? id,
    String? productId,
    String? movementType,
    int? quantityDeltaMilli,
    Value<int?> unitCostKobo = const Value.absent(),
    DateTime? occurredAt,
    String? referenceType,
    String? referenceId,
    Value<String?> reason = const Value.absent(),
    Value<String?> note = const Value.absent(),
    String? idempotencyKey,
    DateTime? createdAt,
  }) => StockMovement(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    movementType: movementType ?? this.movementType,
    quantityDeltaMilli: quantityDeltaMilli ?? this.quantityDeltaMilli,
    unitCostKobo: unitCostKobo.present ? unitCostKobo.value : this.unitCostKobo,
    occurredAt: occurredAt ?? this.occurredAt,
    referenceType: referenceType ?? this.referenceType,
    referenceId: referenceId ?? this.referenceId,
    reason: reason.present ? reason.value : this.reason,
    note: note.present ? note.value : this.note,
    idempotencyKey: idempotencyKey ?? this.idempotencyKey,
    createdAt: createdAt ?? this.createdAt,
  );
  StockMovement copyWithCompanion(StockMovementsCompanion data) {
    return StockMovement(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      movementType: data.movementType.present
          ? data.movementType.value
          : this.movementType,
      quantityDeltaMilli: data.quantityDeltaMilli.present
          ? data.quantityDeltaMilli.value
          : this.quantityDeltaMilli,
      unitCostKobo: data.unitCostKobo.present
          ? data.unitCostKobo.value
          : this.unitCostKobo,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      referenceType: data.referenceType.present
          ? data.referenceType.value
          : this.referenceType,
      referenceId: data.referenceId.present
          ? data.referenceId.value
          : this.referenceId,
      reason: data.reason.present ? data.reason.value : this.reason,
      note: data.note.present ? data.note.value : this.note,
      idempotencyKey: data.idempotencyKey.present
          ? data.idempotencyKey.value
          : this.idempotencyKey,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StockMovement(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('movementType: $movementType, ')
          ..write('quantityDeltaMilli: $quantityDeltaMilli, ')
          ..write('unitCostKobo: $unitCostKobo, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('referenceType: $referenceType, ')
          ..write('referenceId: $referenceId, ')
          ..write('reason: $reason, ')
          ..write('note: $note, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    productId,
    movementType,
    quantityDeltaMilli,
    unitCostKobo,
    occurredAt,
    referenceType,
    referenceId,
    reason,
    note,
    idempotencyKey,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockMovement &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.movementType == this.movementType &&
          other.quantityDeltaMilli == this.quantityDeltaMilli &&
          other.unitCostKobo == this.unitCostKobo &&
          other.occurredAt == this.occurredAt &&
          other.referenceType == this.referenceType &&
          other.referenceId == this.referenceId &&
          other.reason == this.reason &&
          other.note == this.note &&
          other.idempotencyKey == this.idempotencyKey &&
          other.createdAt == this.createdAt);
}

class StockMovementsCompanion extends UpdateCompanion<StockMovement> {
  final Value<String> id;
  final Value<String> productId;
  final Value<String> movementType;
  final Value<int> quantityDeltaMilli;
  final Value<int?> unitCostKobo;
  final Value<DateTime> occurredAt;
  final Value<String> referenceType;
  final Value<String> referenceId;
  final Value<String?> reason;
  final Value<String?> note;
  final Value<String> idempotencyKey;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const StockMovementsCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.movementType = const Value.absent(),
    this.quantityDeltaMilli = const Value.absent(),
    this.unitCostKobo = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.referenceType = const Value.absent(),
    this.referenceId = const Value.absent(),
    this.reason = const Value.absent(),
    this.note = const Value.absent(),
    this.idempotencyKey = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StockMovementsCompanion.insert({
    required String id,
    required String productId,
    required String movementType,
    required int quantityDeltaMilli,
    this.unitCostKobo = const Value.absent(),
    required DateTime occurredAt,
    required String referenceType,
    required String referenceId,
    this.reason = const Value.absent(),
    this.note = const Value.absent(),
    required String idempotencyKey,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       productId = Value(productId),
       movementType = Value(movementType),
       quantityDeltaMilli = Value(quantityDeltaMilli),
       occurredAt = Value(occurredAt),
       referenceType = Value(referenceType),
       referenceId = Value(referenceId),
       idempotencyKey = Value(idempotencyKey),
       createdAt = Value(createdAt);
  static Insertable<StockMovement> custom({
    Expression<String>? id,
    Expression<String>? productId,
    Expression<String>? movementType,
    Expression<int>? quantityDeltaMilli,
    Expression<int>? unitCostKobo,
    Expression<DateTime>? occurredAt,
    Expression<String>? referenceType,
    Expression<String>? referenceId,
    Expression<String>? reason,
    Expression<String>? note,
    Expression<String>? idempotencyKey,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (movementType != null) 'movement_type': movementType,
      if (quantityDeltaMilli != null)
        'quantity_delta_milli': quantityDeltaMilli,
      if (unitCostKobo != null) 'unit_cost_kobo': unitCostKobo,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (referenceType != null) 'reference_type': referenceType,
      if (referenceId != null) 'reference_id': referenceId,
      if (reason != null) 'reason': reason,
      if (note != null) 'note': note,
      if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StockMovementsCompanion copyWith({
    Value<String>? id,
    Value<String>? productId,
    Value<String>? movementType,
    Value<int>? quantityDeltaMilli,
    Value<int?>? unitCostKobo,
    Value<DateTime>? occurredAt,
    Value<String>? referenceType,
    Value<String>? referenceId,
    Value<String?>? reason,
    Value<String?>? note,
    Value<String>? idempotencyKey,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return StockMovementsCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      movementType: movementType ?? this.movementType,
      quantityDeltaMilli: quantityDeltaMilli ?? this.quantityDeltaMilli,
      unitCostKobo: unitCostKobo ?? this.unitCostKobo,
      occurredAt: occurredAt ?? this.occurredAt,
      referenceType: referenceType ?? this.referenceType,
      referenceId: referenceId ?? this.referenceId,
      reason: reason ?? this.reason,
      note: note ?? this.note,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (movementType.present) {
      map['movement_type'] = Variable<String>(movementType.value);
    }
    if (quantityDeltaMilli.present) {
      map['quantity_delta_milli'] = Variable<int>(quantityDeltaMilli.value);
    }
    if (unitCostKobo.present) {
      map['unit_cost_kobo'] = Variable<int>(unitCostKobo.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (referenceType.present) {
      map['reference_type'] = Variable<String>(referenceType.value);
    }
    if (referenceId.present) {
      map['reference_id'] = Variable<String>(referenceId.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (idempotencyKey.present) {
      map['idempotency_key'] = Variable<String>(idempotencyKey.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockMovementsCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('movementType: $movementType, ')
          ..write('quantityDeltaMilli: $quantityDeltaMilli, ')
          ..write('unitCostKobo: $unitCostKobo, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('referenceType: $referenceType, ')
          ..write('referenceId: $referenceId, ')
          ..write('reason: $reason, ')
          ..write('note: $note, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StockAdjustmentsTable extends StockAdjustments
    with TableInfo<$StockAdjustmentsTable, StockAdjustment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockAdjustmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _adjustmentNumberMeta = const VerificationMeta(
    'adjustmentNumber',
  );
  @override
  late final GeneratedColumn<String> adjustmentNumber = GeneratedColumn<String>(
    'adjustment_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id)',
    ),
  );
  static const VerificationMeta _adjustmentTypeMeta = const VerificationMeta(
    'adjustmentType',
  );
  @override
  late final GeneratedColumn<String> adjustmentType = GeneratedColumn<String>(
    'adjustment_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMilliMeta = const VerificationMeta(
    'quantityMilli',
  );
  @override
  late final GeneratedColumn<int> quantityMilli = GeneratedColumn<int>(
    'quantity_milli',
    aliasedName,
    false,
    check: () => ComparableExpr(quantityMilli).isBiggerThanValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitCostKoboMeta = const VerificationMeta(
    'unitCostKobo',
  );
  @override
  late final GeneratedColumn<int> unitCostKobo = GeneratedColumn<int>(
    'unit_cost_kobo',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idempotencyKeyMeta = const VerificationMeta(
    'idempotencyKey',
  );
  @override
  late final GeneratedColumn<String> idempotencyKey = GeneratedColumn<String>(
    'idempotency_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    adjustmentNumber,
    productId,
    adjustmentType,
    quantityMilli,
    unitCostKobo,
    reason,
    note,
    occurredAt,
    idempotencyKey,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_adjustments';
  @override
  VerificationContext validateIntegrity(
    Insertable<StockAdjustment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('adjustment_number')) {
      context.handle(
        _adjustmentNumberMeta,
        adjustmentNumber.isAcceptableOrUnknown(
          data['adjustment_number']!,
          _adjustmentNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_adjustmentNumberMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('adjustment_type')) {
      context.handle(
        _adjustmentTypeMeta,
        adjustmentType.isAcceptableOrUnknown(
          data['adjustment_type']!,
          _adjustmentTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_adjustmentTypeMeta);
    }
    if (data.containsKey('quantity_milli')) {
      context.handle(
        _quantityMilliMeta,
        quantityMilli.isAcceptableOrUnknown(
          data['quantity_milli']!,
          _quantityMilliMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_quantityMilliMeta);
    }
    if (data.containsKey('unit_cost_kobo')) {
      context.handle(
        _unitCostKoboMeta,
        unitCostKobo.isAcceptableOrUnknown(
          data['unit_cost_kobo']!,
          _unitCostKoboMeta,
        ),
      );
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('idempotency_key')) {
      context.handle(
        _idempotencyKeyMeta,
        idempotencyKey.isAcceptableOrUnknown(
          data['idempotency_key']!,
          _idempotencyKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_idempotencyKeyMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StockAdjustment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockAdjustment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      adjustmentNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}adjustment_number'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      adjustmentType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}adjustment_type'],
      )!,
      quantityMilli: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity_milli'],
      )!,
      unitCostKobo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_cost_kobo'],
      ),
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      idempotencyKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}idempotency_key'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $StockAdjustmentsTable createAlias(String alias) {
    return $StockAdjustmentsTable(attachedDatabase, alias);
  }
}

class StockAdjustment extends DataClass implements Insertable<StockAdjustment> {
  final String id;
  final String adjustmentNumber;
  final String productId;
  final String adjustmentType;
  final int quantityMilli;
  final int? unitCostKobo;
  final String reason;
  final String? note;
  final DateTime occurredAt;
  final String idempotencyKey;
  final DateTime createdAt;
  const StockAdjustment({
    required this.id,
    required this.adjustmentNumber,
    required this.productId,
    required this.adjustmentType,
    required this.quantityMilli,
    this.unitCostKobo,
    required this.reason,
    this.note,
    required this.occurredAt,
    required this.idempotencyKey,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['adjustment_number'] = Variable<String>(adjustmentNumber);
    map['product_id'] = Variable<String>(productId);
    map['adjustment_type'] = Variable<String>(adjustmentType);
    map['quantity_milli'] = Variable<int>(quantityMilli);
    if (!nullToAbsent || unitCostKobo != null) {
      map['unit_cost_kobo'] = Variable<int>(unitCostKobo);
    }
    map['reason'] = Variable<String>(reason);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    map['idempotency_key'] = Variable<String>(idempotencyKey);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  StockAdjustmentsCompanion toCompanion(bool nullToAbsent) {
    return StockAdjustmentsCompanion(
      id: Value(id),
      adjustmentNumber: Value(adjustmentNumber),
      productId: Value(productId),
      adjustmentType: Value(adjustmentType),
      quantityMilli: Value(quantityMilli),
      unitCostKobo: unitCostKobo == null && nullToAbsent
          ? const Value.absent()
          : Value(unitCostKobo),
      reason: Value(reason),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      occurredAt: Value(occurredAt),
      idempotencyKey: Value(idempotencyKey),
      createdAt: Value(createdAt),
    );
  }

  factory StockAdjustment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockAdjustment(
      id: serializer.fromJson<String>(json['id']),
      adjustmentNumber: serializer.fromJson<String>(json['adjustmentNumber']),
      productId: serializer.fromJson<String>(json['productId']),
      adjustmentType: serializer.fromJson<String>(json['adjustmentType']),
      quantityMilli: serializer.fromJson<int>(json['quantityMilli']),
      unitCostKobo: serializer.fromJson<int?>(json['unitCostKobo']),
      reason: serializer.fromJson<String>(json['reason']),
      note: serializer.fromJson<String?>(json['note']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      idempotencyKey: serializer.fromJson<String>(json['idempotencyKey']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'adjustmentNumber': serializer.toJson<String>(adjustmentNumber),
      'productId': serializer.toJson<String>(productId),
      'adjustmentType': serializer.toJson<String>(adjustmentType),
      'quantityMilli': serializer.toJson<int>(quantityMilli),
      'unitCostKobo': serializer.toJson<int?>(unitCostKobo),
      'reason': serializer.toJson<String>(reason),
      'note': serializer.toJson<String?>(note),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'idempotencyKey': serializer.toJson<String>(idempotencyKey),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  StockAdjustment copyWith({
    String? id,
    String? adjustmentNumber,
    String? productId,
    String? adjustmentType,
    int? quantityMilli,
    Value<int?> unitCostKobo = const Value.absent(),
    String? reason,
    Value<String?> note = const Value.absent(),
    DateTime? occurredAt,
    String? idempotencyKey,
    DateTime? createdAt,
  }) => StockAdjustment(
    id: id ?? this.id,
    adjustmentNumber: adjustmentNumber ?? this.adjustmentNumber,
    productId: productId ?? this.productId,
    adjustmentType: adjustmentType ?? this.adjustmentType,
    quantityMilli: quantityMilli ?? this.quantityMilli,
    unitCostKobo: unitCostKobo.present ? unitCostKobo.value : this.unitCostKobo,
    reason: reason ?? this.reason,
    note: note.present ? note.value : this.note,
    occurredAt: occurredAt ?? this.occurredAt,
    idempotencyKey: idempotencyKey ?? this.idempotencyKey,
    createdAt: createdAt ?? this.createdAt,
  );
  StockAdjustment copyWithCompanion(StockAdjustmentsCompanion data) {
    return StockAdjustment(
      id: data.id.present ? data.id.value : this.id,
      adjustmentNumber: data.adjustmentNumber.present
          ? data.adjustmentNumber.value
          : this.adjustmentNumber,
      productId: data.productId.present ? data.productId.value : this.productId,
      adjustmentType: data.adjustmentType.present
          ? data.adjustmentType.value
          : this.adjustmentType,
      quantityMilli: data.quantityMilli.present
          ? data.quantityMilli.value
          : this.quantityMilli,
      unitCostKobo: data.unitCostKobo.present
          ? data.unitCostKobo.value
          : this.unitCostKobo,
      reason: data.reason.present ? data.reason.value : this.reason,
      note: data.note.present ? data.note.value : this.note,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      idempotencyKey: data.idempotencyKey.present
          ? data.idempotencyKey.value
          : this.idempotencyKey,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StockAdjustment(')
          ..write('id: $id, ')
          ..write('adjustmentNumber: $adjustmentNumber, ')
          ..write('productId: $productId, ')
          ..write('adjustmentType: $adjustmentType, ')
          ..write('quantityMilli: $quantityMilli, ')
          ..write('unitCostKobo: $unitCostKobo, ')
          ..write('reason: $reason, ')
          ..write('note: $note, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    adjustmentNumber,
    productId,
    adjustmentType,
    quantityMilli,
    unitCostKobo,
    reason,
    note,
    occurredAt,
    idempotencyKey,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockAdjustment &&
          other.id == this.id &&
          other.adjustmentNumber == this.adjustmentNumber &&
          other.productId == this.productId &&
          other.adjustmentType == this.adjustmentType &&
          other.quantityMilli == this.quantityMilli &&
          other.unitCostKobo == this.unitCostKobo &&
          other.reason == this.reason &&
          other.note == this.note &&
          other.occurredAt == this.occurredAt &&
          other.idempotencyKey == this.idempotencyKey &&
          other.createdAt == this.createdAt);
}

class StockAdjustmentsCompanion extends UpdateCompanion<StockAdjustment> {
  final Value<String> id;
  final Value<String> adjustmentNumber;
  final Value<String> productId;
  final Value<String> adjustmentType;
  final Value<int> quantityMilli;
  final Value<int?> unitCostKobo;
  final Value<String> reason;
  final Value<String?> note;
  final Value<DateTime> occurredAt;
  final Value<String> idempotencyKey;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const StockAdjustmentsCompanion({
    this.id = const Value.absent(),
    this.adjustmentNumber = const Value.absent(),
    this.productId = const Value.absent(),
    this.adjustmentType = const Value.absent(),
    this.quantityMilli = const Value.absent(),
    this.unitCostKobo = const Value.absent(),
    this.reason = const Value.absent(),
    this.note = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.idempotencyKey = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StockAdjustmentsCompanion.insert({
    required String id,
    required String adjustmentNumber,
    required String productId,
    required String adjustmentType,
    required int quantityMilli,
    this.unitCostKobo = const Value.absent(),
    required String reason,
    this.note = const Value.absent(),
    required DateTime occurredAt,
    required String idempotencyKey,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       adjustmentNumber = Value(adjustmentNumber),
       productId = Value(productId),
       adjustmentType = Value(adjustmentType),
       quantityMilli = Value(quantityMilli),
       reason = Value(reason),
       occurredAt = Value(occurredAt),
       idempotencyKey = Value(idempotencyKey),
       createdAt = Value(createdAt);
  static Insertable<StockAdjustment> custom({
    Expression<String>? id,
    Expression<String>? adjustmentNumber,
    Expression<String>? productId,
    Expression<String>? adjustmentType,
    Expression<int>? quantityMilli,
    Expression<int>? unitCostKobo,
    Expression<String>? reason,
    Expression<String>? note,
    Expression<DateTime>? occurredAt,
    Expression<String>? idempotencyKey,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (adjustmentNumber != null) 'adjustment_number': adjustmentNumber,
      if (productId != null) 'product_id': productId,
      if (adjustmentType != null) 'adjustment_type': adjustmentType,
      if (quantityMilli != null) 'quantity_milli': quantityMilli,
      if (unitCostKobo != null) 'unit_cost_kobo': unitCostKobo,
      if (reason != null) 'reason': reason,
      if (note != null) 'note': note,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StockAdjustmentsCompanion copyWith({
    Value<String>? id,
    Value<String>? adjustmentNumber,
    Value<String>? productId,
    Value<String>? adjustmentType,
    Value<int>? quantityMilli,
    Value<int?>? unitCostKobo,
    Value<String>? reason,
    Value<String?>? note,
    Value<DateTime>? occurredAt,
    Value<String>? idempotencyKey,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return StockAdjustmentsCompanion(
      id: id ?? this.id,
      adjustmentNumber: adjustmentNumber ?? this.adjustmentNumber,
      productId: productId ?? this.productId,
      adjustmentType: adjustmentType ?? this.adjustmentType,
      quantityMilli: quantityMilli ?? this.quantityMilli,
      unitCostKobo: unitCostKobo ?? this.unitCostKobo,
      reason: reason ?? this.reason,
      note: note ?? this.note,
      occurredAt: occurredAt ?? this.occurredAt,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (adjustmentNumber.present) {
      map['adjustment_number'] = Variable<String>(adjustmentNumber.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (adjustmentType.present) {
      map['adjustment_type'] = Variable<String>(adjustmentType.value);
    }
    if (quantityMilli.present) {
      map['quantity_milli'] = Variable<int>(quantityMilli.value);
    }
    if (unitCostKobo.present) {
      map['unit_cost_kobo'] = Variable<int>(unitCostKobo.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (idempotencyKey.present) {
      map['idempotency_key'] = Variable<String>(idempotencyKey.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockAdjustmentsCompanion(')
          ..write('id: $id, ')
          ..write('adjustmentNumber: $adjustmentNumber, ')
          ..write('productId: $productId, ')
          ..write('adjustmentType: $adjustmentType, ')
          ..write('quantityMilli: $quantityMilli, ')
          ..write('unitCostKobo: $unitCostKobo, ')
          ..write('reason: $reason, ')
          ..write('note: $note, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses with TableInfo<$ExpensesTable, Expense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountKoboMeta = const VerificationMeta(
    'amountKobo',
  );
  @override
  late final GeneratedColumn<int> amountKobo = GeneratedColumn<int>(
    'amount_kobo',
    aliasedName,
    false,
    check: () => ComparableExpr(amountKobo).isBiggerThanValue(0),
    type: DriftSqlType.int,
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
  static const VerificationMeta _expenseDateMeta = const VerificationMeta(
    'expenseDate',
  );
  @override
  late final GeneratedColumn<DateTime> expenseDate = GeneratedColumn<DateTime>(
    'expense_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentMethodMeta = const VerificationMeta(
    'paymentMethod',
  );
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
    'payment_method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    amountKobo,
    category,
    expenseDate,
    paymentMethod,
    note,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<Expense> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('amount_kobo')) {
      context.handle(
        _amountKoboMeta,
        amountKobo.isAcceptableOrUnknown(data['amount_kobo']!, _amountKoboMeta),
      );
    } else if (isInserting) {
      context.missing(_amountKoboMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('expense_date')) {
      context.handle(
        _expenseDateMeta,
        expenseDate.isAcceptableOrUnknown(
          data['expense_date']!,
          _expenseDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_expenseDateMeta);
    }
    if (data.containsKey('payment_method')) {
      context.handle(
        _paymentMethodMeta,
        paymentMethod.isAcceptableOrUnknown(
          data['payment_method']!,
          _paymentMethodMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentMethodMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Expense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Expense(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      amountKobo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_kobo'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      expenseDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expense_date'],
      )!,
      paymentMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_method'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }
}

class Expense extends DataClass implements Insertable<Expense> {
  final String id;
  final int amountKobo;
  final String category;
  final DateTime expenseDate;
  final String paymentMethod;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Expense({
    required this.id,
    required this.amountKobo,
    required this.category,
    required this.expenseDate,
    required this.paymentMethod,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['amount_kobo'] = Variable<int>(amountKobo);
    map['category'] = Variable<String>(category);
    map['expense_date'] = Variable<DateTime>(expenseDate);
    map['payment_method'] = Variable<String>(paymentMethod);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      amountKobo: Value(amountKobo),
      category: Value(category),
      expenseDate: Value(expenseDate),
      paymentMethod: Value(paymentMethod),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Expense.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Expense(
      id: serializer.fromJson<String>(json['id']),
      amountKobo: serializer.fromJson<int>(json['amountKobo']),
      category: serializer.fromJson<String>(json['category']),
      expenseDate: serializer.fromJson<DateTime>(json['expenseDate']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'amountKobo': serializer.toJson<int>(amountKobo),
      'category': serializer.toJson<String>(category),
      'expenseDate': serializer.toJson<DateTime>(expenseDate),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Expense copyWith({
    String? id,
    int? amountKobo,
    String? category,
    DateTime? expenseDate,
    String? paymentMethod,
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Expense(
    id: id ?? this.id,
    amountKobo: amountKobo ?? this.amountKobo,
    category: category ?? this.category,
    expenseDate: expenseDate ?? this.expenseDate,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Expense copyWithCompanion(ExpensesCompanion data) {
    return Expense(
      id: data.id.present ? data.id.value : this.id,
      amountKobo: data.amountKobo.present
          ? data.amountKobo.value
          : this.amountKobo,
      category: data.category.present ? data.category.value : this.category,
      expenseDate: data.expenseDate.present
          ? data.expenseDate.value
          : this.expenseDate,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Expense(')
          ..write('id: $id, ')
          ..write('amountKobo: $amountKobo, ')
          ..write('category: $category, ')
          ..write('expenseDate: $expenseDate, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    amountKobo,
    category,
    expenseDate,
    paymentMethod,
    note,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Expense &&
          other.id == this.id &&
          other.amountKobo == this.amountKobo &&
          other.category == this.category &&
          other.expenseDate == this.expenseDate &&
          other.paymentMethod == this.paymentMethod &&
          other.note == this.note &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ExpensesCompanion extends UpdateCompanion<Expense> {
  final Value<String> id;
  final Value<int> amountKobo;
  final Value<String> category;
  final Value<DateTime> expenseDate;
  final Value<String> paymentMethod;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.amountKobo = const Value.absent(),
    this.category = const Value.absent(),
    this.expenseDate = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExpensesCompanion.insert({
    required String id,
    required int amountKobo,
    required String category,
    required DateTime expenseDate,
    required String paymentMethod,
    this.note = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       amountKobo = Value(amountKobo),
       category = Value(category),
       expenseDate = Value(expenseDate),
       paymentMethod = Value(paymentMethod),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Expense> custom({
    Expression<String>? id,
    Expression<int>? amountKobo,
    Expression<String>? category,
    Expression<DateTime>? expenseDate,
    Expression<String>? paymentMethod,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amountKobo != null) 'amount_kobo': amountKobo,
      if (category != null) 'category': category,
      if (expenseDate != null) 'expense_date': expenseDate,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExpensesCompanion copyWith({
    Value<String>? id,
    Value<int>? amountKobo,
    Value<String>? category,
    Value<DateTime>? expenseDate,
    Value<String>? paymentMethod,
    Value<String?>? note,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ExpensesCompanion(
      id: id ?? this.id,
      amountKobo: amountKobo ?? this.amountKobo,
      category: category ?? this.category,
      expenseDate: expenseDate ?? this.expenseDate,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (amountKobo.present) {
      map['amount_kobo'] = Variable<int>(amountKobo.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (expenseDate.present) {
      map['expense_date'] = Variable<DateTime>(expenseDate.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('amountKobo: $amountKobo, ')
          ..write('category: $category, ')
          ..write('expenseDate: $expenseDate, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BusinessProfileTable businessProfile = $BusinessProfileTable(
    this,
  );
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $ProductCategoriesTable productCategories =
      $ProductCategoriesTable(this);
  late final $SuppliersTable suppliers = $SuppliersTable(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $StockReceiptsTable stockReceipts = $StockReceiptsTable(this);
  late final $StockReceiptLinesTable stockReceiptLines =
      $StockReceiptLinesTable(this);
  late final $SalesTable sales = $SalesTable(this);
  late final $SaleLinesTable saleLines = $SaleLinesTable(this);
  late final $StockMovementsTable stockMovements = $StockMovementsTable(this);
  late final $StockAdjustmentsTable stockAdjustments = $StockAdjustmentsTable(
    this,
  );
  late final $ExpensesTable expenses = $ExpensesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    businessProfile,
    appSettings,
    productCategories,
    suppliers,
    products,
    stockReceipts,
    stockReceiptLines,
    sales,
    saleLines,
    stockMovements,
    stockAdjustments,
    expenses,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'product_categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('products', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'suppliers',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('stock_receipts', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'stock_receipts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('stock_receipt_lines', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'sales',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('sale_lines', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$BusinessProfileTableCreateCompanionBuilder =
    BusinessProfileCompanion Function({
      required String id,
      required String businessName,
      Value<String?> phone,
      Value<String?> address,
      Value<String?> logoPath,
      Value<String?> receiptFooter,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$BusinessProfileTableUpdateCompanionBuilder =
    BusinessProfileCompanion Function({
      Value<String> id,
      Value<String> businessName,
      Value<String?> phone,
      Value<String?> address,
      Value<String?> logoPath,
      Value<String?> receiptFooter,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$BusinessProfileTableFilterComposer
    extends Composer<_$AppDatabase, $BusinessProfileTable> {
  $$BusinessProfileTableFilterComposer({
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

  ColumnFilters<String> get businessName => $composableBuilder(
    column: $table.businessName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get logoPath => $composableBuilder(
    column: $table.logoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receiptFooter => $composableBuilder(
    column: $table.receiptFooter,
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
}

class $$BusinessProfileTableOrderingComposer
    extends Composer<_$AppDatabase, $BusinessProfileTable> {
  $$BusinessProfileTableOrderingComposer({
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

  ColumnOrderings<String> get businessName => $composableBuilder(
    column: $table.businessName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get logoPath => $composableBuilder(
    column: $table.logoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiptFooter => $composableBuilder(
    column: $table.receiptFooter,
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
}

class $$BusinessProfileTableAnnotationComposer
    extends Composer<_$AppDatabase, $BusinessProfileTable> {
  $$BusinessProfileTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get businessName => $composableBuilder(
    column: $table.businessName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get logoPath =>
      $composableBuilder(column: $table.logoPath, builder: (column) => column);

  GeneratedColumn<String> get receiptFooter => $composableBuilder(
    column: $table.receiptFooter,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$BusinessProfileTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BusinessProfileTable,
          BusinessProfileData,
          $$BusinessProfileTableFilterComposer,
          $$BusinessProfileTableOrderingComposer,
          $$BusinessProfileTableAnnotationComposer,
          $$BusinessProfileTableCreateCompanionBuilder,
          $$BusinessProfileTableUpdateCompanionBuilder,
          (
            BusinessProfileData,
            BaseReferences<
              _$AppDatabase,
              $BusinessProfileTable,
              BusinessProfileData
            >,
          ),
          BusinessProfileData,
          PrefetchHooks Function()
        > {
  $$BusinessProfileTableTableManager(
    _$AppDatabase db,
    $BusinessProfileTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BusinessProfileTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BusinessProfileTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BusinessProfileTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> businessName = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> logoPath = const Value.absent(),
                Value<String?> receiptFooter = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BusinessProfileCompanion(
                id: id,
                businessName: businessName,
                phone: phone,
                address: address,
                logoPath: logoPath,
                receiptFooter: receiptFooter,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String businessName,
                Value<String?> phone = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> logoPath = const Value.absent(),
                Value<String?> receiptFooter = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => BusinessProfileCompanion.insert(
                id: id,
                businessName: businessName,
                phone: phone,
                address: address,
                logoPath: logoPath,
                receiptFooter: receiptFooter,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BusinessProfileTable, BusinessProfileData>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $BusinessProfileTable,
                    BusinessProfileData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BusinessProfileTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BusinessProfileTable,
      BusinessProfileData,
      $$BusinessProfileTableFilterComposer,
      $$BusinessProfileTableOrderingComposer,
      $$BusinessProfileTableAnnotationComposer,
      $$BusinessProfileTableCreateCompanionBuilder,
      $$BusinessProfileTableUpdateCompanionBuilder,
      (
        BusinessProfileData,
        BaseReferences<
          _$AppDatabase,
          $BusinessProfileTable,
          BusinessProfileData
        >,
      ),
      BusinessProfileData,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String id,
      Value<int> defaultLowStockThresholdMilli,
      Value<bool> notificationsEnabled,
      Value<String> receiptLayout,
      Value<int> lastSaleSeq,
      Value<int> lastReceiptSeq,
      Value<int> lastAdjustmentSeq,
      Value<int> settingsVersion,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> id,
      Value<int> defaultLowStockThresholdMilli,
      Value<bool> notificationsEnabled,
      Value<String> receiptLayout,
      Value<int> lastSaleSeq,
      Value<int> lastReceiptSeq,
      Value<int> lastAdjustmentSeq,
      Value<int> settingsVersion,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
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

  ColumnFilters<int> get defaultLowStockThresholdMilli => $composableBuilder(
    column: $table.defaultLowStockThresholdMilli,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receiptLayout => $composableBuilder(
    column: $table.receiptLayout,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastSaleSeq => $composableBuilder(
    column: $table.lastSaleSeq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastReceiptSeq => $composableBuilder(
    column: $table.lastReceiptSeq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastAdjustmentSeq => $composableBuilder(
    column: $table.lastAdjustmentSeq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get settingsVersion => $composableBuilder(
    column: $table.settingsVersion,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
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

  ColumnOrderings<int> get defaultLowStockThresholdMilli => $composableBuilder(
    column: $table.defaultLowStockThresholdMilli,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiptLayout => $composableBuilder(
    column: $table.receiptLayout,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastSaleSeq => $composableBuilder(
    column: $table.lastSaleSeq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastReceiptSeq => $composableBuilder(
    column: $table.lastReceiptSeq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastAdjustmentSeq => $composableBuilder(
    column: $table.lastAdjustmentSeq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get settingsVersion => $composableBuilder(
    column: $table.settingsVersion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get defaultLowStockThresholdMilli => $composableBuilder(
    column: $table.defaultLowStockThresholdMilli,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<String> get receiptLayout => $composableBuilder(
    column: $table.receiptLayout,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastSaleSeq => $composableBuilder(
    column: $table.lastSaleSeq,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastReceiptSeq => $composableBuilder(
    column: $table.lastReceiptSeq,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastAdjustmentSeq => $composableBuilder(
    column: $table.lastAdjustmentSeq,
    builder: (column) => column,
  );

  GeneratedColumn<int> get settingsVersion => $composableBuilder(
    column: $table.settingsVersion,
    builder: (column) => column,
  );
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> defaultLowStockThresholdMilli = const Value.absent(),
                Value<bool> notificationsEnabled = const Value.absent(),
                Value<String> receiptLayout = const Value.absent(),
                Value<int> lastSaleSeq = const Value.absent(),
                Value<int> lastReceiptSeq = const Value.absent(),
                Value<int> lastAdjustmentSeq = const Value.absent(),
                Value<int> settingsVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(
                id: id,
                defaultLowStockThresholdMilli: defaultLowStockThresholdMilli,
                notificationsEnabled: notificationsEnabled,
                receiptLayout: receiptLayout,
                lastSaleSeq: lastSaleSeq,
                lastReceiptSeq: lastReceiptSeq,
                lastAdjustmentSeq: lastAdjustmentSeq,
                settingsVersion: settingsVersion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<int> defaultLowStockThresholdMilli = const Value.absent(),
                Value<bool> notificationsEnabled = const Value.absent(),
                Value<String> receiptLayout = const Value.absent(),
                Value<int> lastSaleSeq = const Value.absent(),
                Value<int> lastReceiptSeq = const Value.absent(),
                Value<int> lastAdjustmentSeq = const Value.absent(),
                Value<int> settingsVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                id: id,
                defaultLowStockThresholdMilli: defaultLowStockThresholdMilli,
                notificationsEnabled: notificationsEnabled,
                receiptLayout: receiptLayout,
                lastSaleSeq: lastSaleSeq,
                lastReceiptSeq: lastReceiptSeq,
                lastAdjustmentSeq: lastAdjustmentSeq,
                settingsVersion: settingsVersion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTable, AppSetting>(table),
                  BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;
typedef $$ProductCategoriesTableCreateCompanionBuilder =
    ProductCategoriesCompanion Function({
      required String id,
      required String name,
      required String normalizedName,
      Value<bool> isArchived,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ProductCategoriesTableUpdateCompanionBuilder =
    ProductCategoriesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> normalizedName,
      Value<bool> isArchived,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$ProductCategoriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ProductCategoriesTable,
          ProductCategory
        > {
  $$ProductCategoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$ProductsTable, List<Product>> _productsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.products,
    aliasName: 'product_categories__id__products__category_id',
  );

  $$ProductsTableProcessedTableManager get productsRefs {
    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_productsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProductCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $ProductCategoriesTable> {
  $$ProductCategoriesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get normalizedName => $composableBuilder(
    column: $table.normalizedName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
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

  Expression<bool> productsRefs(
    Expression<bool> Function($$ProductsTableFilterComposer f) f,
  ) {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductCategoriesTable> {
  $$ProductCategoriesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get normalizedName => $composableBuilder(
    column: $table.normalizedName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
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
}

class $$ProductCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductCategoriesTable> {
  $$ProductCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get normalizedName => $composableBuilder(
    column: $table.normalizedName,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> productsRefs<T extends Object>(
    Expression<T> Function($$ProductsTableAnnotationComposer a) f,
  ) {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductCategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductCategoriesTable,
          ProductCategory,
          $$ProductCategoriesTableFilterComposer,
          $$ProductCategoriesTableOrderingComposer,
          $$ProductCategoriesTableAnnotationComposer,
          $$ProductCategoriesTableCreateCompanionBuilder,
          $$ProductCategoriesTableUpdateCompanionBuilder,
          (ProductCategory, $$ProductCategoriesTableReferences),
          ProductCategory,
          PrefetchHooks Function({bool productsRefs})
        > {
  $$ProductCategoriesTableTableManager(
    _$AppDatabase db,
    $ProductCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductCategoriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> normalizedName = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductCategoriesCompanion(
                id: id,
                name: name,
                normalizedName: normalizedName,
                isArchived: isArchived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String normalizedName,
                Value<bool> isArchived = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ProductCategoriesCompanion.insert(
                id: id,
                name: name,
                normalizedName: normalizedName,
                isArchived: isArchived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProductCategoriesTable, ProductCategory>(table),
                  $$ProductCategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({productsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (productsRefs) db.products],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (productsRefs)
                    await $_getPrefetchedData<
                      ProductCategory,
                      $ProductCategoriesTable,
                      Product
                    >(
                      currentTable: table,
                      referencedTable: $$ProductCategoriesTableReferences
                          ._productsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ProductCategoriesTableReferences(
                            db,
                            table,
                            p0,
                          ).productsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.categoryId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ProductCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductCategoriesTable,
      ProductCategory,
      $$ProductCategoriesTableFilterComposer,
      $$ProductCategoriesTableOrderingComposer,
      $$ProductCategoriesTableAnnotationComposer,
      $$ProductCategoriesTableCreateCompanionBuilder,
      $$ProductCategoriesTableUpdateCompanionBuilder,
      (ProductCategory, $$ProductCategoriesTableReferences),
      ProductCategory,
      PrefetchHooks Function({bool productsRefs})
    >;
typedef $$SuppliersTableCreateCompanionBuilder =
    SuppliersCompanion Function({
      required String id,
      required String name,
      Value<String?> contactName,
      Value<String?> phone,
      Value<String?> email,
      Value<String?> address,
      Value<String?> notes,
      Value<bool> isArchived,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$SuppliersTableUpdateCompanionBuilder =
    SuppliersCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> contactName,
      Value<String?> phone,
      Value<String?> email,
      Value<String?> address,
      Value<String?> notes,
      Value<bool> isArchived,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$SuppliersTableReferences
    extends BaseReferences<_$AppDatabase, $SuppliersTable, Supplier> {
  $$SuppliersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$StockReceiptsTable, List<StockReceipt>>
  _stockReceiptsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.stockReceipts,
    aliasName: 'suppliers__id__stock_receipts__supplier_id',
  );

  $$StockReceiptsTableProcessedTableManager get stockReceiptsRefs {
    final manager = $$StockReceiptsTableTableManager(
      $_db,
      $_db.stockReceipts,
    ).filter((f) => f.supplierId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_stockReceiptsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SuppliersTableFilterComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contactName => $composableBuilder(
    column: $table.contactName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
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

  Expression<bool> stockReceiptsRefs(
    Expression<bool> Function($$StockReceiptsTableFilterComposer f) f,
  ) {
    final $$StockReceiptsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockReceipts,
      getReferencedColumn: (t) => t.supplierId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockReceiptsTableFilterComposer(
            $db: $db,
            $table: $db.stockReceipts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SuppliersTableOrderingComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contactName => $composableBuilder(
    column: $table.contactName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
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
}

class $$SuppliersTableAnnotationComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get contactName => $composableBuilder(
    column: $table.contactName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> stockReceiptsRefs<T extends Object>(
    Expression<T> Function($$StockReceiptsTableAnnotationComposer a) f,
  ) {
    final $$StockReceiptsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockReceipts,
      getReferencedColumn: (t) => t.supplierId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockReceiptsTableAnnotationComposer(
            $db: $db,
            $table: $db.stockReceipts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SuppliersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SuppliersTable,
          Supplier,
          $$SuppliersTableFilterComposer,
          $$SuppliersTableOrderingComposer,
          $$SuppliersTableAnnotationComposer,
          $$SuppliersTableCreateCompanionBuilder,
          $$SuppliersTableUpdateCompanionBuilder,
          (Supplier, $$SuppliersTableReferences),
          Supplier,
          PrefetchHooks Function({bool stockReceiptsRefs})
        > {
  $$SuppliersTableTableManager(_$AppDatabase db, $SuppliersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SuppliersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SuppliersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SuppliersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> contactName = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SuppliersCompanion(
                id: id,
                name: name,
                contactName: contactName,
                phone: phone,
                email: email,
                address: address,
                notes: notes,
                isArchived: isArchived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> contactName = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SuppliersCompanion.insert(
                id: id,
                name: name,
                contactName: contactName,
                phone: phone,
                email: email,
                address: address,
                notes: notes,
                isArchived: isArchived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SuppliersTable, Supplier>(table),
                  $$SuppliersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({stockReceiptsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (stockReceiptsRefs) db.stockReceipts,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (stockReceiptsRefs)
                    await $_getPrefetchedData<
                      Supplier,
                      $SuppliersTable,
                      StockReceipt
                    >(
                      currentTable: table,
                      referencedTable: $$SuppliersTableReferences
                          ._stockReceiptsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SuppliersTableReferences(
                            db,
                            table,
                            p0,
                          ).stockReceiptsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.supplierId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SuppliersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SuppliersTable,
      Supplier,
      $$SuppliersTableFilterComposer,
      $$SuppliersTableOrderingComposer,
      $$SuppliersTableAnnotationComposer,
      $$SuppliersTableCreateCompanionBuilder,
      $$SuppliersTableUpdateCompanionBuilder,
      (Supplier, $$SuppliersTableReferences),
      Supplier,
      PrefetchHooks Function({bool stockReceiptsRefs})
    >;
typedef $$ProductsTableCreateCompanionBuilder =
    ProductsCompanion Function({
      required String id,
      required String name,
      required String normalizedName,
      Value<String?> sku,
      Value<String?> barcode,
      Value<String?> categoryId,
      required String unitLabel,
      required int sellingPriceKobo,
      Value<int> averageCostKobo,
      Value<int> quantityOnHandMilli,
      Value<int> lowStockThresholdMilli,
      Value<String?> imagePath,
      Value<String?> description,
      Value<bool> isArchived,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ProductsTableUpdateCompanionBuilder =
    ProductsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> normalizedName,
      Value<String?> sku,
      Value<String?> barcode,
      Value<String?> categoryId,
      Value<String> unitLabel,
      Value<int> sellingPriceKobo,
      Value<int> averageCostKobo,
      Value<int> quantityOnHandMilli,
      Value<int> lowStockThresholdMilli,
      Value<String?> imagePath,
      Value<String?> description,
      Value<bool> isArchived,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$ProductsTableReferences
    extends BaseReferences<_$AppDatabase, $ProductsTable, Product> {
  $$ProductsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProductCategoriesTable _categoryIdTable(_$AppDatabase db) => db
      .productCategories
      .createAlias('products__category_id__product_categories__id');

  $$ProductCategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<String>('category_id');
    if ($_column == null) return null;
    final manager = $$ProductCategoriesTableTableManager(
      $_db,
      $_db.productCategories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$StockReceiptLinesTable, List<StockReceiptLine>>
  _stockReceiptLinesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.stockReceiptLines,
        aliasName: 'products__id__stock_receipt_lines__product_id',
      );

  $$StockReceiptLinesTableProcessedTableManager get stockReceiptLinesRefs {
    final manager = $$StockReceiptLinesTableTableManager(
      $_db,
      $_db.stockReceiptLines,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _stockReceiptLinesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SaleLinesTable, List<SaleLine>>
  _saleLinesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.saleLines,
    aliasName: 'products__id__sale_lines__product_id',
  );

  $$SaleLinesTableProcessedTableManager get saleLinesRefs {
    final manager = $$SaleLinesTableTableManager(
      $_db,
      $_db.saleLines,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_saleLinesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StockMovementsTable, List<StockMovement>>
  _stockMovementsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.stockMovements,
    aliasName: 'products__id__stock_movements__product_id',
  );

  $$StockMovementsTableProcessedTableManager get stockMovementsRefs {
    final manager = $$StockMovementsTableTableManager(
      $_db,
      $_db.stockMovements,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_stockMovementsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StockAdjustmentsTable, List<StockAdjustment>>
  _stockAdjustmentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.stockAdjustments,
    aliasName: 'products__id__stock_adjustments__product_id',
  );

  $$StockAdjustmentsTableProcessedTableManager get stockAdjustmentsRefs {
    final manager = $$StockAdjustmentsTableTableManager(
      $_db,
      $_db.stockAdjustments,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _stockAdjustmentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get normalizedName => $composableBuilder(
    column: $table.normalizedName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sku => $composableBuilder(
    column: $table.sku,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unitLabel => $composableBuilder(
    column: $table.unitLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sellingPriceKobo => $composableBuilder(
    column: $table.sellingPriceKobo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get averageCostKobo => $composableBuilder(
    column: $table.averageCostKobo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantityOnHandMilli => $composableBuilder(
    column: $table.quantityOnHandMilli,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lowStockThresholdMilli => $composableBuilder(
    column: $table.lowStockThresholdMilli,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
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

  $$ProductCategoriesTableFilterComposer get categoryId {
    final $$ProductCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.productCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.productCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> stockReceiptLinesRefs(
    Expression<bool> Function($$StockReceiptLinesTableFilterComposer f) f,
  ) {
    final $$StockReceiptLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockReceiptLines,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockReceiptLinesTableFilterComposer(
            $db: $db,
            $table: $db.stockReceiptLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> saleLinesRefs(
    Expression<bool> Function($$SaleLinesTableFilterComposer f) f,
  ) {
    final $$SaleLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.saleLines,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SaleLinesTableFilterComposer(
            $db: $db,
            $table: $db.saleLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> stockMovementsRefs(
    Expression<bool> Function($$StockMovementsTableFilterComposer f) f,
  ) {
    final $$StockMovementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockMovements,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockMovementsTableFilterComposer(
            $db: $db,
            $table: $db.stockMovements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> stockAdjustmentsRefs(
    Expression<bool> Function($$StockAdjustmentsTableFilterComposer f) f,
  ) {
    final $$StockAdjustmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockAdjustments,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockAdjustmentsTableFilterComposer(
            $db: $db,
            $table: $db.stockAdjustments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get normalizedName => $composableBuilder(
    column: $table.normalizedName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sku => $composableBuilder(
    column: $table.sku,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unitLabel => $composableBuilder(
    column: $table.unitLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sellingPriceKobo => $composableBuilder(
    column: $table.sellingPriceKobo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get averageCostKobo => $composableBuilder(
    column: $table.averageCostKobo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantityOnHandMilli => $composableBuilder(
    column: $table.quantityOnHandMilli,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lowStockThresholdMilli => $composableBuilder(
    column: $table.lowStockThresholdMilli,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
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

  $$ProductCategoriesTableOrderingComposer get categoryId {
    final $$ProductCategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.productCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductCategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.productCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get normalizedName => $composableBuilder(
    column: $table.normalizedName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sku =>
      $composableBuilder(column: $table.sku, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get unitLabel =>
      $composableBuilder(column: $table.unitLabel, builder: (column) => column);

  GeneratedColumn<int> get sellingPriceKobo => $composableBuilder(
    column: $table.sellingPriceKobo,
    builder: (column) => column,
  );

  GeneratedColumn<int> get averageCostKobo => $composableBuilder(
    column: $table.averageCostKobo,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quantityOnHandMilli => $composableBuilder(
    column: $table.quantityOnHandMilli,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lowStockThresholdMilli => $composableBuilder(
    column: $table.lowStockThresholdMilli,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ProductCategoriesTableAnnotationComposer get categoryId {
    final $$ProductCategoriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.categoryId,
          referencedTable: $db.productCategories,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ProductCategoriesTableAnnotationComposer(
                $db: $db,
                $table: $db.productCategories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> stockReceiptLinesRefs<T extends Object>(
    Expression<T> Function($$StockReceiptLinesTableAnnotationComposer a) f,
  ) {
    final $$StockReceiptLinesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.stockReceiptLines,
          getReferencedColumn: (t) => t.productId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StockReceiptLinesTableAnnotationComposer(
                $db: $db,
                $table: $db.stockReceiptLines,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> saleLinesRefs<T extends Object>(
    Expression<T> Function($$SaleLinesTableAnnotationComposer a) f,
  ) {
    final $$SaleLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.saleLines,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SaleLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.saleLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> stockMovementsRefs<T extends Object>(
    Expression<T> Function($$StockMovementsTableAnnotationComposer a) f,
  ) {
    final $$StockMovementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockMovements,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockMovementsTableAnnotationComposer(
            $db: $db,
            $table: $db.stockMovements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> stockAdjustmentsRefs<T extends Object>(
    Expression<T> Function($$StockAdjustmentsTableAnnotationComposer a) f,
  ) {
    final $$StockAdjustmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockAdjustments,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockAdjustmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.stockAdjustments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTable,
          Product,
          $$ProductsTableFilterComposer,
          $$ProductsTableOrderingComposer,
          $$ProductsTableAnnotationComposer,
          $$ProductsTableCreateCompanionBuilder,
          $$ProductsTableUpdateCompanionBuilder,
          (Product, $$ProductsTableReferences),
          Product,
          PrefetchHooks Function({
            bool categoryId,
            bool stockReceiptLinesRefs,
            bool saleLinesRefs,
            bool stockMovementsRefs,
            bool stockAdjustmentsRefs,
          })
        > {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> normalizedName = const Value.absent(),
                Value<String?> sku = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String> unitLabel = const Value.absent(),
                Value<int> sellingPriceKobo = const Value.absent(),
                Value<int> averageCostKobo = const Value.absent(),
                Value<int> quantityOnHandMilli = const Value.absent(),
                Value<int> lowStockThresholdMilli = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion(
                id: id,
                name: name,
                normalizedName: normalizedName,
                sku: sku,
                barcode: barcode,
                categoryId: categoryId,
                unitLabel: unitLabel,
                sellingPriceKobo: sellingPriceKobo,
                averageCostKobo: averageCostKobo,
                quantityOnHandMilli: quantityOnHandMilli,
                lowStockThresholdMilli: lowStockThresholdMilli,
                imagePath: imagePath,
                description: description,
                isArchived: isArchived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String normalizedName,
                Value<String?> sku = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                required String unitLabel,
                required int sellingPriceKobo,
                Value<int> averageCostKobo = const Value.absent(),
                Value<int> quantityOnHandMilli = const Value.absent(),
                Value<int> lowStockThresholdMilli = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion.insert(
                id: id,
                name: name,
                normalizedName: normalizedName,
                sku: sku,
                barcode: barcode,
                categoryId: categoryId,
                unitLabel: unitLabel,
                sellingPriceKobo: sellingPriceKobo,
                averageCostKobo: averageCostKobo,
                quantityOnHandMilli: quantityOnHandMilli,
                lowStockThresholdMilli: lowStockThresholdMilli,
                imagePath: imagePath,
                description: description,
                isArchived: isArchived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProductsTable, Product>(table),
                  $$ProductsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                categoryId = false,
                stockReceiptLinesRefs = false,
                saleLinesRefs = false,
                stockMovementsRefs = false,
                stockAdjustmentsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (stockReceiptLinesRefs) db.stockReceiptLines,
                    if (saleLinesRefs) db.saleLines,
                    if (stockMovementsRefs) db.stockMovements,
                    if (stockAdjustmentsRefs) db.stockAdjustments,
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
                        if (categoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.categoryId,
                                    referencedTable: $$ProductsTableReferences
                                        ._categoryIdTable(db),
                                    referencedColumn: $$ProductsTableReferences
                                        ._categoryIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (stockReceiptLinesRefs)
                        await $_getPrefetchedData<
                          Product,
                          $ProductsTable,
                          StockReceiptLine
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableReferences
                              ._stockReceiptLinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).stockReceiptLinesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (saleLinesRefs)
                        await $_getPrefetchedData<
                          Product,
                          $ProductsTable,
                          SaleLine
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableReferences
                              ._saleLinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).saleLinesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (stockMovementsRefs)
                        await $_getPrefetchedData<
                          Product,
                          $ProductsTable,
                          StockMovement
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableReferences
                              ._stockMovementsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).stockMovementsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (stockAdjustmentsRefs)
                        await $_getPrefetchedData<
                          Product,
                          $ProductsTable,
                          StockAdjustment
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableReferences
                              ._stockAdjustmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).stockAdjustmentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productId == item.id,
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

typedef $$ProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTable,
      Product,
      $$ProductsTableFilterComposer,
      $$ProductsTableOrderingComposer,
      $$ProductsTableAnnotationComposer,
      $$ProductsTableCreateCompanionBuilder,
      $$ProductsTableUpdateCompanionBuilder,
      (Product, $$ProductsTableReferences),
      Product,
      PrefetchHooks Function({
        bool categoryId,
        bool stockReceiptLinesRefs,
        bool saleLinesRefs,
        bool stockMovementsRefs,
        bool stockAdjustmentsRefs,
      })
    >;
typedef $$StockReceiptsTableCreateCompanionBuilder =
    StockReceiptsCompanion Function({
      required String id,
      required String receiptNumber,
      Value<String?> supplierId,
      Value<String?> supplierNameSnapshot,
      Value<String?> supplierReference,
      required DateTime receivedAt,
      Value<String?> notes,
      required int totalCostKobo,
      required String idempotencyKey,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$StockReceiptsTableUpdateCompanionBuilder =
    StockReceiptsCompanion Function({
      Value<String> id,
      Value<String> receiptNumber,
      Value<String?> supplierId,
      Value<String?> supplierNameSnapshot,
      Value<String?> supplierReference,
      Value<DateTime> receivedAt,
      Value<String?> notes,
      Value<int> totalCostKobo,
      Value<String> idempotencyKey,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$StockReceiptsTableReferences
    extends BaseReferences<_$AppDatabase, $StockReceiptsTable, StockReceipt> {
  $$StockReceiptsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SuppliersTable _supplierIdTable(_$AppDatabase db) =>
      db.suppliers.createAlias('stock_receipts__supplier_id__suppliers__id');

  $$SuppliersTableProcessedTableManager? get supplierId {
    final $_column = $_itemColumn<String>('supplier_id');
    if ($_column == null) return null;
    final manager = $$SuppliersTableTableManager(
      $_db,
      $_db.suppliers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_supplierIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$StockReceiptLinesTable, List<StockReceiptLine>>
  _stockReceiptLinesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.stockReceiptLines,
        aliasName: 'stock_receipts__id__stock_receipt_lines__receipt_id',
      );

  $$StockReceiptLinesTableProcessedTableManager get stockReceiptLinesRefs {
    final manager = $$StockReceiptLinesTableTableManager(
      $_db,
      $_db.stockReceiptLines,
    ).filter((f) => f.receiptId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _stockReceiptLinesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$StockReceiptsTableFilterComposer
    extends Composer<_$AppDatabase, $StockReceiptsTable> {
  $$StockReceiptsTableFilterComposer({
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

  ColumnFilters<String> get receiptNumber => $composableBuilder(
    column: $table.receiptNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supplierNameSnapshot => $composableBuilder(
    column: $table.supplierNameSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supplierReference => $composableBuilder(
    column: $table.supplierReference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalCostKobo => $composableBuilder(
    column: $table.totalCostKobo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SuppliersTableFilterComposer get supplierId {
    final $$SuppliersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supplierId,
      referencedTable: $db.suppliers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SuppliersTableFilterComposer(
            $db: $db,
            $table: $db.suppliers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> stockReceiptLinesRefs(
    Expression<bool> Function($$StockReceiptLinesTableFilterComposer f) f,
  ) {
    final $$StockReceiptLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockReceiptLines,
      getReferencedColumn: (t) => t.receiptId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockReceiptLinesTableFilterComposer(
            $db: $db,
            $table: $db.stockReceiptLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StockReceiptsTableOrderingComposer
    extends Composer<_$AppDatabase, $StockReceiptsTable> {
  $$StockReceiptsTableOrderingComposer({
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

  ColumnOrderings<String> get receiptNumber => $composableBuilder(
    column: $table.receiptNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supplierNameSnapshot => $composableBuilder(
    column: $table.supplierNameSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supplierReference => $composableBuilder(
    column: $table.supplierReference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalCostKobo => $composableBuilder(
    column: $table.totalCostKobo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SuppliersTableOrderingComposer get supplierId {
    final $$SuppliersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supplierId,
      referencedTable: $db.suppliers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SuppliersTableOrderingComposer(
            $db: $db,
            $table: $db.suppliers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StockReceiptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StockReceiptsTable> {
  $$StockReceiptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get receiptNumber => $composableBuilder(
    column: $table.receiptNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get supplierNameSnapshot => $composableBuilder(
    column: $table.supplierNameSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get supplierReference => $composableBuilder(
    column: $table.supplierReference,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get totalCostKobo => $composableBuilder(
    column: $table.totalCostKobo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$SuppliersTableAnnotationComposer get supplierId {
    final $$SuppliersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supplierId,
      referencedTable: $db.suppliers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SuppliersTableAnnotationComposer(
            $db: $db,
            $table: $db.suppliers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> stockReceiptLinesRefs<T extends Object>(
    Expression<T> Function($$StockReceiptLinesTableAnnotationComposer a) f,
  ) {
    final $$StockReceiptLinesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.stockReceiptLines,
          getReferencedColumn: (t) => t.receiptId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StockReceiptLinesTableAnnotationComposer(
                $db: $db,
                $table: $db.stockReceiptLines,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$StockReceiptsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StockReceiptsTable,
          StockReceipt,
          $$StockReceiptsTableFilterComposer,
          $$StockReceiptsTableOrderingComposer,
          $$StockReceiptsTableAnnotationComposer,
          $$StockReceiptsTableCreateCompanionBuilder,
          $$StockReceiptsTableUpdateCompanionBuilder,
          (StockReceipt, $$StockReceiptsTableReferences),
          StockReceipt,
          PrefetchHooks Function({bool supplierId, bool stockReceiptLinesRefs})
        > {
  $$StockReceiptsTableTableManager(_$AppDatabase db, $StockReceiptsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StockReceiptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StockReceiptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StockReceiptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> receiptNumber = const Value.absent(),
                Value<String?> supplierId = const Value.absent(),
                Value<String?> supplierNameSnapshot = const Value.absent(),
                Value<String?> supplierReference = const Value.absent(),
                Value<DateTime> receivedAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> totalCostKobo = const Value.absent(),
                Value<String> idempotencyKey = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StockReceiptsCompanion(
                id: id,
                receiptNumber: receiptNumber,
                supplierId: supplierId,
                supplierNameSnapshot: supplierNameSnapshot,
                supplierReference: supplierReference,
                receivedAt: receivedAt,
                notes: notes,
                totalCostKobo: totalCostKobo,
                idempotencyKey: idempotencyKey,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String receiptNumber,
                Value<String?> supplierId = const Value.absent(),
                Value<String?> supplierNameSnapshot = const Value.absent(),
                Value<String?> supplierReference = const Value.absent(),
                required DateTime receivedAt,
                Value<String?> notes = const Value.absent(),
                required int totalCostKobo,
                required String idempotencyKey,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => StockReceiptsCompanion.insert(
                id: id,
                receiptNumber: receiptNumber,
                supplierId: supplierId,
                supplierNameSnapshot: supplierNameSnapshot,
                supplierReference: supplierReference,
                receivedAt: receivedAt,
                notes: notes,
                totalCostKobo: totalCostKobo,
                idempotencyKey: idempotencyKey,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StockReceiptsTable, StockReceipt>(table),
                  $$StockReceiptsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({supplierId = false, stockReceiptLinesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (stockReceiptLinesRefs) db.stockReceiptLines,
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
                        if (supplierId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.supplierId,
                                    referencedTable:
                                        $$StockReceiptsTableReferences
                                            ._supplierIdTable(db),
                                    referencedColumn:
                                        $$StockReceiptsTableReferences
                                            ._supplierIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (stockReceiptLinesRefs)
                        await $_getPrefetchedData<
                          StockReceipt,
                          $StockReceiptsTable,
                          StockReceiptLine
                        >(
                          currentTable: table,
                          referencedTable: $$StockReceiptsTableReferences
                              ._stockReceiptLinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StockReceiptsTableReferences(
                                db,
                                table,
                                p0,
                              ).stockReceiptLinesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.receiptId == item.id,
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

typedef $$StockReceiptsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StockReceiptsTable,
      StockReceipt,
      $$StockReceiptsTableFilterComposer,
      $$StockReceiptsTableOrderingComposer,
      $$StockReceiptsTableAnnotationComposer,
      $$StockReceiptsTableCreateCompanionBuilder,
      $$StockReceiptsTableUpdateCompanionBuilder,
      (StockReceipt, $$StockReceiptsTableReferences),
      StockReceipt,
      PrefetchHooks Function({bool supplierId, bool stockReceiptLinesRefs})
    >;
typedef $$StockReceiptLinesTableCreateCompanionBuilder =
    StockReceiptLinesCompanion Function({
      required String id,
      required String receiptId,
      required String productId,
      required int quantityMilli,
      required int unitCostKobo,
      required int lineCostKobo,
      required String productNameSnapshot,
      required String unitLabelSnapshot,
      Value<int> rowid,
    });
typedef $$StockReceiptLinesTableUpdateCompanionBuilder =
    StockReceiptLinesCompanion Function({
      Value<String> id,
      Value<String> receiptId,
      Value<String> productId,
      Value<int> quantityMilli,
      Value<int> unitCostKobo,
      Value<int> lineCostKobo,
      Value<String> productNameSnapshot,
      Value<String> unitLabelSnapshot,
      Value<int> rowid,
    });

final class $$StockReceiptLinesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $StockReceiptLinesTable,
          StockReceiptLine
        > {
  $$StockReceiptLinesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $StockReceiptsTable _receiptIdTable(_$AppDatabase db) => db
      .stockReceipts
      .createAlias('stock_receipt_lines__receipt_id__stock_receipts__id');

  $$StockReceiptsTableProcessedTableManager get receiptId {
    final $_column = $_itemColumn<String>('receipt_id')!;

    final manager = $$StockReceiptsTableTableManager(
      $_db,
      $_db.stockReceipts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_receiptIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias('stock_receipt_lines__product_id__products__id');

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<String>('product_id')!;

    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StockReceiptLinesTableFilterComposer
    extends Composer<_$AppDatabase, $StockReceiptLinesTable> {
  $$StockReceiptLinesTableFilterComposer({
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

  ColumnFilters<int> get quantityMilli => $composableBuilder(
    column: $table.quantityMilli,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitCostKobo => $composableBuilder(
    column: $table.unitCostKobo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lineCostKobo => $composableBuilder(
    column: $table.lineCostKobo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productNameSnapshot => $composableBuilder(
    column: $table.productNameSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unitLabelSnapshot => $composableBuilder(
    column: $table.unitLabelSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  $$StockReceiptsTableFilterComposer get receiptId {
    final $$StockReceiptsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.receiptId,
      referencedTable: $db.stockReceipts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockReceiptsTableFilterComposer(
            $db: $db,
            $table: $db.stockReceipts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StockReceiptLinesTableOrderingComposer
    extends Composer<_$AppDatabase, $StockReceiptLinesTable> {
  $$StockReceiptLinesTableOrderingComposer({
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

  ColumnOrderings<int> get quantityMilli => $composableBuilder(
    column: $table.quantityMilli,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitCostKobo => $composableBuilder(
    column: $table.unitCostKobo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lineCostKobo => $composableBuilder(
    column: $table.lineCostKobo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productNameSnapshot => $composableBuilder(
    column: $table.productNameSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unitLabelSnapshot => $composableBuilder(
    column: $table.unitLabelSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  $$StockReceiptsTableOrderingComposer get receiptId {
    final $$StockReceiptsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.receiptId,
      referencedTable: $db.stockReceipts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockReceiptsTableOrderingComposer(
            $db: $db,
            $table: $db.stockReceipts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StockReceiptLinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StockReceiptLinesTable> {
  $$StockReceiptLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get quantityMilli => $composableBuilder(
    column: $table.quantityMilli,
    builder: (column) => column,
  );

  GeneratedColumn<int> get unitCostKobo => $composableBuilder(
    column: $table.unitCostKobo,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lineCostKobo => $composableBuilder(
    column: $table.lineCostKobo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get productNameSnapshot => $composableBuilder(
    column: $table.productNameSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unitLabelSnapshot => $composableBuilder(
    column: $table.unitLabelSnapshot,
    builder: (column) => column,
  );

  $$StockReceiptsTableAnnotationComposer get receiptId {
    final $$StockReceiptsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.receiptId,
      referencedTable: $db.stockReceipts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockReceiptsTableAnnotationComposer(
            $db: $db,
            $table: $db.stockReceipts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StockReceiptLinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StockReceiptLinesTable,
          StockReceiptLine,
          $$StockReceiptLinesTableFilterComposer,
          $$StockReceiptLinesTableOrderingComposer,
          $$StockReceiptLinesTableAnnotationComposer,
          $$StockReceiptLinesTableCreateCompanionBuilder,
          $$StockReceiptLinesTableUpdateCompanionBuilder,
          (StockReceiptLine, $$StockReceiptLinesTableReferences),
          StockReceiptLine,
          PrefetchHooks Function({bool receiptId, bool productId})
        > {
  $$StockReceiptLinesTableTableManager(
    _$AppDatabase db,
    $StockReceiptLinesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StockReceiptLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StockReceiptLinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StockReceiptLinesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> receiptId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<int> quantityMilli = const Value.absent(),
                Value<int> unitCostKobo = const Value.absent(),
                Value<int> lineCostKobo = const Value.absent(),
                Value<String> productNameSnapshot = const Value.absent(),
                Value<String> unitLabelSnapshot = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StockReceiptLinesCompanion(
                id: id,
                receiptId: receiptId,
                productId: productId,
                quantityMilli: quantityMilli,
                unitCostKobo: unitCostKobo,
                lineCostKobo: lineCostKobo,
                productNameSnapshot: productNameSnapshot,
                unitLabelSnapshot: unitLabelSnapshot,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String receiptId,
                required String productId,
                required int quantityMilli,
                required int unitCostKobo,
                required int lineCostKobo,
                required String productNameSnapshot,
                required String unitLabelSnapshot,
                Value<int> rowid = const Value.absent(),
              }) => StockReceiptLinesCompanion.insert(
                id: id,
                receiptId: receiptId,
                productId: productId,
                quantityMilli: quantityMilli,
                unitCostKobo: unitCostKobo,
                lineCostKobo: lineCostKobo,
                productNameSnapshot: productNameSnapshot,
                unitLabelSnapshot: unitLabelSnapshot,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StockReceiptLinesTable, StockReceiptLine>(table),
                  $$StockReceiptLinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({receiptId = false, productId = false}) {
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
                    if (receiptId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.receiptId,
                                referencedTable:
                                    $$StockReceiptLinesTableReferences
                                        ._receiptIdTable(db),
                                referencedColumn:
                                    $$StockReceiptLinesTableReferences
                                        ._receiptIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (productId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.productId,
                                referencedTable:
                                    $$StockReceiptLinesTableReferences
                                        ._productIdTable(db),
                                referencedColumn:
                                    $$StockReceiptLinesTableReferences
                                        ._productIdTable(db)
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

typedef $$StockReceiptLinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StockReceiptLinesTable,
      StockReceiptLine,
      $$StockReceiptLinesTableFilterComposer,
      $$StockReceiptLinesTableOrderingComposer,
      $$StockReceiptLinesTableAnnotationComposer,
      $$StockReceiptLinesTableCreateCompanionBuilder,
      $$StockReceiptLinesTableUpdateCompanionBuilder,
      (StockReceiptLine, $$StockReceiptLinesTableReferences),
      StockReceiptLine,
      PrefetchHooks Function({bool receiptId, bool productId})
    >;
typedef $$SalesTableCreateCompanionBuilder =
    SalesCompanion Function({
      required String id,
      required String saleNumber,
      Value<String> status,
      required DateTime soldAt,
      required String paymentMethod,
      Value<String?> customerName,
      Value<String?> note,
      required int subtotalKobo,
      required int discountTotalKobo,
      required int totalKobo,
      Value<DateTime?> voidedAt,
      Value<String?> voidReason,
      required String idempotencyKey,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$SalesTableUpdateCompanionBuilder =
    SalesCompanion Function({
      Value<String> id,
      Value<String> saleNumber,
      Value<String> status,
      Value<DateTime> soldAt,
      Value<String> paymentMethod,
      Value<String?> customerName,
      Value<String?> note,
      Value<int> subtotalKobo,
      Value<int> discountTotalKobo,
      Value<int> totalKobo,
      Value<DateTime?> voidedAt,
      Value<String?> voidReason,
      Value<String> idempotencyKey,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$SalesTableReferences
    extends BaseReferences<_$AppDatabase, $SalesTable, Sale> {
  $$SalesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SaleLinesTable, List<SaleLine>>
  _saleLinesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.saleLines,
    aliasName: 'sales__id__sale_lines__sale_id',
  );

  $$SaleLinesTableProcessedTableManager get saleLinesRefs {
    final manager = $$SaleLinesTableTableManager(
      $_db,
      $_db.saleLines,
    ).filter((f) => f.saleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_saleLinesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SalesTableFilterComposer extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableFilterComposer({
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

  ColumnFilters<String> get saleNumber => $composableBuilder(
    column: $table.saleNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get soldAt => $composableBuilder(
    column: $table.soldAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get subtotalKobo => $composableBuilder(
    column: $table.subtotalKobo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discountTotalKobo => $composableBuilder(
    column: $table.discountTotalKobo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalKobo => $composableBuilder(
    column: $table.totalKobo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get voidedAt => $composableBuilder(
    column: $table.voidedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get voidReason => $composableBuilder(
    column: $table.voidReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> saleLinesRefs(
    Expression<bool> Function($$SaleLinesTableFilterComposer f) f,
  ) {
    final $$SaleLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.saleLines,
      getReferencedColumn: (t) => t.saleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SaleLinesTableFilterComposer(
            $db: $db,
            $table: $db.saleLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SalesTableOrderingComposer
    extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableOrderingComposer({
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

  ColumnOrderings<String> get saleNumber => $composableBuilder(
    column: $table.saleNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get soldAt => $composableBuilder(
    column: $table.soldAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get subtotalKobo => $composableBuilder(
    column: $table.subtotalKobo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discountTotalKobo => $composableBuilder(
    column: $table.discountTotalKobo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalKobo => $composableBuilder(
    column: $table.totalKobo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get voidedAt => $composableBuilder(
    column: $table.voidedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get voidReason => $composableBuilder(
    column: $table.voidReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SalesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get saleNumber => $composableBuilder(
    column: $table.saleNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get soldAt =>
      $composableBuilder(column: $table.soldAt, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get subtotalKobo => $composableBuilder(
    column: $table.subtotalKobo,
    builder: (column) => column,
  );

  GeneratedColumn<int> get discountTotalKobo => $composableBuilder(
    column: $table.discountTotalKobo,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalKobo =>
      $composableBuilder(column: $table.totalKobo, builder: (column) => column);

  GeneratedColumn<DateTime> get voidedAt =>
      $composableBuilder(column: $table.voidedAt, builder: (column) => column);

  GeneratedColumn<String> get voidReason => $composableBuilder(
    column: $table.voidReason,
    builder: (column) => column,
  );

  GeneratedColumn<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> saleLinesRefs<T extends Object>(
    Expression<T> Function($$SaleLinesTableAnnotationComposer a) f,
  ) {
    final $$SaleLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.saleLines,
      getReferencedColumn: (t) => t.saleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SaleLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.saleLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SalesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SalesTable,
          Sale,
          $$SalesTableFilterComposer,
          $$SalesTableOrderingComposer,
          $$SalesTableAnnotationComposer,
          $$SalesTableCreateCompanionBuilder,
          $$SalesTableUpdateCompanionBuilder,
          (Sale, $$SalesTableReferences),
          Sale,
          PrefetchHooks Function({bool saleLinesRefs})
        > {
  $$SalesTableTableManager(_$AppDatabase db, $SalesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SalesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SalesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SalesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> saleNumber = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> soldAt = const Value.absent(),
                Value<String> paymentMethod = const Value.absent(),
                Value<String?> customerName = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> subtotalKobo = const Value.absent(),
                Value<int> discountTotalKobo = const Value.absent(),
                Value<int> totalKobo = const Value.absent(),
                Value<DateTime?> voidedAt = const Value.absent(),
                Value<String?> voidReason = const Value.absent(),
                Value<String> idempotencyKey = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SalesCompanion(
                id: id,
                saleNumber: saleNumber,
                status: status,
                soldAt: soldAt,
                paymentMethod: paymentMethod,
                customerName: customerName,
                note: note,
                subtotalKobo: subtotalKobo,
                discountTotalKobo: discountTotalKobo,
                totalKobo: totalKobo,
                voidedAt: voidedAt,
                voidReason: voidReason,
                idempotencyKey: idempotencyKey,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String saleNumber,
                Value<String> status = const Value.absent(),
                required DateTime soldAt,
                required String paymentMethod,
                Value<String?> customerName = const Value.absent(),
                Value<String?> note = const Value.absent(),
                required int subtotalKobo,
                required int discountTotalKobo,
                required int totalKobo,
                Value<DateTime?> voidedAt = const Value.absent(),
                Value<String?> voidReason = const Value.absent(),
                required String idempotencyKey,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => SalesCompanion.insert(
                id: id,
                saleNumber: saleNumber,
                status: status,
                soldAt: soldAt,
                paymentMethod: paymentMethod,
                customerName: customerName,
                note: note,
                subtotalKobo: subtotalKobo,
                discountTotalKobo: discountTotalKobo,
                totalKobo: totalKobo,
                voidedAt: voidedAt,
                voidReason: voidReason,
                idempotencyKey: idempotencyKey,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SalesTable, Sale>(table),
                  $$SalesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({saleLinesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (saleLinesRefs) db.saleLines],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (saleLinesRefs)
                    await $_getPrefetchedData<Sale, $SalesTable, SaleLine>(
                      currentTable: table,
                      referencedTable: $$SalesTableReferences
                          ._saleLinesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SalesTableReferences(db, table, p0).saleLinesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.saleId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SalesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SalesTable,
      Sale,
      $$SalesTableFilterComposer,
      $$SalesTableOrderingComposer,
      $$SalesTableAnnotationComposer,
      $$SalesTableCreateCompanionBuilder,
      $$SalesTableUpdateCompanionBuilder,
      (Sale, $$SalesTableReferences),
      Sale,
      PrefetchHooks Function({bool saleLinesRefs})
    >;
typedef $$SaleLinesTableCreateCompanionBuilder =
    SaleLinesCompanion Function({
      required String id,
      required String saleId,
      required String productId,
      required String productNameSnapshot,
      Value<String?> skuSnapshot,
      required String unitLabelSnapshot,
      required int quantityMilli,
      required int unitPriceKobo,
      required int grossLineTotalKobo,
      required int discountKobo,
      required int netLineTotalKobo,
      required int unitCostSnapshotKobo,
      required int cogsTotalKobo,
      Value<int> rowid,
    });
typedef $$SaleLinesTableUpdateCompanionBuilder =
    SaleLinesCompanion Function({
      Value<String> id,
      Value<String> saleId,
      Value<String> productId,
      Value<String> productNameSnapshot,
      Value<String?> skuSnapshot,
      Value<String> unitLabelSnapshot,
      Value<int> quantityMilli,
      Value<int> unitPriceKobo,
      Value<int> grossLineTotalKobo,
      Value<int> discountKobo,
      Value<int> netLineTotalKobo,
      Value<int> unitCostSnapshotKobo,
      Value<int> cogsTotalKobo,
      Value<int> rowid,
    });

final class $$SaleLinesTableReferences
    extends BaseReferences<_$AppDatabase, $SaleLinesTable, SaleLine> {
  $$SaleLinesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SalesTable _saleIdTable(_$AppDatabase db) =>
      db.sales.createAlias('sale_lines__sale_id__sales__id');

  $$SalesTableProcessedTableManager get saleId {
    final $_column = $_itemColumn<String>('sale_id')!;

    final manager = $$SalesTableTableManager(
      $_db,
      $_db.sales,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_saleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias('sale_lines__product_id__products__id');

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<String>('product_id')!;

    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SaleLinesTableFilterComposer
    extends Composer<_$AppDatabase, $SaleLinesTable> {
  $$SaleLinesTableFilterComposer({
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

  ColumnFilters<String> get productNameSnapshot => $composableBuilder(
    column: $table.productNameSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get skuSnapshot => $composableBuilder(
    column: $table.skuSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unitLabelSnapshot => $composableBuilder(
    column: $table.unitLabelSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantityMilli => $composableBuilder(
    column: $table.quantityMilli,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitPriceKobo => $composableBuilder(
    column: $table.unitPriceKobo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get grossLineTotalKobo => $composableBuilder(
    column: $table.grossLineTotalKobo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discountKobo => $composableBuilder(
    column: $table.discountKobo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get netLineTotalKobo => $composableBuilder(
    column: $table.netLineTotalKobo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitCostSnapshotKobo => $composableBuilder(
    column: $table.unitCostSnapshotKobo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cogsTotalKobo => $composableBuilder(
    column: $table.cogsTotalKobo,
    builder: (column) => ColumnFilters(column),
  );

  $$SalesTableFilterComposer get saleId {
    final $$SalesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.saleId,
      referencedTable: $db.sales,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalesTableFilterComposer(
            $db: $db,
            $table: $db.sales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SaleLinesTableOrderingComposer
    extends Composer<_$AppDatabase, $SaleLinesTable> {
  $$SaleLinesTableOrderingComposer({
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

  ColumnOrderings<String> get productNameSnapshot => $composableBuilder(
    column: $table.productNameSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get skuSnapshot => $composableBuilder(
    column: $table.skuSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unitLabelSnapshot => $composableBuilder(
    column: $table.unitLabelSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantityMilli => $composableBuilder(
    column: $table.quantityMilli,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitPriceKobo => $composableBuilder(
    column: $table.unitPriceKobo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get grossLineTotalKobo => $composableBuilder(
    column: $table.grossLineTotalKobo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discountKobo => $composableBuilder(
    column: $table.discountKobo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get netLineTotalKobo => $composableBuilder(
    column: $table.netLineTotalKobo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitCostSnapshotKobo => $composableBuilder(
    column: $table.unitCostSnapshotKobo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cogsTotalKobo => $composableBuilder(
    column: $table.cogsTotalKobo,
    builder: (column) => ColumnOrderings(column),
  );

  $$SalesTableOrderingComposer get saleId {
    final $$SalesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.saleId,
      referencedTable: $db.sales,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalesTableOrderingComposer(
            $db: $db,
            $table: $db.sales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SaleLinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SaleLinesTable> {
  $$SaleLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productNameSnapshot => $composableBuilder(
    column: $table.productNameSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get skuSnapshot => $composableBuilder(
    column: $table.skuSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unitLabelSnapshot => $composableBuilder(
    column: $table.unitLabelSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quantityMilli => $composableBuilder(
    column: $table.quantityMilli,
    builder: (column) => column,
  );

  GeneratedColumn<int> get unitPriceKobo => $composableBuilder(
    column: $table.unitPriceKobo,
    builder: (column) => column,
  );

  GeneratedColumn<int> get grossLineTotalKobo => $composableBuilder(
    column: $table.grossLineTotalKobo,
    builder: (column) => column,
  );

  GeneratedColumn<int> get discountKobo => $composableBuilder(
    column: $table.discountKobo,
    builder: (column) => column,
  );

  GeneratedColumn<int> get netLineTotalKobo => $composableBuilder(
    column: $table.netLineTotalKobo,
    builder: (column) => column,
  );

  GeneratedColumn<int> get unitCostSnapshotKobo => $composableBuilder(
    column: $table.unitCostSnapshotKobo,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cogsTotalKobo => $composableBuilder(
    column: $table.cogsTotalKobo,
    builder: (column) => column,
  );

  $$SalesTableAnnotationComposer get saleId {
    final $$SalesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.saleId,
      referencedTable: $db.sales,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalesTableAnnotationComposer(
            $db: $db,
            $table: $db.sales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SaleLinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SaleLinesTable,
          SaleLine,
          $$SaleLinesTableFilterComposer,
          $$SaleLinesTableOrderingComposer,
          $$SaleLinesTableAnnotationComposer,
          $$SaleLinesTableCreateCompanionBuilder,
          $$SaleLinesTableUpdateCompanionBuilder,
          (SaleLine, $$SaleLinesTableReferences),
          SaleLine,
          PrefetchHooks Function({bool saleId, bool productId})
        > {
  $$SaleLinesTableTableManager(_$AppDatabase db, $SaleLinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SaleLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SaleLinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SaleLinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> saleId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<String> productNameSnapshot = const Value.absent(),
                Value<String?> skuSnapshot = const Value.absent(),
                Value<String> unitLabelSnapshot = const Value.absent(),
                Value<int> quantityMilli = const Value.absent(),
                Value<int> unitPriceKobo = const Value.absent(),
                Value<int> grossLineTotalKobo = const Value.absent(),
                Value<int> discountKobo = const Value.absent(),
                Value<int> netLineTotalKobo = const Value.absent(),
                Value<int> unitCostSnapshotKobo = const Value.absent(),
                Value<int> cogsTotalKobo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SaleLinesCompanion(
                id: id,
                saleId: saleId,
                productId: productId,
                productNameSnapshot: productNameSnapshot,
                skuSnapshot: skuSnapshot,
                unitLabelSnapshot: unitLabelSnapshot,
                quantityMilli: quantityMilli,
                unitPriceKobo: unitPriceKobo,
                grossLineTotalKobo: grossLineTotalKobo,
                discountKobo: discountKobo,
                netLineTotalKobo: netLineTotalKobo,
                unitCostSnapshotKobo: unitCostSnapshotKobo,
                cogsTotalKobo: cogsTotalKobo,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String saleId,
                required String productId,
                required String productNameSnapshot,
                Value<String?> skuSnapshot = const Value.absent(),
                required String unitLabelSnapshot,
                required int quantityMilli,
                required int unitPriceKobo,
                required int grossLineTotalKobo,
                required int discountKobo,
                required int netLineTotalKobo,
                required int unitCostSnapshotKobo,
                required int cogsTotalKobo,
                Value<int> rowid = const Value.absent(),
              }) => SaleLinesCompanion.insert(
                id: id,
                saleId: saleId,
                productId: productId,
                productNameSnapshot: productNameSnapshot,
                skuSnapshot: skuSnapshot,
                unitLabelSnapshot: unitLabelSnapshot,
                quantityMilli: quantityMilli,
                unitPriceKobo: unitPriceKobo,
                grossLineTotalKobo: grossLineTotalKobo,
                discountKobo: discountKobo,
                netLineTotalKobo: netLineTotalKobo,
                unitCostSnapshotKobo: unitCostSnapshotKobo,
                cogsTotalKobo: cogsTotalKobo,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SaleLinesTable, SaleLine>(table),
                  $$SaleLinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({saleId = false, productId = false}) {
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
                    if (saleId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.saleId,
                                referencedTable: $$SaleLinesTableReferences
                                    ._saleIdTable(db),
                                referencedColumn: $$SaleLinesTableReferences
                                    ._saleIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (productId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.productId,
                                referencedTable: $$SaleLinesTableReferences
                                    ._productIdTable(db),
                                referencedColumn: $$SaleLinesTableReferences
                                    ._productIdTable(db)
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

typedef $$SaleLinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SaleLinesTable,
      SaleLine,
      $$SaleLinesTableFilterComposer,
      $$SaleLinesTableOrderingComposer,
      $$SaleLinesTableAnnotationComposer,
      $$SaleLinesTableCreateCompanionBuilder,
      $$SaleLinesTableUpdateCompanionBuilder,
      (SaleLine, $$SaleLinesTableReferences),
      SaleLine,
      PrefetchHooks Function({bool saleId, bool productId})
    >;
typedef $$StockMovementsTableCreateCompanionBuilder =
    StockMovementsCompanion Function({
      required String id,
      required String productId,
      required String movementType,
      required int quantityDeltaMilli,
      Value<int?> unitCostKobo,
      required DateTime occurredAt,
      required String referenceType,
      required String referenceId,
      Value<String?> reason,
      Value<String?> note,
      required String idempotencyKey,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$StockMovementsTableUpdateCompanionBuilder =
    StockMovementsCompanion Function({
      Value<String> id,
      Value<String> productId,
      Value<String> movementType,
      Value<int> quantityDeltaMilli,
      Value<int?> unitCostKobo,
      Value<DateTime> occurredAt,
      Value<String> referenceType,
      Value<String> referenceId,
      Value<String?> reason,
      Value<String?> note,
      Value<String> idempotencyKey,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$StockMovementsTableReferences
    extends BaseReferences<_$AppDatabase, $StockMovementsTable, StockMovement> {
  $$StockMovementsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias('stock_movements__product_id__products__id');

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<String>('product_id')!;

    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StockMovementsTableFilterComposer
    extends Composer<_$AppDatabase, $StockMovementsTable> {
  $$StockMovementsTableFilterComposer({
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

  ColumnFilters<String> get movementType => $composableBuilder(
    column: $table.movementType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantityDeltaMilli => $composableBuilder(
    column: $table.quantityDeltaMilli,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitCostKobo => $composableBuilder(
    column: $table.unitCostKobo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referenceType => $composableBuilder(
    column: $table.referenceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referenceId => $composableBuilder(
    column: $table.referenceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StockMovementsTableOrderingComposer
    extends Composer<_$AppDatabase, $StockMovementsTable> {
  $$StockMovementsTableOrderingComposer({
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

  ColumnOrderings<String> get movementType => $composableBuilder(
    column: $table.movementType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantityDeltaMilli => $composableBuilder(
    column: $table.quantityDeltaMilli,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitCostKobo => $composableBuilder(
    column: $table.unitCostKobo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referenceType => $composableBuilder(
    column: $table.referenceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referenceId => $composableBuilder(
    column: $table.referenceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StockMovementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StockMovementsTable> {
  $$StockMovementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get movementType => $composableBuilder(
    column: $table.movementType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quantityDeltaMilli => $composableBuilder(
    column: $table.quantityDeltaMilli,
    builder: (column) => column,
  );

  GeneratedColumn<int> get unitCostKobo => $composableBuilder(
    column: $table.unitCostKobo,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get referenceType => $composableBuilder(
    column: $table.referenceType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get referenceId => $composableBuilder(
    column: $table.referenceId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StockMovementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StockMovementsTable,
          StockMovement,
          $$StockMovementsTableFilterComposer,
          $$StockMovementsTableOrderingComposer,
          $$StockMovementsTableAnnotationComposer,
          $$StockMovementsTableCreateCompanionBuilder,
          $$StockMovementsTableUpdateCompanionBuilder,
          (StockMovement, $$StockMovementsTableReferences),
          StockMovement,
          PrefetchHooks Function({bool productId})
        > {
  $$StockMovementsTableTableManager(
    _$AppDatabase db,
    $StockMovementsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StockMovementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StockMovementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StockMovementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<String> movementType = const Value.absent(),
                Value<int> quantityDeltaMilli = const Value.absent(),
                Value<int?> unitCostKobo = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<String> referenceType = const Value.absent(),
                Value<String> referenceId = const Value.absent(),
                Value<String?> reason = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String> idempotencyKey = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StockMovementsCompanion(
                id: id,
                productId: productId,
                movementType: movementType,
                quantityDeltaMilli: quantityDeltaMilli,
                unitCostKobo: unitCostKobo,
                occurredAt: occurredAt,
                referenceType: referenceType,
                referenceId: referenceId,
                reason: reason,
                note: note,
                idempotencyKey: idempotencyKey,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String productId,
                required String movementType,
                required int quantityDeltaMilli,
                Value<int?> unitCostKobo = const Value.absent(),
                required DateTime occurredAt,
                required String referenceType,
                required String referenceId,
                Value<String?> reason = const Value.absent(),
                Value<String?> note = const Value.absent(),
                required String idempotencyKey,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => StockMovementsCompanion.insert(
                id: id,
                productId: productId,
                movementType: movementType,
                quantityDeltaMilli: quantityDeltaMilli,
                unitCostKobo: unitCostKobo,
                occurredAt: occurredAt,
                referenceType: referenceType,
                referenceId: referenceId,
                reason: reason,
                note: note,
                idempotencyKey: idempotencyKey,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StockMovementsTable, StockMovement>(table),
                  $$StockMovementsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({productId = false}) {
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
                    if (productId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.productId,
                                referencedTable: $$StockMovementsTableReferences
                                    ._productIdTable(db),
                                referencedColumn:
                                    $$StockMovementsTableReferences
                                        ._productIdTable(db)
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

typedef $$StockMovementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StockMovementsTable,
      StockMovement,
      $$StockMovementsTableFilterComposer,
      $$StockMovementsTableOrderingComposer,
      $$StockMovementsTableAnnotationComposer,
      $$StockMovementsTableCreateCompanionBuilder,
      $$StockMovementsTableUpdateCompanionBuilder,
      (StockMovement, $$StockMovementsTableReferences),
      StockMovement,
      PrefetchHooks Function({bool productId})
    >;
typedef $$StockAdjustmentsTableCreateCompanionBuilder =
    StockAdjustmentsCompanion Function({
      required String id,
      required String adjustmentNumber,
      required String productId,
      required String adjustmentType,
      required int quantityMilli,
      Value<int?> unitCostKobo,
      required String reason,
      Value<String?> note,
      required DateTime occurredAt,
      required String idempotencyKey,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$StockAdjustmentsTableUpdateCompanionBuilder =
    StockAdjustmentsCompanion Function({
      Value<String> id,
      Value<String> adjustmentNumber,
      Value<String> productId,
      Value<String> adjustmentType,
      Value<int> quantityMilli,
      Value<int?> unitCostKobo,
      Value<String> reason,
      Value<String?> note,
      Value<DateTime> occurredAt,
      Value<String> idempotencyKey,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$StockAdjustmentsTableReferences
    extends
        BaseReferences<_$AppDatabase, $StockAdjustmentsTable, StockAdjustment> {
  $$StockAdjustmentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias('stock_adjustments__product_id__products__id');

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<String>('product_id')!;

    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StockAdjustmentsTableFilterComposer
    extends Composer<_$AppDatabase, $StockAdjustmentsTable> {
  $$StockAdjustmentsTableFilterComposer({
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

  ColumnFilters<String> get adjustmentNumber => $composableBuilder(
    column: $table.adjustmentNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get adjustmentType => $composableBuilder(
    column: $table.adjustmentType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantityMilli => $composableBuilder(
    column: $table.quantityMilli,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitCostKobo => $composableBuilder(
    column: $table.unitCostKobo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StockAdjustmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $StockAdjustmentsTable> {
  $$StockAdjustmentsTableOrderingComposer({
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

  ColumnOrderings<String> get adjustmentNumber => $composableBuilder(
    column: $table.adjustmentNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get adjustmentType => $composableBuilder(
    column: $table.adjustmentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantityMilli => $composableBuilder(
    column: $table.quantityMilli,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitCostKobo => $composableBuilder(
    column: $table.unitCostKobo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StockAdjustmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StockAdjustmentsTable> {
  $$StockAdjustmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get adjustmentNumber => $composableBuilder(
    column: $table.adjustmentNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get adjustmentType => $composableBuilder(
    column: $table.adjustmentType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quantityMilli => $composableBuilder(
    column: $table.quantityMilli,
    builder: (column) => column,
  );

  GeneratedColumn<int> get unitCostKobo => $composableBuilder(
    column: $table.unitCostKobo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StockAdjustmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StockAdjustmentsTable,
          StockAdjustment,
          $$StockAdjustmentsTableFilterComposer,
          $$StockAdjustmentsTableOrderingComposer,
          $$StockAdjustmentsTableAnnotationComposer,
          $$StockAdjustmentsTableCreateCompanionBuilder,
          $$StockAdjustmentsTableUpdateCompanionBuilder,
          (StockAdjustment, $$StockAdjustmentsTableReferences),
          StockAdjustment,
          PrefetchHooks Function({bool productId})
        > {
  $$StockAdjustmentsTableTableManager(
    _$AppDatabase db,
    $StockAdjustmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StockAdjustmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StockAdjustmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StockAdjustmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> adjustmentNumber = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<String> adjustmentType = const Value.absent(),
                Value<int> quantityMilli = const Value.absent(),
                Value<int?> unitCostKobo = const Value.absent(),
                Value<String> reason = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<String> idempotencyKey = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StockAdjustmentsCompanion(
                id: id,
                adjustmentNumber: adjustmentNumber,
                productId: productId,
                adjustmentType: adjustmentType,
                quantityMilli: quantityMilli,
                unitCostKobo: unitCostKobo,
                reason: reason,
                note: note,
                occurredAt: occurredAt,
                idempotencyKey: idempotencyKey,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String adjustmentNumber,
                required String productId,
                required String adjustmentType,
                required int quantityMilli,
                Value<int?> unitCostKobo = const Value.absent(),
                required String reason,
                Value<String?> note = const Value.absent(),
                required DateTime occurredAt,
                required String idempotencyKey,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => StockAdjustmentsCompanion.insert(
                id: id,
                adjustmentNumber: adjustmentNumber,
                productId: productId,
                adjustmentType: adjustmentType,
                quantityMilli: quantityMilli,
                unitCostKobo: unitCostKobo,
                reason: reason,
                note: note,
                occurredAt: occurredAt,
                idempotencyKey: idempotencyKey,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StockAdjustmentsTable, StockAdjustment>(table),
                  $$StockAdjustmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({productId = false}) {
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
                    if (productId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.productId,
                                referencedTable:
                                    $$StockAdjustmentsTableReferences
                                        ._productIdTable(db),
                                referencedColumn:
                                    $$StockAdjustmentsTableReferences
                                        ._productIdTable(db)
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

typedef $$StockAdjustmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StockAdjustmentsTable,
      StockAdjustment,
      $$StockAdjustmentsTableFilterComposer,
      $$StockAdjustmentsTableOrderingComposer,
      $$StockAdjustmentsTableAnnotationComposer,
      $$StockAdjustmentsTableCreateCompanionBuilder,
      $$StockAdjustmentsTableUpdateCompanionBuilder,
      (StockAdjustment, $$StockAdjustmentsTableReferences),
      StockAdjustment,
      PrefetchHooks Function({bool productId})
    >;
typedef $$ExpensesTableCreateCompanionBuilder =
    ExpensesCompanion Function({
      required String id,
      required int amountKobo,
      required String category,
      required DateTime expenseDate,
      required String paymentMethod,
      Value<String?> note,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ExpensesTableUpdateCompanionBuilder =
    ExpensesCompanion Function({
      Value<String> id,
      Value<int> amountKobo,
      Value<String> category,
      Value<DateTime> expenseDate,
      Value<String> paymentMethod,
      Value<String?> note,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$ExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
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

  ColumnFilters<int> get amountKobo => $composableBuilder(
    column: $table.amountKobo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expenseDate => $composableBuilder(
    column: $table.expenseDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
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
}

class $$ExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
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

  ColumnOrderings<int> get amountKobo => $composableBuilder(
    column: $table.amountKobo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expenseDate => $composableBuilder(
    column: $table.expenseDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
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
}

class $$ExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amountKobo => $composableBuilder(
    column: $table.amountKobo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get expenseDate => $composableBuilder(
    column: $table.expenseDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ExpensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpensesTable,
          Expense,
          $$ExpensesTableFilterComposer,
          $$ExpensesTableOrderingComposer,
          $$ExpensesTableAnnotationComposer,
          $$ExpensesTableCreateCompanionBuilder,
          $$ExpensesTableUpdateCompanionBuilder,
          (Expense, BaseReferences<_$AppDatabase, $ExpensesTable, Expense>),
          Expense,
          PrefetchHooks Function()
        > {
  $$ExpensesTableTableManager(_$AppDatabase db, $ExpensesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> amountKobo = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<DateTime> expenseDate = const Value.absent(),
                Value<String> paymentMethod = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExpensesCompanion(
                id: id,
                amountKobo: amountKobo,
                category: category,
                expenseDate: expenseDate,
                paymentMethod: paymentMethod,
                note: note,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int amountKobo,
                required String category,
                required DateTime expenseDate,
                required String paymentMethod,
                Value<String?> note = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ExpensesCompanion.insert(
                id: id,
                amountKobo: amountKobo,
                category: category,
                expenseDate: expenseDate,
                paymentMethod: paymentMethod,
                note: note,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ExpensesTable, Expense>(table),
                  BaseReferences<_$AppDatabase, $ExpensesTable, Expense>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpensesTable,
      Expense,
      $$ExpensesTableFilterComposer,
      $$ExpensesTableOrderingComposer,
      $$ExpensesTableAnnotationComposer,
      $$ExpensesTableCreateCompanionBuilder,
      $$ExpensesTableUpdateCompanionBuilder,
      (Expense, BaseReferences<_$AppDatabase, $ExpensesTable, Expense>),
      Expense,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BusinessProfileTableTableManager get businessProfile =>
      $$BusinessProfileTableTableManager(_db, _db.businessProfile);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$ProductCategoriesTableTableManager get productCategories =>
      $$ProductCategoriesTableTableManager(_db, _db.productCategories);
  $$SuppliersTableTableManager get suppliers =>
      $$SuppliersTableTableManager(_db, _db.suppliers);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$StockReceiptsTableTableManager get stockReceipts =>
      $$StockReceiptsTableTableManager(_db, _db.stockReceipts);
  $$StockReceiptLinesTableTableManager get stockReceiptLines =>
      $$StockReceiptLinesTableTableManager(_db, _db.stockReceiptLines);
  $$SalesTableTableManager get sales =>
      $$SalesTableTableManager(_db, _db.sales);
  $$SaleLinesTableTableManager get saleLines =>
      $$SaleLinesTableTableManager(_db, _db.saleLines);
  $$StockMovementsTableTableManager get stockMovements =>
      $$StockMovementsTableTableManager(_db, _db.stockMovements);
  $$StockAdjustmentsTableTableManager get stockAdjustments =>
      $$StockAdjustmentsTableTableManager(_db, _db.stockAdjustments);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
}
