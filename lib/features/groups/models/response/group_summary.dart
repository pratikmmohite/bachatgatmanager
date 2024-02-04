import 'package:json_annotation/json_annotation.dart';

part 'group_summary.g.dart';

@JsonSerializable()
class GroupSummary {
  String groupId = "";
  String trxPeriod = "";
  String trxType = "";
  double totalCr = 0;
  double totalDr = 0;

  GroupSummary();

  factory GroupSummary.fromJson(Map<String, dynamic> json) =>
      _$GroupSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$GroupSummaryToJson(this);
}
