// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Room _$RoomFromJson(Map<String, dynamic> json) {
  return Room(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    imageURL: json['imageURL'] as String,
    entries: (json['entries'] as List)
        ?.map((e) =>
            e == null ? null : RoomEntry.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    warnings: (json['warnings'] as List)
        ?.map((e) =>
            e == null ? null : RoomWarning.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    owner: json['owner'] as String,
    collaborators:
        (json['collaborators'] as List)?.map((e) => e as String)?.toList(),
    creationDate: json['creationDate'] == null
        ? null
        : DateTime.parse(json['creationDate'] as String),
    disabled: json['disabled'] as bool,
  );
}

Map<String, dynamic> _$RoomToJson(Room instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'imageURL': instance.imageURL,
      'entries': instance.entries?.map((e) => e?.toJson())?.toList(),
      'warnings': instance.warnings?.map((e) => e?.toJson())?.toList(),
      'owner': instance.owner,
      'collaborators': instance.collaborators,
      'creationDate': instance.creationDate?.toIso8601String(),
      'disabled': instance.disabled,
    };
