import 'package:json_annotation/json_annotation.dart';

part 'group_balance_summary.g.dart';

@JsonSerializable()
class GroupBalanceSummary {
  @JsonKey(name: 'totalDeposit')
  final double totalDeposit;

  @JsonKey(name: 'totalShares')
  final double totalShares;

  @JsonKey(name: 'TotalLoanInterest')
  final double totalLoanInterest;

  @JsonKey(name: 'TotalPenalty')
  final double totalPenalty;

  @JsonKey(name: 'OtherDeposit')
  final double otherDeposit;

  @JsonKey(name: 'totalExpenditures')
  final double totalExpenditures;

  @JsonKey(name: 'remainingLoan')
  final double remainingLoan;

  GroupBalanceSummary({
    required this.totalDeposit,
    required this.totalShares,
    required this.totalLoanInterest,
    required this.totalPenalty,
    required this.otherDeposit,
    required this.totalExpenditures,
    required this.remainingLoan,
  });

  factory GroupBalanceSummary.fromSqlResults(Map<String, dynamic> json) {
    return GroupBalanceSummary(
      totalDeposit: (json['totalDeposit'] as num?)?.toDouble() ?? 0.0,
      totalShares: (json['totalShares'] as num?)?.toDouble() ?? 0.0,
      totalLoanInterest: (json['TotalLoanInterest'] as num?)?.toDouble() ?? 0.0,
      totalPenalty: (json['TotalPenalty'] as num?)?.toDouble() ?? 0.0,
      otherDeposit: (json['OtherDeposit'] as num?)?.toDouble() ?? 0.0,
      totalExpenditures: (json['totalExpenditures'] as num?)?.toDouble() ?? 0.0,
      remainingLoan: (json['remainingLoan'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => _$GroupBalanceSummaryToJson(this);
}
