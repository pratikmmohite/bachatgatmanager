/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
import 'package:json_annotation/json_annotation.dart';

import './com_fields.dart';

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

  double installmentAmtPerMonth = 0;
  double loanInterestPercentPerMonth = 0;
  double lateFeePerDay = 0;

  Group(
      {required this.name,
      required this.sdt,
      required this.edt,
      required this.accountOpeningDate,
      this.address,
      this.bankName,
      this.accountNo,
      this.ifscCode,
      this.installmentAmtPerMonth = 0,
      this.loanInterestPercentPerMonth = 0,
      this.lateFeePerDay = 0})
      : super();

  Group.withDefault() {
    name = "";
    var dt = DateTime.now();
    sdt = DateTime(dt.year, dt.month, 1);
    edt = DateTime(dt.year + 1, dt.month, 0);
    accountOpeningDate = sdt;
    lateFeePerDay = 0;
    installmentAmtPerMonth = 100;
    loanInterestPercentPerMonth = 0;
  }
  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GroupToJson(this);
}
