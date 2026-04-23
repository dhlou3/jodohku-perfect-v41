enum PrayerFrequency { never, sometimes, often, always }
enum MaritalIntent { exploring, open, serious, immediate }

class UserProfile {
  final String id;
  final String name;
  final int age;
  final String location;
  final String photoUrl;
  final PrayerFrequency prayerFrequency;
  final MaritalIntent maritalIntent;
  final bool isWaliVerified;
  final bool isHalalOnly;
  final List<String> interests;
  final List<String> dynamicPrompt; // AI-Leaned Preferences from chat/prompts
  final Map<String, bool> attributes; // Concrete traits (smokes, canCook, etc.)
  final double latitude;
  final double longitude;

  UserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.location,
    required this.photoUrl,
    required this.prayerFrequency,
    required this.maritalIntent,
    required this.isWaliVerified,
    required this.isHalalOnly,
    required this.interests,
    this.dynamicPrompt = const [],
    this.attributes = const {}, // Default empty
    required this.latitude,
    required this.longitude,
  });

  factory UserProfile.mock() {
    return UserProfile(
      id: '1',
      name: 'Nurul Izzah',
      age: 26,
      location: 'Kuala Lumpur',
      photoUrl: 'https://images.unsplash.com/photo-1594132474932-84b39b0d9124',
      prayerFrequency: PrayerFrequency.always,
      maritalIntent: MaritalIntent.immediate,
      isWaliVerified: true,
      isHalalOnly: true,
      interests: ['Islamic Art', 'Baking', 'Nature'],
      dynamicPrompt: ['I don\'t want someone who smokes'],
      attributes: {
        'smokes': false,
        'canCook': true,
        'hasCats': false,
      },
      latitude: 3.1390,
      longitude: 101.6869,
    );
  }
}
