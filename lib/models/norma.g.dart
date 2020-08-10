// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'norma.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NormaAdapter extends TypeAdapter<Norma> {
  @override
  final int typeId = 5;

  @override
  Norma read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Norma(
      text: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Norma obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.text);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NormaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Norma _$NormaFromJson(Map<String, dynamic> json) {
  return Norma(
    text: json['TEXT'] as String,
  );
}

Map<String, dynamic> _$NormaToJson(Norma instance) => <String, dynamic>{
      'TEXT': instance.text,
    };
