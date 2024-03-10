// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_balance_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupBalanceSummary _$GroupBalanceSummaryFromJson(Map<String, dynamic> json) =>
    GroupBalanceSummary(
      totalDeposit: (json['totalDeposit'] as num).toDouble(),
      totalShares: (json['totalShares'] as num).toDouble(),
      totalLoanInterest: (json['TotalLoanInterest'] as num).toDouble(),
      totalPenalty: (json['TotalPenalty'] as num).toDouble(),
      otherDeposit: (json['OtherDeposit'] as num).toDouble(),
      totalExpenditures: (json['totalExpenditures'] as num).toDouble(),
      remainingLoan: (json['remainingLoan'] as num).toDouble(),
    );

Map<String, dynamic> _$GroupBalanceSummaryToJson(
        GroupBalanceSummary instance) =>
    <String, dynamic>{
      'totalDeposit': instance.totalDeposit,
      'totalShares': instance.totalShares,
      'TotalLoanInterest': instance.totalLoanInterest,
      'TotalPenalty': instance.totalPenalty,
      'OtherDeposit': instance.otherDeposit,
      'totalExpenditures': instance.totalExpenditures,
      'remainingLoan': instance.remainingLoan,
    };
