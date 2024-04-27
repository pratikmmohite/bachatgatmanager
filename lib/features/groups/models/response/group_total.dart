/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
import 'package:json_annotation/json_annotation.dart';

part 'group_total.g.dart';

@JsonSerializable()
class GroupTotal {
  double balance = 0;
  double totalSaving = 0;
  double memberCount = 0;
  double perMemberShare = 0;
  GroupTotal();

  factory GroupTotal.fromJson(Map<String, dynamic> json) =>
      _$GroupTotalFromJson(json);

  Map<String, dynamic> toJson() => _$GroupTotalToJson(this);
}
