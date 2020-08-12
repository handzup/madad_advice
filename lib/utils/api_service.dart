import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:madad_advice/models/comment.dart';
import 'package:madad_advice/models/config.dart';
import 'package:madad_advice/models/file.dart';
import 'package:madad_advice/utils/api_response.dart';

var dio = Dio();
final restUrl = Config().resturl;

class ApiService {
  Future<APIResponse<List<Comment>>> getComments(code) async {
    try {
      return dio.get('$restUrl/mobapi.getelements?path=$code').then((result) {
        if (result.statusCode != 200) {
          return APIResponse<List<Comment>>(
              error: true, errorMessage: 'Service error');
        }
        var data = <Comment>[];
        result.data['result']['elements'][0]['forum_messages'].forEach((item) {
          data.add(Comment.fromJson(item));
        });
        return APIResponse<List<Comment>>(data: data, error: false);
      }).catchError((onError) =>
          APIResponse<List<Comment>>(error: true, errorMessage: onError));
    } catch (e) {
      return APIResponse<List<Comment>>(error: true, errorMessage: e);
    }
  }

  Future<bool> sendComment(
      {String message,
      String topicId,
      String authorName = 'Guest',
      String authorId,
      String code}) async {
    {
      var formData;
      if (topicId == null) {
        formData = FormData.fromMap({
          'message': message,
          'author_name': authorName,
          'author_id': authorId,
          'element_code': code,
        });
      } else {
        formData = FormData.fromMap({
          'message': message,
          'author_name': authorName,
          'tid': topicId,
          'author_id': authorId,
        });
      }

      try {
        dio.post('$restUrl/mobapi.addcomment', data: formData).then((result) {
          if (result.statusCode != 200) {
            return APIResponse<List<Comment>>(
                error: true, errorMessage: 'Service error');
          }
          if (result.data['result'] != null) {
            if (result.data['result']['error'] != null) {
              return false;
            }
            if (result.data['result']['message_id'] != null) {
              return true;
            }
          }
          return false;
        }).catchError((onError) => false);
      } catch (e) {
        print(e);
        return false;
      }
    }
    return true;
  }

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

  // Future sendComment(
  //     {String reqUrl,
  //     String message,
  //     String topicId,
  //     String authorName = 'Guest',
  //     String authorId}) async {
  //   var formData = FormData.fromMap({
  //     'message': message,
  //     'author_name': authorName,
  //     'tid': topicId,
  //     'author_id': authorId
  //   });
  //   var response = await dio.post(reqUrl, data: formData);
  //   return response.data;
  // }

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
