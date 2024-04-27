/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
import 'package:json_annotation/json_annotation.dart';

import 'com_fields.dart';
import 'group.dart';

part 'group_members.g.dart';

@JsonSerializable()
class GroupMember extends ComFields {
  String name = "";
  String mobileNo = "";
  String groupId = "";
  DateTime joiningDate = DateTime(2022, 01, 01);
  String? aadharNo = "";
  String? panNo = "";
  double balance = 0;

  GroupMember({
    required this.name,
    required this.mobileNo,
    required this.groupId,
    required this.joiningDate,
    this.balance = 0,
    this.aadharNo,
    this.panNo,
  });

  GroupMember.withDefault(Group group) {
    groupId = group.id;
    joiningDate = group.sdt;
    name = "";
    mobileNo = "";
    aadharNo = "";
    panNo = "";
    balance = 0;
  }

  factory GroupMember.fromJson(Map<String, dynamic> json) =>
      _$GroupMemberFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GroupMemberToJson(this);
}
