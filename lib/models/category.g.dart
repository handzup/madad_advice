// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MyCategoryAdapter extends TypeAdapter<MyCategory> {
  @override
  final int typeId = 0;

  @override
  MyCategory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MyCategory(
      id: fields[0] as String,
      title: fields[1] as String,
      icon: fields[3] as String,
      path: fields[4] as String,
      sort: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MyCategory obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.icon)
      ..writeByte(4)
      ..write(obj.path)
      ..writeByte(5)
      ..write(obj.sort);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyCategory _$MyCategoryFromJson(Map<String, dynamic> json) {
  return MyCategory(
    id: json['id'] as String,
    title: json['title'] as String,
    icon: json['icon'] as String,
    path: json['path'] as String,
    sort: json['sort'] as String,
  );
}

Map<String, dynamic> _$MyCategoryToJson(MyCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'icon': instance.icon,
      'path': instance.path,
      'sort': instance.sort,
    };
