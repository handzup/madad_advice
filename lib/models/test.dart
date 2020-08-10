import 'package:json_annotation/json_annotation.dart';


part 'test.g.dart';


@JsonSerializable()
class Test {
  final int userId;
  final int id;
  final String title;
  final bool completed;
 
  Test({this.userId, this.id, this.title, this.completed}); 

  factory Test.fromJson(Map<String,dynamic> json)=> _$TestFromJson(json);

  Map<String, dynamic> toJson() => _$TestToJson(this);
}