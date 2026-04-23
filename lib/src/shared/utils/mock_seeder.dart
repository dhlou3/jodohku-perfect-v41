import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class MockSeeder {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> seedTestUsers() async {
    final List<Map<String, dynamic>> testUsers = [
      {
        'name': 'Nur Aisyah',
        'age': 24,
        'location': 'Selangor',
        'career': 'Guru Tadika',
        'bio': 'Mencari pasangan yang memahami nilai kekeluargaan dan rajin solat.',
        'memberId': 'JDK-2024-1001',
        'gender': 'Female',
        'matchScore': 98,
        'trustScore': 95,
        'isSovereign': true,
        'isVerified': true,
        'prompt_q': 'Pasangan idaman saya adalah...',
        'prompt_a': 'Seseorang yang menjaga solat 5 waktu dan sayang keluarga.',
      },
      {
        'name': 'Farhan Jamil',
        'age': 28,
        'location': 'Kuala Lumpur',
        'career': 'Software Engineer',
        'bio': 'Seorang yang pendiam tapi penyayang.',
        'memberId': 'JDK-2024-1002',
        'gender': 'Male',
        'matchScore': 85,
        'trustScore': 75,
        'isSovereign': false,
        'isVerified': true,
        'prompt_q': 'Gaya hidup saya...',
        'prompt_a': 'Sangat mementingkan solat Subuh berjemaah di Masjid.',
      },
      {
        'name': 'Fatimah Yusuf',
        'age': 22,
        'location': 'Johor Bahru',
        'career': 'Arkitek',
        'bio': 'Masih belajar tapi matang dalam pemikiran.',
        'memberId': 'JDK-2024-1003',
        'gender': 'Female',
        'matchScore': 92,
        'trustScore': 88,
        'isSovereign': true,
        'isVerified': true,
        'prompt_q': 'Rahsia kebahagiaan adalah...',
        'prompt_a': 'Sabar dan redha dalam setiap ujian Allah.',
      },
      {
        'name': 'Khairul Nizam',
        'age': 30,
        'location': 'Terengganu',
        'career': 'Doktor',
        'bio': 'Sibuk mencari rezeki, moga bertemu jodoh yang baik.',
        'memberId': 'JDK-2024-1004',
        'gender': 'Male',
        'matchScore': 80,
        'trustScore': 90,
        'isSovereign': false,
        'isVerified': true,
        'prompt_q': 'Impian saya...',
        'prompt_a': 'Membina keluarga yang diredhai Allah.',
      },
    ];

    final batch = _firestore.batch();
    for (var user in testUsers) {
      final docRef = _firestore.collection('users').doc();
      batch.set(docRef, user);
    }
    await batch.commit();
  }
}
