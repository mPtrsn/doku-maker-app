import 'package:json_annotation/json_annotation.dart';

part 'RoomEntryAttachment.g.dart';

@JsonSerializable()
class RoomEntryAttachment {
  String type;
  String content;

  RoomEntryAttachment({this.type, this.content});

  factory RoomEntryAttachment.fromJson(Map<String, dynamic> json) =>
      _$RoomEntryAttachmentFromJson(json);

  Map<String, dynamic> toJson() => _$RoomEntryAttachmentToJson(this);
}
