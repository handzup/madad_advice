// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sphere.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SphereModelAdapter extends TypeAdapter<SphereModel> {
  @override
  final int typeId = 2;

  @override
  SphereModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SphereModel(
      path: fields[0] as String,
      type: fields[1] as String,
      title: fields[2] as String,
      elements: (fields[3] as List)?.cast<SphereArticle>(),
      lastFetch: fields[4] as DateTime,
      sections: (fields[5] as List)?.cast<Subsection2>(),
    );
  }

  @override
  void write(BinaryWriter writer, SphereModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.path)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.elements)
      ..writeByte(4)
      ..write(obj.lastFetch)
      ..writeByte(5)
      ..write(obj.sections);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SphereModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SphereModel _$SphereModelFromJson(Map<String, dynamic> json) {
  return SphereModel(
    path: (json['query'] is List) ? null : json['query']['path'] as String,
    type: json['type'] as String,
    title: json['title'] as String,
    elements: (json['elements'] as List)
        ?.map((e) => e == null
            ? null
            : SphereArticle.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    lastFetch: json['lastFetch'] == null
        ? null
        : DateTime.parse(json['lastFetch'] as String),
    sections: (json['sections'] as List)
        ?.map((e) =>
            e == null ? null : Subsection2.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$SphereModelToJson(SphereModel instance) =>
    <String, dynamic>{
      'path': instance.path,
      'type': instance.type,
      'title': instance.title,
      'elements': instance.elements,
      'lastFetch': instance.lastFetch?.toIso8601String(),
      'sections': instance.sections,
    };
