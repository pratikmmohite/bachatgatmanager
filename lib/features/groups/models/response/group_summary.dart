/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
import 'package:json_annotation/json_annotation.dart';

part 'group_summary.g.dart';

@JsonSerializable()
class GroupSummary {
  String groupId = "";
  String trxPeriod = "";
  String trxType = "";
  double totalCr = 0;
  double totalDr = 0;

  GroupSummary();

  factory GroupSummary.fromJson(Map<String, dynamic> json) =>
      _$GroupSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$GroupSummaryToJson(this);
}
