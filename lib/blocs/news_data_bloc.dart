//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:madad_advice/models/icons_data.dart';

class NewsDataBloc extends ChangeNotifier {

  
  List _data = [];
  Icon _loveIcon = LoveIcon().normal;
  Icon _bookmarIcon = BookmarkIcon().normal;
  String _envatoUrl = 'https://codecanyon.net/item/news-hour-flutter-news-app-with-admin-panel/25700781';


  

  NewsDataBloc() {
   // getData();
  }



  List get data => _data;
  Icon get loveIcon => _loveIcon;
  Icon get bookmarkIcon => _bookmarIcon;
  String get envatoUrl => _envatoUrl;



  // Future getData() async {
  //   QuerySnapshot snap = await Firestore.instance.collection('contents').getDocuments();
  //   var x = snap.documents;
  //   _data.clear();
  //   x.forEach((f) {
  //     _data.add(f);
  //   });
  //   _data.shuffle();
  // }


}
