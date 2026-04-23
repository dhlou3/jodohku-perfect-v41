import 'package:cloud_firestore/cloud_firestore.dart';

class Venue {
  final String id, name, location, imageUrl, jakimLicense;
  final bool isWaliFriendly;
  final double rating;

  Venue({
    required this.id,
    required this.name,
    required this.location,
    required this.imageUrl,
    required this.jakimLicense,
    required this.isWaliFriendly,
    required this.rating,
  });

  Map<String, dynamic> toFirestore() => {
    'name': name,
    'location': location,
    'imageUrl': imageUrl,
    'jakimLicense': jakimLicense,
    'isWaliFriendly': isWaliFriendly,
    'rating': rating,
  };

  factory Venue.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Venue(
      id: doc.id,
      name: data['name'],
      location: data['location'],
      imageUrl: data['imageUrl'],
      jakimLicense: data['jakimLicense'],
      isWaliFriendly: data['isWaliFriendly'] ?? true,
      rating: (data['rating'] as num).toDouble(),
    );
  }
}
