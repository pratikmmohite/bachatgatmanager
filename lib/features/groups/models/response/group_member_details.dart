/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
import 'package:json_annotation/json_annotation.dart';

part 'group_member_details.g.dart';

@JsonSerializable()
class GroupMemberDetails {
  String name = "";
  String groupId = "";
  String memberId = "";
  double balance = 0;
  double paidShareAmount = 0;
  double paidLoanAmount = 0;
  double paidLateFee = 0;
  double pendingLoanAmount = 0;
  double paidLoanInterestAmount = 0;
  double lendLoan = 0;
  double paidOtherAmount = 0;

  GroupMemberDetails();

  factory GroupMemberDetails.fromJson(Map<String, dynamic> json) =>
      _$GroupMemberDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$GroupMemberDetailsToJson(this);

  double calculateTotalPaid() {
    return paidLoanAmount +
        paidLoanInterestAmount +
        paidShareAmount +
        paidLateFee +
        paidOtherAmount;
  }
}
