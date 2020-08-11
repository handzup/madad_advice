import 'dart:io';

class Question {
  String qid;
  String uid;
  String title;
  String description;
  List<File> files;
  DateTime createdTime;
  DateTime answeredTime;
  bool isAnswered;
}