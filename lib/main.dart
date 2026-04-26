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
  String _debugStatus = "📡 Waiting for Bridge...";

  void _updateLog(String msg) {
    setState(() {
      _debugStatus = msg;
    });
    debugPrint(msg);
  }

  Future<void> _handleGoogleLogin() async {
    _updateLog("🚀 Signal Received! Attempting Native Login...");
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      
      if (googleUser == null) {
        _updateLog("⚠️ Login Cancelled by User.");
        return;
      }

      _updateLog("🔋 Account Selected: ${googleUser.email}");
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      _updateLog("🛰️ Connecting to Firebase...");
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        _updateLog("✅ SUCCESS! Redirecting to Home...");
        final String uid = user.uid;
        _controller.runJavaScript("localStorage.setItem('current_user_id', '$uid'); window.location.href='home_preview.html';");
      }
    } catch (e) {
      _updateLog("❌ ERROR: $e");
      // Show error in a snackbar for easy reading
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login Failed: $e"), backgroundColor: Colors.red),
        );
      }
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
          } else {
            _updateLog("📩 Msg: ${message.message}");
          }
        },
      )
      ..setBackgroundColor(const Color(0xFF0B0E14))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            _updateLog("🔗 Page Loaded: ${url.split('/').last}");
          },
          onWebResourceError: (WebResourceError error) {
            _updateLog("❌ Web Error: ${error.description}");
          },
        ),
      )
      ..loadFlutterAsset('assets/www/landing_preview.html');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // DEBUG STATUS BAR (v7.9)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: Colors.red.withOpacity(0.9),
            child: Text(
              _debugStatus,
              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: WebViewWidget(controller: _controller),
          ),
        ],
      ),
    );
  }
}
