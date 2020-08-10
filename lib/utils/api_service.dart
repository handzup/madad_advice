import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

var dio = Dio();

class ApiService {
  fetch(String reqUrl) async {
    final response = await http.get(reqUrl);
    if (response.statusCode != 200) {
      throw "Err";
    }
    return response.body;
  }

  Future fetchPostRegister(
      {String reqUrl,
      String name,
      String lastName,
      String phoneNumber,
      String email,
      String password,
      String firebase}) async {
    var formData = FormData.fromMap({
      'telephone': phoneNumber,
      'password': password,
      'name': name,
      'last_name': lastName,
      'email': email,
      'firebase':firebase
    });
    var response = await dio.post(reqUrl, data: formData);

    if (response.statusCode != 200) {
      throw 'Err';
    }

    return response.data;
  }

  Future fetchPosLogIn(
      {String reqUrl, String phoneNumber, String password,String firebase}) async {
    var formData = FormData.fromMap({
      'telephone': phoneNumber,
      'password': password,
      'firebase':firebase
    });
    var response = await dio.post(reqUrl, data: formData);

    if (response.statusCode != 200) {
      throw 'Err';
    }

    return response.data;
  }

  Future fetchCheckPhone({String reqUrl, String phoneNumber}) async {
    var formData = FormData.fromMap({
      'telephone': phoneNumber,
    });
    var response = await dio.post(reqUrl, data: formData);

    if (response.statusCode != 200) {
      throw 'Err';
    }

    return response.data;
  }
  Future fetchClearFirebaseToken({String reqUrl, String id}) async {
    var formData = FormData.fromMap({
      'uid': id,
    });
    var response = await dio.post(reqUrl, data: formData);

    if (response.statusCode != 200) {
      throw 'Err';
    }

    return response.data;
  }
  Future fetchGetSmsCode({String reqUrl, String phoneNumber}) async {
    var formData = FormData.fromMap({
      'telephone': phoneNumber,
      'withsms':'Y',
    });
    var response = await dio.post(reqUrl, data: formData);

    if (response.statusCode != 200) {
      throw 'Err';
    }

    return response.data;
  }
}
