import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:madad_advice/blocs/firebase_bloc.dart';
import 'package:madad_advice/blocs/user_bloc.dart';
import 'package:madad_advice/models/config.dart';
import 'package:madad_advice/pages/home.dart';
import 'package:madad_advice/utils/api_service.dart';
import 'package:madad_advice/utils/next_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
final restUrl = Config().resturl;

class SignUpBloc extends ChangeNotifier {
  SignUpBloc() {
    checkSignIn();
  }

  String randomUserImageUrl =
      'https://img.pngio.com/avatar-business-face-people-icon-people-icon-png-512_512.png';

  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  bool _hasError = false;
  bool get hasError => _hasError;

  String _errorCode = 'hi';
  String get errorCode => _errorCode;

  String _name;
  String get name => _name;
  String _phone;
  String get phone => _phone;
  String _lastName;
  String get lastName => _lastName;

  String _uid;
  String get uid => _uid;

  String _email;
  String get email => _email;

  String _imageUrl;
  String get imageUrl => _imageUrl;
  Map<String, dynamic> _json;
  Map<String, dynamic> get uJson => _json;

  String timestamp;
  var apiService = ApiService();
  Future<bool> checkPhone(String phone) async {
    final result = await apiService.fetch(
        '$restUrl/mobapi.checktelephone?telephone=$phone');
    if ((result['result'] is bool)) {
      return false;
    }
    return true;
  }

  Future<String> sendVerificationCode(String phone) async {
    final result = await apiService.fetchGetSmsCode(
        reqUrl:
            '$restUrl/mobapi.checktelephone',
        phoneNumber: phone);

    var code = result['result']['code'].toString();
    return code;
  }

  Future<bool> checkVarificationCode(String code, String smsCode) async {
    if (code == smsCode) {
      return true;
    }
    return false;
  }

  final firebaseBloc = FirebaseBloc();
  Future<bool> register({
    String name,
    String lastName,
    String phoneNumber,
    String email,
    String password,
  }) async {
    final token = await firebaseBloc.getToken();
    final result = await apiService.fetchPostRegister(
        reqUrl:
            '$restUrl/mobapi.registerbytelephone',
        email: email,
        lastName: lastName,
        name: name,
        password: password,
        phoneNumber: phoneNumber,
        firebase: token);

    if ((result['result'] is bool)) {
      return false;
    }
    _name = name;
    _lastName = lastName;
    _email = email;
    _phone = phoneNumber;
    _uid = result['result']['id'];
    await saveDataToSP();
    await setSignIn();
    return true;
  }

  Future signInwithEmailPassword(userEmail, userPassword) async {
    try {
      // final FirebaseUser user = (await _firebaseAuth.signInWithEmailAndPassword(email: userEmail, password: userPassword)).user;
      if (userEmail == "mail@mail.com" && userPassword == "12345") {
        String data = await rootBundle.loadString('assets/userJson.json');
        _json = json.decode(data);

        print('Howdy, ${uJson['result']['NAME']}!');
      } else {}
      // assert(user != null);
      // assert(await user.getIdToken() != null);
      // final FirebaseUser currentUser = await _firebaseAuth.currentUser();
      // this._uid = currentUser.uid;

      _hasError = false;
      notifyListeners();
    } catch (e) {
      _hasError = true;
      _errorCode = e.code;
      notifyListeners();
    }
  }

  Future saveDataToSP() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences.setString('name', _name);
    await sharedPreferences.setString('lastName', _lastName);
    await sharedPreferences.setString('phone', _phone);
    await sharedPreferences.setString('email', _email);
    await sharedPreferences.setString('image url', _imageUrl);
    await sharedPreferences.setString('uid', _uid);
  }

  Future getUserData(uid) async {
    _uid = uJson['result']['ID'];
    _name = uJson['result']['NAME'];
    _email = uJson['result']['EMAIL'];
    _imageUrl = uJson['result']['PERSONAL_PHOTO'];
    print(_name);

    notifyListeners();
  }

  handleAfterSignup(context) {
    Future.delayed(Duration(milliseconds: 1000)).then((f) {
      nextScreenReplace(context, HomePage());
    });
  }

  handleBack(context) {
    final ub = Provider.of<UserBloc>(context);
    Future.delayed(Duration(milliseconds: 1000)).then((f) {
      Navigator.pop(context);
    });
    checkSignIn();
    ub.getUserData();
    notifyListeners();
  }

  Future setSignIn() async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool('signed in', true);

    notifyListeners();
  }

  Future setLogIut() async {
    _isSignedIn = false;
    final sp = await SharedPreferences.getInstance();
    await sp.setBool('signed in', false);
    notifyListeners();
  }

  void checkSignIn() async {
    final sp = await SharedPreferences.getInstance();

    _isSignedIn = sp.getBool('signed in') ?? false;
    notifyListeners();
  }
}
