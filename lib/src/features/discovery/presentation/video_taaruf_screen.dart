import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jodohku_malaysia/src/theme/app_theme.dart';

class VideoTaarufScreen extends StatelessWidget {
  final String userName;

  const VideoTaarufScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Immersive Dark Mode
      body: Stack(
        children: [
          // MOCK VIDEO CONTENT (Full Screen)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
              ),
            ),
            child: Center(
              child: Icon(Icons.play_circle_fill, color: Colors.white.withOpacity(0.2), size: 100),
            ),
          ),
          
          // WATERMARK (Privacy Layer)
          const Positioned(
            top: 60, left: 20,
            child: Text('Jodohku SECURE VIDEO • DO NOT RECORD', style: TextStyle(color: Colors.white24, fontSize: 10, letterSpacing: 1.5)),
          ),

          // OVERLAY DETAILS
          Positioned(
            bottom: 40, left: 24, right: 90,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(userName, style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(width: 8),
                    const Icon(Icons.verified, color: AppColors.primaryGold, size: 20),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Guru • Selangor • 27 Tahun', style: GoogleFonts.outfit(color: Colors.white70)),
                const SizedBox(height: 16),
                Text(
                  'Assalamualaikum, saya mencari pasangan yang boleh membimbing saya ke arah yang lebih baik...',
                  style: GoogleFonts.outfit(color: Colors.white),
                  maxLines: 2, overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // SIDE ACTIONS (Elite Glassmorphism)
          Positioned(
            right: 20, bottom: 60,
            child: Column(
              children: [
                _buildAction(Icons.favorite, AppColors.primaryGold),
                const SizedBox(height: 24),
                _buildAction(Icons.star, AppColors.accentCyan),
                const SizedBox(height: 24),
                _buildAction(Icons.chat_bubble, Colors.white),
                const SizedBox(height: 48),
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white10,
                  child: Text('N', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          // BACK BUTTON
          Positioned(
            top: 50, left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAction(IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 50, height: 50,
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle, border: Border.all(color: Colors.white24)),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 4),
        Text('87%', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 10)),
      ],
    );
  }
}
