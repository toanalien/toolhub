import 'package:flutter/material.dart';
import 'package:toolhub/theme.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:io';
import 'package:wallet_connect/wallet_connect.dart';

class Browser extends StatefulWidget {
  final String url;
  const Browser({Key? key, required this.url}) : super(key: key);

  @override
  State<Browser> createState() => _BrowserState();
}

class _BrowserState extends State<Browser> {
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
      onWebViewCreated: (controller) {
        print('created');
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
