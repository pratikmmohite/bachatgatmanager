/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
import 'package:json_annotation/json_annotation.dart';

part 'member_balance_filter.g.dart';

@JsonSerializable()
class MemberBalanceFilter {
  String groupId = "";
  String memberId = "";
  String trxPeriod = "";

  MemberBalanceFilter(this.groupId, this.trxPeriod);

  factory MemberBalanceFilter.fromJson(Map<String, dynamic> json) =>
      _$MemberBalanceFilterFromJson(json);

  Map<String, dynamic> toJson() => _$MemberBalanceFilterToJson(this);
}
