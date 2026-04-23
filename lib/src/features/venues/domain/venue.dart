import 'package:flutter_riverpod/flutter_riverpod.dart';

class SafeVenue {
  final String name;
  final String location;
  final String city;
  final String type; // e.g., 'Cafe', 'Restaurant', 'Cultural Site'
  final bool isJakimCertified;
  final String description;
  final String photoUrl;

  SafeVenue({
    required this.name,
    required this.location,
    required this.city,
    required this.type,
    this.isJakimCertified = true,
    required this.description,
    required this.photoUrl,
  });
}

class VenueService {
  final List<SafeVenue> _jakimVenues = [
    SafeVenue(
      name: 'VCR Cafe',
      location: 'Galloway, Kuala Lumpur',
      city: 'Kuala Lumpur',
      type: 'Cafe',
      description: 'A popular chic cafe for high-end Halal coffee and dates.',
      photoUrl: 'https://vcr.my/wp-content/uploads/2021/01/vcr-galloway-ext.jpg',
    ),
    SafeVenue(
      name: 'Dewakan',
      location: 'Naza Tower, KL',
      city: 'Kuala Lumpur',
      type: 'Fine Dining',
      description: 'High-end Malay fine dining, perfect for meeting a wali.',
      photoUrl: 'https://images.unsplash.com/photo-1514361892635-6b07e31e75f9',
    ),
    SafeVenue(
      name: 'Feeka Coffee Roasters',
      location: 'Changkat, Bukit Bintang',
      city: 'Kuala Lumpur',
      type: 'Cafe',
      description: 'Cozy and sophisticated spot for initial introductions.',
      photoUrl: 'https://images.unsplash.com/photo-1501339819398-ed47a755b28d',
    ),
    SafeVenue(
      name: 'Restoran Ikan Bakar Din',
      location: 'George Town',
      city: 'Penang',
      type: 'Restaurant',
      description: 'Authentic Penang Halal grilled fish.',
      photoUrl: 'https://images.unsplash.com/photo-1529193591184-b1d58069ecdd',
    ),
  ];

  List<SafeVenue> getVenues({String? city}) {
    if (city == null) return _jakimVenues;
    return _jakimVenues.where((v) => v.city == city).toList();
  }
}

final venueServiceProvider = Provider((ref) => VenueService());
