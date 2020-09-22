// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subsection_2.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class Subsection2Adapter extends TypeAdapter<Subsection2> {
  @override
  final int typeId = 7;

  @override
  Subsection2 read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Subsection2(
      id: fields[0] as String,
      title: fields[1] as String,
      code: fields[2] as String,
      sort: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Subsection2 obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.code)
      ..writeByte(3)
      ..write(obj.sort);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Subsection2Adapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subsection2 _$Subsection2FromJson(Map<String, dynamic> json) {
  return Subsection2(
    id: json['id'] as String,
    title: json['title'] as String,
    code: json['code'] as String,
    sort: json['sort'] as String,
  );
}

Map<String, dynamic> _$Subsection2ToJson(Subsection2 instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'code': instance.code,
      'sort': instance.sort,
    };
