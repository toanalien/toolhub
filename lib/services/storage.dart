import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PrefKeys {
  static String language = "app.language";
  static String currency = "app.currency";
  static String theme = "app.theme";
  static String security = "app.security";
}

class Preference {
  static late SharedPreferences prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    // 获取基础配置
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
    await Hive.initFlutter();

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
