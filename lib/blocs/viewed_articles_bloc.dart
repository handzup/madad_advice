
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:madad_advice/models/sphere_articel.dart';

const key = 'viewed';
class ViewedArticlesBloc extends ChangeNotifier {
 
  List<SphereArticle> _allArticles;
  List<SphereArticle> get allArticles => _allArticles;
 
  
  Future<List<SphereArticle>> _readBoxAll() async {
    final box = await Hive.openBox<SphereArticle>(key);
    var secData = <SphereArticle>[];
    for (var i = 0; i < box.length; i++) {
      secData.add(box.getAt(i));
    }
    return secData;
  }

  Future<SphereArticle> readBox(id) async {
    final box = await Hive.openBox<SphereArticle>(key);
    var secData = SphereArticle();
    secData = box.get(id);
    notifyListeners();
    return secData;
  }

  Future _writeBox(String id, SphereArticle item) async {
    final openBox = await Hive.openBox<SphereArticle>(key);
    await openBox.put(id, item);
    notifyListeners();
  }

 

  Future<bool> isExists(id) async {
    final openBox = await Hive.openBox<SphereArticle>(key);
    var length = openBox.length;
    if (length != 0) {
      return openBox.get(id) != null ? true : false;
    }
    return false;
  }
 

  Future getAllFiles() async {
    _allArticles = await _readBoxAll();
   notifyListeners();
  }

  Future writeArticle(id, item) async {
    await _writeBox(id, item);
  }
}
