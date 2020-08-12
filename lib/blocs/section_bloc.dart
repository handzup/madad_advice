import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:madad_advice/models/config.dart';
import 'package:madad_advice/models/langs.dart';
import 'dart:convert';
import 'package:madad_advice/models/section.dart';
import 'package:madad_advice/utils/api_response.dart';

import 'package:madad_advice/utils/api_service.dart';
import 'package:madad_advice/utils/locator.dart';

final restUrl = Config().resturl;

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

  Future<APIResponse<List<Section>>> updateFromApi() async {
    return await apiService.fetchApiGetSections();
  }

  APIResponse<List<Section>> _sectionData;
  APIResponse<List<Section>> get sectionData => _sectionData;
  // ignore: missing_return
  Future<List<Section>> getSectionData({force = false}) async {
    if (force) {
      _sectionData = await updateFromApi();
      if (!_sectionData.error) _writeBox(_sectionData.data);
    } else {
      bool ex = await isExists();
      if (ex) {
        _sectionData.data = await _readBox();
      } else {
        _sectionData = await updateFromApi();
        if (!_sectionData.error) _writeBox(_sectionData.data);
      }
    }

    notifyListeners();
  }
}
