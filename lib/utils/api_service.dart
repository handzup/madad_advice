import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:madad_advice/models/file.dart';

var dio = Dio();

class ApiService {
  fetch(String reqUrl) async {
    var response;
    try {
      // throw OSError('dasdasd', 51);
      response = await dio.get(reqUrl);
      if (response.statusCode != 200) {
        throw "Err";
      }
    } on DioError catch (e) {
      print(e.error);
      return null;
    } on SocketException catch (e) {
      print(e.message);
    } catch (e) {
      print(e);
    }
    return response.data;
  }

  Future sendQuestion(
      {String reqUrl,
      String uid,
      String uName,
      String qMessage,
      List<FileTo> files}) async {
    var mPartFIles = [];
    files.forEach((element) {
      mPartFIles
          .add(MultipartFile.fromFile(element.path, filename: element.name));
    });
    var formData = FormData.fromMap({
      'uid': uid,
      'uName': uName,
      'qMessage': qMessage,
      'files': mPartFIles
    });
    var response = await dio.post(reqUrl, data: formData);
    return response.data;
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
      'firebase': firebase
    });
    var response = await dio.post(reqUrl, data: formData);

    if (response.statusCode != 200) {
      throw 'Err';
    }

    return response.data;
  }

  Future fetchPosLogIn(
      {String reqUrl,
      String phoneNumber,
      String password,
      String firebase}) async {
    var formData = FormData.fromMap(
        {'telephone': phoneNumber, 'password': password, 'firebase': firebase});
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
      'withsms': 'Y',
    });
    var response = await dio.post(reqUrl, data: formData);

    if (response.statusCode != 200) {
      throw 'Err';
    }

    return response.data;
  }
}
