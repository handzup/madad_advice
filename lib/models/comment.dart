import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment {
  @JsonKey(name: 'ID')
  final String id;
  @JsonKey(name: 'AUTHOR_ID')
  final String authorId;
  @JsonKey(name: 'AUTHOR_NAME')
  final String authorName;
  @JsonKey(name: 'USE_SMILES')
  final String useSmiles;
  @JsonKey(name: 'POST_MESSAGE')
  final String postMessage;
  @JsonKey(name: 'FORUM_ID')
  final String forumId;
  @JsonKey(name: 'TOPIC_ID')
  final String topicId;
  @JsonKey(name: 'POST_DATE')
  final String postDate;
  @JsonKey(name: 'PERSONAL_PHOTO')
  final String photo;
  Comment({
    this.id,
    this.authorId,
    this.authorName,
    this.useSmiles,
    this.postMessage,
    this.forumId,
    this.topicId,
    this.postDate,
    this.photo
  });

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
