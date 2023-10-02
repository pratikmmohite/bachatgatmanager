import 'package:bachat_gat/common/utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'com_fields.g.dart';

@JsonSerializable()
class ComFields {
  late String id;
  late DateTime sysCreated;
  late DateTime sysUpdated;
  ComFields() {
    id = Utils.getUUID();
    sysCreated = sysUpdated = DateTime.now();
  }
  factory ComFields.fromJson(Map<String, dynamic> json) =>
      _$ComFieldsFromJson(json);

  Map<String, dynamic> toJson() => _$ComFieldsToJson(this);
}
