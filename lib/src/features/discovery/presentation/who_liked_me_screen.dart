import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jodohku_malaysia/src/theme/app_theme.dart';

class WhoLikedMeScreen extends StatelessWidget {
  final bool isPremium;

  const WhoLikedMeScreen({super.key, this.isPremium = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Siapa Suka Saya', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // PREMIUM UPSELL HEADER (If free)
          if (!isPremium)
            _buildUpsellHeader(),
            
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: 12,
              itemBuilder: (context, idx) {
                return _buildLikerCard(idx);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpsellHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.primaryGold, Color(0xFFB45309)]),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Icon(Icons.diamond, color: Colors.white, size: 32),
          const SizedBox(height: 12),
          Text('Lihat 124 Orang Yang Suka Anda', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          Text('Upgrade ke Platinum sekarang!', style: GoogleFonts.outfit(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildLikerCard(int idx) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // MOCK AVATAR
            Container(color: Colors.white10, child: const Center(child: Icon(Icons.person, color: Colors.white24, size: 50))),
            
            // THE BLUR (Tinder Premium Style)
            if (!isPremium)
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(color: Colors.black.withOpacity(0.1)),
                ),
              ),
              
            // NAME (If premium, clear. If free, hidden/blurry)
            Positioned(
              bottom: 16, left: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(isPremium ? 'Nur Aisyah, 24' : 'Seseorang...', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(isPremium ? 'Kuala Lumpur' : 'Lokasi Disembunyikan', style: GoogleFonts.outfit(color: Colors.white70, fontSize: 10)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
