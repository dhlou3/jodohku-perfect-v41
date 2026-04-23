import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jodohku_malaysia/src/theme/app_theme.dart';

class StoryBar extends StatelessWidget {
  const StoryBar({super.key});

  @override
  Widget build(BuildContext context) {
    final stories = [
      {'icon': '📜', 'label': 'Hadith Harian'},
      {'icon': '💡', 'label': 'Tips Taaruf'},
      {'icon': '💍', 'label': 'Kisah Nikah'},
      {'icon': '🏆', 'label': 'Top Picks'},
      {'icon': '🕌', 'label': 'Sunnah'},
    ];

    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: stories.length,
        itemBuilder: (context, idx) {
          final s = stories[idx];
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Column(
              children: [
                Container(
                  width: 70, height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primaryGold, width: 2),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.primaryGold.withOpacity(0.3), Colors.transparent],
                    ),
                  ),
                  child: Center(child: Text(s['icon']!, style: const TextStyle(fontSize: 30))),
                ),
                const SizedBox(height: 8),
                Text(s['label']!, style: GoogleFonts.outfit(fontSize: 11, color: Colors.white70, fontWeight: FontWeight.w500)),
              ],
            ),
          );
        },
      ),
    );
  }
}
