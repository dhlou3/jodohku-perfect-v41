import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jodohku_malaysia/src/theme/app_theme.dart';
import 'package:jodohku_malaysia/src/features/discovery/presentation/discovery_screen.dart';
import 'package:jodohku_malaysia/src/features/chat/presentation/chat_list_screen.dart';
import 'package:jodohku_malaysia/src/features/islam/presentation/islam_features_screen.dart';
import 'package:jodohku_malaysia/src/features/profile/presentation/profile_screen.dart';
import 'package:jodohku_malaysia/src/features/auth/application/auth_notifier.dart';
import 'package:jodohku_malaysia/src/features/notifications/application/notification_notifier.dart';
import 'package:jodohku_malaysia/src/features/discovery/presentation/safe_venue_screen.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  ConsumerState<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // PHASE 5: LISTENING FOR GLOBAL LOGIC NOTIFICATIONS
    ref.listen(notificationProvider, (previous, next) {
      if (next != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(next.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(next.message, style: const TextStyle(fontSize: 12)),
              ],
            ),
            backgroundColor: next.isError ? Colors.redAccent : const Color(0xFFBD8B52),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(20),
          ),
        );
      }
    });

    final List<Widget> _screens = [
      const DiscoveryScreen(),
      const SafeVenueScreen(), 
      const ChatListScreen(),
      const IslamFeaturesScreen(),
      const ProfileScreen(),
    ];

    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      body: Column(
        children: [
          profileAsync.when(
            data: (profile) {
              if (profile != null && profile.waliName == null) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE11D48), Color(0xFFF43F5E)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFE11D48).withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.security_rounded, color: Colors.white, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'WALI DIPERLUKAN',
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 10,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const Text(
                              'Sila tambah maklumat wali untuk keselamatan taaruf.',
                              style: TextStyle(color: Colors.white, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () => _showWaliRegistration(context),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.2),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        ),
                        child: const Text(
                          'TAMBAH',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          Expanded(child: _screens[_currentIndex]),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 30, top: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5)),
          ],
          border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.1))),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(Icons.home_filled, 'Home', 0),
            _navItem(Icons.search, 'Explore', 1),
            _navItem(Icons.chat_bubble_outline, 'Chat', 2, badge: '3'),
            _navItem(Icons.mosque_outlined, 'Islam', 3),
            _navItem(Icons.person_outline, 'Me', 4),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index, {String? badge}) {
    final bool isActive = _currentIndex == index;
    final color = isActive ? const Color(0xFFBD8B52) : Colors.grey;
    
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(icon, color: color, size: 28),
              if (badge != null)
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Color(0xFFE11D48), shape: BoxShape.circle),
                    child: Text(badge, style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showWaliRegistration(BuildContext context) {
    final nameBot = TextEditingController();
    final emailBot = TextEditingController();
    final relationBot = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 48),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            ),
            const SizedBox(height: 24),
            Text('Pendaftaran Wali', style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Wali adalah penjaga sah anda (Bapa, Abang, atau Adik Lelaki) yang akan memantau sesi taaruf.', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            TextField(controller: nameBot, decoration: AppTheme.glassInput('Nama Penuh Wali')),
            const SizedBox(height: 16),
            TextField(controller: emailBot, decoration: AppTheme.glassInput('Email Wali (Untuk laporan PDF)')),
            const SizedBox(height: 16),
            TextField(controller: relationBot, decoration: AppTheme.glassInput('Hubungan (Contoh: Bapa Kandung)')),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (nameBot.text.isNotEmpty && emailBot.text.isNotEmpty) {
                  ref.read(authProvider.notifier).updateWali(
                    name: nameBot.text,
                    email: emailBot.text,
                    relation: relationBot.text,
                  );
                  Navigator.pop(context);
                }
              },
              style: AppTheme.vibrantButton,
              child: const Text('Simpan Maklumat Wali'),
            ),
          ],
        ),
      ),
    );
  }
}

