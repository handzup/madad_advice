// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResult _$SearchResultFromJson(Map<String, dynamic> json) {
  return SearchResult(
    id: json['id'] as String,
    iblockid: json['iblockid'] as String,
    code: json['code'] as String,
    title: json['title'] as String,
    preview_text: json['preview_text'] as String,
  );
}

Map<String, dynamic> _$SearchResultToJson(SearchResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'iblockid': instance.iblockid,
      'code': instance.code,
      'title': instance.title,
      'preview_text': instance.preview_text,
    };
