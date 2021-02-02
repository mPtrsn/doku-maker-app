// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RoomWarning.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomWarning _$RoomWarningFromJson(Map<String, dynamic> json) {
  return RoomWarning(
    id: json['id'] as String,
    level: json['level'] as String,
    text: json['text'] as String,
    author: json['author'] as String,
    creationDate: json['creationDate'] == null
        ? null
        : DateTime.parse(json['creationDate'] as String),
    validFrom: json['validFrom'] == null
        ? null
        : DateTime.parse(json['validFrom'] as String),
    validTo: json['validTo'] == null
        ? null
        : DateTime.parse(json['validTo'] as String),
  );
}

Map<String, dynamic> _$RoomWarningToJson(RoomWarning instance) =>
    <String, dynamic>{
      'id': instance.id,
      'level': instance.level,
      'text': instance.text,
      'author': instance.author,
      'creationDate': instance.creationDate?.toIso8601String(),
      'validFrom': instance.validFrom?.toIso8601String(),
      'validTo': instance.validTo?.toIso8601String(),
    };
