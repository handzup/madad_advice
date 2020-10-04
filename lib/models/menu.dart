import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'menu.g.dart';

@JsonSerializable()
@HiveType(typeId: 8)
class Menu {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String path;
  @HiveField(2)
  final String icon;
  @JsonKey(fromJson: _toInt)
  @HiveField(3)
  final int sort;
  @HiveField(4)
  final List<Menu> submenu;
  @JsonKey(fromJson: _toString)
  @HiveField(5)
  final String type;
  Menu({this.title, this.icon, this.path, this.sort, this.submenu, this.type});

  factory Menu.fromJson(Map<String, dynamic> json) => _$MenuFromJson(json);

  Map<String, dynamic> toJson() => _$MenuToJson(this);
  static int _toInt(dynamic answer) => int.parse(answer.toString());
  static String _toString(dynamic type) => type.toString();
}
