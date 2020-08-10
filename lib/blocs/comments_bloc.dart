//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentsBloc extends ChangeNotifier{

  
  String date;
  String timestamp1;

  

  Future getData(timestamp) async {
    // QuerySnapshot snap = await Firestore.instance.collection('contents/$timestamp/comments').getDocuments();
    // var x = snap.documents;
    var data = [];
    // x.forEach((f) => data.add(f));
    return data;
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


