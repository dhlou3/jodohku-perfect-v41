import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Firebase Init Error: $e");
  }
  runApp(const JodohkuHybridApp());
}

class JodohkuHybridApp extends StatelessWidget {
  const JodohkuHybridApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jodohku Malaysia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF0B0E14),
        brightness: Brightness.dark,
      ),
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
        final String uid = user.uid;
        _controller.runJavaScript("localStorage.setItem('current_user_id', '$uid'); window.location.href='home_preview.html';");
      }
    } catch (e) {
      if (mounted) {
        // 🕵️‍♂️ TRUE ERROR DETECTOR
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("DEBUG ERROR: $e"), 
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 10),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent("Mozilla/5.0 (Android 13; Mobile; rv:109.0) Gecko/116.0 Firefox/116.0")
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('appbridge://')) {
              if (request.url.contains('googleLogin')) {
                _handleGoogleLogin();
              }
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadFlutterAsset('assets/www/landing_preview.html');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}
