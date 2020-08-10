import 'package:json_annotation/json_annotation.dart';

part 'menu.g.dart';

@JsonSerializable()
class Menu {
  final String title;
  final String path;
  final String icon;
  final int sort; // нужно парснуть в int в ручную
  Menu({
    this.title,
    this.icon,
    this.path,
    this.sort
  });

  factory Menu.fromJson(Map<String, dynamic> json) => _$MenuFromJson(json);

  Map<String, dynamic> toJson() => _$MenuToJson(this);
}
