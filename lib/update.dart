import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
// import 'package:install_plugin/install_plugin.dart';
import 'package:dio/dio.dart';

class Update {
  String _updateUrl =
      "https://raw.githubusercontent.com/newset/toolhub/master/version.json";

  void checkUpdate(BuildContext context) {
    // UpdateManager.checkUpdate(context, _updateUrl);
  }
}
