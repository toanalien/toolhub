import 'package:flutter/material.dart';

class MTheme {
  static bool dark = true; // 是否为黑夜模式
  static ThemeData darkTheme(context) {
    return ThemeData.dark();
  } // 主题为暗色

  static ThemeData lightTheme(context) {
    return ThemeData(
      primaryColor: Colors.teal,
      splashColor: Colors.yellow,
      appBarTheme: const AppBarTheme(
        color: Colors.white,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18,
          // fontWeight: FontWeight.bold,
        ),
        // titleTextStyle: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  static InputDecoration input = InputDecoration(
    hintText: "Search...",
    hintStyle: TextStyle(color: Colors.grey.shade500),
    prefixIcon: Icon(
      Icons.search,
      color: Colors.grey.shade500,
      size: 20,
    ),
    filled: true,
    fillColor: Colors.grey.shade100,
    contentPadding: const EdgeInsets.all(8),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(40),
      borderSide: BorderSide(color: Colors.grey.shade100),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(40),
      borderSide: BorderSide(color: Colors.grey.shade100),
    ),
  ); // 主题为暗色
}

Widget light(
  BuildContext context,
  Widget child,
) {
  return Theme(
    data: MTheme.lightTheme(context),
    child: child,
  );
}
