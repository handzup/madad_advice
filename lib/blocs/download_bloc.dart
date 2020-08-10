import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:madad_advice/models/pinned_file.dart';

class DownloadBloc extends ChangeNotifier {
  List<String> _allPaths;
  List<String> get allPaths => _allPaths;
  List<PinnedFile> _allFiles;
  List<PinnedFile> get allFiles => _allFiles;
  String _size;
  String get size => _size;
  Future<List<PinnedFile>> _readBoxAll() async {
    final box = await Hive.openBox<PinnedFile>('downloads');
    var secData = <PinnedFile>[];
    for (var i = 0; i < box.length; i++) {
      secData.add(box.getAt(i));
    }
    return secData;
  }

  Future<PinnedFile> readBox(name) async {
    final box = await Hive.openBox<PinnedFile>('downloads');
    var secData = PinnedFile();
    secData = box.get(name.hashCode);
    notifyListeners();
    return secData;
  }

  Future _writeBox(String name, PinnedFile item) async {
    final openBox = await Hive.openBox<PinnedFile>('downloads');
    await openBox.put(name.hashCode, item);
    notifyListeners();
  }

  // ignore: missing_return
  Future<bool> removeAllFiles() async {
    allPaths.forEach((element) {
      var file = File(element);
      file.delete(recursive: true);
    });

    final openBox = await Hive.openBox<PinnedFile>('downloads');
    await openBox.clear();
    _allFiles = [];
    notifyListeners();
  }

  Future<bool> isExists(name) async {
    final openBox = await Hive.openBox<PinnedFile>('downloads');
    var length = openBox.length;
    if (length != 0) {
      return openBox.get(name.hashCode) != null ? true : false;
    }
    return false;
  }

  Future getSize() async {
    await getAllFiles();
    var size2 = 0.0;
    var allpath = <String>[];
    allFiles.forEach((element) {
      size2 += double.parse(element.size);
      allpath.add(element.path);
    });
    _allPaths = allpath;
    _size = (size2 / 1000000).toStringAsFixed(1);
  }

  Future getAllFiles() async {
    _allFiles = await _readBoxAll();
   notifyListeners();
  }

  Future writeFile(name, item) async {
    await _writeBox(name, item);
  }
}
