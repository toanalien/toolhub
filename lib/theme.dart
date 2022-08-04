import 'package:flutter/material.dart';

class Config {
  static bool dark = true; // 是否为黑夜模式
  static ThemeData darkTheme = ThemeData.dark(); // 主题为暗色
  static ThemeData lightTheme = ThemeData(
    primaryColor: Colors.teal,
    splashColor: Colors.yellow,
    appBarTheme: const AppBarTheme(
      color: Colors.white,
    ),
  ); // 主题为暗色
}

Widget light(Widget child) {
  return Theme(
    data: Config.lightTheme,
    child: child,
  );
}
