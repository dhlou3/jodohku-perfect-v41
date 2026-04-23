import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jodohku_malaysia/src/theme/app_theme.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  bool _isCapturing = false;
  bool _isVerifying = false;

  void _startVerification() async {
    setState(() => _isCapturing = true);
    await Future.delayed(const Duration(seconds: 3)); // Simulate Camera Capture
    setState(() {
      _isCapturing = false;
      _isVerifying = true;
    });
    await Future.delayed(const Duration(seconds: 4)); // Simulate AI Processing
    if (mounted) Navigator.pop(context); // Verification Done
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Text('Pengesahan Identiti', style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            Text('Ambil selfie untuk padankan dengan akaun MyKad anda.', textAlign: TextAlign.center, style: GoogleFonts.outfit(color: AppColors.textSubtle, fontSize: 14)),
            
            const SizedBox(height: 64),
            
            // CAMERA VIEW / SCANNER ANIMATION
            _buildCameraFrame(),
            
            const SizedBox(height: 64),
            
            if (!_isVerifying)
              Column(
                children: [
                  _buildGuideline(Icons.light_mode_outlined, 'Pastikan pencahayaan cukup'),
                  _buildGuideline(Icons.face_retouching_natural, 'Tanggalkan cermin mata hitam / mask'),
                ],
              ),
              
            if (_isVerifying)
              Column(
                children: [
                  const CircularProgressIndicator(color: AppColors.primaryGold),
                  const SizedBox(height: 16),
                  Text('AI sedang memadankan muka dengan MyKad...', style: GoogleFonts.outfit(color: AppColors.primaryGold, fontWeight: FontWeight.bold)),
                ],
              ),
              
            const Spacer(),
            
            if (!_isCapturing && !_isVerifying)
              ElevatedButton(
                onPressed: _startVerification,
                style: AppTheme.proButtonPrimary,
                child: const Text('MULAKAN IMBASAN'),
              ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraFrame() {
    return Container(
      width: 280, height: 280,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        shape: BoxShape.circle,
        border: Border.all(color: _isVerifying ? AppColors.primaryGold : Colors.white24, width: 2),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.person_outline, size: 120, color: Colors.white.withOpacity(0.1)),
          if (_isCapturing || _isVerifying)
            const Positioned.fill(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(color: AppColors.accentCyan, strokeWidth: 1),
              ),
            ),
          // SCANNING BAR ANIMATION (Simulation)
          if (_isVerifying)
            _buildScanningBar(),
        ],
      ),
    );
  }

  Widget _buildScanningBar() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: -100, end: 100),
      duration: const Duration(seconds: 1),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, value),
          child: Container(height: 2, width: 200, decoration: BoxDecoration(boxShadow: [BoxShadow(color: AppColors.primaryGold, blurRadius: 10)], color: AppColors.primaryGold)),
        );
      },
      onEnd: () {}, 
    );
  }

  Widget _buildGuideline(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.accentCyan, size: 18),
          const SizedBox(width: 12),
          Text(label, style: GoogleFonts.outfit(color: AppColors.textSubtle, fontSize: 13)),
        ],
      ),
    );
  }
}
