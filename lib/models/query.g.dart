// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QueryPathAdapter extends TypeAdapter<QueryPath> {
  @override
  final int typeId = 6;

  @override
  QueryPath read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QueryPath(
      path: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, QueryPath obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.path);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QueryPathAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryPath _$QueryPathFromJson(Map<String, dynamic> json) {
  return QueryPath(
    path: json['path'] as String,
  );
}

Map<String, dynamic> _$QueryPathToJson(QueryPath instance) => <String, dynamic>{
      'path': instance.path,
    };
