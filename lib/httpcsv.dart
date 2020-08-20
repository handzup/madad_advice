import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';

import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

//
// load example/resources/langs/langs.csv
//

class CsvAssetLoader extends AssetLoader {
  CSVParser csvParser;
  Future<String> getPath(url) async {
    var result = await (Connectivity().checkConnectivity());
    var filesDirectory = await getApplicationDocumentsDirectory();
    var dioresult;

    var fullPath = filesDirectory.path + '/langs.csv';
    if (result == ConnectivityResult.none) {
      dioresult = await rootBundle.loadString('resources/langs/langs.csv');
    } else {
      dioresult = await Dio().download(url, fullPath).then((value) async {
        File file = File(fullPath);
        return await file.readAsString();
      });
    }

    return dioresult;
  }

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    if (csvParser == null) {
      log('easy localization loader: load csv file $path');
      csvParser = CSVParser(await getPath(path));
    } else {
      log('easy localization loader: CSV parser already loaded, read cache');
    }
    return csvParser.getLanguageMap(locale.toString());
  }
}

class CSVParser {
  final String fieldDelimiter;
  final String strings;
  final List<List<dynamic>> lines;

  CSVParser(this.strings, {this.fieldDelimiter = ','})
      : lines = CsvToListConverter()
            .convert(strings, fieldDelimiter: fieldDelimiter);

  List getLanguages() {
    return lines.first.sublist(1, lines.first.length);
  }

  Map<String, dynamic> getLanguageMap(String localeName) {
    final indexLocale = lines.first.indexOf(localeName);

    var translations = <String, dynamic>{};
    for (var i = 1; i < lines.length; i++) {
      translations.addAll({lines[i][0]: lines[i][indexLocale]});
    }
    return translations;
  }
}
