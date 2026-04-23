import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jodohku_malaysia/src/features/venues/domain/venue.dart';
import 'package:jodohku_malaysia/src/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SafeDatesScreen extends ConsumerWidget {
  const SafeDatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final venues = ref.watch(venueServiceProvider).getVenues();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Safe-Date Venues',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.emeraldGradient,
        ),
        child: SafeArea(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            itemCount: venues.length,
            itemBuilder: (context, index) {
              final venue = venues[index];
              return _VenueCard(venue: venue);
            },
          ),
        ),
      ),
    );
  }
}

class _VenueCard extends StatelessWidget {
  final SafeVenue venue;
  const _VenueCard({required this.venue});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.bottom(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.network(
                venue.photoUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 180,
                  color: AppColors.darkEmerald,
                  child: const Icon(Icons.restaurant, color: Colors.white24),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.accentMint,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.verified, color: Colors.white, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        'JAKIM Certified',
                        style: GoogleFonts.outfit(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  venue.name,
                  style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  '${venue.location}, ${venue.city}',
                  style: GoogleFonts.outfit(fontSize: 13, color: Colors.white38),
                ),
                const SizedBox(height: 12),
                Text(
                  venue.description,
                  style: GoogleFonts.outfit(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
