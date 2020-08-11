
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:madad_advice/models/category.dart';
import 'package:madad_advice/models/langs.dart';
import 'dart:convert';
import 'package:madad_advice/utils/api_service.dart';
import 'package:madad_advice/utils/locator.dart';

class CategoryBloc extends ChangeNotifier {
  var lang = locator<Langs>();
  List<MyCategory> _sphereData;

  List<MyCategory> get sphereData => _sphereData;
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

  Future<List<MyCategory>> updateFromApi() async {
    var data = <MyCategory>[];
    final result = await apiService
        .fetch('https://madad.4u.uz/rest/1/e0mnf0e1a2f0y88k/mobapi.getscopes');
     result['result'][lang.lang.toString()].forEach((item) {
      data.add(MyCategory.fromJson(item));
    });
    return data;
  }

  Future<void> update() async {
    final data = await updateFromApi();
    _sphereData = data;
    await _writeBox(data);
    notifyListeners();
  }

  // ignore: missing_return
  Future<List<MyCategory>> getCategoryData({force = false}) async {
    if (force) {
      await update();
    } else {
      var ex = await isExists();
      if (ex) {
        _sphereData = await _readBox();
        notifyListeners();
      } else {
        await update();
      }
    }

    //notifyListeners();
  }
}
