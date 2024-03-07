import 'package:json_annotation/json_annotation.dart';

import '../common/com_fields.dart';

part 'member_transaction_summary.g.dart';

@JsonSerializable()
class MemberTransactionSummary extends ComFields {
  final String name;
  final double totalSharesDeposit;
  final double totalLoanInterest;
  final double totalPenalty;
  final double otherDeposit;
  final double loanTakenTillDate;
  final double loanReturn;
  final double remainingLoan;
  final double sharesGivenByGroup;

  MemberTransactionSummary({
    required this.name,
    required this.totalSharesDeposit,
    required this.totalLoanInterest,
    required this.totalPenalty,
    required this.otherDeposit,
    required this.loanTakenTillDate,
    required this.loanReturn,
    required this.remainingLoan,
    required this.sharesGivenByGroup,
  });

  factory MemberTransactionSummary.fromJson(Map<String, dynamic> json) {
    return MemberTransactionSummary(
      name: json['name'],
      totalSharesDeposit: json['TotalSharesDeposit'] ?? 0.0,
      totalLoanInterest: json['TotalLoanInterest'] ?? 0.0,
      totalPenalty: json['TotalPenalty'] ?? 0.0,
      otherDeposit: json['OtherDeposit'] ?? 0.0,
      loanTakenTillDate: json['LoanTakenTillDate'] ?? 0.0,
      loanReturn: json['LoanReturn'] ?? 0.0,
      remainingLoan: json['RemainingLoan'] ?? 0.0,
      sharesGivenByGroup: json['SharesGivenByGroup'] ?? 0.0,
    );
  }
  @override
  Map<String, dynamic> toJson() => _$MemberTransactionSummaryToJson(this);
}
