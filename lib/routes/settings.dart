import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
        ),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            // title: Text('Common'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Icon(Icons.contact_page),
                title: Text('地址簿'),
                // value: Text('English'),
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.notifications),
                title: Text('通知'),
                // value: Text('English'),
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.help),
                title: Text('通知'),
                // value: Text('English'),
              ),
            ],
          ),
          SettingsSection(
            // title: Text('Common'),
            tiles: <SettingsTile>[
              SettingsTile(
                leading: Icon(Icons.language),
                title: Text('语言'),
                value: Text('English'),
              ),
              SettingsTile(
                leading: Icon(Icons.currency_bitcoin),
                title: Text('货币'),
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
}
