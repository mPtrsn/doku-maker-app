import 'package:json_annotation/json_annotation.dart';

import 'RoomEntry.dart';
import 'RoomWarning.dart';

part 'Room.g.dart';

@JsonSerializable(explicitToJson: true)
class Room {
  String id;
  String title;
  String description;
  String imageURL;
  List<RoomEntry> entries;
  List<RoomWarning> warnings;
  List<String> owners;
  List<String> collaborators;
  DateTime creationDate;
  bool disabled;

  Room({
    this.id,
    this.title,
    this.description,
    this.imageURL,
    this.entries,
    this.warnings,
    this.owners,
    this.collaborators,
    this.creationDate,
    this.disabled,
  });

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);

  Map<String, dynamic> toJson() => _$RoomToJson(this);
}
