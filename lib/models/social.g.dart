// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocMedia _$SocMediaFromJson(Map<String, dynamic> json) {
  return SocMedia(
    facebook: json['facebook'] as String,
    instagram: json['instagram'] as String,
    twitter: json['twitter'] as String,
    youtubel: json['youtubel'] as String,
    telegram: json['telegram'] as String,
  );
}

Map<String, dynamic> _$SocMediaToJson(SocMedia instance) => <String, dynamic>{
      'facebook': instance.facebook,
      'instagram': instance.instagram,
      'twitter': instance.twitter,
      'youtubel': instance.youtubel,
      'telegram': instance.telegram,
    };
