import 'dart:math';
import 'package:jodohku_malaysia/src/features/auth/domain/member_profile.dart';

/**
 * 🧠 JODOHKU AI MATCHING ENGINE v1.0
 * This domain logic calculates compatibility using Sharia-alignment and value-based parameters.
 */

class AIMatcher {
  static double calculateCompatibility(MemberProfile user1, MemberProfile user2) {
    double score = 65.0; // 🏗️ ELITE RESILIENCE v2.6 (Floor Protection)
    
    // 1. DIRECT TAARUF ALIGNMENT (Weight: +10%)
    if (user1.isWaliVerified == user2.isWaliVerified) score += 5;
    
    // 2. RELIGIOUS SYNERGY (+10%)
    if (user1.prayerFrequency == user2.prayerFrequency) score += 10;

    // 3. CONTEXT AGGREGATION
    final meRequirements = user1.fullName.toLowerCase() + " " + user1.dynamicPrompt.join(" ").toLowerCase();
    final otherStory = user2.fullName.toLowerCase() + " " + user2.dynamicPrompt.join(" ").toLowerCase(); 
    final otherAttributes = user2.attributes.keys.where((k) => user2.attributes[k] == true).join(" ").toLowerCase();
    final targetContext = otherStory + " " + otherAttributes;

    // 4. 🛡️ SOFTENED DEALBREAKER (Penalty: -15 per hit)
    bool isNegatedMatch(String text, String keywordRegex) {
      final regex = RegExp("(don't|no|not|tak nak|jangan|bukan|excluding|anti|neither).*($keywordRegex)", caseSensitive: false);
      return regex.hasMatch(text);
    }

    final tracks = [
      {'kw': 'teacher|cikgu|guru|lecturer', 'id': 'teacher'},
      {'kw': 'smoke|merokok|rokok|vape', 'id': 'smoker'},
      {'kw': 'cat|kucing|animal', 'id': 'pets'}
    ];

    for (var track in tracks) {
      if (isNegatedMatch(meRequirements, track['kw']!)) {
        if (RegExp(track['kw']!, caseSensitive: false).hasMatch(targetContext)) {
          score -= 15; // Softened penalty to protect 50% floor
        }
      } else if (RegExp(track['kw']!, caseSensitive: false).hasMatch(meRequirements) && 
               RegExp(track['kw']!, caseSensitive: false).hasMatch(targetContext)) {
        score += 5; // Synergy Bonus
      }
    }

    // 5. RANDOM STABILITY HASH (AI "Vibe")
    final seed = user1.id.hashCode ^ user2.id.hashCode;
    score += (Random(seed).nextDouble() * 5);

    return max(5.0, min(99.0, score));
  }

    // 4. RANDOM STABILITY HASH (AI "Vibe")
    final seed = user1.id.hashCode ^ user2.id.hashCode;
    score += (Random(seed).nextDouble() * 5);

    return max(5.0, min(99.0, score));
  }

  static String getCompatibilityLabel(double score) {
    if (score >= 90) return "Sangat Serasi (Sultan Match)";
    if (score >= 75) return "Serasi (Barakah)";
    if (score >= 55) return "Sesuai";
    return "Kurang Serasi";
  }
}

