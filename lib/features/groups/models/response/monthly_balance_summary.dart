/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
import 'package:json_annotation/json_annotation.dart';

part 'monthly_balance_summary.g.dart';

@JsonSerializable()
class MonthlyBalanceSummary {
  @JsonKey(name: 'peviousRemainig')
  final double peviousRemainigBalance;

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

  @JsonKey(name: "paidLoan")
  final double paidLoan;

  @JsonKey(name: 'givenLoan')
  final double givenLoan;

  MonthlyBalanceSummary({
    required this.totalDeposit,
    required this.totalShares,
    required this.totalLoanInterest,
    required this.totalPenalty,
    required this.otherDeposit,
    required this.totalExpenditures,
    required this.remainingLoan,
    required this.givenLoan,
    required this.peviousRemainigBalance,
    required this.paidLoan,
  });

  factory MonthlyBalanceSummary.fromSqlResults(Map<String, dynamic> json) {
    return MonthlyBalanceSummary(
      totalDeposit: (json['totalDeposit'] as num?)?.toDouble() ?? 0.0,
      totalShares: (json['totalShares'] as num?)?.toDouble() ?? 0.0,
      totalLoanInterest: (json['TotalLoanInterest'] as num?)?.toDouble() ?? 0.0,
      totalPenalty: (json['TotalPenalty'] as num?)?.toDouble() ?? 0.0,
      otherDeposit: (json['OtherDeposit'] as num?)?.toDouble() ?? 0.0,
      totalExpenditures: (json['totalExpenditures'] as num?)?.toDouble() ?? 0.0,
      remainingLoan: (json['remainingLoan'] as num?)?.toDouble() ?? 0.0,
      givenLoan: (json['givenLoan'] as num?)?.toDouble() ?? 0.0,
      peviousRemainigBalance:
          (json['previousRemainingBalance'] as num?)?.toDouble() ?? 0.0,
      paidLoan: (json['paidLoan'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => _$MonthlyBalanceSummaryToJson(this);
}
