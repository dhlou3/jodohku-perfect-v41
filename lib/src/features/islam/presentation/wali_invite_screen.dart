import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jodohku_malaysia/src/theme/app_theme.dart';

class WaliInviteScreen extends StatelessWidget {
  const WaliInviteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // ICON HERO
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(color: AppColors.accentCyan.withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.security_outlined, color: AppColors.accentCyan, size: 64),
            ),
            const SizedBox(height: 48),
            
            Text('Jemput Wali Anda', style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 16),
            Text(
              'Gunakan Mod Wali untuk penglibatan keluarga yang lebih berkat dan selamat dalam urusan Taaruf anda.',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(color: AppColors.textSubtle, fontSize: 14, height: 1.6),
            ),
            
            const SizedBox(height: 48),
            
            // VALUE PROP LIST
            _buildProp(Icons.check_circle_outline, 'Wali dapat memantau perbualan anda'),
            _buildProp(Icons.check_circle_outline, 'Peluang mendapat restu lebih awal'),
            _buildProp(Icons.check_circle_outline, 'Perlidungan penuh dari AI Sentinel'),
            
            const Spacer(),
            
            ElevatedButton(
              onPressed: () {},
              style: AppTheme.proButtonPrimary,
              child: const Text('JEMPUT VIA WHATSAPP \u2192'),
            ),
            const SizedBox(height: 16),
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Mungkin Kemudian', style: GoogleFonts.outfit(color: Colors.white24))),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildProp(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryGold, size: 20),
          const SizedBox(width: 16),
          Expanded(child: Text(label, style: GoogleFonts.outfit(color: Colors.white70, fontSize: 13))),
        ],
      ),
    );
  }
}
