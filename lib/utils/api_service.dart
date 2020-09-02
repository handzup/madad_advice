import 'dart:io';

import 'package:dio/dio.dart';
import 'package:madad_advice/models/category.dart';
import 'package:madad_advice/models/comment.dart';
import 'package:madad_advice/models/config.dart';
import 'package:madad_advice/models/file.dart';
import 'package:madad_advice/models/langs.dart';
import 'package:madad_advice/models/menu.dart';
import 'package:madad_advice/models/question.dart';
import 'package:madad_advice/models/section.dart';
import 'package:madad_advice/models/sphere.dart';
import 'package:madad_advice/models/user.dart';
import 'package:madad_advice/utils/api_response.dart';
import 'package:madad_advice/utils/locator.dart';

var dio = Dio();
final restUrl = Config().resturl;

class ApiService {
  var lang = locator<Langs>();

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
      }).catchError((onError) => APIResponse<List<Comment>>(error: true));
    } catch (e) {
      return APIResponse<List<Comment>>(error: true);
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

  Future<APIResponse<List<Menu>>> fetchApiGetMenu() async {
    try {
      return dio.get('$restUrl/mobapi.getmenu').then((result) {
        if (result.statusCode != 200) {
          return APIResponse<List<Menu>>(
              error: true, errorMessage: 'Service error');
        }
        var data = <Menu>[];
        result.data['result'][lang.lang.toString()].forEach((item) {
          data.add(Menu.fromJson(item));
        });
        return APIResponse<List<Menu>>(data: data, error: false);
      }).catchError((onError) => APIResponse<List<Menu>>(
            data: [],
            error: true,
          ));
    } catch (e) {
      return APIResponse<List<Menu>>(data: [], error: true);
    }
  }

  Future<APIResponse<List<MyCategory>>> fetchApiGetCategories() async {
    try {
      return dio
          .get(
        '$restUrl/mobapi.getscopes',
      )
          .then((result) {
        if (result.statusCode != 200) {
          return APIResponse<List<MyCategory>>(
              error: true, errorMessage: 'Service error');
        }
        var data = <MyCategory>[];
        result.data['result'][lang.lang.toString()].forEach((item) {
          data.add(MyCategory.fromJson(item));
        });
        return APIResponse<List<MyCategory>>(data: data, error: false);
      }).catchError((onError) => APIResponse<List<MyCategory>>(
                data: [],
                error: true,
              ));
    } catch (e) {
      return APIResponse<List<MyCategory>>(error: true);
    }
  }

  Future<APIResponse<List<Section>>> fetchApiGetSections() async {
    try {
      return dio.get('$restUrl/mobapi.getsections').then((result) {
        if (result.statusCode != 200) {
          return APIResponse<List<Section>>(
              error: true, errorMessage: 'Service error');
        }
        var data = <Section>[];
        result.data['result'][lang.lang.toString()].forEach((item) {
          data.add(Section.fromJson(item));
        });
        return APIResponse<List<Section>>(data: data, error: false);
      }).catchError((onError) {
        if (onError is DioError) {
          return APIResponse<List<Section>>(
              error: true, errorMessage: 'internet');
        }
        return APIResponse<List<Section>>(data: [], error: true);
      });
    } catch (e) {
      return APIResponse<List<Section>>(data: [], error: true);
    }
  }

  Future<APIResponse<SphereModel>> fetchApiGetArticle(String code) async {
    try {
      return dio.get('$restUrl/mobapi.getelements?path=$code').then((result) {
        if (result.statusCode != 200) {
          return APIResponse<SphereModel>(
              error: true, errorMessage: 'Service error');
        }
        var data = SphereModel.fromJson(result.data['result']);
        return APIResponse<SphereModel>(data: data, error: false);
      }).catchError((error) {
        if (error is DioError) {
          return APIResponse<SphereModel>(
              error: true, errorMessage: 'internet');
        }
        return APIResponse<SphereModel>(error: true);
      });
    } catch (e) {
      return APIResponse<SphereModel>(error: true);
    }
  }

  Future<APIResponse<SphereModel>> fetchApiGetRecent() async {
    try {
      return dio
          .get('$restUrl/mobapi.lastelements?lang=${lang.lang.toString()}')
          .then((result) {
        if (result.statusCode != 200) {
          return APIResponse<SphereModel>(
              error: true, errorMessage: 'Service error');
        }
        var data = SphereModel.fromJson(result.data['result']);
        return APIResponse<SphereModel>(data: data, error: false);
      }).catchError((error) {
        if (error is DioError) {
          return APIResponse<SphereModel>(
              error: true, errorMessage: 'internet');
        }
        return APIResponse<SphereModel>(error: true);
      });
    } catch (e) {
      return APIResponse<SphereModel>(error: true);
    }
  }

  Future<APIResponse<bool>> fetchApiCheckPhone(String phoneNumber) async {
    var formData = FormData.fromMap({
      'telephone': phoneNumber,
    });
    try {
      return dio
          .post('$restUrl/mobapi.checktelephone', data: formData)
          .then((result) {
        if (result.statusCode != 200) {
          return APIResponse<bool>(error: true, errorMessage: 'Service error');
        }
        if ((result.data['result'] is bool)) {
          if (result.data['result']) {
            return APIResponse<bool>(data: true, error: false);
          }
        }
        return APIResponse<bool>(data: false, error: false);
      }).catchError((onError) => APIResponse<bool>(
                error: true,
              ));
    } catch (e) {
      return APIResponse<bool>(error: true);
    }
  }

  Future<APIResponse<User>> fetchApiLogin(
      {String phoneNumber, String password, String firebase}) async {
    var formData = FormData.fromMap(
        {'telephone': phoneNumber, 'password': password, 'firebase': firebase});
    try {
      return dio
          .post('$restUrl/mobapi.loginbytelephone', data: formData)
          .then((result) {
        if (result.statusCode != 200) {
          return APIResponse<User>(error: true, errorMessage: 'Service error');
        }
        if ((result.data['result'] is String)) {
          return APIResponse<User>(
              error: true, errorMessage: 'Login or Password wrong');
        }
        var data = User.fromJson(result.data['result']);
        return APIResponse<User>(data: data, error: false);
      }).catchError((onError) => APIResponse<User>(error: true));
    } catch (e) {
      return APIResponse<User>(error: true);
    }
  }

  Future<APIResponse<List<Question>>> fetchApiGetAllQuestions({
    String uid,
  }) async {
    var formData = FormData.fromMap({
      'uid': uid,
    });
    try {
      return dio
          .post('$restUrl/mobapi.getquestions', data: formData)
          .then((result) {
        if (result.statusCode != 200) {
          return APIResponse<List<Question>>(
              error: true, errorMessage: 'Service error');
        }
        var data = <Question>[];
        result.data['result'].forEach((e) {
          data.add(Question.fromJson(e));
        });

        return APIResponse<List<Question>>(data: data, error: false);
      }).catchError((onError) => APIResponse<List<Question>>(error: true));
    } catch (e) {
      return APIResponse<List<Question>>(error: true);
    }
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
  Future<APIResponse<User>> updateUser(
      {String uid,
      String userName,
      String lastName,
      String email,
      String imageUrl,
      String phoneNumber,
      String password}) async {
    var formDataHasPhoto = FormData.fromMap({
      'id': uid,
      'name': userName,
      'last_name': lastName,
      'email': email,
      'login': phoneNumber,
      'password': password,
      'photo': imageUrl != null
          ? await MultipartFile.fromFile(
              imageUrl,
            )
          : null
    });
    var formData = FormData.fromMap({
      'uid': uid,
      'name': userName,
      'last_name': lastName,
      'email': email,
      'login': phoneNumber,
      'password': password,
    });

    try {
      return dio
          .post('$restUrl/mobapi.saveprofile',
              data: imageUrl == null ? formData : formDataHasPhoto)
          .then((result) {
        if (result.statusCode != 200) {
          return APIResponse(data: User(), error: true);
        }
        if (result.data['result'] is bool) {
          if (result.data['result']) {
            return APIResponse(data: User());
          } else {
            return APIResponse(data: User(), error: true);
          }
        }
        return APIResponse(data: User(), error: true);
      }).catchError((onError) => APIResponse(data: User(), error: true));
    } catch (e) {
      return APIResponse(data: User(), error: true);
    }
    // try {
    //   return dio
    //       .post('https://5f3be455fff8550016ae5db3.mockapi.io/api/user',
    //           data: imageUrl == null ? formData : formDataHasPhoto)
    //       .then((result) {
    //     // if (result.statusCode != 200) {
    //     //   return APIResponse(data: User(), error: true);
    //     // }
    //     if (result.data['result'] is bool) {
    //       return APIResponse(data: User(), error: true);
    //     }
    //     return APIResponse(data: User.fromJson(result.data['result']));
    //   }).catchError((onError)=>APIResponse(data: User(), error: true));
    // } catch (e) {
    //   return APIResponse(data: User(), error: true);
    // }
  }

  Future<APIResponse<int>> sendQuestion(
      {String reqUrl, String uid, String qMessage, List<FileTo> files}) async {
    var mPartFIles = [];
    files.forEach((element) {
      mPartFIles
          .add(MultipartFile.fromFile(element.path, filename: element.name));
    });
    var formData = FormData.fromMap(
        {'uid': uid, 'question': qMessage, 'files': mPartFIles});
    try {
      return dio
          .post('$restUrl/mobapi.sendquestion', data: formData)
          .then((result) {
        if (result.statusCode != 200) {
          return APIResponse(data: -1, error: true);
        }
        if (result.data['result'] is int) {
          var quetionId = result.data['result'] as int;
          return APIResponse(data: quetionId);
        }
        return APIResponse(data: -1, error: true, errorMessage: 'err');
      }).catchError((onError) {
        if (onError is DioError) {
          return APIResponse(data: -1, errorMessage: 'internet', error: true);
        }
        return APIResponse(data: -1, error: true);
      });
    } catch (e) {
      return APIResponse(data: -1, error: true);
    }
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

  Future<APIResponse<String>> fetchGetSmsCode({String phoneNumber}) async {
    var formData = FormData.fromMap({
      'telephone': phoneNumber,
      'withsms': 'Y',
    });
    try {
      return dio
          .post('$restUrl//mobapi.checktelephone', data: formData)
          .then((result) {
        if (result.statusCode != 200) {
          return APIResponse(data: null, error: true);
        }
        if (result.data['result']['code'] != null) {
          var code = result.data['result']['code'].toString();
          return APIResponse(data: code);
        }
        return APIResponse(data: null, error: true, errorMessage: 'err');
      }).catchError((onError) {
        if (onError is DioError) {
          return APIResponse(data: null, errorMessage: 'internet', error: true);
        }
        return APIResponse(data: null, error: true);
      });
    } catch (e) {
      return APIResponse(data: null, error: true);
    }
  }

  Future<APIResponse<User>> getUserDataFromApi({String uid}) async {
    var formData = FormData.fromMap({
      'uid': uid,
    });
    try {
      return dio
          .post('$restUrl/mobapi.getuserbyid', data: formData)
          .then((result) {
        if (result.statusCode != 200) {
          return APIResponse<User>(error: true, errorMessage: 'Service error');
        }
        if ((result.data['result'] is String)) {
          return APIResponse<User>(
              error: true, errorMessage: 'Login or Password wrong');
        }
        var data = User.fromJson(result.data['result']);
        return APIResponse<User>(data: data, error: false);
      }).catchError((onError) => APIResponse<User>(error: true));
    } catch (e) {
      return APIResponse<User>(error: true);
    }
  }

  Future<APIResponse<bool>> resetPasswordFromApi(
      {String telephone, String pass, String comfrimPass}) async {
    var formData = FormData.fromMap({
      'telephone': telephone,
      'password': pass,
      'confirm_password': comfrimPass,
    });
    try {
      return dio
          .post('$restUrl/mobapi.changepassword', data: formData)
          .then((result) {
        if (result.statusCode != 200) {
          return APIResponse<bool>(error: true, errorMessage: 'Service error');
        }
        if ((result.data['result'] is String)) {
          return APIResponse<bool>(
              error: true, errorMessage: 'Login or Password wrong');
        }
        if (result.data['result'] is bool) {
          if (result.data['result']) {
            return APIResponse<bool>(data: true, error: false);
          }
        }
        return APIResponse<bool>(data: false, error: false);
      }).catchError((onError) => APIResponse<bool>(error: true));
    } catch (e) {
      return APIResponse<bool>(error: true);
    }
  }
}
