import 'package:get/get.dart';

class Translation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'hello': 'Hello World',
          "settings.title": "Settings",
          "settings.language": "Language",
          "settings.currency": "Currency",
        },
        'de_DE': {
          'hello': 'Hallo Welt',
        },
        "zh_CN": {
          'hello': '你好世界',
          "settings.title": "设置",
          "settings.language": "语言",
          "settings.currency": "货币",
        },
      };
}
