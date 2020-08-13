// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    email: json['email'] as String,
    active: json['active'] as String,
    login: json['login'] as String,
    uid: json['id'] as String,
    name: json['name'] as String,
    lastname: json['last_name'] as String,
    photo: json['photo'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.uid,
      'login': instance.login,
      'name': instance.name,
      'last_name': instance.lastname,
      'photo': instance.photo,
      'active': instance.active,
      'email': instance.email,
    };
