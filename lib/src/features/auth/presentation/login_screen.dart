import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jodohku_malaysia/src/theme/app_theme.dart';
import 'package:jodohku_malaysia/src/features/auth/application/auth_notifier.dart';
import 'package:jodohku_malaysia/src/features/auth/domain/auth_models.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isAuthenticating = authState.status == AuthStatus.authenticating;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 100,
        leading: TextButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryGold, size: 18),
          label: Text('Back', style: GoogleFonts.outfit(color: AppColors.primaryGold, fontWeight: FontWeight.bold)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Welcome Back',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 12),
            Text(
              'Please enter your email to receive a magic link.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 60),

            Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 4),
              child: Text(
                'EMAIL ADDRESS',
                style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white.withOpacity(0.4), letterSpacing: 1.5),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.1), width: 2),
              ),
              child: Row(
                children: [
                  const Icon(Icons.email_outlined, color: AppColors.primaryGold, size: 20),
                  const SizedBox(width: 15),
                  Expanded(
                    child: TextField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'name@example.com',
                        hintStyle: TextStyle(color: Colors.white24),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 48),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: ElevatedButton(
                    onPressed: isAuthenticating ? null : () {
                      if (_emailController.text.isNotEmpty) {
                        ref.read(authProvider.notifier).sendMagicLink(_emailController.text);
                      }
                    },
                    style: AppTheme.vibrantButton,
                    child: isAuthenticating 
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                      : const Text('SEND MAGIC LINK'),
                  ),
                ),
                if (authState.biometricAvailable) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () => ref.read(authProvider.notifier).authenticateWithBiometrics(),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.primaryGold.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.primaryGold.withOpacity(0.3), width: 2),
                        ),
                        child: const Icon(Icons.fingerprint, color: AppColors.primaryGold, size: 32),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
