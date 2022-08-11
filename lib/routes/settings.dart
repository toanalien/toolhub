import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:local_auth/local_auth.dart';
import 'package:get/get.dart';
import './mine/help.dart';

const languages = {
  "en": "English",
  "zh": "中文",
};

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final LocalAuthentication auth = LocalAuthentication();
  late List<BiometricType> availableBiometrics;

  @override
  void initState() {
    super.initState();

    auth.getAvailableBiometrics().then((value) => availableBiometrics = value);
  }

  void authenticate() async {
    try {
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to show account balance',
      );
      print('auth result $didAuthenticate $availableBiometrics');
      // ···
    } on PlatformException {
      // ...
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'settings.title'.tr,
        ),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Icon(Icons.contact_page),
                title: Text('地址簿'),
                // value: Text('English'),
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.notifications),
                title: Text('通知'),
                onPressed: (context) {
                  authenticate();
                },
                // value: Text('English'),
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.help),
                title: Text('帮助'),
                onPressed: (context) {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          HelpPage(),
                    ),
                  );
                },
                // value: Text('English'),
              ),
            ],
          ),
          SettingsSection(
            // title: Text('Common'),
            tiles: <SettingsTile>[
              SettingsTile(
                leading: Icon(Icons.language),
                title: Text(
                  "settings.language".tr,
                  strutStyle: const StrutStyle(
                    forceStrutHeight: true,
                    fontSize: 24,
                    height: 1,
                  ),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                value: Text(languages[Get.locale!.languageCode]!),
                onPressed: openLanguage,
              ),
              SettingsTile(
                leading: Icon(Icons.currency_bitcoin),
                title: Text(
                  'settings.currency'.tr,
                  strutStyle: const StrutStyle(
                      forceStrutHeight: true, fontSize: 24, height: 1),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                value: Text('￥'),
              ),
              SettingsTile.switchTile(
                onToggle: (value) {},
                initialValue: true,
                leading: Icon(Icons.format_paint),
                title: Text('安全'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  openLanguage(context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: ((context) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: languages.entries
                  .map(
                    (e) => TextButton(
                      onPressed: () {
                        Get.updateLocale(Locale(e.key));
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Text(
                            e.value,
                            style: Theme.of(context).textTheme.bodyLarge,
                          )
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      }),
    );
  }
}
