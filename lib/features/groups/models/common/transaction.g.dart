// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      memberId: json['memberId'] as String,
      groupId: json['groupId'] as String,
      trxType: json['trxType'] as String,
      trxPeriod: json['trxPeriod'] as String,
      cr: (json['cr'] as num).toDouble(),
      dr: (json['dr'] as num).toDouble(),
      sourceType: json['sourceType'] as String,
      sourceId: json['sourceId'] as String,
      addedBy: json['addedBy'] as String,
      note: json['note'] as String? ?? "",
      trxDt: json['trxDt'] == null
          ? null
          : DateTime.parse(json['trxDt'] as String),
    )
      ..id = json['id'] as String
      ..sysCreated = DateTime.parse(json['sysCreated'] as String)
      ..sysUpdated = DateTime.parse(json['sysUpdated'] as String);

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sysCreated': instance.sysCreated.toIso8601String(),
      'sysUpdated': instance.sysUpdated.toIso8601String(),
      'memberId': instance.memberId,
      'groupId': instance.groupId,
      'trxType': instance.trxType,
      'trxDt': instance.trxDt.toIso8601String(),
      'trxPeriod': instance.trxPeriod,
      'cr': instance.cr,
      'dr': instance.dr,
      'sourceType': instance.sourceType,
      'sourceId': instance.sourceId,
      'addedBy': instance.addedBy,
      'note': instance.note,
    };
