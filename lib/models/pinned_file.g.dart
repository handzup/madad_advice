// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pinned_file.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PinnedFileAdapter extends TypeAdapter<PinnedFile> {
  @override
  final int typeId = 4;

  @override
  PinnedFile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PinnedFile(
      path: fields[0] as String,
      size: fields[1] as String,
      type: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PinnedFile obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.path)
      ..writeByte(1)
      ..write(obj.size)
      ..writeByte(2)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PinnedFileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PinnedFile _$PinnedFileFromJson(Map<String, dynamic> json) {
  return PinnedFile(
    path: json['path'] as String,
    size: json['size'] as String,
    type: json['type'] as String,
  );
}

Map<String, dynamic> _$PinnedFileToJson(PinnedFile instance) =>
    <String, dynamic>{
      'path': instance.path,
      'size': instance.size,
      'type': instance.type,
    };
