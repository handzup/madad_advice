import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:madad_advice/models/langs.dart';
import 'dart:convert';
import 'package:madad_advice/models/section.dart';

import 'package:madad_advice/utils/api_service.dart';
import 'package:madad_advice/utils/locator.dart';

class SectionBloc extends ChangeNotifier {
  ApiService apiService = ApiService();
  var lang = locator<Langs>();

  Future<List<Section>> _readBox() async {
    final box = await Hive.openBox<Section>('section');
    var secData = <Section>[];
    for (var i = 0; i < box.length; i++) {
      secData.add(box.getAt(i));
    }
    return secData;
  }

  Future<bool> isExists() async {
    final openBox = await Hive.openBox<Section>('section');
    int length = openBox.length;
    return length != 0;
  }

  Future _writeBox(List<Section> items) async {
    final openBox = await Hive.openBox<Section>('section');
    openBox.clear();
    for (var item in items) {
      openBox.add(item);
    }
    notifyListeners();
  }

  Future<List<Section>> updateFromApi() async {
    var data = <Section>[];
    final result = await apiService.fetch(
        'https://madad.4u.uz/rest/1/e0mnf0e1a2f0y88k/mobapi.getsections');
    result['result'][lang.lang.toString()].forEach((item) {
      data.add(Section.fromJson(item));
    });
    return data;
  }

  List<Section> _sectionData;
  List<Section> get sectionData => _sectionData;
  // ignore: missing_return
  Future<List<Section>> getSectionData({force = false}) async {
    if (force) {
      final data = await updateFromApi();
      _sectionData = data;
      _writeBox(data);
    } else {
      bool ex = await isExists();
      if (ex) {
        _sectionData = await _readBox();
      } else {
        final data = await updateFromApi();
        _sectionData = data;
        _writeBox(data);
      }
    }

    notifyListeners();
  }
}
