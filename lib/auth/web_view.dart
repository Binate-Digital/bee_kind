import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VeriffWebViewScreen extends StatefulWidget {
  final String verificationUrl;
  final String sessionId;

  const VeriffWebViewScreen({
    super.key,
    required this.verificationUrl,
    required this.sessionId,
  });

  @override
  State<VeriffWebViewScreen> createState() => _VeriffWebViewScreenState();
}

class _VeriffWebViewScreenState extends State<VeriffWebViewScreen> {
  late final WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    controller =
        WebViewController(
            onPermissionRequest: (WebViewPermissionRequest request) =>
                request.grant(),
          )
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(Colors.white)
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {},
              onPageStarted: (String url) {
                setState(() => isLoading = true);
              },
              onPageFinished: (String url) {
                setState(() => isLoading = false);
                _checkForCompletion(url);
              },
              onNavigationRequest: (NavigationRequest request) {
                // 🔥 Intercept the success URL and STOP navigation
                if (_isCompletionUrl(request.url)) {
                  _handleVerificationSuccess();
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
              onUrlChange: (UrlChange change) {
                final url = change.url ?? '';
                _checkForCompletion(url);
              },
              onWebResourceError: (WebResourceError error) {
                // don't mark as failed here, just hide loader
                setState(() => isLoading = false);
              },
            ),
          )
          ..loadRequest(Uri.parse(widget.verificationUrl));
  }

  bool _isCompletionUrl(String url) {
    // tweak this to match your actual redirect URL pattern
    final lower = url.toLowerCase();
    return lower.contains("success") ||
        lower.contains("completed") ||
        lower.contains("finished") ||
        lower.contains("thank-you");
  }

  void _checkForCompletion(String url) {
    if (_isCompletionUrl(url)) {
      _handleVerificationSuccess();
    }
  }

  void _handleVerificationSuccess() {
    if (!mounted) return;
    // You might also want to call your backend here to confirm session status
    Navigator.of(context).pop(true); // pass true back to previous screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Identity Verification"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
