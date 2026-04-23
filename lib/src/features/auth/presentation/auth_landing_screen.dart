import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jodohku_malaysia/src/theme/app_theme.dart';
import 'package:jodohku_malaysia/src/features/auth/application/auth_notifier.dart';
import 'package:jodohku_malaysia/src/features/onboarding/presentation/registration_screen.dart';
import 'package:jodohku_malaysia/src/features/auth/presentation/login_screen.dart';

class AuthLandingScreen extends ConsumerWidget {
  final bool isAuthenticating;
  const AuthLandingScreen({super.key, this.isAuthenticating = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        children: [
          // THE LUXURY HERO (FROM SCREENSHOT)
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1583939003579-730e3918a45a?auto=format&fit=crop&q=80&w=1000'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Deep Navy Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF070D1E).withOpacity(0.4),
                  const Color(0xFF070D1E).withOpacity(0.95),
                ],
              ),
            ),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // LANGUAGE TOGGLE
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: Text(
                        'EN | MS',
                        style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // BRAND LOGO
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.outfit(
                        fontSize: 64,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -2,
                      ),
                      children: const [
                        TextSpan(text: 'Jodoh'),
                        TextSpan(
                          text: 'ku',
                          style: TextStyle(color: AppColors.primaryGold),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    'Find a love blessed under the guidance of Sharia.',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w400,
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 48),

                  // PRIMARY ACTION (LOGIC CONNECTED)
                  ElevatedButton(
                    onPressed: isAuthenticating ? null : () {
                      // PHASE 1 LOGIC: Triggering registration state
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const RegistrationScreen()));
                    },
                    style: AppTheme.vibrantButton,
                    child: isAuthenticating 
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Text('CREATE NEW ACCOUNT'),
                  ),

                  const SizedBox(height: 16),

                  // SECONDARY ACTION (LOGIC CONNECTED)
                  OutlinedButton(
                    onPressed: isAuthenticating ? null : () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                    },
                    style: AppTheme.outlineButton,
                    child: const Text('LOG IN'),
                  ),

                  const SizedBox(height: 40),

                  // BISMILLAH FOOTER
                  Center(
                    child: Text(
                      'بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ',
                      style: GoogleFonts.amiri(
                        fontSize: 24,
                        color: AppColors.primaryGold.withOpacity(0.8),
                        height: 1.2,
                      ),
                    ),
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




