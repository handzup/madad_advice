import 'package:flutter/material.dart';
import 'package:madad_advice/generated/locale_keys.g.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import '../models/config.dart';
import '../utils/api_service.dart';

ApiService apiService = ApiService();

class UserBloc extends ChangeNotifier {
  String randomUserImageUrl =
      'https://img.pngio.com/avatar-business-face-people-icon-people-icon-png-512_512.png';

  String _userName = LocaleKeys.appSubtitle.tr();
  String get userName => _userName;
  String _userLastName = "LastName";
  String _email = LocaleKeys.appTitle.tr();
  String _uid = 'uid';
  String _imageUrl = Config().splashIcon;
  String _phone = '';
  String get phone => _phone;
  bool _inProgress = false;
  bool get inProgress => _inProgress;
  bool _hasError = false;
  bool get hasError => _hasError;
  bool _shouldClose = false;
  bool get shouldClose => _shouldClose;
  bool _succes = false;
  bool get succes => _succes;
  String get userLastName => _userLastName;
  String get email => _email;
  String get uid => _uid;
  String get imageUrl => _imageUrl;
  String get pickeImageUrl => _pickeImageUrl;
  String _pickeImageUrl;
  bool _isGuest;
  bool get isGuest => _isGuest;
  getUserData() async {
    final sp = await SharedPreferences.getInstance();

    _userName = sp.getString('name') ?? LocaleKeys.appSubtitle.tr();
    _userLastName = sp.getString('lastName') ?? 'LastName';
    _email = sp.getString('email') ?? LocaleKeys.appTitle.tr();
    _uid = sp.getString('uid') ?? 'uid';
    _imageUrl = sp.getString('image url') ?? Config().uri;
    _phone = sp.getString('phone') ?? '';
    _isGuest = sp.getBool('guest') ?? true;
    notifyListeners();
  }

  Future setImage(String imagePath) async {
    if (imagePath == null) {
      _hasError = true;
    } else {
      _pickeImageUrl = imagePath;
    }
    _hasError = false;
  }

  setClose(bool cond) {
    _shouldClose = cond;
  }

  Future<bool> updateUserProfileApi(
      {String userName,
      String lastName,
      String email,
      String phoneNumber,
      String password}) async {
    _inProgress = true;
    _hasError = false;
    _succes = false;
    notifyListeners();
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await Future.delayed(Duration(milliseconds: 1000));
    var uid = sp.getString('uid');
    print(uid);
    var data = await apiService
        .updateUser(
            uid: uid,
            userName: userName ?? _userName,
            email: email ?? _email,
            imageUrl: _pickeImageUrl,
            lastName: lastName ?? _userLastName,
            phoneNumber: phoneNumber ?? _phone,
            password: password)
        .then((result) async {
      _pickeImageUrl = null;
      if (!result.error) {
        var userResult = await apiService.getUserDataFromApi(uid: uid);
        await updateUserData(
            userName: userResult.data.name,
            email: userResult.data.email,
            imageUrl: userResult.data.photo,
            lastName: userResult.data.lastname,
            phoneNumber: userResult.data.login);
        _inProgress = false;
        _succes = true;
        return true;
      } else {
        _inProgress = false;
        _hasError = true;
        _succes = false;
        notifyListeners();
        return false;
      }
    });
    // updateUserData(
    //     userName: userName,
    //     email: email,
    //     imageUrl: imageUrl,
    //     lastName: lastName,
    //     phoneNumber: phoneNumber);
    return data;
  }

  Future updateUserData(
      {String userName,
      String lastName,
      String email,
      String imageUrl,
      String phoneNumber}) async {
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
    if (_imageUrl != null) {
      await sp.setString(
          'image url', _imageUrl != null ? '${Config().url}/$imageUrl' : null);
    }
    if (phoneNumber != null) {
      await sp.setString('phone', phoneNumber);
    }
    _hasError = false;
    getUserData();
  }

  // ignore: missing_return
  Future removeUserPhoto() {
    //TODO:remove user photo;
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
