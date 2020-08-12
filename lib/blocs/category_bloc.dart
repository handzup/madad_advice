import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:madad_advice/models/category.dart';
import 'package:madad_advice/models/config.dart';
import 'package:madad_advice/models/langs.dart';
import 'package:madad_advice/utils/api_response.dart';
import 'package:madad_advice/utils/api_service.dart';

final restUrl = Config().resturl;

class CategoryBloc extends ChangeNotifier {
  APIResponse<List<MyCategory>> _sphereData;

  APIResponse<List<MyCategory>> get sphereData => _sphereData;
  ApiService apiService = ApiService();

  Future<List<MyCategory>> _readBox() async {
    final box = await Hive.openBox<MyCategory>('category');
    var secData = <MyCategory>[];
    for (var i = 0; i < box.length; i++) {
      secData.add(box.getAt(i));
    }
    // notifyListeners();
    return secData;
  }

  Future _writeBox(List<MyCategory> items) async {
    final openBox = await Hive.openBox<MyCategory>('category');
    await openBox.clear();
    for (var item in items) {
      await openBox.add(item);
    }
    //notifyListeners();
  }

  Future<bool> isExists() async {
    final openBox = await Hive.openBox<MyCategory>('category');
    var length = openBox.length;
    return length != 0;
  }

  Future<APIResponse<List<MyCategory>>> updateFromApi() async {
    return await apiService.fetchApiGetCategories();
  }

  Future<void> update() async {
    _sphereData = await updateFromApi();
    if (!_sphereData.error) {
      await _writeBox(_sphereData.data);
    }

    notifyListeners();
  }

  // ignore: missing_return
  Future<List<MyCategory>> getCategoryData({force = false}) async {
    if (force) {
      await update();
    } else {
      var ex = await isExists();
      if (ex) {
        _sphereData.data = await _readBox();
        notifyListeners();
      } else {
        await update();
      }
    }

    //notifyListeners();
  }
}
