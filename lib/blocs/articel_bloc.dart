import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:madad_advice/models/config.dart';
import 'package:madad_advice/models/sphere.dart';
import 'package:madad_advice/utils/api_response.dart';

import 'package:madad_advice/utils/api_service.dart';
import 'package:madad_advice/widgets/sphere.dart';

const key = 'articles';

final restUrl = Config().resturl;

class ArticleBloc extends ChangeNotifier {
  bool _first = true;
  bool get first => _first;
  String _lastCode = '';
  String get lastCode => _lastCode;
  List<SphereModel> _history = List<SphereModel>();
  APIResponse<SphereModel> _sphereData =
      APIResponse(data: SphereModel(elements: [], sections: []));
  APIResponse<SphereModel> get sectionData => _sphereData;
  ApiService apiService = ApiService();
  Duration _cacheValidDuration;
  ArticleBloc() {
    _cacheValidDuration = Duration(minutes: 5);
  }
  Future<SphereModel> _readBox(acticleKey) async {
    final box = await Hive.openBox<SphereModel>(key);
    var secData = SphereModel();
    secData = box.get(acticleKey);
    // notifyListeners();
    return secData;
  }

  Future _writeBox(SphereModel item) async {
    final openBox = await Hive.openBox<SphereModel>(key);
    final arKey = item.path.toString();
    await openBox.put(arKey, item);

    // notifyListeners();
  }

  clearData() {
    if (_history.length == 0) {
      _sphereData = APIResponse(data: SphereModel(elements: [], sections: []));
    } else {
      _sphereData = APIResponse(
          data: _history[_history.length == 1
              ? _history.length - 1
              : _history.length - 2]);
      _history.removeLast();
    }
    notifyListeners();
  }

  Future<bool> isExists(acticleKey) async {
    final openBox = await Hive.openBox<SphereModel>(key);
    var length = openBox.length;
    if (length != 0) {
      return openBox.get(acticleKey) != null ? true : false;
    }
    return false;
  }

  Future<bool> getLastFetch(code) async {
    final box = await Hive.openBox<SphereModel>(key);
    var secData = SphereModel();
    secData = box.get(code);
    if (secData != null) {
      return secData.lastFetch
          .isBefore(DateTime.now().subtract(_cacheValidDuration));
    }

    //notifyListeners();
    return true;
  }

  Future<APIResponse<SphereModel>> updateFromApi(code) async {
    return await apiService.fetchApiGetArticle(code);
  }

  Future<void> update(code) async {
    final data = await updateFromApi(code);
    var lastData;
    if (!data.error) {
      lastData = SphereModel(
          sections: data.data.sections,
          elements: data.data.elements,
          title: data.data.title,
          path: data.data.path,
          type: data.data.type,
          lastFetch: DateTime.now());
    }

    _sphereData = APIResponse<SphereModel>(
        data: lastData ?? SphereModel(elements: [], sections: []),
        error: data.error,
        errorMessage: data.errorMessage);
    if (!data.error) _writeBox(lastData);
  }

  // ignore: missing_return
  Future<SphereModel> getSectionData(
      {String code, bool force = false, refresh = false}) async {
    _first = false;
    final lastFetch = await getLastFetch(code);
    if (force) {
      _sphereData = APIResponse(data: SphereModel(elements: [], sections: []));
      notifyListeners();
      await update(code);
      _history.add(_sphereData.data);
    } else if (refresh) {
      await update(code);
    } else {
      if (lastFetch) {
        await update(code);
      }
      var ex = await isExists(code);
      if (ex) {
        _sphereData = APIResponse<SphereModel>(data: await _readBox(code));
        notifyListeners();
      } else {
        await update(code);
      }
    }

    notifyListeners();
  }
}
