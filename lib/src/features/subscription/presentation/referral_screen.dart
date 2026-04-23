import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jodohku_malaysia/src/theme/app_theme.dart';

class ReferralScreen extends StatelessWidget {
  const ReferralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F0), // Light Theme
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // REWARD ICON
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xFFBD8B52).withOpacity(0.1), 
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: const Color(0xFFBD8B52).withOpacity(0.05), blurRadius: 40, offset: const Offset(0, 10)),
                ],
              ),
              child: const Icon(Icons.card_giftcard_rounded, color: Color(0xFFBD8B52), size: 64),
            ),
            const SizedBox(height: 40),
            
            Text(
              'Kongsi Barakah', 
              style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.bold, color: const Color(0xFF333333))
            ),
            const SizedBox(height: 12),
            Text(
              'Jemput 3 kawan (Mahram) anda sertai Jodohku dan nikmati 1 Bulan Pelan Sultan PERCUMA!',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(color: const Color(0xFF999999), fontSize: 13, height: 1.6, fontWeight: FontWeight.w500),
            ),
            
            const SizedBox(height: 40),
            
            // REFERRAL CODE BOX
            Container(
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white, 
                borderRadius: BorderRadius.circular(32), 
                border: Border.all(color: const Color(0xFFEEEEEE)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20, offset: const Offset(0, 10)),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'KOD RUJUKAN ANDA', 
                    style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w900, color: const Color(0xFFBD8B52), letterSpacing: 2)
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'JDK-9982-SULTAN', 
                    style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF333333))
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // PROGRESS
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'KEMAJUAN GANJARAN', 
                      style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w800, color: const Color(0xFF999999), letterSpacing: 1.5)
                    ),
                    Text(
                      '1 / 3 Diaktifkan', 
                      style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFFBD8B52))
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: 0.33, 
                    backgroundColor: const Color(0xFFEEEEEE), 
                    color: const Color(0xFFBD8B52), 
                    minHeight: 10
                  ),
                ),
              ],
            ),
            
            const Spacer(),
            
            ElevatedButton(
              onPressed: () {},
              style: AppTheme.proButtonPrimary,
              child: const Text('KONGSI LINK SEKARANG'),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}

