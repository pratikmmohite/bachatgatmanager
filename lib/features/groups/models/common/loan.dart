import 'package:json_annotation/json_annotation.dart';

import 'com_fields.dart';

part 'loan.g.dart';

@JsonSerializable()
class Loan extends ComFields {
  String id = "";
  String memberId = "";
  String groupId = "";
  double loanAmount = 0;
  double interestPercentage = 0;
  String status = "";
  DateTime loanDate;
  String note = "";
  double remainingLoanAmount = 0;
  double remainingInterestAmount = 0;
  Loan({
    required this.memberId,
    required this.groupId,
    required this.loanAmount,
    required this.interestPercentage,
    required this.remainingLoanAmount,
    required this.remainingInterestAmount,
    required this.note,
    required this.status,
    required this.loanDate,
  });

  factory Loan.fromJson(Map<String, dynamic> json) => _$LoanFromJson(json);

  Map<String, dynamic> toJson() => _$LoanToJson(this);
}
