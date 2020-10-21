import 'package:flutter/material.dart';
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
  @JsonKey(fromJson: _toColor, name: 'text_color',toJson: _toString)
  @HiveField(6)
  final Color textColor;
  @JsonKey(fromJson: _toColor, name: 'bg_color',toJson: _toString)
  @HiveField(7)
  final Color bgColor;

  Menu(
      {this.bgColor,
      this.textColor,
      this.title,
      this.icon,
      this.path,
      this.sort,
      this.submenu,
      this.type});

  factory Menu.fromJson(Map<String, dynamic> json) => _$MenuFromJson(json);

  Map<String, dynamic> toJson() => _$MenuToJson(this);
  static int _toInt(dynamic answer) => int.parse(answer.toString());
  static String _toString(dynamic type) => type.toString();
  static Color _toColor(String type) {
    if ( type != null && type.isNotEmpty) {
      var str = type.replaceAll('#', '');

      return Color(int.parse('0xFF$str'));
    } else {
      return null;
    }
  }
}
