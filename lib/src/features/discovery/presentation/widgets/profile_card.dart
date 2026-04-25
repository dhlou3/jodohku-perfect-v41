import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jodohku_malaysia/src/theme/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jodohku_malaysia/src/features/auth/domain/member_profile.dart';
import 'package:jodohku_malaysia/src/features/matching/application/discovery_notifier.dart';

class ProfileCard extends ConsumerWidget {
  final DiscoveryMatch match;

  const ProfileCard({super.key, required this.match});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // PROFILE IMAGE AREA
          Stack(
            children: [
              Container(
                height: 400,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                  image: DecorationImage(
                    image: NetworkImage(match.profile.photoUrl ?? 'https://images.unsplash.com/photo-1512484776495-a09d92e87c3b?auto=format&fit=crop&q=80&w=800'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppColors.background.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
              ),
              
              // MATCH SCORE (GOLD TAG)
              Positioned(
                top: 20, 
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGold,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [BoxShadow(color: AppColors.primaryGold.withOpacity(0.3), blurRadius: 15)],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.bolt, size: 16, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        '${match.score.toStringAsFixed(0)}% MATCH',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().shimmer(duration: 2.seconds),

              // IDENTITY OVERLAY
              Positioned(
                bottom: 24,
                left: 24,
                right: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          match.profile.fullName,
                          style: GoogleFonts.outfit(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -1,
                          ),
                        ),
                        if (match.profile.isWaliVerified) ...[
                          const SizedBox(width: 10),
                          const Icon(Icons.verified, color: AppColors.accentCyan, size: 24),
                        ]
                      ],
                    ),
                    Text(
                      '${match.profile.birthState} • ${match.profile.age} YEARS OLD',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        color: Colors.white70,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // DETAILS
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPromptItem('PRAYER FREQUENCY', _getReligiousLabel(match.profile.prayerFrequency)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Divider(color: Colors.white.withOpacity(0.05)),
                ),
                _buildPromptItem('MARITAL INTENT', _getIntentLabel(match.profile.maritalIntent)),
              ],
            ),
          ),

          // ACTION BUTTONS
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _circleBtn(Icons.close, Colors.white, onTap: () {}),
                _circleBtn(Icons.star, AppColors.primaryGold, isLarge: true, onTap: () {}),
                _circleBtn(Icons.favorite, AppColors.primaryGold, onTap: () {}),
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
            fontWeight: FontWeight.w900,
            color: AppColors.primaryGold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          a,
          style: GoogleFonts.outfit(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w500,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _circleBtn(IconData icon, Color color, {bool isLarge = false, required VoidCallback onTap}) {
    return Container(
      width: isLarge ? 84 : 64,
      height: isLarge ? 84 : 64,
      decoration: BoxDecoration(
        color: isLarge ? AppColors.primaryGold : Colors.white.withOpacity(0.05),
        shape: BoxShape.circle,
        border: Border.all(color: isLarge ? Colors.transparent : Colors.white.withOpacity(0.1)),
        boxShadow: isLarge ? [BoxShadow(color: AppColors.primaryGold.withOpacity(0.3), blurRadius: 20)] : [],
      ),
      child: Icon(icon, color: isLarge ? Colors.white : color, size: isLarge ? 36 : 28),
    );
  }

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
