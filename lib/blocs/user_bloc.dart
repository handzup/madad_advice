//import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:madad_advice/models/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserBloc extends ChangeNotifier {
  String randomUserImageUrl =
      'https://img.pngio.com/avatar-business-face-people-icon-people-icon-png-512_512.png';

  String _userName = 'Madad';
  String get userName => _userName;
  String _userLastName = "LastName";
  String _email = 'Advice for Business';
  String _uid = 'uid';
  String _imageUrl = Config().splashIcon;
  String _phone ='';
  String get phone => _phone;
  String _gender = "";
  bool _hasError = false;
  bool get hasError => _hasError;
  String get userLastName => _userLastName;
  String get email => _email;
  String get uid => _uid;
  String get imageUrl => _imageUrl;
  String get gender => _gender;

  getUserData() async {
    final sp = await SharedPreferences.getInstance();

    _userName = sp.getString('name') ?? 'Madad';
    _userLastName = sp.getString('lastName') ?? 'LastName';
    _email = sp.getString('email') ?? 'Advice for Business';
    _uid = sp.getString('uid') ?? 'uid';
    _imageUrl = sp.getString('image url') ?? Config().splashIcon;
    _gender = sp.getString('gender') ?? '';
    _phone = sp.getString('phone') ?? '';
    notifyListeners();
  }
  //TODO upload image to server and recive update here

  Future setImage(File image) async {
    final sp = await SharedPreferences.getInstance();
    if (image == null) {
      _hasError = true;
    } else {
      await sp.setString('image url', image.path);
    }

    _hasError = false;
  }

  Future updateUserData(userName, lastName, email, imageUrl, gender) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    if (userName != null) {
      await sp.setString('name', userName);
    }
    if (lastName != null) {
      await sp.setString('lastName', lastName);
    }
    if (email != null) {
      await sp.setString('email', email);
    }
    // if (_imageUrl != null) {
    //   await sp.setString('image url', _imageUrl);
    // }
    if (gender != null) {
      await sp.setString('gender', gender);
    }
    _hasError = false;
  }

  // handleLoveIconClick(timestamp) async {
  //   final DocumentReference ref =
  //       Firestore.instance.collection('users').document(_uid);
  //   final DocumentReference ref1 =
  //       Firestore.instance.collection('contents').document(timestamp);

  //   DocumentSnapshot snap = await ref.get();
  //   DocumentSnapshot snap1 = await ref1.get();
  //   List d = snap.data['loved items'];
  //   int _loves = snap1['loves'];

  //   if (d.contains(timestamp)) {
  //     List a = [timestamp];
  //     await ref.updateData({'loved items': FieldValue.arrayRemove(a)});
  //     ref1.updateData({'loves': _loves - 1});
  //   } else {
  //     d.add(timestamp);
  //     await ref.updateData({'loved items': FieldValue.arrayUnion(d)});
  //     ref1.updateData({'loves': _loves + 1});
  //   }
  // }

  // handleBookmarkIconClick(context, timestamp) async {
  //   final BookmarkBloc bb = Provider.of<BookmarkBloc>(context);
  //   final DocumentReference ref =
  //       Firestore.instance.collection('users').document(_uid);
  //   DocumentSnapshot snap = await ref.get();
  //   List d = snap.data['bookmarked items'];

  //   if (d.contains(timestamp)) {
  //     List a = [timestamp];
  //     await ref.updateData({'bookmarked items': FieldValue.arrayRemove(a)});
  //   } else {
  //     d.add(timestamp);
  //     await ref.updateData({'bookmarked items': FieldValue.arrayUnion(d)});
  //   }
  //   bb.getData();
  // }

}
