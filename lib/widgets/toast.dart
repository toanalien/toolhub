import 'package:flutter/material.dart';

const DEFAULT_TOAST_DURATION = Duration(seconds: 2);
const DEFAULT_TOAST_COLOR = Color(0xFF424242);

class ToastUtils {
  ToastUtils._internal();

  ///全局初始化Toast配置, child为MaterialApp
  static init(Widget child) {}

  static void toast(String msg,
      {Duration duration = DEFAULT_TOAST_DURATION,
      Color color = DEFAULT_TOAST_COLOR}) {}

  static void waring(String msg,
      {Duration duration = DEFAULT_TOAST_DURATION}) {}

  static void error(String msg, {Duration duration = DEFAULT_TOAST_DURATION}) {}

  static void success(String msg,
      {Duration duration = DEFAULT_TOAST_DURATION}) {}
}
