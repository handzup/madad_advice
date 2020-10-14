import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'norma.g.dart';

@HiveType(typeId: 5)
@JsonSerializable()
class Norma {
 
  @HiveField(0)
  @JsonKey(name: 'TEXT')
  final String text;

  Norma({this.text});
  factory Norma.fromJson(Map<String, dynamic> json) => _$NormaFromJson(json);

  Map<String, dynamic> toJson() => _$NormaToJson(this);
}
