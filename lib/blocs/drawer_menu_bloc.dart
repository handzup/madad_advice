import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:madad_advice/blocs/internet_bloc.dart';
import 'package:madad_advice/models/config.dart';
import 'package:madad_advice/models/menu.dart';

import 'package:madad_advice/utils/api_response.dart';
import 'package:madad_advice/utils/api_service.dart';

final restUrl = Config().resturl;

class DrawerMenuBloc extends ChangeNotifier {
  APIResponse<List<Menu>> _menuData = APIResponse(data: []);
  APIResponse<List<Menu>> get menuData => _menuData;
  // bool _hasError = false;
  // bool get hasError => _hasError;
  ApiService apiService = ApiService();

  Future<APIResponse<List<Menu>>> updateFromApi() async {
    return await apiService.fetchApiGetMenu();
  }

  Future<List<Menu>> _readBox() async {
    final box = await Hive.openBox<Menu>('Menu');
    var secData = <Menu>[];
    for (var i = 0; i < box.length; i++) {
      secData.add(box.getAt(i));
    }
    return secData;
  }

  Future<bool> isExists() async {
    final openBox = await Hive.openBox<Menu>('Menu');
    int length = openBox.length;
    return length != 0;
  }

  Future _writeBox(List<Menu> items) async {
    final openBox = await Hive.openBox<Menu>('Menu');
    openBox.clear();
    for (var item in items) {
      openBox.add(item);
    }
  }

  Future<void> update() async {
    _menuData = null;
    final data = await updateFromApi();

    if (!data.error) {
      _menuData = data;
      _writeBox(data.data);
    }
  }

  Future<bool> checkInterner() async {
    final InternetBloc internetBloc = InternetBloc();
    await internetBloc.checkInternet();
    return internetBloc.hasInternet;
  }

  Future<List<Menu>> getFromHive() async {
    bool ex = await isExists();
    if (ex) {
      _menuData.data = await _readBox();
    } else {
      await update();
    }
  }

  // ignore: missing_return
  Future<List<Menu>> getMenuData() async {
    if (await checkInterner()) {
      await update();
    } else {
      await getFromHive();
    }

    notifyListeners();
  }
}
