import 'package:jodohku_malaysia/src/features/auth/domain/member_profile.dart';
import 'package:jodohku_malaysia/src/features/auth/application/firestore_service.dart';

class ChatObserverService {
  static Future<void> analyzeMessageForPreferences(String message) async {
    final lowerMsg = message.toLowerCase();
    final List<String> extractedPrefs = [];
    
    // 1. LIFESTYLE (NEGATIVES)
    if (_isNegative(lowerMsg)) {
      if (lowerMsg.contains('rokok') || lowerMsg.contains('smoke')) extractedPrefs.add('Negative: Smoking');
      if (lowerMsg.contains('vape') || lowerMsg.contains('isap')) extractedPrefs.add('Negative: Vaping');
      if (lowerMsg.contains('shisha')) extractedPrefs.add('Negative: Shisha');
      if (lowerMsg.contains('kucing') || lowerMsg.contains('cat')) extractedPrefs.add('Negative: Cats');
      if (lowerMsg.contains('anjing') || lowerMsg.contains('dog')) extractedPrefs.add('Negative: Dogs');
      if (lowerMsg.contains('game') || lowerMsg.contains('gaming')) extractedPrefs.add('Negative: Gaming');
    }

    // 2. LIFESTYLE (POSITIVES)
    if (_isPositive(lowerMsg)) {
      if (lowerMsg.contains('masak') || lowerMsg.contains('cook')) extractedPrefs.add('Positive: Cooking');
      if (lowerMsg.contains('hike') || lowerMsg.contains('mendaki')) extractedPrefs.add('Positive: Hiking');
      if (lowerMsg.contains('baca') || lowerMsg.contains('read')) extractedPrefs.add('Positive: Reading');
      if (lowerMsg.contains('melancong') || lowerMsg.contains('travel')) extractedPrefs.add('Positive: Traveling');
      if (lowerMsg.contains('sukan') || lowerMsg.contains('sport')) extractedPrefs.add('Positive: Sports');
      if (lowerMsg.contains('bisnes') || lowerMsg.contains('business')) extractedPrefs.add('Positive: Business');
    }

    // 3. RELIGIOUS & VALUES
    if (lowerMsg.contains('tudung') || lowerMsg.contains('hijab')) {
       if (_isPositive(lowerMsg)) extractedPrefs.add('Positive: Hijab');
       if (_isNegative(lowerMsg)) extractedPrefs.add('Negative: Hijab');
    }

    if (extractedPrefs.isNotEmpty) {
      final profile = await FirestoreService.getProfile();
      if (profile != null) {
        final currentPrompt = List<String>.from(profile.dynamicPrompt);
        for (var p in extractedPrefs) {
          if (!currentPrompt.contains(p)) currentPrompt.add(p);
        }
        await FirestoreService.saveProfile(profile.copyWith(dynamicPrompt: currentPrompt));
        print('🧠 AI UPDATED PREFERENCES: $extractedPrefs');
      }
    }
  }

  static bool _isNegative(String msg) => msg.contains('tak nak') || msg.contains('don\'t want') || msg.contains('no ') || msg.contains('benci') || msg.contains('anti');
  static bool _isPositive(String msg) => msg.contains('suka') || msg.contains('love') || msg.contains('prefer') || msg.contains('impian') || msg.contains('nak ');
}
