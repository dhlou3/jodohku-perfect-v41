import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jodohku_malaysia/src/theme/app_theme.dart';
import 'package:jodohku_malaysia/src/features/auth/application/auth_notifier.dart';
import 'package:jodohku_malaysia/src/features/auth/domain/auth_models.dart';
import 'package:jodohku_malaysia/src/features/onboarding/presentation/otp_screen.dart';

import 'package:jodohku_malaysia/src/features/auth/application/ic_service.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({super.key});

  @override
  ConsumerState<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _icController = TextEditingController();
  bool _biometricRequested = false;
  
  // LOGIC: Local Display State
  String _age = '—';
  String _gender = '—';
  String _state = '—';

  void _onIcChanged(String val) {
    if (val.length == 12) {
      final result = IcService.parse(val);
      if (result != null) {
        setState(() {
          _age = '${result.age} Tahun';
          _gender = result.gender;
          _state = result.birthState;
        });
      }
    }
  }

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Register Account',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 12),
            Text(
              'Your first step towards halal happiness.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 48),

            _buildLabel('FULL NAME (AS PER IC)'),
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: AppTheme.glassInput('Ahmad Bin Abdullah'),
            ),

            const SizedBox(height: 24),
            _buildLabel('IC NUMBER (12 DIGITS)'),
            TextField(
              controller: _icController,
              onChanged: _onIcChanged,
              keyboardType: TextInputType.number,
              maxLength: 12,
              style: const TextStyle(color: Colors.white),
              decoration: AppTheme.glassInput('000000000000'),
            ),
            
            if (_icController.text.length == 12)
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _infoBit('UMUR', _age),
                    _infoBit('JANTINA', _gender),
                    _infoBit('NEGERI', _state),
                  ],
                ),
              ),

            const SizedBox(height: 24),
            _buildLabel('EMAIL ADDRESS'),
            TextField(
              controller: _emailController,
              style: const TextStyle(color: Colors.white),
              decoration: AppTheme.glassInput('name@example.com'),
            ),

            const SizedBox(height: 32),
            if (authState.biometricAvailable)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primaryGold.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.primaryGold.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.fingerprint, color: AppColors.primaryGold, size: 32),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Enable Biometrics', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white)),
                          Text('Use FaceID/Fingerprint for future logins', style: GoogleFonts.outfit(fontSize: 12, color: Colors.white60)),
                        ],
                      ),
                    ),
                    Switch(
                      value: _biometricRequested,
                      onChanged: (val) => setState(() => _biometricRequested = val),
                      activeColor: AppColors.primaryGold,
                    ),
                  ],
                ),
              ),
            
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: isAuthenticating ? null : () {
                if (_emailController.text.isNotEmpty) {
                  ref.read(authProvider.notifier).sendMagicLink(_emailController.text);
                }
              },
              style: AppTheme.vibrantButton,
              child: isAuthenticating 
                ? const CircularProgressIndicator(color: Colors.black)
                : const Text('CONTINUE TO VERIFICATION \u2192'),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Text(
        text,
        style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white.withOpacity(0.4), letterSpacing: 1.5),
      ),
    );
  }

  Widget _infoBit(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.outfit(fontSize: 9, color: Colors.white.withOpacity(0.4), fontWeight: FontWeight.w800, letterSpacing: 1)),
        const SizedBox(height: 4),
        Text(value, style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }
}




