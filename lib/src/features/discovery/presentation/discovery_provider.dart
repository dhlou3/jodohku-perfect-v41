import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jodohku_malaysia/src/shared/constants/app_constants.dart';
import 'package:jodohku_malaysia/src/features/auth/domain/member_profile.dart';
import 'package:jodohku_malaysia/src/features/auth/application/auth_notifier.dart';
import 'package:jodohku_malaysia/src/features/auth/application/firestore_service.dart';

// Filter state class
class DiscoveryFilters {
  final double maxDistance;
  final bool waliVerifiedOnly;
  final MaritalIntent? preferredIntent;
  final PrayerFrequency? minPrayerFrequency;

  DiscoveryFilters({
    this.maxDistance = 50.0,
    this.waliVerifiedOnly = false,
    this.preferredIntent,
    this.minPrayerFrequency,
  });

  DiscoveryFilters copyWith({
    double? maxDistance,
    bool? waliVerifiedOnly,
    MaritalIntent? preferredIntent,
    PrayerFrequency? minPrayerFrequency,
  }) {
    return DiscoveryFilters(
      maxDistance: maxDistance ?? this.maxDistance,
      waliVerifiedOnly: waliVerifiedOnly ?? this.waliVerifiedOnly,
      preferredIntent: preferredIntent ?? this.preferredIntent,
      minPrayerFrequency: minPrayerFrequency ?? this.minPrayerFrequency,
    );
  }
}

final discoveryFilterProvider = StateProvider<DiscoveryFilters>((ref) => DiscoveryFilters());

final discoveryProvider = StateNotifierProvider<DiscoveryNotifier, List<MemberProfile>>((ref) {
  return DiscoveryNotifier(ref);
});

enum MatchResult { none, match }

class DiscoveryNotifier extends StateNotifier<List<MemberProfile>> {
  final Ref ref;
  
  DiscoveryNotifier(this.ref) : super([]) {
    // 1. Initial Load & Real-time Stream
    _setupUserStream();

    // 2. Profile Sync - Re-filter if search criteria change
    ref.listen(discoveryFilterProvider, (previous, next) {
      _applyFiltersAndRank();
    });
  }

  void _setupUserStream() {
    // QUALITY: In production, this would be a real-time Firestore stream
    _fetchAndSync();
  }

  Future<void> _fetchAndSync() async {
    try {
      final users = await FirestoreService.fetchAllUsers();
      final myProfile = ref.read(profileProvider).value;
      
      if (myProfile != null) {
        final excluded = [...myProfile.likes, ...myProfile.skips];
        state = users.where((u) {
          if (u.id == null || u.id == myProfile.id || u.fullName.isEmpty) return false;
          // Standardized on UID-first exclusion
          if (excluded.contains(u.id) || excluded.contains(u.phone)) return false;
          // STRICT GENDER POLARITY
          if (u.gender == null || myProfile.gender == null) return false;
          if (u.gender == myProfile.gender) return false;
          return true;
        }).toList();
      } else {
        state = users;
      }
      
      _applyFiltersAndRank();
    } catch (e) {
      print("Discovery sync error: $e");
    }
  }

  Future<MatchResult> recordLike(String targetUid) async {
    try {
      final myProfile = ref.read(profileProvider).value;
      if (myProfile == null) return MatchResult.none;

      // 1. Persist the like
      await FirestoreService.recordLike(myProfile.id!, targetUid);
      
      // 2. Refresh local state immediately (UI responsiveness)
      state = state.where((u) => u.id != targetUid).toList();

      // 3. Check for mutual match
      final targetProfile = await FirestoreService.fetchUserProfile(targetUid);
      if (targetProfile != null && (targetProfile.likes.contains(myProfile.phone) || targetProfile.likes.contains(myProfile.id))) {
        
        // 4. Create Chat Session (Deterministic ID Sync with Web)
        final pair = [myProfile.id!, targetUid].sort();
        final chatId = "chat_${pair[0]}_${pair[1]}";
        await FirestoreService.createChatRoom(chatId, myProfile.id!, targetUid);
        
        return MatchResult.match;
      }
      return MatchResult.none;
    } catch (e) {
      print("Like recorded with error: $e");
      return MatchResult.none;
    }
  }

  void _applyFiltersAndRank() {
    final filters = ref.read(discoveryFilterProvider);
    
    var filtered = state.where((u) {
      if (filters.waliVerifiedOnly && !u.isWaliVerified) return false;
      if (filters.preferredIntent != null && u.maritalIntent != filters.preferredIntent) return false;
      return true;
    }).toList();

    filtered.sort((a, b) {
      int scoreA = (a.isWaliVerified ? 2 : 0) + (a.maritalIntent == filters.preferredIntent ? 3 : 0);
      int scoreB = (b.isWaliVerified ? 2 : 0) + (b.maritalIntent == filters.preferredIntent ? 3 : 0);
      return scoreB.compareTo(scoreA);
    });

    state = filtered;
  }

  void updateFilters(DiscoveryFilters newFilters) {
    ref.read(discoveryFilterProvider.notifier).state = newFilters;
    _fetchAndSync(); // Refresh after filter change
  }
}
