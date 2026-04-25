import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';
import 'package:jodohku_malaysia/src/features/auth/domain/auth_models.dart';
import 'package:jodohku_malaysia/src/features/auth/domain/member_profile.dart';
import 'package:jodohku_malaysia/src/features/auth/application/firestore_service.dart';
import 'package:jodohku_malaysia/src/features/notifications/application/notification_notifier.dart';

class AuthNotifier extends StateNotifier<JodohkuAuthState> {
  final Ref ref;
  final LocalAuthentication _localAuth = LocalAuthentication();

  AuthNotifier(this.ref) : super(JodohkuAuthState()) {
    checkBiometricAvailability();
  }

  Future<void> checkBiometricAvailability() async {
    final isAvailable = await _localAuth.canCheckBiometrics || await _localAuth.isDeviceSupported();
    state = state.copyWith(biometricAvailable: isAvailable);
  }

  Future<void> sendMagicLink(String email) async {
    state = state.copyWith(status: AuthStatus.authenticating, email: email);
    
    // Real implementation: FirebaseAuth.instance.sendSignInLinkToEmail(...)
    await Future.delayed(const Duration(seconds: 2));
    
    ref.read(notificationProvider.notifier).show('MAGIC LINK DIHANTAR! 📧', 'Sila semak e-mel anda ($email) untuk akses masuk.');
    
    // For demo purposes, we'll verify it automatically after a shorter delay
    await Future.delayed(const Duration(seconds: 3));
    state = state.copyWith(status: AuthStatus.authenticated);
  }

  Future<void> authenticateWithBiometrics() async {
    if (!state.biometricAvailable) return;

    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Gunakan biometrik untuk log masuk ke Jodohku',
        options: const AuthenticationOptions(stickyAuth: true),
      );

      if (authenticated) {
        state = state.copyWith(status: AuthStatus.authenticating);
        await Future.delayed(const Duration(seconds: 1));
        state = state.copyWith(status: AuthStatus.authenticated);
      }
    } catch (e) {
      state = state.copyWith(errorMessage: 'Biometric failed: $e');
    }
  }

  Future<void> sendMagicLink(String email) async {
    state = state.copyWith(status: AuthStatus.authenticating);
    // LOGIC: Simulation
    await Future.delayed(const Duration(seconds: 2));
    state = state.copyWith(status: AuthStatus.awaitingOtp, email: email);
  }

  Future<void> verifyOtp(String code) async {
    state = state.copyWith(status: AuthStatus.authenticating);
    // LOGIC: Simulation
    await Future.delayed(const Duration(seconds: 2));
    state = state.copyWith(status: AuthStatus.authenticated);
  }

  Future<void> upgradeToSultan() async {
    state = state.copyWith(status: AuthStatus.authenticating);
    
    // LOGIC: Verify payment or trigger cloud script
    await Future.delayed(const Duration(seconds: 2));
    
    final profile = await FirestoreService.getProfile();
    if (profile != null) {
      await FirestoreService.saveProfile(profile.copyWith(isSultan: true));
    }
    
    state = state.copyWith(status: AuthStatus.authenticated);
    ref.read(notificationProvider.notifier).show('STATUS SULTAN AKTIF! 💎', 'Selamat datang ke Elit Jodohku. Akses anda telah dibuka.');
  }

  Future<void> updateWali({required String name, required String email, required String relation}) async {
    final profile = await FirestoreService.getProfile();
    if (profile != null) {
      final updated = profile.copyWith(
        waliName: name,
        waliEmail: email,
        waliRelation: relation,
        isWaliVerified: true,
      );
      await FirestoreService.saveProfile(updated);
      ref.read(notificationProvider.notifier).show('WALI DIKEMASKINI 🛡️', 'Maklumat penjaga anda telah selamat disimpan.');
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    state = JodohkuAuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, JodohkuAuthState>((ref) {
  return AuthNotifier(ref);
});

final profileProvider = StreamProvider<MemberProfile?>((ref) {
  return FirestoreService.watchProfile();
});

