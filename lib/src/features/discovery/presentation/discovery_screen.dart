import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jodohku_malaysia/src/theme/app_theme.dart';
import 'package:jodohku_malaysia/src/features/matching/application/discovery_notifier.dart';
import 'package:jodohku_malaysia/src/features/auth/domain/member_profile.dart';
import 'package:jodohku_malaysia/src/features/discovery/presentation/widgets/profile_card.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DiscoveryScreen extends ConsumerStatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  ConsumerState<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends ConsumerState<DiscoveryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final user = MemberProfile.initial(); 
      ref.read(discoveryProvider.notifier).loadDiscovery(user);
    });
  }

  @override
  Widget build(BuildContext context) {
    final discoveryState = ref.watch(discoveryProvider);

    return Scaffold(
      backgroundColor: AppColors.premiumTan,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              discoveryState.when(
                data: (matches) {
                  if (matches.isEmpty) return _buildEmptyState();
                  
                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 120),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final match = matches[index];
                          return ProfileCard(match: match);
                        },
                        childCount: 1, // Swipe model: show one at a time like web
                      ),
                    ),
                  );
                },
                loading: () => SliverFillRemaining(
                  child: _buildEliteLoader(),
                ),
                error: (e, _) => SliverFillRemaining(child: Center(child: Text('Error: $e'))),
              ),
            ],
          ),

          // FLOATING ACTION BUTTONS (MATCHING WEB action-float)
          if (discoveryState.hasValue && discoveryState.value!.isNotEmpty)
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildRoundBtn('✕', Colors.black87, () {
                    ref.read(discoveryProvider.notifier).loadDiscovery(MemberProfile.initial()); // Simulate next
                  }),
                  const SizedBox(width: 40),
                  _buildRoundBtn('❤️', const Color(0xFFF43F5E), () {
                    // Like logic
                  }),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEliteLoader() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // THE RADAR (MATCHING WEB radar class)
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryGold, width: 2),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primaryGold.withOpacity(0.3), width: 2),
                  ),
                ).animate(onPlay: (controller) => controller.repeat())
                 .scale(begin: const Offset(1, 1), end: const Offset(1.5, 1.5), duration: 1.5.seconds)
                 .fadeOut(duration: 1.5.seconds),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'MENCARI CALON ELIT...',
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: AppColors.primaryGold,
              letterSpacing: 2,
            ),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
           .fadeOut(duration: 1.seconds, curve: Curves.easeInOut),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SliverFillRemaining(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🕊️', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 20),
            Text(
              'TIADA CALON DITEMUI',
              style: GoogleFonts.playfairDisplay(fontSize: 22, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            const Text(
              'Cuba luaskan tapis pencarian anda.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {},
              style: AppTheme.vibrantButton,
              child: const Text('LARASKAN TAPIS'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundBtn(String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 68,
        height: 68,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFF3F4F6)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 35, offset: const Offset(0, 15)),
          ],
        ),
        child: Center(
          child: Text(label, style: TextStyle(fontSize: 26, color: color)),
        ),
      ),
    ).animate().scale(delay: 200.ms, duration: 300.ms, curve: Curves.easeOutBack);
  }
}
