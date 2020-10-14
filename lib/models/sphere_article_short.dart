import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sphere_article_short.g.dart';

@HiveType(typeId: 9)
@JsonSerializable()
class SphereArticleShort {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String code;
  @HiveField(2)
  final String section_id;
  @HiveField(3)
  final String title;
  @HiveField(4)
  final String detail_text;
  @HiveField(5)
  final String sort;
  @HiveField(6)
  final String type;

  SphereArticleShort({
    this.id,
    this.code,
    this.sort,
    this.type,
    this.section_id,
    this.title,
    this.detail_text,
  });

  factory SphereArticleShort.fromJson(Map<String, dynamic> json) =>
      _$SphereArticleShortFromJson(json);

  Map<String, dynamic> toJson() => _$SphereArticleShortToJson(this);
}
