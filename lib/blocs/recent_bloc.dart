import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
import 'package:madad_advice/models/sphere.dart';

import 'package:madad_advice/utils/api_service.dart';

const key = 'recent';

class RecentDataBloc extends ChangeNotifier {
  SphereModel _recentData;

  SphereModel get recentData => _recentData;
  var apiService = ApiService();
  Duration _cacheValidDuration;
  RecentDataBloc() {
    _cacheValidDuration = Duration(minutes: 5);
  }
  Future<SphereModel> _readBox() async {
    final box = await Hive.openBox<SphereModel>(key);
    SphereModel secData = SphereModel();
    secData = box.getAt(0);
    //notifyListeners();
    return secData;
  }

  Future _writeBox(SphereModel item) async {
    final openBox = await Hive.openBox<SphereModel>(key);
    openBox.clear();

    //final arKey = item.path.toString();
    openBox.add(item);

    // notifyListeners();
  }

  Future<bool> isExists() async {
    final openBox = await Hive.openBox<SphereModel>(key);
    int length = openBox.length;
    return length != 0;
  }

  Future<bool> getLastFetch() async {
    final box = await Hive.openBox<SphereModel>(key);
    SphereModel secData = SphereModel();
    if (box.length > 0) {
      secData = box.getAt(0);
      if (secData != null) {
        return secData.lastFetch
            .isBefore(DateTime.now().subtract(_cacheValidDuration));
      }
    }

    // notifyListeners();
    return false;
  }

  Future<SphereModel> updateFromApi() async {
    SphereModel data = SphereModel();
    final result = await apiService.fetch(
        'https://madad.4u.uz/rest/1/e0mnf0e1a2f0y88k/mobapi.lastelements');
    final jsonData = json.decode(result);
    data = (SphereModel.fromJson(jsonData['result']));
    return data;
  }

  Future<void> update() async {
    final data = await updateFromApi();
    final lastData = SphereModel(
        elements: data.elements,
        title: data.title,
        path: data.path,
        type: data.type,
        lastFetch: DateTime.now());
    _recentData = lastData;
    _writeBox(lastData);
  }

  // ignore: missing_return
  Future<SphereModel> getRecentData({bool force = false}) async {
    final lastFetch = await getLastFetch();
    if (force) {
      await update();
    } else {
      if (lastFetch) {
        await update();
      }
      bool ex = await isExists();
      if (ex) {
        _recentData = await _readBox();
        notifyListeners();
      } else {
        await update();
      }
    }

    notifyListeners();
  }

  var _filteredData;
  List get filteredData => _filteredData;
  void afterSearch(value) {
    _filteredData = _recentData.elements
        .where((u) => (u.title.toLowerCase().contains(value.toLowerCase())))
        .toList();

    notifyListeners();
  }
}
