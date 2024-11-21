import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewScreen extends StatefulWidget {
  final String url;

  const WebViewScreen({super.key, required this.url});

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late InAppWebViewController _webViewController;
  late PullToRefreshController _pullToRefreshController;

  @override
  void initState() {
    super.initState();
    _pullToRefreshController = PullToRefreshController(
      onRefresh: () async {
        // Reload WebView when the user pulls to refresh
        _webViewController.reload();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ข่าวเต็ม'),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri(widget.url), // Use WebUri directly with the string URL
        ),
        onWebViewCreated: (InAppWebViewController controller) {
          _webViewController = controller;
        },
        pullToRefreshController: _pullToRefreshController,
        onLoadStart: (InAppWebViewController controller, Uri? url) {
          // When loading starts
          print("เริ่มโหลด URL: $url");
        },
        onLoadStop: (InAppWebViewController controller, Uri? url) async {
          // When loading stops
          _pullToRefreshController.endRefreshing();
        },
        onProgressChanged: (InAppWebViewController controller, int progress) {
          // While loading (show progress)
          print("ความคืบหน้า: $progress%");
        },
      ),
    );
  }
}
