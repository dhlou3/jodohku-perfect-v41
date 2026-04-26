import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:jodohku_malaysia/src/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const JodohkuHybridApp());
}

class JodohkuHybridApp extends StatelessWidget {
  const JodohkuHybridApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jodohku Malaysia',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.proTheme,
      home: const HybridMainScreen(),
    );
  }
}

class HybridMainScreen extends StatefulWidget {
  const HybridMainScreen({super.key});

  @override
  State<HybridMainScreen> createState() => _HybridMainScreenState();
}

class _HybridMainScreenState extends State<HybridMainScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.background)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadFlutterAsset('assets/www/landing_preview.html');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}
