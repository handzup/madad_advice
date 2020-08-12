//import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:madad_advice/models/comment.dart';
import 'package:madad_advice/models/config.dart';
import 'package:madad_advice/utils/api_response.dart';
import 'package:madad_advice/utils/api_service.dart';

final restUrl = Config().resturl;

class CommentsBloc extends ChangeNotifier {
  final apiService = ApiService();

  String date;
  String timestamp1;
  String _topicId;
  String get topickId => _topicId;
  APIResponse<List<Comment>> _data;
  APIResponse<List<Comment>> get data => _data;
  String _lastCode;
  String get lastCode => _lastCode;

  Future<APIResponse<List<Comment>>> getCommens(code) async {
    _lastCode = code;
    final result = await apiService.getComments(code);
    _data = result;
    notifyListeners();
    return _data;
  }

  setTopicId(String id) {
    _topicId = id;
  }

  Future<bool> sendComment({
    String message,
    String authorId,
    String authorName,
    String photo,
    String code,
  }) async {
    _data.data.insert(
        0,
        Comment(
          authorId: authorId,
          postMessage: message,
          photo: photo,
          postDate: DateTime.now().toString(),
          authorName: authorName,
        ));

    notifyListeners();
    var result = await apiService
        .sendComment(
            authorId: authorId,
            authorName: authorName,
            message: message,
            topicId: _topicId,
            code: code)
        .then((value) {
      getCommens(lastCode);
      return value;
    });
    return result;
  }

  Future getData(code) async {
    return await getCommens(code);
  }

  // Future saveNewComment(timestamp, comment)async{

  //   final SharedPreferences sp = await SharedPreferences.getInstance();
  //   String _uid = sp.getString('uid');
  //   String _name = sp.getString('name');
  //   String _imageUrl = sp.getString('image url');

  //   await _getDate().then((_){
  //     Firestore.instance.collection('contents/$timestamp/comments').document('$_uid$timestamp1').setData({
  //       'name': _name,
  //       'comment' : comment,
  //       'date' : date,
  //       'image url' : _imageUrl,
  //       'timestamp': timestamp1,
  //       'uid' : _uid
  //     });
  //   });

  //   getData(timestamp);

  //  }

  // Future deleteComment (timestamp,uid, timestamp2) async{
  //   Firestore.instance.collection('contents/$timestamp/comments').document('$uid$timestamp2').delete();
  //   getData(timestamp);
  // }

  // ignore: unused_element
  Future _getDate() async {
    var now = DateTime.now();
    var _date = DateFormat('dd MMMM yy').format(now);
    var _timestamp = DateFormat('yyyyMMddHHmmss').format(now);
    date = _date;
    timestamp1 = _timestamp;
  }
}
