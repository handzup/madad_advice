import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:madad_advice/models/menu.dart';

import 'package:madad_advice/utils/api_response.dart';
import 'package:madad_advice/utils/api_service.dart';

class DrawerMenuBloc extends ChangeNotifier {
  List<Menu> _menuData;
  List<Menu> get menuData => _menuData;
  ApiService apiService = ApiService();

  Future<List<Menu>> updateFromApi() async {
    var data = <Menu>[];
    final result = await apiService
        .fetch('https://madad.4u.uz/rest/1/e0mnf0e1a2f0y88k/mobapi.getmenu');
    final jsonData = json.decode(result);
    jsonData['result']['ru'].forEach((item) {
      data.add(Menu.fromJson(item));
    });
    return data;
  }

  // ignore: missing_return
  Future<APIResponse<List<Menu>>> getMenuData() async {
    _menuData = await updateFromApi();
    notifyListeners();
  }
}
