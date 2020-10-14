import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'query.g.dart';

@HiveType(typeId: 6)
@JsonSerializable()
class QueryPath {
  @HiveField(0)
  final String path;

  QueryPath({this.path});
  factory QueryPath.fromJson(Map<String, dynamic> json) => _$QueryPathFromJson(json);

  Map<String, dynamic> toJson() => _$QueryPathToJson(this);
}
