import 'package:json_annotation/json_annotation.dart';

part 'group_total.g.dart';

@JsonSerializable()
class GroupTotal {
  double balance = 0;
  double totalSaving = 0;
  double memberCount = 0;
  double perMemberShare = 0;
  GroupTotal();

  factory GroupTotal.fromJson(Map<String, dynamic> json) =>
      _$GroupTotalFromJson(json);

  Map<String, dynamic> toJson() => _$GroupTotalToJson(this);
}
