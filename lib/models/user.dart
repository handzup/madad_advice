import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: 'id')
  final String uid;
  final String login;
  final String name;
  @JsonKey(name: 'last_name')
  final String lastname;
  final String photo;
  final String active;
  final String email;

  User({
    this.email,
    this.active,
    this.login,
    this.uid,
    this.name,
    this.lastname,
    this.photo,
  });
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
