/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_total.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupTotal _$GroupTotalFromJson(Map<String, dynamic> json) => GroupTotal()
  ..balance = (json['balance'] as num).toDouble()
  ..totalSaving = (json['totalSaving'] as num).toDouble()
  ..memberCount = (json['memberCount'] as num).toDouble()
  ..perMemberShare = (json['perMemberShare'] as num).toDouble();

Map<String, dynamic> _$GroupTotalToJson(GroupTotal instance) =>
    <String, dynamic>{
      'balance': instance.balance,
      'totalSaving': instance.totalSaving,
      'memberCount': instance.memberCount,
      'perMemberShare': instance.perMemberShare,
    };
