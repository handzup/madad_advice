// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sphere_article_short.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SphereArticleShortAdapter extends TypeAdapter<SphereArticleShort> {
  @override
  final int typeId = 9;

  @override
  SphereArticleShort read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SphereArticleShort(
      id: fields[0] as String,
      code: fields[1] as String,
      sort: fields[5] as String,
      type: fields[6] as String,
      section_id: fields[2] as String,
      title: fields[3] as String,
      detail_text: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SphereArticleShort obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.code)
      ..writeByte(2)
      ..write(obj.section_id)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.detail_text)
      ..writeByte(5)
      ..write(obj.sort)
      ..writeByte(6)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SphereArticleShortAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SphereArticleShort _$SphereArticleShortFromJson(Map<String, dynamic> json) {
  return SphereArticleShort(
    id: json['id'] as String,
    code: json['code'] as String,
    sort: json['sort'] as String,
    type: json['type'] as String,
    section_id: json['section_id'] as String,
    title: json['title'] as String,
    detail_text: json['detail_text'] as String,
  );
}

Map<String, dynamic> _$SphereArticleShortToJson(SphereArticleShort instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'section_id': instance.section_id,
      'title': instance.title,
      'detail_text': instance.detail_text,
      'sort': instance.sort,
      'type': instance.type,
    };
