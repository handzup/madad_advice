//import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:madad_advice/models/comment.dart';
import 'package:madad_advice/models/config.dart';
import 'package:madad_advice/utils/api_service.dart';
final restUrl = Config().resturl;
class CommentsBloc extends ChangeNotifier {
  final apiService = ApiService();

  String date;
  String timestamp1;

  Future<List<Comment>> getCommens(code) async {
    var data = <Comment>[];
    final result = await apiService.fetch(
        '$restUrl/mobapi.getelements?path=$code');
    result['result']['elements'][0]['forum_messages'].forEach((item) {
      data.add(Comment.fromJson(item));
    });
    return data;
  }
  Future<bool> sendComment()async {

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
