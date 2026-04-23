import 'package:jodohku_malaysia/src/features/auth/domain/member_profile.dart';

class MatchingEngine {
  static double calculateSimilarity(MemberProfile userA, MemberProfile userB) {
    // Standardizing values
    final freqA = userA.prayerFrequency.index.toDouble();
    final freqB = userB.prayerFrequency.index.toDouble();
    
    // 1. Religious Baseline
    double score = 1.0 - (freqA - freqB).abs() / 5.0;
    if (freqA >= 1 && freqB >= 1) score += 0.05;

    // 2. Geographic Proximity (Haversine)
    if (userA.latitude != null && userB.latitude != null) {
      double dist = _calculateDistance(userA.latitude!, userA.longitude!, userB.latitude!, userB.longitude!);
      if (dist < 50) score += 0.05; // 5% Neighborhood Bonus
      if (dist > 300) score -= 0.10; // 10% Long-dist Penalty
    } else if (userA.birthState == userB.birthState) {
      score += 0.03; // Simple state-match bonus
    }
    
    return calculateAICompatibleScore(score, userA.dynamicPrompt, userB);
  }

  static double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    // Simple math for demo (Pythagoras for small distances in a grid-like region)
    // In production, use geolocator.distanceBetween
    return ((lat1 - lat2).abs() + (lon1 - lon2).abs()) * 111.0; 
  }

  static double calculateAICompatibleScore(double baseScore, List<String> myPrompt, MemberProfile partner) {
    double score = baseScore;

    // Traits Map (Maps AI extracted strings to Attribute keys)
    final traitMap = {
      'Smoking': 'smokes',
      'Vaping': 'vapes',
      'Shisha': 'shisha',
      'Cats': 'hasCats',
      'Dogs': 'hasDogs',
      'Gaming': 'isGamer',
      'Cooking': 'canCook',
      'Hiking': 'isHiker',
      'Reading': 'isReader',
      'Traveling': 'isTraveler',
      'Sports': 'isAthlete',
      'Business': 'isBusinessMinded',
      'Hijab': 'wearsHijab',
    };

    for (var pref in myPrompt) {
      final isNegative = pref.startsWith('Negative: ');
      final traitName = pref.split(': ').last;
      final attrKey = traitMap[traitName];

      if (attrKey != null && partner.attributes.containsKey(attrKey)) {
        final partnerHasTrait = partner.attributes[attrKey]!;
        
        if (isNegative && partnerHasTrait) {
          score -= 0.15; // 15% Penalty for explicit dislike
        } else if (!isNegative && partnerHasTrait) {
          score += 0.05; // 5% Bonus for shared interest
        }
      }
    }

    return score.clamp(0.0, 1.0);
  }
}
