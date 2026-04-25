import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../domain/member_profile.dart';

class FirestoreService {
  static final _db = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static Future<void> saveProfile(MemberProfile profile) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    
    await _db.collection('users').doc(uid).set(profile.toMap(), SetOptions(merge: true));
  }

  static Future<MemberProfile?> getProfile() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;

    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    
    return MemberProfile.fromMap(doc.data()!);
  }

  static Stream<MemberProfile?> watchProfile() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return Stream.value(null);

    return _db.collection('users').doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return MemberProfile.fromMap(doc.data()!);
    });
  }

  static Future<void> createChatSession(String roomId, String p1, String p2) async {
    await _db.collection('chats').doc(roomId).set({
      'id': roomId,
      'memberA': p1,
      'memberB': p2,
      'createdAt': FieldValue.serverTimestamp(),
      'lastMessage': "Padanan Taaruf Berjaya! ✨",
      'currentQuestionIndex': 0,
      'isFrozen': false,
    }, SetOptions(merge: true));
  }

  static Future<List<MemberProfile>> fetchAllUsers() async {
    final snap = await _db.collection('users').get();
    return snap.docs.map((d) => MemberProfile.fromMap(d.data())).toList();
  }

  static Future<MemberProfile?> fetchUserProfile(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return MemberProfile.fromMap(doc.data()!);
  }

  static Future<void> recordLike(String myId, String targetId) async {
    await _db.collection('users').doc(myId).update({
      'likes': FieldValue.arrayUnion([targetId])
    });
  }

  static Stream<List<Map<String, dynamic>>> watchChats() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return Stream.value([]);

    return _db.collection('chats')
      .where(Filter.or(
        Filter('memberA', isEqualTo: uid),
        Filter('memberB', isEqualTo: uid),
      ))
      .snapshots()
      .map((snap) => snap.docs.map((d) => d.data()).toList());
  }

  static Future<void> advanceTaarufQuestion(String sessionId, int nextIndex) async {
    await _db.collection('chats').doc(sessionId).update({
      'currentQuestionIndex': nextIndex,
    });
  }
}
