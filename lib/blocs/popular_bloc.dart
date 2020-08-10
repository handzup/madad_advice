//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PopularDataBloc extends ChangeNotifier {
  
  List _popularData = [];
  List _filteredData = [];
  bool _hasData = false;

  PopularDataBloc() {
   // getData();
  }
  

  List get popularData => _popularData;
  List get filteredData => _filteredData;
  bool get hasData => _hasData;

  // Future getData() async {

  //   QuerySnapshot snap = await Firestore.instance.collection('contents').getDocuments();
  //   var x = snap.documents;
  //   _popularData.clear();
  //   x.forEach((f) {
  //     _popularData.add(f);
  //   });
  //   _popularData.sort((a, b) => b['loves'].compareTo(a['loves']));
  //   notifyListeners();
  // }



  void afterSearch(value) {
    _filteredData = _popularData
        .where((u) => (u['title'].toLowerCase().contains(value.toLowerCase())) 
        ||  u['description'].toLowerCase().contains(value.toLowerCase()))
        .toList();


    _filteredData.isEmpty ? _hasData = false : _hasData = true;

    notifyListeners();
  }
}
