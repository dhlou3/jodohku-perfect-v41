import 'package:jodohku_malaysia/src/features/auth/domain/member_profile.dart';

class ProfileRepository {
  static List<MemberProfile> getPotentialMatches() {
    // LOGIC: DYNAMIC MAPPING OF ALL 37 UNIQUE ASSETS
    final List<String> assets = [
        "file:///C:/Users/amin/.gemini/antigravity/brain/3c0d9333-ad2b-44a3-a98f-83cf41583457/media__1775651589741.png",
        "file:///C:/Users/amin/.gemini/antigravity/brain/3c0d9333-ad2b-44a3-a98f-83cf41583457/media__1775652409821.png",
        "file:///C:/Users/amin/.gemini/antigravity/brain/3c0d9333-ad2b-44a3-a98f-83cf41583457/media__1775652453801.png",
        "file:///C:/Users/amin/.gemini/antigravity/brain/3c0d9333-ad2b-44a3-a98f-83cf41583457/media__1775652705529.png",
        "file:///C:/Users/amin/.gemini/antigravity/brain/3c0d9333-ad2b-44a3-a98f-83cf41583457/media__1775655048392.png",
        "file:///C:/Users/amin/.gemini/antigravity/brain/3c0d9333-ad2b-44a3-a98f-83cf41583457/media__1775655667570.png",
        "file:///C:/Users/amin/.gemini/antigravity/brain/3c0d9333-ad2b-44a3-a98f-83cf41583457/media__1775655858406.png",
        "file:///C:/Users/amin/.gemini/antigravity/brain/3c0d9333-ad2b-44a3-a98f-83cf41583457/media__1775658742507.png",
        "file:///C:/Users/amin/.gemini/antigravity/brain/3c0d9333-ad2b-44a3-a98f-83cf41583457/media__1775679605667.png",
        "file:///C:/Users/amin/.gemini/antigravity/brain/3c0d9333-ad2b-44a3-a98f-83cf41583457/media__1775679684441.png",
        "file:///C:/Users/amin/.gemini/antigravity/brain/3c0d9333-ad2b-44a3-a98f-83cf41583457/media__1775679867826.png",
        "file:///C:/Users/amin/.gemini/antigravity/brain/3c0d9333-ad2b-44a3-a98f-83cf41583457/media__1775679903042.png",
        "file:///C:/Users/amin/.gemini/antigravity/brain/3c0d9333-ad2b-44a3-a98f-83cf41583457/media__1775690408679.png",
        "file:///C:/Users/amin/.gemini/antigravity/brain/3c0d9333-ad2b-44a3-a98f-83cf41583457/media__1775690788026.png",
        "file:///C:/Users/amin/.gemini/antigravity/brain/3c0d9333-ad2b-44a3-a98f-83cf41583457/media__1775690886246.png",
        "file:///C:/Users/amin/.gemini/antigravity/brain/3c0d9333-ad2b-44a3-a98f-83cf41583457/media__1775691063860.png",
        "file:///C:/Users/amin/.gemini/antigravity/brain/3c0d9333-ad2b-44a3-a98f-83cf41583457/media__1775691165777.png",
        "file:///C:/Users/amin/.gemini/antigravity/brain/3c0d9333-ad2b-44a3-a98f-83cf41583457/media__1775691491730.png",
        "file:///C:/Users/amin/.gemini/antigravity/brain/3c0d9333-ad2b-44a3-a98f-83cf41583457/media__1775691529320.png",
        "file:///C:/Users/amin/.gemini/antigravity/brain/3c0d9333-ad2b-44a3-a98f-83cf41583457/media__1775691572140.png",
        "file:///C:/Users/amin/.gemini/antigravity/brain/3c0d9333-ad2b-44a3-a98f-83cf41583457/media__1775691605303.png",
        "file:///C:/Users/amin/.gemini/antigravity/brain/3c0d9333-ad2b-44a3-a98f-83cf41583457/media__1775691692000.png",
        "file:///C:/Users/amin/.gemini/antigravity/brain/3c0d9333-ad2b-44a3-a98f-83cf41583457/media__1775691738853.png",
        "file:///C:/Users/amin/.gemini/antigravity/brain/3c0d9333-ad2b-44a3-a98f-83cf41583457/media__1775691777749.png",
        "file:///C:/Users/amin/.gemini/antigravity/brain/3c0d9333-ad2b-44a3-a98f-83cf41583457/media__1775691811742.png",
        "file:///C:/Users/amin/.gemini/antigravity/brain/3c0d9333-ad2b-44a3-a98f-83cf41583457/media__1775691847524.png",
        "file:///C:/Users/amin/.gemini/antigravity/brain/3c0d9333-ad2b-44a3-a98f-83cf41583457/media__1775691888902.png",
        "file:///C:/Users/amin/.gemini/antigravity/brain/3c0d9333-ad2b-44a3-a98f-83cf41583457/media__1775691904580.png",
        "file:///C:/Users/amin/.gemini/antigravity/brain/3c0d9333-ad2b-44a3-a98f-83cf41583457/media__1775691922178.png",
        "file:///C:/Users/amin/.gemini/antigravity/brain/3c0d9333-ad2b-44a3-a98f-83cf41583457/media__1775692053651.png",
        "file:///C:/Users/amin/.gemini/antigravity/brain/3c0d9333-ad2b-44a3-a98f-83cf41583457/media__1775692077082.png",
        "file:///C:/Users/amin/.gemini/antigravity/brain/3c0d9333-ad2b-44a3-a98f-83cf41583457/media__1775695911154.png",
        "file:///C:/Users/amin/.gemini/antigravity/brain/3c0d9333-ad2b-44a3-a98f-83cf41583457/media__1775696169898.jpg",
        "file:///C:/Users/amin/.gemini/antigravity/brain/3c0d9333-ad2b-44a3-a98f-83cf41583457/media__1775696169923.jpg",
        "file:///C:/Users/amin/.gemini/antigravity/brain/3c0d9333-ad2b-44a3-a98f-83cf41583457/media__1775696170001.jpg",
        "file:///C:/Users/amin/.gemini/antigravity/brain/3c0d9333-ad2b-44a3-a98f-83cf41583457/muslim_wedding_hijab_hero_1775652283587.png"
    ];

    return List.generate(assets.length, (index) {
      return MemberProfile(
        id: 'user_$index',
        fullName: _names[index % _names.length] + " " + _subs[index % _subs.length],
        icNumber: '950101-10-${5000 + index}',
        phone: '01234567${index.toString().padLeft(2, "0")}',
        email: 'user$index@jodohku.my',
        photoUrl: assets[index],
        birthState: _states[index % _states.length],
        age: 20 + (index % 10),
        prayerFrequency: PrayerFrequency.always,
        gender: index % 2 == 0 ? 'woman' : 'man',
      );
    });
  }

  static const List<String> _names = ["Nur", "Siti", "Farah", "Zarith", "Aisyah", "Dania"];
  static const List<String> _subs = ["Aminah", "Wahida", "Sofia", "Huda", "Balqis"];
  static const List<String> _states = ["Selangor", "Kuala Lumpur", "Johor", "Perak", "Kedah", "Melaka"];
}
