import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      const Center(child: Text('Explore')), // To be updated
      const ChatListScreen(),
      const Center(child: Text('Islam')), // To be updated
      const ProfileScreen(),
    ];

    return Scaffold(
    return Scaffold(
      appBar: _currentIndex == 0 ? AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        toolbarHeight: 80,
        title: Text(
          'JODOHKU',
          style: GoogleFonts.playfairDisplay(
            color: AppColors.primaryGold,
            fontSize: 26,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {}, 
            icon: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFF3F4F6)),
              ),
              child: const Icon(Icons.tune_rounded, color: Colors.black87, size: 20),
            ),
          ),
          IconButton(
            onPressed: () {}, 
            icon: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFF3F4F6)),
              ),
              child: const Icon(Icons.settings_outlined, color: Colors.black87, size: 20),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ) : null,
      body: Column(
        children: [
          // Banner logic... (preserving existing)
          Expanded(child: _screens[_currentIndex]),
        ],
      ),
      bottomNavigationBar: Container(
        height: 95,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.1))),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(Icons.home_filled, 'Utama', 0),
            _navItem(Icons.search, 'Jelajah', 1),
            _navItem(Icons.chat_bubble_outline, 'Sembang', 2),
            _navItem(Icons.mosque_outlined, 'Islam', 3),
            _navItem(Icons.person_outline, 'Saya', 4),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final bool isActive = _currentIndex == index;
    final color = isActive ? AppColors.primaryGold : const Color(0xFF9CA3AF);
    
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
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

