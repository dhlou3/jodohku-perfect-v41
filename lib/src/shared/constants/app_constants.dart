enum MaritalIntent {
  immediate,
  nearFuture,
  educational,
}

enum PrayerFrequency {
  always,
  usually,
  sometimes,
  rarely,
  notPracticing,
}

enum HijabPreference {
  hijabi,
  notHijabi,
  openToBoth,
}

class AppConstants {
  static const List<String> regions = [
    'Klang Valley',
    'Penang',
    'Johor Bahru',
    'Ipoh',
    'Melaka',
    'Kota Kinabalu',
    'Kuching',
    'Kuantan',
  ];

  static const List<String> icebreakers = [
    'What is your favorite mosque in Malaysia?',
    'How do you spend your Friday mornings?',
    'What is your favorite Halal cafe in your city?',
    'What role does faith play in your daily life?',
    'What is your favorite local dish for Iftar?',
  ];
}
