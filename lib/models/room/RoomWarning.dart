import 'package:json_annotation/json_annotation.dart';

part 'RoomWarning.g.dart';

@JsonSerializable()
class RoomWarning {
  String id;
  String level;
  String text;
  String author;
  DateTime creationDate;

  RoomWarning({
    this.id,
    this.level,
    this.text,
    this.author,
    this.creationDate,
  });

  factory RoomWarning.fromJson(Map<String, dynamic> json) =>
      _$RoomWarningFromJson(json);

  Map<String, dynamic> toJson() => _$RoomWarningToJson(this);
}
