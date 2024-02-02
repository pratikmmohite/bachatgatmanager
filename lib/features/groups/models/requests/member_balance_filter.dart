import 'package:json_annotation/json_annotation.dart';

part 'member_balance_filter.g.dart';

@JsonSerializable()
class MemberBalanceFilter {
  String groupId = "";
  String trxPeriod = "";

  MemberBalanceFilter(this.groupId, this.trxPeriod);

  factory MemberBalanceFilter.fromJson(Map<String, dynamic> json) =>
      _$MemberBalanceFilterFromJson(json);

  Map<String, dynamic> toJson() => _$MemberBalanceFilterToJson(this);
}
