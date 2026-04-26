import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jodohku_malaysia/src/features/matching/domain/discovery_match.dart';
import 'package:jodohku_malaysia/src/theme/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileCard extends StatelessWidget {
  final DiscoveryMatch match;
  const ProfileCard({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE SECTION (MATCHING WEB 420px FEEL)
          Stack(
            children: [
              SizedBox(
                height: 420,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: match.candidate.photoUrl ?? '',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(color: AppColors.primaryGold.withOpacity(0.1)),
                  errorWidget: (context, url, error) => Image.network(
                    'https://ui-avatars.com/api/?name=${Uri.encodeComponent(match.candidate.fullName ?? 'User')}&background=BD8B52&color=fff&size=512',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Match Score Badge (Premium Web Style)
              Positioned(
                top: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: AppColors.primaryGold, width: 1.5),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('✨', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${match.score.toStringAsFixed(0)}% KESERASIAN',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primaryGold,
                              height: 1,
                            ),
                          ),
                          Text(
                            _getMatchLabel(match.score),
                            style: GoogleFonts.outfit(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF374151),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // CARD BODY
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Expanded(
                      child: Text(
                        match.candidate.fullName ?? 'Calon Jodohku',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primaryGold,
                        ),
                      ),
                    ),
                    Text(
                      'JDK-ELITE',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF9CA3AF),
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${match.candidate.profession ?? 'Professional'} • ${match.candidate.birthState ?? 'Malaysia'} • ${match.candidate.age ?? 25} thn',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 16),
                
                // BIO BOX
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFF3F4F6)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '📝 STATUS HARI INI',
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primaryGold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        match.candidate.bio ?? "As-salam, saya mencari teman syurga.",
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          color: const Color(0xFF1F2937),
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // INTEREST CHIPS
                Wrap(
                  spacing: 8,
                  children: (match.candidate.interests ?? []).take(3).map((interest) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Text(
                      interest,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF374151),
                      ),
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getMatchLabel(double score) {
    if (score >= 90) return 'Sangat Serasi (Elite Match)';
    if (score >= 80) return 'Serasi (Barakah)';
    if (score >= 70) return 'Sesuai (Berpotensi)';
    return 'Mencari Keserasian';
  }
}
