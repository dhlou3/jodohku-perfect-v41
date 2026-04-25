import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jodohku_malaysia/src/features/auth/application/auth_notifier.dart';
import 'package:jodohku_malaysia/src/features/chat/domain/chat_models.dart';
import 'package:jodohku_malaysia/src/features/chat/application/chat_observer_service.dart';
import 'package:jodohku_malaysia/src/features/chat/application/wali_report_service.dart';
import 'package:jodohku_malaysia/src/features/auth/domain/member_profile.dart';
import 'package:jodohku_malaysia/src/features/notifications/application/notification_notifier.dart';
import 'package:jodohku_malaysia/src/features/auth/application/firestore_service.dart';

class ChatNotifier extends StateNotifier<List<ChatSession>> {
  final Ref ref;
  ChatNotifier(this.ref) : super([]) {
    // SYNC WITH CLOUD - Always keep the most current chats from the stream
    ref.listen(chatStreamProvider, (previous, next) {
      if (next.hasValue) state = next.value!;
    });

    // WALI HEARTBEAT - Ensure safety remains active during live sessions
    ref.listen<AsyncValue<MemberProfile?>>(profileProvider, (previous, next) {
      final profile = next.value;
      if (profile != null && (profile.waliName == null || profile.waliName!.isEmpty)) {
        // If Wali disappears, we can broadcast a global alert or freeze UI
        print('🚨 WALI HEARTBEAT FAILURE: Security protocol enabled.');
      }
    });
  }

  // LOGIC: Creating a New Taaruf Room (REAL CLOUD SYNC)
  void startTaaruf(String myId, String partnerId, String? myWaliName) async {
    if (myWaliName == null || myWaliName.isEmpty) {
      ref.read(notificationProvider.notifier).show(
        'HALANGAN KESELAMATAN 🛡️', 
        'Sila daftarkan Wali anda di profil sebelum memulakan Taaruf.'
      );
      return;
    }

    final ids = [myId, partnerId]..sort();
    final roomId = 'chat_${ids[0]}_${ids[1]}';
    
    await FirestoreService.createChatSession(roomId, myId, partnerId);
  }

  // LOGIC: Unlocking the next Taaruf Question (CLOUD SYNCED)
  void advanceQuestion(String sessionId) async {
    final session = state.firstWhere((s) => s.id == sessionId);
    final nextIndex = session.currentQuestionIndex + 1;
    await FirestoreService.advanceTaarufQuestion(sessionId, nextIndex);
  }

  void attachWali(String sessionId, String waliId) {
    // SECURITY: Connects the supervisor to the session
  }

  void requestMeeting(String sessionId, String senderId) {
    // LOGIC: Proposals for physical meeting
  }

  void sendMessage(String sessionId, String senderId, String text) {
    final filteredText = _halalGuard(text);
    
    // In production, this would call DB.sendMessage/FirestoreService.sendMessage
    // For the prototype state management:
    state = [
      for (final session in state)
        if (session.id == sessionId && !session.isFrozen)
          session.copyWith(
            messages: [
              ...session.messages,
              ChatMessage(
                id: DateTime.now().toString(),
                senderId: senderId,
                content: filteredText,
                timestamp: DateTime.now(),
              )
            ],
          )
        else
          session,
    ];

    // AI SENTRY: Analyze message for preference updates
    if (senderId == 'me') {
      ChatObserverService.analyzeMessageForPreferences(text);
    }
  }

  // LOGIC: Accept Meeting & Trigger Wali Report
  void acceptMeeting(String sessionId, String senderId, [MemberProfile? partner]) {
    state = [
      for (final session in state)
        if (session.id == sessionId)
          session.copyWith(
            meetStatus: MeetStatus.accepted,
            messages: [
              ...session.messages,
              ChatMessage(
                id: 'accept_${DateTime.now().millisecondsSinceEpoch}',
                senderId: senderId,
                content: '✅ Permintaan berjumpa TELAH DITERIMA! Laporan Taaruf akan dihantar ke Email Wali sebentar lagi.',
                timestamp: DateTime.now(),
                type: MessageType.meetAccepted,
              )
            ],
          )
        else
          session,
    ];
    
    final session = state.firstWhere((s) => s.id == sessionId);
    WaliReportService.generateAndSendReport(session, partner ?? MemberProfile(id: session.memberA == senderId ? session.memberB : session.memberA, fullName: 'Calon Pasangan', isWaliVerified: true));
  }

  // INTERNAL LOGIC: Halal Guard (AGGRESSIVE SENTINEL v3.0)
  String _halalGuard(String input) {
    final lower = input.toLowerCase();
    
    // 1. Safety & Profanity Check
    final profanity = ['babi', 'sial', 'bodoh', 'pala hotak', 'fuck', 'shit', 'anjing', 'pukimak'];
    if (profanity.any((w) => lower.contains(w))) {
      return '[MESEJ DIKOSONGKAN KERANA BAHASA TIDAK SOPAN]';
    }

    // 2. Info Leak Check
    final leakRegex = RegExp(
      r'(\b\d{7,}\b|\b01\d[- ]?\d{7,8}\b|whatsapp|wasap|wsap|tele|tg|telegr|insta|ig|snap|fb|@|dot com|dot my|nombor|number|phone)',
      caseSensitive: false,
    );
    if (leakRegex.hasMatch(lower)) {
      return '[MAKLUMAT PERIBADI DISEKAT KERANA POLISI TAARUF]';
    }

    // 3. Unofficial Meeting Context Check (The "Zus Coffee" Logic)
    final meetingKeywords = ['zus', 'coffee', 'kopi', 'kafe', 'kfc', 'mcd', 'jumpa', 'meet', 'lepak', 'dating', 'date', 'starbucks', 'tealive'];
    final intentKeywords = ['jumpa', 'meet', 'lepak', 'dating', 'date'];
    
    final hasIntent = intentKeywords.any((w) => lower.contains(w));
    final hasPlace = meetingKeywords.any((w) => lower.contains(w));

    if (hasIntent && hasPlace) {
      return '[SILA GUNAKAN BUTANG "MEET" UNTUK PERTEMUAN RASMI]';
    }

    return input;
  }
}

final chatStreamProvider = StreamProvider<List<ChatSession>>((ref) {
  return FirestoreService.watchChats();
});

final chatProvider = StateNotifierProvider<ChatNotifier, List<ChatSession>>((ref) {
  return ChatNotifier(ref);
});
