import 'package:json_annotation/json_annotation.dart';

part 'group_summary_filter.g.dart';

@JsonSerializable()
class GroupSummaryFilter {
  String groupId = "";
  DateTime edt = DateTime(2030);
  DateTime sdt = DateTime(2010);
  String dateMode = "trxPeriod";
  String type = "monthly";
  GroupSummaryFilter([this.groupId = ""]);

  factory GroupSummaryFilter.fromJson(Map<String, dynamic> json) =>
      _$GroupSummaryFilterFromJson(json);

  Map<String, dynamic> toJson() => _$GroupSummaryFilterToJson(this);
}
