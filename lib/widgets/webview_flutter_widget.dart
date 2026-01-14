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

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {},
          onPageFinished: (url) {},
          onWebResourceError: (error) {},
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Vendor Onboarding",style: TextStyle(color: Colors.black),),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
