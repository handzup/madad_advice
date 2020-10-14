import 'package:json_annotation/json_annotation.dart';

part 'scope.g.dart';

@JsonSerializable()
class Scope {
  final String url;
  final String name;

  Scope(this.url, this.name);

    factory Scope.fromJson(Map<String, dynamic> json) =>
      _$ScopeFromJson(json);

  Map<String, dynamic> toJson() => _$ScopeToJson(this);
}
