import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JodohkuNotification {
  final String title;
  final String message;
  final bool isError;

  JodohkuNotification({
    required this.title,
    required this.message,
    this.isError = false,
  });
}

class NotificationNotifier extends StateNotifier<JodohkuNotification?> {
  NotificationNotifier() : super(null);

  // LOGIC: Global Alert Dispatcher
  void show(String title, String message, {bool isError = false}) {
    state = JodohkuNotification(title: title, message: message, isError: isError);
    // Auto-clear after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      state = null;
    });
  }
}

final notificationProvider = StateNotifierProvider<NotificationNotifier, JodohkuNotification?>((ref) {
  return NotificationNotifier();
});
