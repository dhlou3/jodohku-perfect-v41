import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jodohku_malaysia/src/features/auth/domain/member_profile.dart';
import 'package:jodohku_malaysia/src/features/matching/data/profile_repository.dart';
import 'package:jodohku_malaysia/src/features/matching/domain/ai_matcher.dart';

class DiscoveryMatch {
  final MemberProfile profile;
  final double score;
  final String label;

  DiscoveryMatch({
    required this.profile,
    required this.score,
    required this.label,
  });
}

class DiscoveryNotifier extends StateNotifier<AsyncValue<List<DiscoveryMatch>>> {
  DiscoveryNotifier() : super(const AsyncValue.loading());

  // CORE LOGIC: Fetching and Ranking Potential Matches
  Future<void> loadDiscovery(MemberProfile currentUser) async {
    state = const AsyncValue.loading();
    try {
      // 1. Fetch raw profiles from repository
      final profiles = await ProfileRepository.getPotentialMatches();

      // 2. Filter out current user
      final others = profiles.where((p) => p.id != currentUser.id).toList();

      // 3. AI RANKING LOGIC
      final List<DiscoveryMatch> ranked = others.map((p) {
        final score = AIMatcher.calculateCompatibility(currentUser, p);
        final label = AIMatcher.getCompatibilityLabel(score);
        return DiscoveryMatch(profile: p, score: score, label: label);
      }).toList();

      // Sort by score (Highest first)
      ranked.sort((a, b) => b.score.compareTo(a.score));

      state = AsyncValue.data(ranked);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final discoveryProvider = StateNotifierProvider<DiscoveryNotifier, AsyncValue<List<DiscoveryMatch>>>((ref) {
  return DiscoveryNotifier();
});
