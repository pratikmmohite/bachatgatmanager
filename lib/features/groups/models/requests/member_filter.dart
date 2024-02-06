import 'package:json_annotation/json_annotation.dart';

part 'member_filter.g.dart';

@JsonSerializable()
class MemberFilter {
  String groupId = "";

  MemberFilter(this.groupId);

  factory MemberFilter.fromJson(Map<String, dynamic> json) =>
      _$MemberFilterFromJson(json);

  Map<String, dynamic> toJson() => _$MemberFilterToJson(this);
}
