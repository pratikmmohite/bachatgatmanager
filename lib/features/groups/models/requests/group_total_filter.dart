/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
import 'package:json_annotation/json_annotation.dart';

part 'group_total_filter.g.dart';

@JsonSerializable()
class GroupTotalFilter {
  String groupId = "";
  GroupTotalFilter(this.groupId);

  factory GroupTotalFilter.fromJson(Map<String, dynamic> json) =>
      _$GroupTotalFilterFromJson(json);

  Map<String, dynamic> toJson() => _$GroupTotalFilterToJson(this);
}
