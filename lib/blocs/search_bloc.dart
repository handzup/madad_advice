import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:madad_advice/models/config.dart';
import 'package:madad_advice/models/search_result.dart';

import 'package:madad_advice/utils/api_service.dart';
import 'package:madad_advice/models/sphere_articel.dart';

const key = 'articleById';
final restUrl = Config().resturl;

class SearchBloc extends ChangeNotifier {
  List<SearchResult> _searchData;
  bool _hasData = false;
  bool get hasData => _hasData;
  SphereArticle _article;

  SphereArticle get article => _article;
  List<SearchResult> get searchData => _searchData;

  var apiService = ApiService();

  Future<List<SearchResult>> search(value) async {
    var data = <SearchResult>[];
    final result =
        await apiService.fetch('$restUrl/mobapi.getelements?q=$value');
    result['result']['elements'].forEach((item) {
      data.add(SearchResult.fromJson(item));
    });
    _hasData = true;
    return data;
  }

  var _filteredData;
  List get filteredData => _filteredData;
  void afterSearch(String value) async {
    if (value != "" && value.length >= 3) {
      _searchData = await search(value);
      print(_searchData);
    }

    notifyListeners();
  }

  Future<SphereArticle> _readBox(String articleId) async {
    final box = await Hive.openBox<SphereArticle>(key);
    var article = SphereArticle();
    article = box.get(articleId);
    return article;
  }

  Future _writeBox(SphereArticle item) async {
    final openBox = await Hive.openBox<SphereArticle>(key);
    final arKey = item.id.toString();
    await openBox.put(arKey, item);
  }

  Future<bool> isExists(String articleId) async {
    final openBox = await Hive.openBox<SphereArticle>(key);
    var length = openBox.length;
    if (length != 0) {
      return openBox.get(articleId) != null ? true : false;
    }
    return false;
  }

  Future<SphereArticle> _getArticleFormApi(String code) async {
    final result =
        await apiService.fetch('$restUrl/mobapi.getelements?path=$code');
    var data = SphereArticle.fromJson(result['result']['elements'][0]);
    //     jsonData['result']['ru'].forEach((item) {
    //   data.add(SphereArticle.fromJson(item));
    // });
    await _writeBox(data);
    return data;
  }

  Future getArticle(String articleId, String code) async {
    if (await isExists(articleId)) {
      _article = await _readBox(articleId);
    } else {
      if (code != '') _article = await _getArticleFormApi(code);
    }
    notifyListeners();
  }
}
