import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'section.g.dart';

@JsonSerializable()
@HiveType(typeId:1)
class Section {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String icon;
  @HiveField(3)
  final String path;
  @HiveField(4)
  final String sort;

  Section({this.id, this.title, this.icon, this.path, this.sort});

  factory Section.fromJson(Map<String, dynamic> json) =>
      _$SectionFromJson(json);

  Map<String, dynamic> toJson() => _$SectionToJson(this);
}
