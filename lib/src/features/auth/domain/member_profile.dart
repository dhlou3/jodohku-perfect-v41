enum PrayerFrequency { never, usually, often, always }
enum MaritalIntent { exploring, nearFuture, serious, immediate }

class MemberProfile {
  final String? id;
  final String fullName;
  final String? phone;
  final String? email;
  final int age;
  final String gender;
  final String birthState; // Birth state / Location
  final String? photoUrl;
  
  // Religious & Intent
  final PrayerFrequency prayerFrequency;
  final MaritalIntent maritalIntent;
  final bool isWaliVerified;
  final bool isHalalOnly;
  
  // Verification info
  final bool isCertified; // JAKIM/Syariah
  final bool isSultan; // Premium
  
  // Wali info
  final String? waliName;
  final String? waliEmail;
  final String? waliRelation;
  
  final Map<String, bool> attributes;
  final List<String> dynamicPrompt;
  final String? icNumber;
  final double? latitude;
  final double? longitude;
  final int onboardingStep; // Track progress (0-5)

  MemberProfile({
    this.id,
    required this.fullName,
    this.phone,
    this.email,
    this.icNumber,
    this.latitude,
    this.longitude,
    this.onboardingStep = 0,
    this.age = 25,
    required this.gender,
    required this.birthState,
    this.photoUrl,
    this.prayerFrequency = PrayerFrequency.always,
    this.maritalIntent = MaritalIntent.serious,
    this.isWaliVerified = false,
    this.isHalalOnly = true,
    this.isCertified = false,
    this.isSultan = false,
    this.waliName,
    this.waliEmail,
    this.waliRelation,
    this.attributes = const {},
    this.dynamicPrompt = const [],
    this.likes = const [],
    this.skips = const [],
  });

  factory MemberProfile.initial() {
    return MemberProfile(fullName: '', gender: 'man', birthState: 'Kuala Lumpur');
  }

  MemberProfile copyWith({
    String? id,
    String? fullName,
    String? phone,
    String? email,
    String? icNumber,
    double? latitude,
    double? longitude,
    int? onboardingStep,
    int? age,
    String? gender,
    String? birthState,
    String? photoUrl,
    PrayerFrequency? prayerFrequency,
    MaritalIntent? maritalIntent,
    bool? isWaliVerified,
    bool? isHalalOnly,
    bool? isCertified,
    bool? isSultan,
    String? waliName,
    String? waliEmail,
    String? waliRelation,
    Map<String, bool>? attributes,
    List<String>? dynamicPrompt,
    List<String>? likes,
    List<String>? skips,
  }) {
    return MemberProfile(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      icNumber: icNumber ?? this.icNumber,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      onboardingStep: onboardingStep ?? this.onboardingStep,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      birthState: birthState ?? this.birthState,
      photoUrl: photoUrl ?? this.photoUrl,
      prayerFrequency: prayerFrequency ?? this.prayerFrequency,
      maritalIntent: maritalIntent ?? this.maritalIntent,
      isWaliVerified: isWaliVerified ?? this.isWaliVerified,
      isHalalOnly: isHalalOnly ?? this.isHalalOnly,
      isCertified: isCertified ?? this.isCertified,
      isSultan: isSultan ?? this.isSultan,
      waliName: waliName ?? this.waliName,
      waliEmail: waliEmail ?? this.waliEmail,
      waliRelation: waliRelation ?? this.waliRelation,
      attributes: attributes ?? this.attributes,
      dynamicPrompt: dynamicPrompt ?? this.dynamicPrompt,
      likes: likes ?? this.likes,
      skips: skips ?? this.skips,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': id,
      'name': fullName,
      'phone': phone,
      'email': email,
      'icNumber': icNumber,
      'lat': latitude,
      'lng': longitude,
      'onboarding_step': onboardingStep,
      'age_val': age,
      'gender': gender,
      'location_name': birthState,
      'photoUrl': photoUrl,
      'prayerFrequency': prayerFrequency.index,
      'maritalIntent': maritalIntent.index,
      'isWaliVerified': isWaliVerified,
      'isHalalOnly': isHalalOnly,
      'isCertified': isCertified,
      'isSultan': isSultan,
      'waliName': waliName,
      'waliEmail': waliEmail,
      'waliRelation': waliRelation,
      'attributes': attributes,
      'dynamicPrompt': dynamicPrompt,
      'likes': likes,
      'skips': skips,
    };
  }

  factory MemberProfile.fromMap(Map<String, dynamic> map) {
    return MemberProfile(
      id: map['uid'] as String?,
      fullName: map['name'] ?? '',
      phone: map['phone'],
      email: map['email'],
      icNumber: map['icNumber'],
      latitude: map['lat'] as double?,
      longitude: map['lng'] as double?,
      onboardingStep: map['onboarding_step'] ?? 0,
      age: map['age_val'] ?? 25,
      gender: map['gender'] ?? 'man',
      birthState: map['location_name'] ?? 'Malaysia',
      photoUrl: map['photoUrl'],
      prayerFrequency: PrayerFrequency.values[map['prayerFrequency'] ?? 3],
      maritalIntent: MaritalIntent.values[map['maritalIntent'] ?? 2],
      isWaliVerified: map['isWaliVerified'] ?? false,
      isHalalOnly: map['isHalalOnly'] ?? true,
      isCertified: map['isCertified'] ?? false,
      isSultan: map['isSultan'] ?? false,
      waliName: map['waliName'],
      waliEmail: map['waliEmail'],
      waliRelation: map['waliRelation'],
      attributes: Map<String, bool>.from(map['attributes'] ?? {}),
      dynamicPrompt: List<String>.from(map['dynamicPrompt'] ?? []),
      likes: List<String>.from(map['likes'] ?? []),
      skips: List<String>.from(map['skips'] ?? []),
    );
  }
}
旋
