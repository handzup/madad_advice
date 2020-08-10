import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable()
@HiveType(typeId:0)
class MyCategory {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(3)
  final String icon;
  @HiveField(4)
  final String path;
  @HiveField(5)
  final String sort;

  MyCategory({this.id, this.title, this.icon, this.path, this.sort});

  factory MyCategory.fromJson(Map<String, dynamic> json) =>
      _$MyCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$MyCategoryToJson(this);
}
