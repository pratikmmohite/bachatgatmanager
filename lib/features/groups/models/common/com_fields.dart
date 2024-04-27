/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
import 'package:bachat_gat/common/utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'com_fields.g.dart';

@JsonSerializable()
class ComFields {
  late String id;
  late DateTime sysCreated;
  late DateTime sysUpdated;
  ComFields() {
    id = AppUtils.getUUID();
    sysCreated = sysUpdated = DateTime.now();
  }
  factory ComFields.fromJson(Map<String, dynamic> json) =>
      _$ComFieldsFromJson(json);

  Map<String, dynamic> toJson() => _$ComFieldsToJson(this);
}
