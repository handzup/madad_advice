// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'section.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SectionAdapter extends TypeAdapter<Section> {
  @override
  final int typeId = 1;

  @override
  Section read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Section(
      id: fields[0] as String,
      title: fields[1] as String,
      icon: fields[2] as String,
      path: fields[3] as String,
      sort: fields[4] as String,
      desc: fields[5] as String,
      pic: fields[6] as String,
      subsections: (fields[7] as List)?.cast<Subsection>(),
    );
  }

  @override
  void write(BinaryWriter writer, Section obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.icon)
      ..writeByte(3)
      ..write(obj.path)
      ..writeByte(4)
      ..write(obj.sort)
      ..writeByte(5)
      ..write(obj.desc)
      ..writeByte(6)
      ..write(obj.pic)
      ..writeByte(7)
      ..write(obj.subsections);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SectionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Section _$SectionFromJson(Map<String, dynamic> json) {
  return Section(
    id: json['id'] as String,
    title: json['title'] as String,
    icon: json['icon'] as String,
    path: json['path'] as String,
    sort: json['sort'] as String,
    desc: json['desc'] as String,
    pic: json['pic'] as String,
    subsections: (json['subsections'] as List)
        ?.map((e) =>
            e == null ? null : Subsection.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$SectionToJson(Section instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'icon': instance.icon,
      'path': instance.path,
      'sort': instance.sort,
      'desc': instance.desc,
      'pic': instance.pic,
      'subsections': instance.subsections,
    };
