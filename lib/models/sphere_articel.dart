import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'pinned_file.dart';
part 'sphere_articel.g.dart';

@HiveType(typeId: 3)
@JsonSerializable()
class SphereArticle {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String code;
  @HiveField(2)
  final String datetime;
  @HiveField(3)
  final String timestamp;
  @HiveField(4)
  final String created_by_id;
  @HiveField(5)
  final String created_by_name;
  @HiveField(6)
  final String section_id;
  @HiveField(7)
  final String ACTIVE;
  @HiveField(8)
  final String SORT;
  @HiveField(9)
  final String title;
  @HiveField(10)
  final String preview_picture;
  @HiveField(11)
  final String preview_text;
  @HiveField(12)
  final String detail_text;
  @HiveField(13)
  final String show_counter;
  @HiveField(14)
  @JsonKey(defaultValue: null)
  final String normativnye_akty; //вправить в ручную g файл!
  @HiveField(15)
  @JsonKey(defaultValue: null)
  final List<PinnedFile> prikreplennye_fayly;
  @HiveField(16)
  @JsonKey(defaultValue: null)
  final Map<String, String> scopes;
  @HiveField(17)
  final String forum_topic_id;
  @HiveField(18)
  final String forum_message_cnt;

  SphereArticle(
      {this.id,
      this.code,
      this.datetime,
      this.timestamp,
      this.created_by_id,
      this.created_by_name,
      this.section_id,
      this.ACTIVE,
      this.SORT,
      this.title,
      this.preview_picture,
      this.preview_text,
      this.detail_text,
      this.show_counter,
      this.normativnye_akty,
      this.prikreplennye_fayly,
      this.scopes,
      this.forum_topic_id,
      this.forum_message_cnt});

  factory SphereArticle.fromJson(Map<String, dynamic> json) =>
      _$SphereArticleFromJson(json);

  Map<String, dynamic> toJson() => _$SphereArticleToJson(this);
}
