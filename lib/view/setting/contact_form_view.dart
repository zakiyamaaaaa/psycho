import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ContactFormView extends StatefulWidget {
  const ContactFormView({Key? key}) : super(key: key);
  @override
  State<ContactFormView> createState() => _ContactFormViewState();
}

class _ContactFormViewState extends State<ContactFormView> {
  // late WebViewController controller; //WebViewを管理するコントローラー
  double progress = 0;

  @override
  void initState() {
    if (Platform.isAndroid) {
    }
    super.initState();
  }
  final controller = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..setBackgroundColor(const Color(0x00000000))
  ..setNavigationDelegate(
    NavigationDelegate(
      onProgress: (int progress) {
        //　CircleProgressIndicatorを更新
      },
      onPageStarted: (String url) {},
      onPageFinished: (String url) {},
      onWebResourceError: (WebResourceError error) {},
      onNavigationRequest: (NavigationRequest request) {
        if (request.url.startsWith('https://www.youtube.com/')) {
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
    ),
  )
  ..loadRequest(Uri.parse('https://docs.google.com/forms/d/e/1FAIpQLSfjYDRG0GXr2_EBSdg90Oe7XCf_oM4cBkHexanT8AyWD4CQkA/viewform?usp=sf_link'));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("お問い合わせフォーム"),),
      body: Container(
        child: WebViewWidget(controller: controller),
      ),
    );
    
  }
}