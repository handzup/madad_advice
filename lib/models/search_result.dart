import 'package:json_annotation/json_annotation.dart';

part 'search_result.g.dart';

@JsonSerializable()
class SearchResult {
  final String id;
  final String iblockid;
  final String code;
  final String title;
  final String preview_text;
  
SearchResult({this.id, this.iblockid, this.code, this.title, this.preview_text}  );
  factory SearchResult.fromJson(Map<String, dynamic> json) =>
      _$SearchResultFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResultToJson(this);
}
