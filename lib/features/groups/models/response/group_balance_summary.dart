/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
import 'package:json_annotation/json_annotation.dart';

part 'group_balance_summary.g.dart';

@JsonSerializable()
class GroupBalanceSummary {
  @JsonKey(name: 'previousRemaining')
  final double previousRemaining;

  @JsonKey(name: 'paidLoan')
  final double paidLoan;

  @JsonKey(name: 'deposit')
  final double deposit;

  @JsonKey(name: 'shares')
  final double shares;

  @JsonKey(name: 'loanInterest')
  final double loanInterest;

  @JsonKey(name: 'penalty')
  final double penalty;

  @JsonKey(name: 'otherDeposit')
  final double otherDeposit;

  @JsonKey(name: 'expenditures')
  final double expenditures;

  @JsonKey(name: 'givenLoan')
  final double givenLoan;

  @JsonKey(name: 'remainingLoan')
  final double remainingLoan;

  GroupBalanceSummary(
      {required this.previousRemaining,
      required this.paidLoan,
      required this.deposit,
      required this.shares,
      required this.loanInterest,
      required this.penalty,
      required this.otherDeposit,
      required this.expenditures,
      required this.givenLoan,
      required this.remainingLoan});

  factory GroupBalanceSummary.fromSqlResults(Map<String, dynamic> json) {
    return GroupBalanceSummary(
      previousRemaining: (json['previousRemaining'] as num?)?.toDouble() ?? 0.0,
      paidLoan: (json['paidLoan'] as num?)?.toDouble() ?? 0.0,
      deposit: (json['deposit'] as num?)?.toDouble() ?? 0.0,
      shares: (json['shares'] as num?)?.toDouble() ?? 0.0,
      loanInterest: (json['loanInterest'] as num?)?.toDouble() ?? 0.0,
      penalty: (json['penalty'] as num?)?.toDouble() ?? 0.0,
      otherDeposit: (json['otherDeposit'] as num?)?.toDouble() ?? 0.0,
      expenditures: (json['expenditures'] as num?)?.toDouble() ?? 0.0,
      givenLoan: (json['givenLoan'] as num?)?.toDouble() ?? 0.0,
      remainingLoan: (json['remainingLoan'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => _$GroupBalanceSummaryToJson(this);
}
