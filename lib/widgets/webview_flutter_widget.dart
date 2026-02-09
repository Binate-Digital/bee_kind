import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OnboardingWebView extends StatefulWidget {
  final String url;

  const OnboardingWebView({super.key, required this.url});

  @override
  State<OnboardingWebView> createState() => _OnboardingWebViewState();
}

class _OnboardingWebViewState extends State<OnboardingWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // Initialize the WebViewPlatform (this is required in version 4.0.1)
    // WebViewWidget.platform = SurfaceAndroidWebView();

    // Create the WebViewController
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // Enable JavaScript
      ..setBackgroundColor(Colors.white) // Set background color
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {},
          onPageFinished: (url) {},
          onWebResourceError: (error) {},
        ),
      );

    // Load the URL with custom headers
    _controller.loadRequest(
      Uri.parse(widget.url),
      headers: {
        'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile Safari/604.1',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Vendor Onboarding",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: WebViewWidget(controller: _controller), // WebView widget
    );
  }
}
