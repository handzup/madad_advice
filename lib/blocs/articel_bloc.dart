import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
import 'package:madad_advice/models/sphere.dart';

import 'package:madad_advice/utils/api_service.dart';

const key = 'articles';

class ArticleBloc extends ChangeNotifier {
  SphereModel _sphereData;
  SphereModel get sectionData => _sphereData;
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

  Future<SphereModel> updateFromApi(code) async {
    var data = SphereModel();
    final result = await apiService.fetch(
        'https://madad.4u.uz/rest/1/e0mnf0e1a2f0y88k/mobapi.getelements?path=$code');
     data = (SphereModel.fromJson(result['result']));
    return data;
  }

  Future<void> update(code) async {
    final data = await updateFromApi(code);
    final lastData = SphereModel(
        elements: data.elements,
        title: data.title,
        path: data.path,
        type: data.type,
        lastFetch: DateTime.now());
    _sphereData = lastData;
    await _writeBox(lastData);
  }

  // ignore: missing_return
  Future<SphereModel> getSectionData({String code, bool force = false}) async {
    final lastFetch = await getLastFetch(code);
    if (force) {
      await update(code);
    } else {
      if (lastFetch) {
        await update(code);
      }
      var ex = await isExists(code);
      if (ex) {
        _sphereData = await _readBox(code);
        notifyListeners();
      } else {
        await update(code);
      }
    }

    notifyListeners();
  }
}
