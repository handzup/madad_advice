import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:madad_advice/models/file.dart';
import 'package:madad_advice/models/question.dart';
import 'package:madad_advice/utils/api_response.dart';
import 'package:madad_advice/utils/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionBloc extends ChangeNotifier {
  QuestionBloc() {
    getUid();
  }
  getUid() async {
    final sp = await SharedPreferences.getInstance();
    print(sp);
    _uid = sp.getString('uid');
  }

  String _fileName;
  String get fileName => _fileName;

  String _path;
  String get path => _path;
  ApiService apiService = ApiService();
  String _message;
  String get message => _message;
  Map<String, String> _paths;
  Map<String, String> get paths => _paths;
  bool _inProgress = false;
  bool get inProgress => _inProgress;
  List<FileTo> _files = [];
  List<FileTo> get files => _files;
  String _uid;
  APIResponse<int> _response = APIResponse(data: -1);
  APIResponse<int> get response => _response;
  APIResponse<List<Question>> _questions = APIResponse(data: []);
  APIResponse<List<Question>> get questions => _questions;

  bool _error = false;
  bool get error => _error;
  setMessage(String message) {
    _message = message;
  }

  Future<bool> sendQuestion() async {
    _inProgress = true;
    notifyListeners();
    final jsonData = await apiService.sendQuestion(
        uid: _uid, files: _files, qMessage: _message);

    _inProgress = false;
    _response = jsonData;

    _files.clear();
    await getQuestions();
    notifyListeners();
    return true;
  }

  Future getQuestions() async {
    await getUid();
    _questions = await apiService.fetchApiGetAllQuestions(uid: _uid);
    print('ds');
    _questions = APIResponse(data: List.from(_questions.data.reversed));
    notifyListeners();
  }

  // ignore: missing_return
  Future delete(String key) {
    _paths.remove(key);
    _files.clear();
    _paths.forEach((key, value) {
      _files.add(FileTo(name: key, path: value));
    });
    notifyListeners();
  }

  void setDefault() {
    _response = APIResponse(data: -1);
  }

  Future openFileExplorer() async {
    try {
      var tempPath = await FilePicker.getMultiFilePath(
        allowCompression: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf', 'doc', 'txt', 'xlsx', 'docx', 'xls'],
      );

      if (_paths != null && _paths.length == 3) {
        _error = true;
      }
      if (tempPath != null &&
          _paths != null &&
          _paths.length < 3 &&
          tempPath.length < 3) {
        _paths.addAll(tempPath);
      }
      if (tempPath != null && tempPath.length > 3) {
        _error = true;
      }
      if (tempPath != null) {
        _paths = tempPath;
      }

      if (_paths != null) {
        _paths.forEach((key, value) {
          _files.add(FileTo(name: key, path: value));
        });
        _files = _files.take(3).toList();
        _paths =
            Map.fromIterable(_files, key: (e) => e.name, value: (e) => e.path);
      }
    } on PlatformException catch (e) {
      print('Unsupported operation' + e.toString());
    }
    notifyListeners();
  }

  Future getFiles() async {
    return _files;
  }
}
