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
  );
}

Map<String, dynamic> _$RoomWarningToJson(RoomWarning instance) =>
    <String, dynamic>{
      'id': instance.id,
      'level': instance.level,
      'text': instance.text,
    };
