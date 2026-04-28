import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
import 'package:image_picker/image_picker.dart';

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
  final LocalAuthentication auth = LocalAuthentication();
  final ImagePicker _picker = ImagePicker();

  Future<void> _handleImagePick(String slotIndex) async {
    try {
      await Permission.photos.request();
      await Permission.camera.request();

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 70, // Native Compression Engine
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        final base64String = base64Encode(bytes);
        final dataUrl = 'data:image/jpeg;base64,$base64String';
        
        // Push back to Web UI instantly
        _controller.runJavaScript("if(window.receiveImageFromFlutter) window.receiveImageFromFlutter($slotIndex, '$dataUrl')");
      }
    } catch (e) {
      debugPrint("IMAGE_PICK_ERROR: $e");
    }
  }

  Future<void> _handleBiometricRequest() async {
    try {
      final bool canAuth = await auth.isDeviceSupported() || await auth.canCheckBiometrics;
      if (!canAuth) {
        _controller.runJavaScript("alert('Biometrics not supported or setup missing.')");
        return;
      }

      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Sila sahkan identiti untuk masuk Jodohku Malaysia.',
        options: const AuthenticationOptions(stickyAuth: true, biometricOnly: true),
      );

      if (didAuthenticate) {
        final prefs = await SharedPreferences.getInstance();
        final savedUid = prefs.getString('saved_uid');
        if (savedUid != null) {
          _controller.runJavaScript("handleAuthSuccess({uid: '$savedUid', isBio: true})");
        } else {
          _controller.runJavaScript("alert('Sila Log Masuk dengan Google sekali untuk mengaktifkan biometrik.')");
        }
      }
    } catch (e) {
      debugPrint("BIOMETRIC_ERROR: $e");
    }
  }

  Future<void> _handleActionVerification() async {
    try {
      final bool canAuth = await auth.isDeviceSupported() || await auth.canCheckBiometrics;
      if (!canAuth) {
        _controller.runJavaScript("window.onBiometricResult(true)"); // Fallback for unsupported devices
        return;
      }

      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Sila sahkan identiti untuk tindakan keselamatan ini.',
        options: const AuthenticationOptions(stickyAuth: true, biometricOnly: true),
      );

      _controller.runJavaScript("window.onBiometricResult($didAuthenticate)");
    } catch (e) {
      debugPrint("BIO_VERIFY_ERROR: $e");
      _controller.runJavaScript("window.onBiometricResult(false)");
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_uid', uid);
    
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
      ..setUserAgent("Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Mobile Safari/537.36")
      ..addJavaScriptChannel(
        'FlutterApp',
        onMessageReceived: (JavaScriptMessage message) {
          if (message.message.startsWith('onLoginSuccess:')) {
            final uid = message.message.split(':')[1];
            _syncToken(uid);
          } else if (message.message == 'requestBiometric') {
            _handleBiometricRequest();
          } else if (message.message == 'verifyActionBiometric') {
            _handleActionVerification();
          } else if (message.message.startsWith('pickImage:')) {
            final slotIndex = message.message.split(':')[1];
            _handleImagePick(slotIndex);
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('appbridge://')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://jodohku-61096.web.app/landing_preview.html?v=41.4'));

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
