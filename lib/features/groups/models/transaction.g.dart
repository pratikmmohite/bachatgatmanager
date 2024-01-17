// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      memberId: json['memberId'] as String,
      groupId: json['groupId'] as String,
      trxType: json['trxType'] as String,
      month: json['month'] as int,
      year: json['year'] as int,
      cr: json['cr'] as int,
      dr: json['dr'] as int,
      trxDate: DateTime.parse(json['trxDate'] as String),
    )
      ..id = json['id'] as String
      ..sysCreated = DateTime.parse(json['sysCreated'] as String)
      ..sysUpdated = DateTime.parse(json['sysUpdated'] as String)
      ..sourceType = json['sourceType'] as String
      ..sourceId = json['sourceId'] as String;

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sysCreated': instance.sysCreated.toIso8601String(),
      'sysUpdated': instance.sysUpdated.toIso8601String(),
      'memberId': instance.memberId,
      'groupId': instance.groupId,
      'trxType': instance.trxType,
      'month': instance.month,
      'year': instance.year,
      'cr': instance.cr,
      'dr': instance.dr,
      'sourceType': instance.sourceType,
      'sourceId': instance.sourceId,
      'trxDate': instance.trxDate.toIso8601String(),
    };
