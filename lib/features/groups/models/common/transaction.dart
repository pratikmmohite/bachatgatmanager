import 'package:bachat_gat/common/common_index.dart';
import 'package:json_annotation/json_annotation.dart';

import 'com_fields.dart';

part 'transaction.g.dart';

@JsonSerializable()
class Transaction extends ComFields {
  String memberId = "";
  String groupId = "";
  String trxType = "";
  late DateTime trxDt;
  String trxPeriod = "";
  double cr = 0;
  double dr = 0;
  String sourceType = "";
  String sourceId = "";
  String addedBy = "";
  String note = "";

  Transaction({
    required this.memberId,
    required this.groupId,
    required this.trxType,
    required this.trxPeriod,
    required this.cr,
    required this.dr,
    required this.sourceType,
    required this.sourceId,
    required this.addedBy,
    this.note = "",
    DateTime? trxDt,
  }) {
    this.trxDt = trxDt ?? DateTime.now();
  }

  Transaction.withEmpty() {
    trxDt = DateTime.now();
    trxPeriod = AppUtils.getTrxPeriodFromDt(trxDt);
  }

  Transaction.withDefault({
    required this.memberId,
    required this.groupId,
    required this.trxType,
    required this.trxPeriod,
    this.cr = 0,
    this.dr = 0,
    this.sourceId = "",
    this.sourceType = AppConstants.sUser,
    this.addedBy = "Admin",
    this.note = "",
    DateTime? trxDt,
  }) {
    this.trxDt = trxDt ?? DateTime.now();
  }

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}
