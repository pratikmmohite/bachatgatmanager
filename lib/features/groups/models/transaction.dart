import 'package:json_annotation/json_annotation.dart';

import 'com_fields.dart';

part 'transaction.g.dart';

@JsonSerializable()
class Transaction extends ComFields {
  String memberId = "";
  String groupId = "";
  String trxType = "";
  int month = 1;
  int year = 2023;
  int cr = 0;
  int dr = 0;
  String sourceType = "";
  String sourceId = "";
  DateTime trxDate;

  Transaction(
      {required this.memberId,
      required this.groupId,
      required this.trxType,
      required this.month,
      required this.year,
      required this.cr,
      required this.dr,
      required this.trxDate});

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}
