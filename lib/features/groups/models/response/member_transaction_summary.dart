/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
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
  final double sharesGivenByGroup;

  MemberTransactionSummary({
    required this.name,
    required this.totalSharesDeposit,
    required this.totalLoanInterest,
    required this.totalPenalty,
    required this.otherDeposit,
    required this.loanTakenTillDate,
    required this.loanReturn,
    required this.sharesGivenByGroup,
  });

  factory MemberTransactionSummary.fromJson(Map<String, dynamic> json) {
    return MemberTransactionSummary(
      name: json['name'],
      totalSharesDeposit: (json['TotalSharesDeposit'] ?? 0).toDouble(),
      totalLoanInterest: (json['TotalLoanInterest'] ?? 0).toDouble(),
      totalPenalty: (json['TotalPenalty'] ?? 0).toDouble(),
      otherDeposit: (json['OtherDeposit'] ?? 0).toDouble(),
      loanTakenTillDate: (json['LoanTakenTillDate'] ?? 0).toDouble(),
      loanReturn: (json['LoanReturn'] ?? 0).toDouble(),
      sharesGivenByGroup: (json['SharesGivenByGroup'] ?? 0).toDouble(),
    );
  }
  @override
  Map<String, dynamic> toJson() => _$MemberTransactionSummaryToJson(this);
}
