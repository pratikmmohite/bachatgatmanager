import 'package:json_annotation/json_annotation.dart';

part 'member_loan_filter.g.dart';

@JsonSerializable()
class MemberLoanFilter {
  String groupId = "";
  String memberId = "";
  String status = "";

  MemberLoanFilter(this.groupId, this.memberId);

  factory MemberLoanFilter.fromJson(Map<String, dynamic> json) =>
      _$MemberLoanFilterFromJson(json);

  Map<String, dynamic> toJson() => _$MemberLoanFilterToJson(this);
}
