import 'dart:developer';
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
                log("onPageFinished: (String $url)");
                _checkForCompletion(url);
              },
              onNavigationRequest: (NavigationRequest request) {
                return NavigationDecision.navigate;
              },
              onWebResourceError: (WebResourceError error) {
                // don't mark as failed here, just hide loader
                setState(() => isLoading = false);
              },
            ),
          )
          ..loadRequest(Uri.parse(widget.verificationUrl));
  }

  void _checkForCompletion(String url) {
    log("_checkForCompletion(String url)");

    log("_isCompletionUrl(url)");
    _handleVerificationSuccess(url);
  }

  void _handleVerificationSuccess(String url) {
    log("HANDLE VERIFICATION SUCCESS");
    log('splitUrl $url');
    log(
      ' Succes url: https://beekind-backend.deployment-uat.com/api/v1/veriff/callback}',
    );
    try {
      final splitUrl = url.split('?');
      log('splitUrl $splitUrl');
      log(
        ' Succes url: https://beekind-backend.deployment-uat.com/api/v1/veriff/callback}',
      );
      if (splitUrl[0] ==
          "https://beekind-backend.deployment-uat.com/api/v1/veriff/callback") {
        Navigator.of(context).pop();
      }
    } catch (e) {
      Navigator.of(context).pop();
    }
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
