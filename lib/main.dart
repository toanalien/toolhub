import 'package:flutter/material.dart';
import "package:get/get.dart";
import 'package:toolhub/services/storage.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import './i10n/translation.dart';
import './tabs.dart';
import './theme.dart';
import './widgets/login.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:trust_wallet_core/flutter_trust_wallet_core.dart';
// import 'package:trust_wallet_core/trust_wallet_core.dart';
// import 'package:trust_wallet_core_lib/trust_wallet_core_lib.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Duration backgroundLockLatency = const Duration(seconds: 30);

  await Storage.start();

  FlutterTrustWalletCore.init();

  // TrustWalletCoreLib.init();

  runApp(
    AppLock(
      builder: (args) => const ToolApp(),
      lockScreen: const LoginScreen(),
      backgroundLockLatency: backgroundLockLatency,
    ),
  );
}

class ToolApp extends StatelessWidget {
  const ToolApp({Key? key}) : super(key: key);

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
      home: AppLocker(
        child: const BottomBar(),
      ),
    );
  }
}
