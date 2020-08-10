import 'package:firebase_messaging/firebase_messaging.dart';

final _firebaseMessaging = FirebaseMessaging();

class FirebaseBloc {
  String _token;
  String get token => _token;

  Future<String> getToken() async {
    _token = await _firebaseMessaging.getToken();
    return token;
  }
}
