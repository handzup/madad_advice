import 'package:hive/hive.dart';

class Langs {
  String _lang;

  String get lang => _lang;
  void setLang(String name) {
    _lang = name;
  }
}

class SectionHive {
  SectionHive() {
    openBox();
  }
  Box box;

  void openBox() async {
    await Hive.openBox('section');
    box = Hive.box('section');
  }
}

class MenuHive {
  MenuHive() {
    openBox();
  }
  Box box;

  void openBox() async {
    await Hive.openBox('menu');
    box = Hive.box('menu');
  }
}
