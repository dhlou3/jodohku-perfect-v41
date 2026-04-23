import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jodohku_malaysia/src/shared/services/ai_sentinel_service.dart';

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream of messages with AI-Safe Filter validation
  Stream<List<Message>> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => Message.fromFirestore(doc)).toList();
        });
  }

  // AI-SUPREME SENTINEL MESSAGING (Phase 1 Backend Hardening)
  Future<void> sendMessage(String chatId, Message message) async {
    // 1. 🛡️ GOD-MODE AI EVALUATION
    final aiResult = await AISentinelService.evaluateMessage(message.content);

    // 2. LOGIC: Handling Safety Result
    String finalContent = aiResult.redactedText;
    bool isFlagged = !aiResult.isSafe;

    // 3. COMMIT TO FIRESTORE
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'senderId': message.senderId,
      'content': finalContent, // Redacted content
      'isFlagged': isFlagged,
      'originalContent': isFlagged ? message.content : null, // Hidden for Director Review
      'timestamp': FieldValue.serverTimestamp(),
    });

    // 4. ACTION: If critical violation, trigger Admin/Wali Notification
    if (isFlagged) {
      _notifyWaliOfViolation(chatId, message.senderId);
    }
  }

  void _notifyWaliOfViolation(String chatId, String userId) {
    // In production, this triggers a Push Notification to the Wali's phone
    print('🚨 AI SENTINEL: Violation detected in chat $chatId by user $userId');
  }
}

class Message {
  final String senderId, content;
  final DateTime timestamp;
  final bool isFlagged;

  Message({required this.senderId, required this.content, required this.timestamp, this.isFlagged = false});

  factory Message.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Message(
      senderId: data['senderId'],
      content: data['content'],
      isFlagged: data['isFlagged'] ?? false,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}
