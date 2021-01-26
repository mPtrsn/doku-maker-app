// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RoomEntry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomEntry _$RoomEntryFromJson(Map<String, dynamic> json) {
  return RoomEntry(
    id: json['id'] as String,
    title: json['title'] as String,
    text: json['text'] as String,
    tags: (json['tags'] as List)?.map((e) => e as String)?.toList(),
    creationDate: json['creationDate'] == null
        ? null
        : DateTime.parse(json['creationDate'] as String),
    attachments: (json['attachments'] as List)
        ?.map((e) => e == null
            ? null
            : RoomEntryAttachment.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    author: json['author'] as String,
  );
}

Map<String, dynamic> _$RoomEntryToJson(RoomEntry instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'text': instance.text,
      'tags': instance.tags,
      'creationDate': instance.creationDate?.toIso8601String(),
      'attachments': instance.attachments?.map((e) => e?.toJson())?.toList(),
      'author': instance.author,
    };
