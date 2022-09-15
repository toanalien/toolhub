# toolhub

A new Flutter project.

## 图标生成

```
flutter pub run flutter_launcher_icons:main
```

## 生成 Model

```
flutter packages pub run json_model
```

## 升级

https://pub.dev/packages/flutter_update_dialog

  install_plugin_v2: ^1.0.0
  flutter_update_dialog: ^2.0.0

## 语音助手

## 设置界面

https://pub.dev/packages/settings_ui

## 多语言

## Toast

## IM

## onBoarding

https://github.com/Pyozer/introduction_screen

## 本地认证

https://pub.dev/packages/local_auth

## 扫码

## Webview

    flutter_inappwebview: ^5.4.3+7

地址: https://pub.flutter-io.cn/packages/flutter_inappwebview
初始化: https://inappwebview.dev/docs/get-started/setup-ios/


## 分享

share_plus: ^4.0.10

https://pub.dev/packages/share_plus

## Nginx 多应用

```
location ~* ^\/(\w+) {
    root /publish_webapp/;
    index index.html;
    try_files $uri $uri/ $uri/index.html /$1/ /$1/index.html;
}
```
## Wallet_Connect

https://pub.dev/packages/wallet_connect

- USDT: 
0x1a106986c0b44b48a03a30d278a06ae7717f54a8


## 命令
1. 执行 generator `flutter packages pub run build_runner build`
2. 


### Fix 
```
  cannot be marked potentially unavailable with '@available'
        @available(iOS 14.0, *)
```
https://github.com/pichillilorenzo/flutter_inappwebview/commit/06f87e81c4f55b7b251a149ec0db60442bb351c3