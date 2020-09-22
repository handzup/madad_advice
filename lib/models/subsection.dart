import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subsection.g.dart';

@JsonSerializable()
@HiveType(typeId: 6)
class Subsection {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;

  @HiveField(2)
  final String path;
  @HiveField(3)
  final String sort;

  Subsection({this.id, this.title, this.path, this.sort});

  factory Subsection.fromJson(Map<String, dynamic> json) =>
      _$SubsectionFromJson(json);

  Map<String, dynamic> toJson() => _$SubsectionToJson(this);
}
