import 'package:jodohku_malaysia/src/features/auth/domain/member_profile.dart';

class StorageService {
  static MemberProfile? _cachedProfile;

  // CORE LOGIC: Simulated Persistence
  static Future<void> saveProfile(MemberProfile profile) async {
    // In production, this writes to SharedPreferences / SecureStorage
    _cachedProfile = profile;
    await Future.delayed(const Duration(milliseconds: 500));
  }

  static Future<MemberProfile?> getProfile() async {
    return _cachedProfile;
  }

  static Future<void> clear() async {
    _cachedProfile = null;
  }
}
