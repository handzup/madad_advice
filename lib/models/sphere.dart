import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import 'sphere_articel.dart';

part 'sphere.g.dart';

@JsonSerializable()
@HiveType(typeId: 2)
class SphereModel {
  @HiveField(0)
  final String path; //вправить в ручную g файл!
  @HiveField(1)
  final String type;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final List<SphereArticle> elements;
  @HiveField(4)
  final DateTime lastFetch;

  SphereModel({
    this.path,
    this.type,
    this.title,
    this.elements,
    this.lastFetch,
  });

  factory SphereModel.fromJson(Map<String, dynamic> json) =>
      _$SphereModelFromJson(json);

  Map<String, dynamic> toJson() => _$SphereModelToJson(this);
}
