import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jodohku_malaysia/src/theme/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:jodohku_malaysia/src/features/matching/application/discovery_notifier.dart';

class ProfileCard extends ConsumerWidget {
  final DiscoveryMatch match;

  const ProfileCard({super.key, required this.match});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: const Color(0xFFF0E6D8), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // PROFILE IMAGE AREA
          Stack(
            children: [
              Container(
                height: 320,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFFAF7F2),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Center(
                  child: Text(
                    match.profile.fullName.isNotEmpty ? match.profile.fullName[0] : 'J',
                    style: GoogleFonts.outfit(
                      fontSize: 120,
                      color: const Color(0xFFBD8B52).withOpacity(0.2),
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ),
              ),
              
              // MATCH LABEL (PHASE 3: INJECTED SCORE)
              Positioned(
                top: 20, 
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: const Color(0xFFF0ECE4)),
                    boxShadow: [BoxShadow(color: const Color(0xFFBD8B52).withOpacity(0.1), blurRadius: 10)],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.bolt, size: 14, color: Color(0xFFBD8B52)),
                      const SizedBox(width: 6),
                      Text(
                        '${match.score.toStringAsFixed(0)}% Match',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFFBD8B52),
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().shimmer(duration: 2.seconds, color: Colors.white70),

              // IDENTITY META
              Positioned(
                bottom: 20,
                left: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      match.profile.fullName,
                      style: GoogleFonts.outfit(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFBD8B52),
                        letterSpacing: -1,
                      ),
                    ),
                    Text(
                      '${match.profile.birthState} • ${match.profile.age} Tahun',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: Colors.black.withOpacity(0.6),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // PROMPT-STYLE DETAILS
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPromptItem('KEKERAPAN SOLAT', _getReligiousLabel(match.profile.prayerFrequency)),
                const Divider(height: 32, color: Color(0xFFF0F0F0)),
                _buildPromptItem('INTENSI PERKAHWINAN', _getIntentLabel(match.profile.maritalIntent)),
              ],
            ),
          ),

          // TAGS
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (match.profile.isWaliVerified) _tag('✓ WALI DISAHKAN', isMatch: true),
                if (match.profile.isSultan) _tag('💎 SULTAN MEMBER', isMatch: true),
                _tag('📍 ${match.profile.birthState}'),
              ],
            ),
          ),
          
          // ACTION BUTTONS (FLOW B: REAL WIRING)
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _circleBtn(Icons.close, Colors.grey, onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profil dialihkan.')));
                }),
                _circleBtn(Icons.star, const Color(0xFFBD8B52), isLarge: true, onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Super Like dihantar!')));
                }),
                _circleBtn(Icons.favorite, const Color(0xFFBD8B52), onTap: () async {
                  final myProfile = ref.read(profileProvider).value;
                  if (myProfile?.waliName == null || myProfile!.waliName!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('⚠️ Sila daftarkan Wali anda di Profil sebelum memulakan Taaruf.'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                    return;
                  }
                  
                  // Record the like first in the unified discovery notifier
                  final result = await ref.read(discoveryProvider.notifier).recordLike(match.profile.id!);
                  
                  if (result == MatchResult.match) {
                    ref.read(notificationProvider.notifier).show(
                      'ALHAMDULILLAH! PADANAN DITEMUI 🎉', 
                      'Anda dan ${match.profile.fullName} kini boleh memulakan Taaruf.'
                    );
                    // Force navigation to Chat tab
                    ref.read(navigationProvider.notifier).setTab(2);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Minat anda kepada ${match.profile.fullName} telah direkodkan. ✨'))
                    );
                  }
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildPromptItem(String q, String a) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          q,
          style: GoogleFonts.outfit(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: const Color(0xFFBD8B52),
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          a,
          style: GoogleFonts.outfit(
            fontSize: 15,
            color: const Color(0xFF444444),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _tag(String text, {bool isMatch = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isMatch ? const Color(0xFFFDF9F4) : Colors.white,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: isMatch ? const Color(0xFFBD8B52) : const Color(0xFFEEEEEE)),
      ),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.w900,
          color: isMatch ? const Color(0xFFBD8B52) : const Color(0xFF666666),
        ),
      ),
    );
  }

  Widget _circleBtn(IconData icon, Color color, {bool isLarge = false, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      width: isLarge ? 80 : 64,
      height: isLarge ? 80 : 64,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: isLarge ? const Color(0xFFBD8B52) : const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, color: isLarge ? const Color(0xFFBD8B52) : color, size: isLarge ? 32 : 24),
    ),);
  String _getReligiousLabel(PrayerFrequency freq) {
    switch (freq) {
      case PrayerFrequency.never: return 'Tidak Pernah';
      case PrayerFrequency.usually: return 'Kadang-kadang';
      case PrayerFrequency.often: return 'Biasanya (5 Waktu)';
      case PrayerFrequency.always: return 'Sentiasa (Istiqamah)';
    }
  }

  String _getIntentLabel(MaritalIntent intent) {
    switch (intent) {
      case MaritalIntent.exploring: return 'Mengenali Hati';
      case MaritalIntent.nearFuture: return 'Tahun Depan';
      case MaritalIntent.serious: return 'Serius (Sedia)';
      case MaritalIntent.immediate: return 'Segera (Akad)';
    }
  }
}
