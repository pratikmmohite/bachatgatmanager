/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_balance_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MonthlyBalanceSummary _$MonthlyBalanceSummaryFromJson(
        Map<String, dynamic> json) =>
    MonthlyBalanceSummary(
      totalDeposit: (json['totalDeposit'] as num).toDouble(),
      totalShares: (json['totalShares'] as num).toDouble(),
      totalLoanInterest: (json['TotalLoanInterest'] as num).toDouble(),
      totalPenalty: (json['TotalPenalty'] as num).toDouble(),
      otherDeposit: (json['OtherDeposit'] as num).toDouble(),
      totalExpenditures: (json['totalExpenditures'] as num).toDouble(),
      remainingLoan: (json['remainingLoan'] as num).toDouble(),
      givenLoan: (json['givenLoan'] as num).toDouble(),
      peviousRemainigBalance: (json['peviousRemainig'] as num).toDouble(),
      paidLoan: (json['paidLoan'] as num).toDouble(),
    );

Map<String, dynamic> _$MonthlyBalanceSummaryToJson(
        MonthlyBalanceSummary instance) =>
    <String, dynamic>{
      'peviousRemainig': instance.peviousRemainigBalance,
      'totalDeposit': instance.totalDeposit,
      'totalShares': instance.totalShares,
      'TotalLoanInterest': instance.totalLoanInterest,
      'TotalPenalty': instance.totalPenalty,
      'OtherDeposit': instance.otherDeposit,
      'totalExpenditures': instance.totalExpenditures,
      'remainingLoan': instance.remainingLoan,
      'paidLoan': instance.paidLoan,
      'givenLoan': instance.givenLoan,
    };
