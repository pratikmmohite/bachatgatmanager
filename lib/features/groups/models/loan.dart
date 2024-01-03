import 'package:json_annotation/json_annotation.dart';

import 'com_fields.dart';

part 'loan.g.dart';

@JsonSerializable()
class Loan extends ComFields {
  String id = "";
  String memberId = "";
  String groupId = "";
  String loanAmount = "";
  String interestPercentage = "";
  String status = "";
  DateTime loanDate;
  Loan(
      {required this.memberId,
      required this.groupId,
      required this.loanAmount,
      required this.interestPercentage,
      required this.status,
      required this.loanDate});

  factory Loan.fromJson(Map<String, dynamic> json) => _$LoanFromJson(json);

  Map<String, dynamic> toJson() => _$LoanToJson(this);
}
