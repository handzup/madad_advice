import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
part 'question.g.dart';

@HiveType(typeId: 7)
@JsonSerializable()
class Question {
  @HiveField(0)
  @JsonKey(name: 'id', fromJson: _toString)
  final String qid;
  @HiveField(1)
  @JsonKey(name: 'answer')
  final String answer;
  @HiveField(2)
  final String question;
  // @HiveField(2)
  // final List<File> files;
  @HiveField(3)
  @JsonKey(name: 'date_create')
  final String createdTime;
  @HiveField(4)
  @JsonKey(name: 'answer_date')
  final String answeredTime;
  @HiveField(5)
  @JsonKey(fromJson: _toBool)
  final bool isAnswered;
  @HiveField(6)
  final String answerer;
  Question(
      {this.qid,
      this.answer,
      this.question,
      this.createdTime,
      this.answeredTime,
      this.isAnswered,
      this.answerer});
  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionToJson(this);
  static bool _toBool(String answer) => answer.isEmpty ? false : true;
  static String _toString(answer) => answer.toString();
}
