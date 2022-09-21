import 'dart:collection';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:toolhub/theme.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:io';
import 'package:wallet_connect/wallet_connect.dart';
import 'package:web3_provider/js_bridge_callback_bean.dart';
import 'package:web3_provider/json_util.dart';

mixin Web3ProviderMixin<T extends StatefulWidget> on State<T> {
  final _alertTitle = "messagePayTube";

  String? jsProviderScript;

  /// Function initial web3
  String? functionInject;

  /// Load provider and function initial web3 end
  bool isLoadJs = true;

  ///Load provider and function initial web3 to inject web app
  Future<void> _loadWeb3() async {
    String? web3;
    String? walletName = 'trustwallet';
    String path = 'packages/web3_provider/assets/trust-min.js';
    web3 = await DefaultAssetBundle.of(context).loadString(path);
    int chainId = 1;
    String rpcUrl = "";
    String walletAddress = "";
    bool isDebug = true;
    var config = """
         (function() {
           var config = {
                chainId: $chainId,
                rpcUrl: "$rpcUrl",
                address: "$walletAddress",
                isDebug: $isDebug
            };
            window.isWeb3chat = true;
            window.ethereum = new $walletName.Provider(config);
            window.web3 = new $walletName.Web3(window.ethereum);
            $walletName.postMessage = (jsonString) => {
               alert("$_alertTitle" + JSON.stringify(jsonString || "{}"))
            };

            console.log("ok: ", ethereum, web3);
        })();
        """;
    if (mounted) {
      setState(() {
        jsProviderScript = web3;
        functionInject = config;
        isLoadJs = true;
      });
    }
  }

  /// Callback handle data receive from dapp
  Future<void> _jsBridgeCallBack(
      String message, InAppWebViewController controller) async {
    Map<dynamic, dynamic> params = JsonUtil.getObj(message);
    final name = params["name"];
    final id = params["id"];
    log('bridge call: $name, $params');

    // BridgeParams
    switch (name) {
      case 'requestAccounts':
      case 'eth_requestAccounts':
        // widget.signCallback(rawData, EIP1193.requestAccounts, _webViewController);
        break;
      case 'signTransaction':
        break;
      case 'signMessage':
        break;
      case 'signPersonalMessage':
        break;
      case 'signTypedMessage':
        break;
      case 'request':
        break;
      default:
    }

    controller.cancel(id);
  }
}

class Browser extends StatefulWidget {
  final String url;
  const Browser({Key? key, required this.url, this.initialUserScripts})
      : super(key: key);

  final UnmodifiableListView<UserScript>? initialUserScripts;

  @override
  State<Browser> createState() => _BrowserState();
}

class _BrowserState extends State<Browser> with Web3ProviderMixin {
  final GlobalKey webViewKey = GlobalKey();

  String title = "";

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
    ),
  );

  late PullToRefreshController pullToRefreshController;

  double progress = 0;

  late Uri _uri;

  final wcClient = WCClient(
    onConnect: () {
      // Respond to connect callback
    },
    onDisconnect: (code, reason) {
      // Respond to disconnect callback
      print('code: $code, reason: $reason');
    },
    onFailure: (error) {
      // Respond to connection failure callback
    },
    onSessionRequest: (id, peerMeta) {
      // Respond to connection request callback
    },
    onEthSign: (id, message) {
      // Respond to personal_sign or eth_sign or eth_signTypedData request callback
    },
    onEthSendTransaction: (id, tx) {
      // Respond to eth_sendTransaction request callback
    },
    onEthSignTransaction: (id, tx) {
      // Respond to eth_signTransaction request callback
    },
  );

  @override
  void initState() {
    _loadWeb3();
    super.initState();

    setState(() {
      _uri = Uri.parse(widget.url);
    });

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.teal,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  Widget buildBrowser() {
    return InAppWebView(
      key: webViewKey,
      initialUrlRequest: URLRequest(
        url: _uri,
      ),
      initialUserScripts: (isLoadJs == true
          ? UnmodifiableListView([
              UserScript(
                source: jsProviderScript ?? '',
                injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
              ),
              UserScript(
                source: functionInject ?? '',
                injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
              ),
            ])
          : null),
      onWebViewCreated: (controller) {
        print('created');
      },
      onJsAlert: (controller, request) {
        final message = request.message;
        bool handledByClient = false;
        if (message?.contains(_alertTitle) == true) {
          handledByClient = true;
          _jsBridgeCallBack(
            request.message!.replaceFirst(_alertTitle, ""),
            controller,
          );
        }

        return Future.value(
          JsAlertResponse(
            message: message ?? "",
            handledByClient: handledByClient,
          ),
        );
      },
      pullToRefreshController: pullToRefreshController,
      onLoadStop: (controller, url) async {
        pullToRefreshController.endRefreshing();
        controller.getTitle().then((value) {
          print('title: $value');
          setState(() {
            title = value ?? "";
          });
        });
      },
      onLoadStart: (controller, url) async {
        // if (Platform.isAndroid) {
        await controller.evaluateJavascript(
          source: jsProviderScript ?? '',
        );
        await controller.evaluateJavascript(
          source: functionInject ?? '',
        );
        // }
      },
      onProgressChanged: (controller, progress) {
        if (progress == 100) {
          pullToRefreshController.endRefreshing();
        }
        setState(() {
          this.progress = progress / 100;
        });
      },
      onConsoleMessage: (controller, consoleMessage) {
        print(consoleMessage);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(title),
      ),
      body: SafeArea(
        // top: false,
        child: Column(
          children: [
            progress < 1.0
                ? LinearProgressIndicator(
                    value: progress,
                    color: Colors.teal,
                    backgroundColor: Colors.teal.shade100,
                  )
                : Container(),
            Expanded(
              child: buildBrowser(),
            ),
            // buildLocationBar(),
          ],
        ),
      ),
    );
  }

  Padding buildLocationBar() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 12.0,
        right: 12.0,
        top: 8.0,
        bottom: 8.0,
      ),
      child: TextField(
        decoration: MTheme.input.copyWith(
          hintText: '请输入地址',
          suffixIcon: IconButton(
            onPressed: () {
              webViewController?.reload();
            },
            icon: const Icon(
              Icons.refresh,
            ),
          ),
        ),
        keyboardType: TextInputType.url,
        onSubmitted: (value) {
          setState(() {
            _uri = Uri.parse(value);
          });
          webViewController?.loadUrl(urlRequest: URLRequest(url: _uri));
        },
      ),
    );
  }
}
