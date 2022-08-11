import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';

class Preference {
  static late SharedPreferences prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static remove(key) async {
    await prefs.remove(key);
  }

  Preference();
}

class IApp {
  // secure 设置
  bool sercure;
  // language
  String language;
  // dark/light theme
  String theme;

  IApp({this.sercure = false, this.language = 'en', this.theme = 'light'});
}

class IWallet {}

class Storage {
  static start() async {
    await Future.wait([
      Hive.openBox('app'),
      Hive.openBox('wallet'),
      Hive.openBox('dapps'),
      Hive.openBox('data'),
      Preference.init()
    ]);
  }

  static Box get app => Hive.box('app');
  // 数组形式
  static Box get wallet => Hive.box('wallet');
  // 数组形式
  static Box get dapps => Hive.box('dapps');
  // 对象形式
  static Box get data => Hive.box('data');
}
