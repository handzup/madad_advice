import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:madad_advice/models/config.dart';
import 'package:madad_advice/models/langs.dart';
import 'dart:convert';
import 'package:madad_advice/models/menu.dart';

import 'package:madad_advice/utils/api_response.dart';
import 'package:madad_advice/utils/api_service.dart';
import 'package:madad_advice/utils/locator.dart';
final restUrl = Config().resturl;

class DrawerMenuBloc extends ChangeNotifier {
  List<Menu> _menuData;
  List<Menu> get menuData => _menuData;
  bool _hasError = false;
  bool get hasError => _hasError;
  ApiService apiService = ApiService();
  var lang = locator<Langs>();

  Future<List<Menu>> updateFromApi() async {
    var data = <Menu>[];
    final result = await apiService
        .fetch('$restUrl/mobapi.getmenu');
    if (result != null) {
      _hasError = false;
      result['result'][lang.lang.toString()].forEach((item) {
        data.add(Menu.fromJson(item));
      });
      return data;
    }
    _hasError = true;
    return data;
  }

  // ignore: missing_return
  Future<List<Menu>> getMenuData() async {
    _hasError = false;
    _menuData = await updateFromApi();
    notifyListeners();
  }
}
