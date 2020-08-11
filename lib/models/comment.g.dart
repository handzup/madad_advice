// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) {
  return Comment(
    id: json['ID'] as String,
    authorId: json['AUTHOR_ID'] as String,
    authorName: json['AUTHOR_NAME'] as String,
    useSmiles: json['USE_SMILES'] as String,
    postMessage: json['POST_MESSAGE'] as String,
    forumId: json['FORUM_ID'] as String,
    topicId: json['TOPIC_ID'] as String,
    postDate: json['POST_DATE'] as String,
    photo: json['PERSONAL_PHOTO'] as String,
  );
}

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'ID': instance.id,
      'AUTHOR_ID': instance.authorId,
      'AUTHOR_NAME': instance.authorName,
      'USE_SMILES': instance.useSmiles,
      'POST_MESSAGE': instance.postMessage,
      'FORUM_ID': instance.forumId,
      'TOPIC_ID': instance.topicId,
      'POST_DATE': instance.postDate,
      'PERSONAL_PHOTO': instance.photo,
    };
