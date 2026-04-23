import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jodohku_malaysia/src/features/auth/application/auth_notifier.dart';
import 'package:jodohku_malaysia/src/features/auth/domain/auth_models.dart';
import 'package:jodohku_malaysia/src/features/auth/presentation/auth_landing_screen.dart';
import 'package:jodohku_malaysia/src/features/auth/presentation/login_screen.dart';
import 'package:jodohku_malaysia/src/features/onboarding/presentation/registration_screen.dart';
import 'package:jodohku_malaysia/src/features/onboarding/presentation/otp_screen.dart';
import 'package:jodohku_malaysia/src/features/navigation/main_navigation_screen.dart';

class AppRouter extends ConsumerWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    // LOGIC: Centralized State-to-Screen Mapping
    switch (authState.status) {
      case AuthStatus.unauthenticated:
        return const AuthLandingScreen();
      
      case AuthStatus.authenticating:
        // Show a loading overlay on top of current screen
        return const AuthLandingScreen(isAuthenticating: true);

      case AuthStatus.awaitingOtp:
        // Although we use Magic Links, we'll keep this for legacy or future OTP needs
        return const OtpVerificationScreen();

      case AuthStatus.authenticated:
        return const MainNavigationScreen();

      case AuthStatus.error:
        return const AuthLandingScreen();
    }
  }
}
