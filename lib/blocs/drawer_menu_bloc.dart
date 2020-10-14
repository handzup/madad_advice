import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/config.dart';
import '../models/menu.dart';
import '../utils/api_response.dart';
import '../utils/api_service.dart';
import 'internet_bloc.dart';

final restUrl = Config().resturl;

class DrawerMenuBloc extends ChangeNotifier {
  APIResponse<List<Menu>> _menuData = APIResponse(data: []);
  APIResponse<List<Menu>> get menuData => _menuData;
  // bool _hasError = false;
  // bool get hasError => _hasError;
  ApiService apiService = ApiService();
  //var box = locator<MenuHive>();

  Future<APIResponse<List<Menu>>> updateFromApi() async {
    return await apiService.fetchApiGetMenu();
  }
 Future<List<Menu>> _readBox() async {
    final box = await Hive.openBox<Menu>('menu');
    var secData = <Menu>[];
    for (var i = 0; i < box.length; i++) {
      secData.add(box.getAt(i));
    }
    return secData;
  }

  // Future<List<Menu>> _readBox() async {
  //   if (hiveIsOpen()) {
  //     var secData = <Menu>[];
  //     for (var i = 0; i < box.box.length; i++) {
  //       secData.add(box.box.getAt(i));
  //     }
  //     return secData;
  //   } else {
  //     // openBox();
  //   }
  // }

  // bool hiveIsOpen() {
  //   final dasd = Hive.isBoxOpen('menu');
  //   print('dasrt $dasd');
  //   return Hive.isBoxOpen('menu');
  // }
 Future<bool> isExists() async {
    final openBox = await Hive.openBox<Menu>('menu');
    int length = openBox.length;
    return length != 0;
  }
  // Future<bool> isExists() async {
  //   return box.box.length != 0;
  // }
  Future _writeBox(List<Menu> items) async {
    final openBox = await Hive.openBox<Menu>('menu');
    for (var item in items) {
      openBox.put(item.path.hashCode, item);
    }
  }

  // Future _writeBox(List<Menu> items) async {
  //   if (hiveIsOpen()) {
  //     for (var item in items) {
  //       box.box.put(item.path.hashCode, item);
  //     }
  //   } else {
  //     // openBox();
  //   }
  // }

  Future<void> update() async {
    _menuData = null;
    final data = await updateFromApi();

    if (!data.error && data?.data?.isNotEmpty) {
      _menuData = data;
      _writeBox(data.data);
      notifyListeners();
    }
  }

  Future<bool> checkInterner() async {
    final InternetBloc internetBloc = InternetBloc();
    await internetBloc.checkInternet();
    return internetBloc.hasInternet;
  }

  Future<List<Menu>> getFromHive() async {
    if (await isExists()) {
      _menuData = APIResponse(data: await _readBox());
      notifyListeners();
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
