import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subsection_2.g.dart';

@JsonSerializable()
@HiveType(typeId: 7)
class Subsection2 {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String code;
  @HiveField(3)
  final String sort;

  Subsection2({this.id, this.title, this.code, this.sort});

  factory Subsection2.fromJson(Map<String, dynamic> json) =>
      _$Subsection2FromJson(json);

  Map<String, dynamic> toJson() => _$Subsection2ToJson(this);
}
