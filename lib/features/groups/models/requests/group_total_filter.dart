import 'package:json_annotation/json_annotation.dart';

part 'group_total_filter.g.dart';

@JsonSerializable()
class GroupTotalFilter {
  String groupId = "";
  GroupTotalFilter(this.groupId);

  factory GroupTotalFilter.fromJson(Map<String, dynamic> json) =>
      _$GroupTotalFilterFromJson(json);

  Map<String, dynamic> toJson() => _$GroupTotalFilterToJson(this);
}
