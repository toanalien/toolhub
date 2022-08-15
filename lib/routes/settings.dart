import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:local_auth/local_auth.dart';
import 'package:get/get.dart';
import 'package:toolhub/storage.dart';
import 'package:flutter/cupertino.dart';
import '../navigator.dart';
import './mine/help.dart';

const languages = {
  "en": "English",
  "zh": "中文",
};

const currencies = {
  "\$USD": "USD",
  '￥CNY': "CNY",
  '￥JPY': "JPY",
};

class SettingData extends StatefulWidget {
  final Widget child;
  const SettingData({Key? key, required this.child}) : super(key: key);

  @override
  State<SettingData> createState() => _SettingDataState();
}

Future getSetting() async {
  return [
    Preference.prefs.getString(PrefKeys.language),
    Preference.prefs.getString(PrefKeys.currency),
    Preference.prefs.getString(PrefKeys.theme),
  ];
}

class _SettingDataState extends State<SettingData> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getSetting(),
      builder: (context, snapshot) {
        return widget.child;
      },
    );
  }
}

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final LocalAuthentication auth = LocalAuthentication();
  late List<BiometricType> availableBiometrics;

  bool security = Preference.prefs.getBool(PrefKeys.security) ?? false;
  String currency = Preference.prefs.getString(PrefKeys.currency) ?? "\$USD";

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
                leading: Icon(Icons.notifications),
                title: Text('通知'),
                onPressed: (context) {
                  // authenticate();
                },
                // value: Text('English'),
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.help),
                title: Text('帮助'),
                onPressed: (context) {
                  MNavigator.push(
                    context,
                    (context, _) => const HelpPage(),
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
                onPressed: (BuildContext context) {
                  openSelector(context, languages, (key) {
                    Get.updateLocale(Locale(key));
                  });
                },
              ),
              SettingsTile(
                leading: Icon(Icons.currency_bitcoin),
                title: Text(
                  'settings.currency'.tr,
                  strutStyle: const StrutStyle(
                      forceStrutHeight: true, fontSize: 24, height: 1),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                value: Text(currency.substring(0, 1)),
                onPressed: ((context) {
                  openSelector(context, currencies, (key) {});
                }),
              ),
              SettingsTile.switchTile(
                onToggle: (value) {
                  // 关闭验证
                  setState(() {
                    security = value;
                  });
                  Preference.prefs.setBool(PrefKeys.security, value);
                },
                initialValue: security,
                leading: const Icon(Icons.format_paint),
                title: Text(
                  'settings.security'.tr,
                ),
              ),
            ],
          ),
          ...MoreSetting
        ],
      ),
    );
  }

  openSelector(
      BuildContext context, Map<String, String> languages, Function onSelect) {
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
                        onSelect(e.key);
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

var MoreSetting = [
  SettingsSection(
    title: Text('STATE RESTORATION TESTING'),
    tiles: [
      SettingsTile.switchTile(
        onToggle: (_) {},
        initialValue: false,
        title: Text(
          'Fast App Termination',
        ),
        description: Text(
          'Terminate instead of suspending apps when backgrounded to '
          'force apps to be relaunched when tray '
          'are foregrounded.',
        ),
      ),
    ],
  ),
  SettingsSection(
    title: Text('IAD DEVELOPER APP TESTING'),
    tiles: [
      SettingsTile.navigation(
        title: Text('Fill Rate'),
      ),
      SettingsTile.navigation(
        title: Text('Add Refresh Rate'),
      ),
      SettingsTile.switchTile(
        onToggle: (_) {},
        initialValue: false,
        title: Text('Unlimited Ad Presentation'),
      ),
    ],
  ),
];
