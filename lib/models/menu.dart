import 'package:json_annotation/json_annotation.dart';

part 'menu.g.dart';

@JsonSerializable()
class Menu {
  final String title;
  final String path;
  final String icon;
  @JsonKey(fromJson: _toInt)
  final int sort;
  final List<Menu> submenu;
  @JsonKey(fromJson: _toString)
  final String type;
  Menu({this.title, this.icon, this.path, this.sort, this.submenu, this.type});

  factory Menu.fromJson(Map<String, dynamic> json) => _$MenuFromJson(json);

  Map<String, dynamic> toJson() => _$MenuToJson(this);
  static int _toInt(dynamic answer) => int.parse(answer.toString());
  static String _toString(dynamic type) => type.toString();
}
