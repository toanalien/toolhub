import 'package:flutter/material.dart';
import "package:get/get.dart";
import 'package:toolhub/storage.dart';
import './i10n/translation.dart';
import './tabs.dart';
import './theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Storage.start();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      translations: Translation(),
      locale: Get.deviceLocale, // translations will be displayed in that locale
      fallbackLocale: const Locale('en', 'US'),
      darkTheme: MTheme.darkTheme(context),
      theme: MTheme.lightTheme(context),
      themeMode:
          Storage.app.get("theme") == "dark" ? ThemeMode.dark : ThemeMode.light,
      home: const BottomBar(),
    );
  }
}
