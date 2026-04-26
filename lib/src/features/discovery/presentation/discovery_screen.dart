import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jodohku_malaysia/src/theme/app_theme.dart';
import 'package:jodohku_malaysia/src/features/matching/application/discovery_notifier.dart';
import 'package:jodohku_malaysia/src/features/auth/domain/member_profile.dart';
import 'package:jodohku_malaysia/src/features/discovery/presentation/widgets/profile_card.dart';

class DiscoveryScreen extends ConsumerStatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  ConsumerState<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends ConsumerState<DiscoveryScreen> {
  @override
  void initState() {
    super.initState();
    // LOGIC: Trigger AI ranking on load (Phase 3)
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
      body: CustomScrollView(
        slivers: [
          discoveryState.when(
            data: (matches) => SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final match = matches[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: ProfileCard(match: match),
                    );
                  },
                  childCount: matches.length,
                ),
              ),
            ),
            loading: () => const SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: AppColors.primaryGold),
                    SizedBox(height: 16),
                    Text('AI Calculating Barakah Match...', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
            error: (e, _) => SliverFillRemaining(child: Center(child: Text('Error: $e'))),
          ),
        ],
      ),
    );
  }

  void _showFilters(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filter Carian', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            const Text('Umur: 18 - 45 tahun', style: TextStyle(fontWeight: FontWeight.w600)),
            const Divider(height: 32),
            const Text('Negeri: Kuala Lumpur, Selangor', style: TextStyle(fontWeight: FontWeight.w600)),
            const Divider(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: AppTheme.vibrantButton,
              child: const Text('APLIKASI FILTER'),
            ),
          ],
        ),
      ),
    );
  }
}
