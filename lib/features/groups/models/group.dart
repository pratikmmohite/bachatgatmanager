import 'package:json_annotation/json_annotation.dart';

import 'com_fields.dart';

part 'group.g.dart';

@JsonSerializable()
class Group extends ComFields {
  late String name;
  int installmentDate = 1;
  late DateTime sdt;
  late DateTime edt;
  late DateTime accountOpeningDate;
  String? address;
  String? bankName;
  String? accountNo;
  String? ifscCode;

  double installmentAmt = 0;
  double loanInterestPer = 0;
  double loanPenaltyAmt = 0;
  double installmentPenaltyAmt = 0;

  Group(
      {required this.name,
      required this.sdt,
      required this.edt,
      required this.accountOpeningDate,
      this.address,
      this.bankName,
      this.accountNo,
      this.ifscCode,
      this.installmentAmt = 0,
      this.loanPenaltyAmt = 0,
      this.loanInterestPer = 0,
      this.installmentPenaltyAmt = 0})
      : super();

  Group.withDefault() {
    name = "";
    var dt = DateTime.now();
    sdt = DateTime(dt.year, dt.month, 1);
    edt = DateTime(dt.year + 1, dt.month, 0);
    accountOpeningDate = sdt;
    installmentPenaltyAmt = 0;
    installmentAmt = 100;
    loanInterestPer = 0;
    loanPenaltyAmt = 0;
  }
  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GroupToJson(this);
}
