// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MenuAdapter extends TypeAdapter<Menu> {
  @override
  final int typeId = 8;

  @override
  Menu read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Menu(
      bgColor: fields[7] as Color,
      textColor: fields[6] as Color,
      title: fields[0] as String,
      icon: fields[2] as String,
      path: fields[1] as String,
      sort: fields[3] as int,
      submenu: (fields[4] as List)?.cast<Menu>(),
      type: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Menu obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.path)
      ..writeByte(2)
      ..write(obj.icon)
      ..writeByte(3)
      ..write(obj.sort)
      ..writeByte(4)
      ..write(obj.submenu)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.textColor)
      ..writeByte(7)
      ..write(obj.bgColor);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Menu _$MenuFromJson(Map<String, dynamic> json) {
  return Menu(
    bgColor: Menu._toColor(json['bg_color'] as String),
    textColor: Menu._toColor(json['text_color'] as String),
    title: json['title'] as String,
    icon: json['icon'] as String,
    path: json['path'] as String,
    sort: Menu._toInt(json['sort']),
    submenu: (json['submenu'] as List)
        ?.map(
            (e) => e == null ? null : Menu.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    type: Menu._toString(json['type']),
  );
}

Map<String, dynamic> _$MenuToJson(Menu instance) => <String, dynamic>{
      'title': instance.title,
      'path': instance.path,
      'icon': instance.icon,
      'sort': instance.sort,
      'submenu': instance.submenu,
      'type': instance.type,
      'text_color': Menu._toString(instance.textColor),
      'bg_color': Menu._toString(instance.bgColor),
    };
