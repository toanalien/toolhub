import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import './tabs.dart';
import './theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        // 本地化的代理类
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'), // 美国英语
        Locale('zh', 'CN'), // 中文简体
        //其它Locales
      ],
      darkTheme: Config.darkTheme,
      theme: Config.lightTheme,
      themeMode: ThemeMode.system,
      home: const BottomBar(),
    );
  }
}
