import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jodohku_malaysia/src/theme/app_theme.dart';
import 'package:jodohku_malaysia/src/features/navigation/main_navigation_screen.dart';

class OtpVerificationScreen extends ConsumerWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isAuthenticating = authState.status == AuthStatus.authenticating;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              'Sahkan Kod',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 32),
            ),
            const SizedBox(height: 12),
            Text(
              'Kod 6-digit telah dihantar ke nombor telefon anda.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSubtle),
            ),
            const SizedBox(height: 48),
            
            // OTP Boxes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) => _OtpBox(index == 0)),
            ),
            
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: isAuthenticating ? null : () {
                // PHASE 1 LOGIC: Simulating OTP Verification
                ref.read(authProvider.notifier).verifyOtp('123456');
              },
              style: AppTheme.vibrantButton,
              child: isAuthenticating 
                ? const CircularProgressIndicator(color: Colors.black)
                : const Text('SAHKAN & MASUK'),
            ),
            
            if (authState.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(authState.errorMessage!, style: const TextStyle(color: Colors.redAccent)),
              ),

            const SizedBox(height: 24),
            TextButton(
              onPressed: () {},
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.outfit(fontSize: 14, color: AppColors.textSubtle),
                  children: const [
                    TextSpan(text: 'Tidak terima kod? '),
                    TextSpan(
                      text: 'Hantar Semula (58s)',
                      style: TextStyle(color: AppColors.primaryGold, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _OtpBox extends StatelessWidget {
  final bool isFirst;
  const _OtpBox([this.isFirst = false]);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.glass,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isFirst ? AppColors.primaryGold : AppColors.glassBorder, width: isFirst ? 2 : 1),
      ),
      alignment: Alignment.center,
      child: Text(
        isFirst ? '1' : '',
        style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}



