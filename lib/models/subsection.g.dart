// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subsection.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubsectionAdapter extends TypeAdapter<Subsection> {
  @override
  final int typeId = 6;

  @override
  Subsection read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Subsection(
      id: fields[0] as String,
      title: fields[1] as String,
      path: fields[2] as String,
      sort: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Subsection obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.path)
      ..writeByte(3)
      ..write(obj.sort);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubsectionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subsection _$SubsectionFromJson(Map<String, dynamic> json) {
  return Subsection(
    id: json['id'] as String,
    title: json['title'] as String,
    path: json['path'] as String,
    sort: json['sort'] as String,
  );
}

Map<String, dynamic> _$SubsectionToJson(Subsection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'path': instance.path,
      'sort': instance.sort,
    };
