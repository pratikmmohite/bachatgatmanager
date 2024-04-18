/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_balance_filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberBalanceFilter _$MemberBalanceFilterFromJson(Map<String, dynamic> json) =>
    MemberBalanceFilter(
      json['groupId'] as String,
      json['trxPeriod'] as String,
    )..memberId = json['memberId'] as String;

Map<String, dynamic> _$MemberBalanceFilterToJson(
        MemberBalanceFilter instance) =>
    <String, dynamic>{
      'groupId': instance.groupId,
      'memberId': instance.memberId,
      'trxPeriod': instance.trxPeriod,
    };
