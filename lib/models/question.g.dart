// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuestionAdapter extends TypeAdapter<Question> {
  @override
  final int typeId = 7;

  @override
  Question read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Question(
      qid: fields[0] as String,
      answer: fields[1] as String,
      question: fields[2] as String,
      createdTime: fields[3] as String,
      answeredTime: fields[4] as String,
      isAnswered: fields[5] as bool,
      answerer: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Question obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.qid)
      ..writeByte(1)
      ..write(obj.answer)
      ..writeByte(2)
      ..write(obj.question)
      ..writeByte(3)
      ..write(obj.createdTime)
      ..writeByte(4)
      ..write(obj.answeredTime)
      ..writeByte(5)
      ..write(obj.isAnswered)
      ..writeByte(6)
      ..write(obj.answerer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) {
  return Question(
    qid: Question._toString(json['id']),
    answer: json['answer'] as String,
    question: json['question'] as String,
    createdTime: json['date_create'] as String,
    answeredTime: json['answer_date'] as String,
    isAnswered: Question._toBool(json['answer'] as String),
    answerer: json['answerer'] as String,
  );
}

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'id': instance.qid,
      'answer': instance.answer,
      'question': instance.question,
      'date_create': instance.createdTime,
      'answer_date': instance.answeredTime,
      'isAnswered': instance.isAnswered,
      'answerer': instance.answerer,
    };
