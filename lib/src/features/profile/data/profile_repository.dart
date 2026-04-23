import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jodohku_malaysia/src/features/discovery/domain/user_profile.dart';
import 'package:jodohku_malaysia/src/features/discovery/domain/matching_engine.dart';

class ProfileRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream of production user profiles filtered for Halal compatibility
  Stream<List<UserProfile>> getCompatibleProfiles(UserProfile currentUser) {
    return _firestore
        .collection('users')
        .where('gender', isNotEqualTo: currentUser.gender)
        .where('maritalStatus', isEqualTo: 'Single') // Basic Halal filter
        .snapshots()
        .map((snapshot) {
          final profiles = snapshot.docs.map((doc) => UserProfile.fromFirestore(doc)).toList();
          
          // Rank by Cosine Similarity (Deep Match)
          profiles.sort((a, b) {
            final simA = MatchingEngine.calculateSimilarity(currentUser.lifeValues, a.lifeValues);
            final simB = MatchingEngine.calculateSimilarity(currentUser.lifeValues, b.lifeValues);
            return simB.compareTo(simA); // Highest match first
          });
          
          return profiles;
        });
  }

  Future<void> updateProfile(UserProfile profile) async {
    await _firestore.collection('users').doc(profile.id).set(profile.toFirestore());
  }
}
