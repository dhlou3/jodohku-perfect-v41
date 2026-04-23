import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jodohku_malaysia/src/theme/app_theme.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Notifikasi', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white)),
        actions: [
          TextButton(onPressed: () {}, child: Text('Read All', style: TextStyle(color: AppColors.primaryGold, fontSize: 12))),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildHeading('Hari Ini'),
          _NotificationItem(
            icon: Icons.verified_user_rounded,
            color: AppColors.accentCyan,
            title: 'Wali Telah Membenarkan',
            desc: 'Wali anda telah meluluskan perbualan dengan Nurul Izzah.',
            time: '2m ago',
            isUnread: true,
          ),
          _NotificationItem(
            icon: Icons.shield_rounded,
            color: Colors.redAccent,
            title: 'Sekatan AI Sentinel',
            desc: 'Satu mesej telah disekat kerana percubaan berkongsi maklumat peribadi.',
            time: '1h ago',
            isUnread: true,
          ),
          const SizedBox(height: 32),
          _buildHeading('Semalam'),
          _NotificationItem(
            icon: Icons.diamond_rounded,
            color: AppColors.primaryGold,
            title: 'Selamat Datang Sovereign',
            desc: 'Akaun anda telah dinaiktaraf ke mod Elite Sovereign. Nikmati kelebihan penuh.',
            time: '1d ago',
            isUnread: false,
          ),
          _NotificationItem(
            icon: Icons.favorite_rounded,
            color: Colors.white,
            title: 'Padanan Baru!',
            desc: 'Seseorang yang mempunyai 98% keserasian telah menyukai anda.',
            time: '1d ago',
            isUnread: false,
          ),
        ],
      ),
    );
  }

  Widget _buildHeading(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(label, style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white24, letterSpacing: 1.5)),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title, desc, time;
  final bool isUnread;

  const _NotificationItem({required this.icon, required this.color, required this.title, required this.desc, required this.time, required this.isUnread});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isUnread ? Colors.white.withOpacity(0.03) : Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isUnread ? color.withOpacity(0.2) : Colors.white10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text(time, style: GoogleFonts.outfit(fontSize: 10, color: Colors.white24)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(desc, style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textSubtle, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
