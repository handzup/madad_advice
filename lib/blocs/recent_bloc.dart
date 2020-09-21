import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:madad_advice/models/config.dart';
import 'package:madad_advice/models/sphere.dart';
import 'package:madad_advice/utils/api_response.dart';

import 'package:madad_advice/utils/api_service.dart';

const key = 'recent';
final restUrl = Config().resturl;

class RecentDataBloc extends ChangeNotifier {
  APIResponse<SphereModel> _recentData =
      APIResponse(data: SphereModel(elements: []));

  APIResponse<SphereModel> get recentData => _recentData;
  var apiService = ApiService();
  Duration _cacheValidDuration;
  RecentDataBloc() {
    _cacheValidDuration = Duration(minutes: 5);
  }
  Future<SphereModel> _readBox() async {
    final box = await Hive.openBox<SphereModel>(key);
    SphereModel secData = SphereModel();
    secData = box.getAt(0);
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

  Future<APIResponse<SphereModel>> updateFromApi() async {
    return await apiService.fetchApiGetRecent();
  }

  Future<void> update() async {
    final data = await updateFromApi();

    _recentData = APIResponse(
        data: data.data ?? SphereModel(elements: []),
        error: data.error,
        errorMessage: data.errorMessage);
    if (!data.error) _writeBox(data.data);
  }

  // ignore: missing_return
  Future<SphereModel> getRecentData({bool force = false}) async {
    if (force) {
      await update();
    } else {
      bool ex = await isExists();
      if (ex) {
        _recentData = APIResponse(data: await _readBox());
        notifyListeners();
      } else {
        await update();
      }
    }

    notifyListeners();
  }

  // var _filteredData;
  // List get filteredData => _filteredData;
  // void afterSearch(value) {
  //   _filteredData = _recentData.elements
  //       .where((u) => (u.title.toLowerCase().contains(value.toLowerCase())))
  //       .toList();

  //   notifyListeners();
  // }
}
