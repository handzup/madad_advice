import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:madad_advice/blocs/internet_bloc.dart';
import 'package:madad_advice/models/config.dart';
import 'package:madad_advice/models/langs.dart';
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
    final openBox =
        await Hive.openBox<Section>('section').then((value) => value.length);

    return openBox != 0;
  }

  Future _writeBox(List<Section> items) async {
    final openBox = await Hive.openBox<Section>('section');
    openBox.clear();
    for (var item in items) {
      openBox.add(item);
    }
  }

  Future<APIResponse<List<Section>>> updateFromApi() async {
    return await apiService.fetchApiGetSections();
  }

  Future<void> update() async {
    final data = await updateFromApi();

    _sectionData = APIResponse(
        data: data.data ?? [],
        error: data.error,
        errorMessage: data.errorMessage);
    // ignore: null_aware_in_logical_operator
    if (!data.error && data?.data?.isNotEmpty) _writeBox(data.data);
  }

  Future<List<Section>> getFromHive() async {
    final ex = await isExists();
    if (ex) {
      _sectionData.data = await _readBox();
    } else {
      _sectionData.data = await _readBox();
      print(_sectionData.data);
      await update();
    }
  }

  Future<bool> checkInterner() async {
    final InternetBloc internetBloc = InternetBloc();
    await internetBloc.checkInternet();
    return internetBloc.hasInternet;
  }

  APIResponse<List<Section>> _sectionData = APIResponse(data: []);
  APIResponse<List<Section>> get sectionData => _sectionData;
  // ignore: missing_return
  Future<List<Section>> getSectionData({force = false}) async {
    if (force && await checkInterner()) {
      await update();
    } else {
      await getFromHive();
    }

    notifyListeners();
  }
}
