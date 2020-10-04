import 'package:json_annotation/json_annotation.dart';
part 'social.g.dart';

@JsonSerializable()
class SocMedia {
  final String facebook;
  final String instagram;
  final String twitter;
  final String youtubel;
  final String telegram;
  SocMedia(
      {this.facebook,
      this.instagram,
      this.twitter,
      this.youtubel,
      this.telegram});
  factory SocMedia.fromJson(Map<String, dynamic> json) =>
      _$SocMediaFromJson(json);

  Map<String, dynamic> toJson() => _$SocMediaToJson(this);
}
