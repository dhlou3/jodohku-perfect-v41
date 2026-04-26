import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:jodohku_malaysia/src/theme/app_theme.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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

  Future<void> _handleGoogleLogin() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Inject token into WebView
        final String uid = user.uid;
        _controller.runJavaScript("localStorage.setItem('current_user_id', '$uid'); window.location.href='home_preview.html';");
      }
    } catch (e) {
      debugPrint("Login Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent("Mozilla/5.0 (Linux; Android 13) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Mobile Safari/537.36")
      ..addJavaScriptChannel(
        'AppBridge',
        onMessageReceived: (JavaScriptMessage message) {
          if (message.message == 'googleLogin') {
            _handleGoogleLogin();
          }
        },
      )
      ..setBackgroundColor(AppColors.background)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
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
