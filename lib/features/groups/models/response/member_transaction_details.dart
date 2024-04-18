/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
import 'package:json_annotation/json_annotation.dart';

part 'member_transaction_details.g.dart';

@JsonSerializable()
class MemberTransactionDetails {
  String? memberId;
  String? trxPeriod;
  double? paidShares;
  double? loanTaken;
  double? paidInterest;
  double? paidLoan;
  double? remainingLoan;
  double? paidLateFee;
  double? paidOtherAmount;

  MemberTransactionDetails({
    this.memberId,
    this.trxPeriod,
    this.paidShares,
    this.loanTaken,
    this.paidInterest,
    this.paidLoan,
    this.remainingLoan,
    this.paidLateFee,
    this.paidOtherAmount,
  });

  factory MemberTransactionDetails.fromJson(Map<String, dynamic> json) {
    return MemberTransactionDetails(
      memberId: json['memberId'] as String?,
      trxPeriod: json['trxPeriod'] as String?,
      paidShares: (json['Paid_Shares'] as num?)?.toDouble(),
      loanTaken: (json['Lend_Loan'] as num?)?.toDouble(),
      paidInterest: (json['Paid_Interest'] as num?)?.toDouble(),
      paidLoan: (json['Paid_Loan'] as num?)?.toDouble(),
      remainingLoan: (json['Remaining_Loan'] as num?)?.toDouble(),
      paidLateFee: (json['Paid_LateFee'] as num?)?.toDouble(),
      paidOtherAmount: (json['Others'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => _$MemberTransactionDetailsToJson(this);
}
