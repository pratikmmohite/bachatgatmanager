/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'com_fields.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComFields _$ComFieldsFromJson(Map<String, dynamic> json) => ComFields()
  ..id = json['id'] as String
  ..sysCreated = DateTime.parse(json['sysCreated'] as String)
  ..sysUpdated = DateTime.parse(json['sysUpdated'] as String);

Map<String, dynamic> _$ComFieldsToJson(ComFields instance) => <String, dynamic>{
      'id': instance.id,
      'sysCreated': instance.sysCreated.toIso8601String(),
      'sysUpdated': instance.sysUpdated.toIso8601String(),
    };
