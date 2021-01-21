import 'package:json_annotation/json_annotation.dart';

import 'RoomEntryAttachment.dart';
part 'RoomEntry.g.dart';

@JsonSerializable(explicitToJson: true)
class RoomEntry {
  String id;
  String title;
  String text;
  List<String> tags;
  DateTime creationDate;
  List<RoomEntryAttachment> attachments;

  RoomEntry({
    this.id,
    this.title,
    this.text,
    this.tags,
    this.creationDate,
    this.attachments,
  });

  factory RoomEntry.fromJson(Map<String, dynamic> json) =>
      _$RoomEntryFromJson(json);

  Map<String, dynamic> toJson() => _$RoomEntryToJson(this);
}
