import 'package:flutter/material.dart';
import 'package:madad_advice/blocs/firebase_bloc.dart';
import 'package:madad_advice/blocs/user_bloc.dart';
import 'package:madad_advice/models/config.dart';
import 'package:madad_advice/pages/home.dart';
import 'package:madad_advice/utils/api_service.dart';
import 'package:madad_advice/utils/next_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final restUrl = Config().resturl;

class SignInBloc extends ChangeNotifier {
  SignInBloc() {
    checkSignIn();
  }

  //final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  //final FacebookLogin fbLogin = new FacebookLogin();
  String randomUserImageUrl =
      'https://img.pngio.com/avatar-business-face-people-icon-people-icon-png-512_512.png';

  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  bool _hasError = false;
  bool get hasError => _hasError;

  String _errorCode = 'hi';
  String get errorCode => _errorCode;

  String _phone;
  String get phone => _phone;
  String _lastName;
  String get lastName => _lastName;
  String _name;
  String get name => _name;

  String _uid;
  String get uid => _uid;

  String _email;
  String get email => _email;

  String _imageUrl;
  String get imageUrl => _imageUrl;
  Map<String, dynamic> _json;
  Map<String, dynamic> get uJson => _json;
  var apiService = ApiService();
  String timestamp;

  // Future signUpwithEmailPassword (userName,userEmail, userPassword) async{
  //   try{
  //     final FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(email: userEmail,password: userPassword,)).user;
  //     assert(user != null);
  //     assert(await user.getIdToken() != null);
  //     this._name = userName;
  //     this._uid = user.uid;
  //     this._imageUrl = randomUserImageUrl;
  //     this._email = user.email;

  //     _hasError = false;
  //     notifyListeners();
  //   }catch(e){
  //     _hasError = true;
  //     _errorCode = e.code;
  //     notifyListeners();
  //   }

  // }
  final firebaseBloc = FirebaseBloc();
  Future<bool> login({String phoneNumber, String password}) async {
    final token = await firebaseBloc.getToken();
    final result = await apiService.fetchPosLogIn(
      reqUrl: '$restUrl/mobapi.loginbytelephone',
      password: password,
      phoneNumber: phoneNumber,
      firebase: token,
    );
    if ((result['result'] is String)) {
      return false;
    } else {}

    _name = result['result']['name'];
    _lastName = result['result']['last_name'];
    _email = result['result']['email'];
    _phone = result['result']['login'];
    _uid = result['result']['id'];

    return true;
  }

  Future<bool> checkPhone({String phone}) async {
    final result = await apiService.fetchCheckPhone(
      reqUrl: '$restUrl/mobapi.checktelephone',
      phoneNumber: phone,
    );
    if ((result['result'] is bool)) {
      if (result['result']) return true;
      return false;
    }
    return false;
  }

  Future signInwithEmailPassword({String phoneNumber, String password}) async {
    try {
      if (await login(password: password, phoneNumber: phoneNumber)) {
        _hasError = false;
      } else {
        _hasError = true;
      }

      notifyListeners();
    } catch (e) {
      _hasError = true;
      _errorCode = e.code;
      notifyListeners();
    }
  }

  Future saveDataToSP() async {
    var sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences.setString('name', _name);
    await sharedPreferences.setString('lastName', _lastName);
    await sharedPreferences.setString('phone', _phone);
    await sharedPreferences.setString('email', _email);
    await sharedPreferences.setString('image url', _imageUrl);
    await sharedPreferences.setString('uid', _uid);
    await sharedPreferences.setBool('guest', false);
  }

  Future<Null> handleAfterSignup(context) async =>
      await Future.delayed(Duration(milliseconds: 1000)).then((f) {
        nextScreenReplace(context, HomePage());
      });

  // ignore: always_declare_return_types
  handleBack(context) async {
    final ub = Provider.of<UserBloc>(context);
    Navigator.pop(context);
    await checkSignIn();
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
    _uid = await sp.getString('uid');

    await clearFirebaseToken();

    await sp.clear();
    notifyListeners();
  }

  Future<bool> clearFirebaseToken() async {
    final result = await apiService.fetchClearFirebaseToken(
        reqUrl: '$restUrl/mobapi.clearfirebase', id: uid);
    if (result['result'] is bool) {
      if (result['result'] as bool) {
        return true;
      }
    }
    return false;
  }

  void checkSignIn() async {
    final sp = await SharedPreferences.getInstance();

    _isSignedIn = sp.getBool('signed in') ?? false;
    notifyListeners();
  }
}
