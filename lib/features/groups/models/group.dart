import 'package:json_annotation/json_annotation.dart';

import 'com_fields.dart';

part 'group.g.dart';

@JsonSerializable()
class Group extends ComFields {
  late String name;
  late DateTime sdt;
  late DateTime edt;
  late DateTime accountOpeningDate;
  String? address;
  String? bankName;
  String? accountNo;
  String? ifscCode;

  Group({
    required this.name,
    required this.sdt,
    required this.edt,
    required this.accountOpeningDate,
    this.address,
    this.bankName,
    this.accountNo,
    this.ifscCode,
  }) : super();

  Group.withDefault() {
    name = "";
    var dt = DateTime.now();
    sdt = DateTime(dt.year, dt.month, 1);
    edt = DateTime(dt.year + 1, dt.month, 0);
    accountOpeningDate = sdt;
  }
  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GroupToJson(this);
}
