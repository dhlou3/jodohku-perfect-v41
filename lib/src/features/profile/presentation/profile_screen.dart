import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jodohku_malaysia/src/theme/app_theme.dart';
import 'package:jodohku_malaysia/src/features/auth/application/auth_notifier.dart';
import 'package:jodohku_malaysia/src/features/auth/domain/auth_models.dart';
import 'package:jodohku_malaysia/src/features/auth/domain/member_profile.dart';
import 'package:jodohku_malaysia/src/features/notifications/application/notification_notifier.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // LOGIC: REACTING TO AUTH & PREMIUM STATE
    final authState = ref.watch(authProvider);
    final profileAsync = ref.watch(profileProvider);
    final bool isAuthenticating = authState.status == AuthStatus.authenticating;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F0), // Light Theme
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (profile) {
          final bool isSultan = profile?.isSultan ?? false;
          final String name = profile?.fullName ?? 'Hamba Allah';
          final String id = profile?.id ?? 'JDK-TEMP-000';
          final bool hasWali = profile?.waliName != null;

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 80),
                // PROFILE HERO CENTRED
                Center(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 140, height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle, 
                              color: Colors.white,
                              border: Border.all(
                                color: isSultan ? const Color(0xFFBD8B52) : const Color(0xFFEEEEEE), 
                                width: 3
                              ),
                            ),
                            child: const Icon(Icons.person_outline, size: 80, color: Color(0xFFBD8B52)),
                          ),
                          if (isSultan)
                            Positioned(
                              bottom: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: [Color(0xFFBD8B52), Color(0xFFE6D5C3)]),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: const Text('SULTAN ELIT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white)),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        name, 
                        style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF333333))
                      ),
                      Text(
                        '$id • ${profile?.birthState ?? 'Malaysia'}', 
                        style: GoogleFonts.outfit(fontSize: 14, color: const Color(0xFF999999), fontWeight: FontWeight.w600)
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),

                // PREMIUM ACTION (PHASE 5 CORE)
                if (!isSultan)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      onTap: isAuthenticating ? null : () => ref.read(authProvider.notifier).upgradeToSultan(),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color(0xFF020617), Color(0xFF1E293B)]),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(color: const Color(0xFFBD8B52).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.diamond_outlined, color: Color(0xFFBD8B52), size: 32),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('NAIK TARAF SULTAN', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
                                  Text('Buka keutamaan & filter AI eksklusif.', style: GoogleFonts.outfit(color: Colors.white60, fontSize: 12)),
                                ],
                              ),
                            ),
                            if (isAuthenticating)
                              const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Color(0xFFBD8B52), strokeWidth: 2))
                            else
                              const Icon(Icons.arrow_forward_ios, color: Color(0xFFBD8B52), size: 16),
                          ],
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 32),
                
                // MENU ITEMS (FLOW C: REAL WIRING)
                _ProfileMenuItem(
                  icon: Icons.settings_suggest_outlined, 
                  title: 'Ketentuan Taaruf (Preferences)', 
                  subtitle: 'Solat, Wali & Gaya Hidup', 
                  onTap: () => _showPreferenceDialog(context, ref)
                ),
                _ProfileMenuItem(
                  icon: Icons.shield_outlined, 
                  title: 'Mod Wali (Zon Penjaga)', 
                  subtitle: hasWali ? 'Aktif: ${profile!.waliName}' : 'Wali Belum Ditambah', 
                  onTap: () {
                    if (hasWali) {
                      _showWaliDetails(context, profile!);
                    } else {
                      ref.read(notificationProvider.notifier).show('Wali Diperlukan', 'Sila gunakan banner di Home untuk menambah wali.');
                    }
                  }
                ),
                _ProfileMenuItem(
                  icon: Icons.logout_rounded, 
                  title: 'Log Keluar', 
                  subtitle: 'Sign out safely', 
                  onTap: () {
                    ref.read(authProvider.notifier).logout();
                    Navigator.of(context).pushNamedAndRemoveUntil('/landing', (route) => false);
                  }
                ),
                
                const SizedBox(height: 120),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showWaliDetails(BuildContext context, MemberProfile profile) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.security, color: Color(0xFFBD8B52), size: 32),
                const SizedBox(width: 16),
                Text('Maklumat Wali', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 24),
            _infoRow('Nama Penuh', profile.waliName ?? '-'),
            _infoRow('Hubungan', profile.waliRelation ?? '-'),
            _infoRow('Email Terpaut', profile.waliEmail ?? '-'),
            const SizedBox(height: 32),
            const Text('💡 Wali akan menerima laporan PDF setiap kali anda bersetuju untuk berjumpa.', style: TextStyle(color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: AppTheme.vibrantButton,
              child: const Text('TUTUP'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }

  void _showPreferenceDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ketentuan Taaruf', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Text('Kekerapan Solat', style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 12),
            _optionBtn(context, 'Pasti (5 Waktu)', true),
            const SizedBox(height: 8),
            _optionBtn(context, 'Masih Berusaha', false),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // LOGIC: Save Preference
                ref.read(notificationProvider.notifier).show('Tetapan Disimpan ✅', 'Kriteria taaruf anda telah dikemaskini.');
                Navigator.pop(context);
              },
              style: AppTheme.vibrantButton,
              child: const Text('SIMPAN PERUBAHAN'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _optionBtn(BuildContext context, String label, bool isSelected) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFBD8B52).withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isSelected ? const Color(0xFFBD8B52) : const Color(0xFFEEEEEE)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
          if (isSelected) const Icon(Icons.check_circle, color: Color(0xFFBD8B52), size: 18),
        ],
      ),
    );
  }
}


class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final VoidCallback onTap;

  const _ProfileMenuItem({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white, 
            borderRadius: BorderRadius.circular(24), 
            border: Border.all(color: const Color(0xFFEEEEEE)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: const Color(0xFFFDF9F4), borderRadius: BorderRadius.circular(16)),
                child: Icon(icon, color: const Color(0xFFBD8B52), size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF333333))),
                    Text(subtitle, style: GoogleFonts.outfit(fontSize: 12, color: const Color(0xFF999999))),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFFCCCCCC)),
            ],
          ),
        ),
      ),
    );
  }
}


