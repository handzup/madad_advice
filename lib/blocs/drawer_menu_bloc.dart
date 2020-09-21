import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

  // ignore: missing_return
  Future<List<Menu>> getMenuData() async {
    _menuData = await updateFromApi();
    notifyListeners();
  }
}
