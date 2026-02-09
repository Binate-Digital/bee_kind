import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class StripeOnboardingWebView extends StatefulWidget {
  final String onboardingUrl;

  /// Optional: Stripe return/refresh URLs you configured when creating the account link
  final String? returnUrl;
  final String? refreshUrl;

  const StripeOnboardingWebView({
    super.key,
    required this.onboardingUrl,
    this.returnUrl,
    this.refreshUrl,
  });

  @override
  State<StripeOnboardingWebView> createState() => _StripeOnboardingWebViewState();
}

class _StripeOnboardingWebViewState extends State<StripeOnboardingWebView> {
  late final WebViewController _controller;

  int _progress = 0;
  bool _isLoading = true;

  // React Native userAgent you provided
  static const String _iosSafariUserAgent =
      "Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) "
      "AppleWebKit/605.1.15 (KHTML, like Gecko) "
      "Version/14.0 Mobile Safari/604.1";

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
    // ✅ javaScriptEnabled={true}
      ..setJavaScriptMode(JavaScriptMode.unrestricted)

    // ✅ userAgent="..."
      ..setUserAgent(_iosSafariUserAgent)

      ..setBackgroundColor(Colors.white)

    // ✅ originWhitelist={['*']} equivalent (handled here)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            setState(() {
              _progress = progress;
              _isLoading = progress < 100;
            });
          },
          onPageStarted: (url) {
            setState(() => _isLoading = true);
            _handleStripeRedirects(url);
          },
          onPageFinished: (url) {
            setState(() => _isLoading = false);
            _handleStripeRedirects(url);
          },
          onWebResourceError: (error) {
            debugPrint("WebView error: ${error.description}");
          },
          onNavigationRequest: (request) async {
            final url = request.url;

            // Handle Stripe redirects (return/refresh) if present
            if (_handleStripeRedirects(url)) {
              return NavigationDecision.prevent;
            }

            // Allow normal http/https inside the webview (this is the core of originWhitelist-like behavior)
            if (url.startsWith("https://") || url.startsWith("http://")) {
              return NavigationDecision.navigate;
            }

            // Open other schemes externally: mailto:, tel:, intent:, whatsapp:, etc.
            final uri = Uri.tryParse(url);
            if (uri != null && await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
              return NavigationDecision.prevent;
            }

            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.onboardingUrl));
  }

  /// Returns true if we consumed navigation (e.g., close screen).
  bool _handleStripeRedirects(String url) {
    final returnUrl = widget.returnUrl;
    final refreshUrl = widget.refreshUrl;

    if (returnUrl != null && url.startsWith(returnUrl)) {
      Navigator.of(context).pop(true); // completed
      return true;
    }

    if (refreshUrl != null && url.startsWith(refreshUrl)) {
      Navigator.of(context).pop(false); // needs refresh/regenerate link
      return true;
    }

    return false;
  }

  Future<bool> _onWillPop() async {
    // Android back button: go back inside webview if possible
    if (Platform.isAndroid) {
      final canGoBack = await _controller.canGoBack();
      if (canGoBack) {
        await _controller.goBack();
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Stripe Onboarding"),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => _controller.reload(),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(3),
            child: _isLoading
                ? LinearProgressIndicator(value: _progress / 100.0)
                : const SizedBox(height: 3),
          ),
        ),
        body: WebViewWidget(controller: _controller),
      ),
    );
  }
}
