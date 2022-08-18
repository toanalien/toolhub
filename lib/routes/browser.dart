import 'package:flutter/material.dart';
import 'package:toolhub/theme.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:io';

class Browser extends StatefulWidget {
  const Browser({Key? key}) : super(key: key);

  @override
  State<Browser> createState() => _BrowserState();
}

class _BrowserState extends State<Browser> {
  final GlobalKey webViewKey = GlobalKey();

  Uri url = Uri.parse('http://127.0.0.1:8000');
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

  @override
  void initState() {
    super.initState();

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
        url: url,
      ),
      onWebViewCreated: (controller) {
        webViewController = controller;
      },
      pullToRefreshController: pullToRefreshController,
      onLoadStop: (controller, url) async {
        pullToRefreshController.endRefreshing();
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
      ),
      body: SafeArea(
        // top: false,
        child: Column(
          children: [
            Expanded(
              child: buildBrowser(),
            ),
            progress < 1.0
                ? LinearProgressIndicator(
                    value: progress,
                    color: Colors.teal,
                    backgroundColor: Colors.teal.shade100,
                  )
                : Container(),
            buildLocationBar(),
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
            url = Uri.parse(value);
          });
          webViewController?.loadUrl(urlRequest: URLRequest(url: url));
        },
      ),
    );
  }
}
