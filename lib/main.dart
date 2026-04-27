import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'jdk_alerts',
      'JDK Priority Alerts',
      description: 'Incoming match and message notifications.',
      importance: Importance.max,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

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
  String? _fcmToken;

  Future<void> _handleGoogleLogin() async {
    try {
      // 🛡️ SMART SYNC v37.2 (ELITE)
      // Check if we are already on a login/register page and trigger the local button.
      // Otherwise, default to the login page.
      _controller.runJavaScript("""
        if (document.getElementById('gBtn')) { 
          document.getElementById('gBtn').click(); 
        } else if (document.getElementById('regBtn')) { 
          document.getElementById('regBtn').click(); 
        } else { 
          window.location.href='login_preview.html?provider=google'; 
        }
      """);
      
    } catch (e) {
      debugPrint("💎 [SENTINEL] Shield Failure: $e");
    }
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.location,
      Permission.notification,
    ].request();
    
    _fcmToken = await FirebaseMessaging.instance.getToken();
    debugPrint("FCM TOKEN: $_fcmToken");
  }

  Future<void> _syncToken(String uid) async {
    if (_fcmToken != null) {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'fcmTokens': FieldValue.arrayUnion([_fcmToken]),
        'pushActive': true,
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    
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

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'jdk_alerts',
              'JDK Priority Alerts',
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    });
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
