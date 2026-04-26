import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jodohku_malaysia/src/theme/app_theme.dart';
import 'package:jodohku_malaysia/src/features/auth/application/auth_notifier.dart';
import 'package:jodohku_malaysia/src/features/onboarding/presentation/registration_screen.dart';

class AuthLandingScreen extends ConsumerWidget {
  final bool isAuthenticating;
  const AuthLandingScreen({super.key, this.isAuthenticating = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        children: [
          // THE ELITE HERO (MATCHING WEB)
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/wedding_hero.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Midnight Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF0B0E14).withOpacity(0.2),
                  const Color(0xFF0B0E14).withOpacity(0.6),
                  const Color(0xFF0B0E14).withOpacity(0.95),
                ],
              ),
            ),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // BACK BUTTON (TOP LEFT)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.arrow_back_rounded, color: Colors.white70, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Kembali',
                            style: GoogleFonts.outfit(color: Colors.white70, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),

                  // HERO ICON (MATCHING WEB SVG)
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primaryGold.withOpacity(0.3), width: 2),
                    ),
                    child: const Center(
                      child: Icon(Icons.fingerprint_rounded, color: AppColors.primaryGold, size: 60),
                    ),
                  ),

                  const SizedBox(height: 32),
                  
                  Text(
                    'Selamat Pulang',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  Text(
                    'Log masuk dengan identiti digital anda.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      color: const Color(0xFF9CA3AF),
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 60),

                  // PRIMARY ACTION: GOOGLE LOGIN (MATCHING WEB)
                  ElevatedButton(
                    onPressed: isAuthenticating ? null : () {
                      ref.read(authProvider.notifier).authenticateWithBiometrics();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF111827),
                      minimumSize: const Size(double.infinity, 64),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                      elevation: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network('https://img.icons8.com/color/48/000000/google-logo.png', width: 22, height: 22),
                        const SizedBox(width: 12),
                        Text(
                          'Continue with Google',
                          style: GoogleFonts.outfit(fontWeight: FontWeight.w800, fontSize: 17),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // SECONDARY ACTION: BIOMETRIC (MATCHING WEB)
                  OutlinedButton(
                    onPressed: isAuthenticating ? null : () {
                      ref.read(authProvider.notifier).authenticateWithBiometrics();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryGold,
                      minimumSize: const Size(double.infinity, 60),
                      side: BorderSide(color: AppColors.primaryGold.withOpacity(0.3), width: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                      backgroundColor: AppColors.primaryGold.withOpacity(0.05),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.lock_outline_rounded, size: 24),
                        const SizedBox(width: 12),
                        Text(
                          'Log Masuk Fingerprint',
                          style: GoogleFonts.outfit(fontWeight: FontWeight.w800, fontSize: 16),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // FOOTER NOTE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Belum ada akaun?',
                        style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const RegistrationScreen()));
                        },
                        child: const Text(
                          'Daftar Sekarang',
                          style: TextStyle(color: AppColors.primaryGold, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
