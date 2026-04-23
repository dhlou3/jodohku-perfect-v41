import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jodohku_malaysia/src/theme/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:jodohku_malaysia/src/features/auth/application/auth_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpgradeScreen extends ConsumerWidget {
  const UpgradeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F0), 
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black), 
          onPressed: () => Navigator.pop(context)
        ),
        title: Text(
          'Naik Taraf Premium', 
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.black)
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildDiamondLogo(),
                  const SizedBox(height: 24),
                  Text(
                    'Jadilah Ahli Sultan', 
                    style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold, color: const Color(0xFF333333), letterSpacing: -1)
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Nikmati pengalaman mencari jodoh #1 paling eksklusif di Malaysia.', 
                    textAlign: TextAlign.center, 
                    style: GoogleFonts.outfit(color: const Color(0xFF999999), fontWeight: FontWeight.w500)
                  ),
                  const SizedBox(height: 40),
                  
                  _buildTierCard(
                    title: '👑 SOVEREIGN ELITE',
                    price: 'RM 149.00 / bln',
                    isElite: true,
                    features: [
                      'Semua ciri Platinum + Sultan',
                      'Profil dipaparkan #1 dalam carian',
                      'Lencana Sovereign eksklusif',
                      'Khidmat pelanggan 24/7 VIP',
                      'Sesi kaunseling pra-nikah percuma',
                      'Pengesahan latar belakang penuh',
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTierCard(
                    title: 'SULTAN MEMBER',
                    price: 'RM 89.90 / bln',
                    isElite: false,
                    features: ['Keutamaan Matchmaking AI', 'Akses Penuh Sijil Wali', 'Boost Profil (KL/Selangor)', 'Laporan Skor Amanah'],
                  ),
                  const SizedBox(height: 16),
                  _buildTierCard(
                    title: 'PREMIUM AHWAL',
                    price: 'RM 49.90 / bln',
                    isElite: false,
                    features: ['Terjemahan Lanjutan', '2x Keterlihatan Profil', 'Alert Minat Tanpa Had'],
                  ),
                ],
              ),
            ),
          ),
          
          Container(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
            ),
            child: ElevatedButton(
              onPressed: () => _handlePayment(context, ref),
              style: AppTheme.proButtonPrimary,
              child: const Text('TERUSKAN KE FPX PAYMENT \u2192'),
            ),
          ),
        ],
      ),
    );
  }

  void _handlePayment(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFFBD8B52)),
      ),
    );
    
    Future.delayed(const Duration(seconds: 2), () async {
      try {
        await ref.read(authProvider.notifier).upgradeToSultan();
        Navigator.pop(context); // Close loader
        Navigator.pushReplacementNamed(context, '/payment-success');
      } catch (e) {
        Navigator.pop(context); // Close loader
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pembayaran Gagal atau Dibatalkan. Sila cuba lagi.')),
        );
      }
    });
  }

  Widget _buildDiamondLogo() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF9F4),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFBD8B52).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(color: const Color(0xFFBD8B52).withOpacity(0.1), blurRadius: 40, offset: const Offset(0, 10)),
        ],
      ),
      child: const Icon(Icons.stars_rounded, size: 64, color: Color(0xFFBD8B52)),
    ).animate().scale(duration: 600.ms, curve: Curves.elasticOut);
  }

  Widget _buildTierCard({required String title, required String price, required bool isElite, required List<String> features}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isElite ? Colors.white : const Color(0xFFFDF9F4),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: isElite ? const Color(0xFFBD8B52) : const Color(0xFFEEEEEE), width: isElite ? 2 : 1),
        boxShadow: isElite ? [
          BoxShadow(color: const Color(0xFFBD8B52).withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 8)),
        ] : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title, 
                style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w900, color: const Color(0xFFBD8B52), letterSpacing: 2)
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFBD8B52).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  price, 
                  style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w800, color: const Color(0xFFBD8B52))
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...features.map((f) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Color(0xFFBD8B52), size: 16),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    f, 
                    style: GoogleFonts.outfit(color: const Color(0xFF666666), fontSize: 13, fontWeight: FontWeight.w500)
                  )
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

