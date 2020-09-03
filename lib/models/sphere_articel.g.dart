// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sphere_articel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SphereArticleAdapter extends TypeAdapter<SphereArticle> {
  @override
  final int typeId = 3;

  @override
  SphereArticle read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SphereArticle(
      id: fields[0] as String,
      code: fields[1] as String,
      datetime: fields[2] as String,
      timestamp: fields[3] as String,
      created_by_id: fields[4] as String,
      created_by_name: fields[5] as String,
      section_id: fields[6] as String,
      ACTIVE: fields[7] as String,
      SORT: fields[8] as String,
      title: fields[9] as String,
      preview_picture: fields[10] as String,
      preview_text: fields[11] as String,
      detail_text: fields[12] as String,
      show_counter: fields[13] as String,
      normativnye_akty: fields[14] as String,
      prikreplennye_fayly: (fields[15] as List)?.cast<PinnedFile>(),
      scopes: (fields[16] as Map)?.cast<String, String>(),
      forum_topic_id: fields[17] as String,
      forum_message_cnt: fields[18] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SphereArticle obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.code)
      ..writeByte(2)
      ..write(obj.datetime)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.created_by_id)
      ..writeByte(5)
      ..write(obj.created_by_name)
      ..writeByte(6)
      ..write(obj.section_id)
      ..writeByte(7)
      ..write(obj.ACTIVE)
      ..writeByte(8)
      ..write(obj.SORT)
      ..writeByte(9)
      ..write(obj.title)
      ..writeByte(10)
      ..write(obj.preview_picture)
      ..writeByte(11)
      ..write(obj.preview_text)
      ..writeByte(12)
      ..write(obj.detail_text)
      ..writeByte(13)
      ..write(obj.show_counter)
      ..writeByte(14)
      ..write(obj.normativnye_akty)
      ..writeByte(15)
      ..write(obj.prikreplennye_fayly)
      ..writeByte(16)
      ..write(obj.scopes)
      ..writeByte(17)
      ..write(obj.forum_topic_id)
      ..writeByte(18)
      ..write(obj.forum_message_cnt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SphereArticleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SphereArticle _$SphereArticleFromJson(Map<String, dynamic> json) {
  return SphereArticle(
    id: json['id'] as String,
    code: json['code'] as String,
    datetime: json['datetime'] as String,
    timestamp: json['timestamp'] as String,
    created_by_id: json['created_by_id'] as String,
    created_by_name: json['created_by_name'] as String,
    section_id: json['section_id'] as String,
    ACTIVE: json['ACTIVE'] as String,
    SORT: json['SORT'] as String,
    title: json['title'] as String,
    preview_picture: json['preview_picture'] as String,
    preview_text: json['preview_text'] as String,
    detail_text: json['detail_text'] as String,
    show_counter: json['show_counter'] as String,
    normativnye_akty: (json['normativnye_akty'] is String)
        ? null
        : ((json['normativnye_akty'] is List)
            ? null
            : json['normativnye_akty']['TEXT'] as String),
    prikreplennye_fayly: (json['prikreplennye_fayly'] as List)
            ?.map((e) => e == null
                ? null
                : PinnedFile.fromJson(e as Map<String, dynamic>))
            ?.toList()
            ?.isEmpty
        ? null
        : (json['prikreplennye_fayly'] as List)
            ?.map((e) => e == null
                ? null
                : PinnedFile.fromJson(e as Map<String, dynamic>))
            ?.toList(),
    scopes: (json['scopes'] is List)
        ? null
        : (json['scopes'] as Map<String, dynamic>)?.map(
            (k, e) => MapEntry(k, e as String),
          ),
    forum_topic_id: json['forum_topic_id'] as String,
    forum_message_cnt: json['forum_message_cnt'].toString(),
  );
}

Map<String, dynamic> _$SphereArticleToJson(SphereArticle instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'datetime': instance.datetime,
      'timestamp': instance.timestamp,
      'created_by_id': instance.created_by_id,
      'created_by_name': instance.created_by_name,
      'section_id': instance.section_id,
      'ACTIVE': instance.ACTIVE,
      'SORT': instance.SORT,
      'title': instance.title,
      'preview_picture': instance.preview_picture,
      'preview_text': instance.preview_text,
      'detail_text': instance.detail_text,
      'show_counter': instance.show_counter,
      'normativnye_akty': instance.normativnye_akty,
      'prikreplennye_fayly': instance.prikreplennye_fayly,
      'scopes': instance.scopes,
      'forum_topic_id': instance.forum_topic_id,
      'forum_message_cnt': instance.forum_message_cnt,
    };
