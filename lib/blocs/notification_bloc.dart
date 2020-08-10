//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationBloc extends ChangeNotifier {



  NotificationBloc(){
    getNlength();
    //getData();
  }


  int _notificationLength = 0;
  int get notificationLength => _notificationLength;
  
  int _savedNlength = 0;
  int get savedNlength => _savedNlength;

  int _notificationFinalLength = 0;
  int get notificationFinalLength => _notificationFinalLength;
  
  List _ndata = [];
  List get ndata => _ndata;
  

  
  // Future getData() async {
    
  //   final DocumentReference ref = Firestore.instance.collection('notifications').document('contents');
  //   DocumentSnapshot snap = await ref.get();
  //   List d = snap.data['list'];
  //   _ndata.clear();

  //   await Firestore.instance.collection('contents').getDocuments().then((QuerySnapshot snap) {
  //     var x = snap.documents;
  //     for (var item in x) {
  //       if (d.contains(item['timestamp'])) {
  //         _ndata.add(item);
  //       }
  //     }
  //   });

  //   await Firestore.instance.collection('notifications').document('custom').collection('list').getDocuments().then((QuerySnapshot snap){
  //     List c = snap.documents;
  //     for (var item in c) {
  //       _ndata.add(item);
  //     }
  //   });
  //   _notificationLength = _ndata.length;
  //   _notificationFinalLength = _notificationLength - _savedNlength;
  //   notifyListeners();  
  // }


  void getNlength () async{
    final SharedPreferences sp = await SharedPreferences.getInstance();
    int _savedLength = sp.get('saved length') ?? 0;
    _savedNlength = _savedLength;
    notifyListeners();
  }


  void saveNlength () async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setInt('saved length', _notificationLength);
    _savedNlength = _notificationLength;
    notifyListeners();
  }



  
}
