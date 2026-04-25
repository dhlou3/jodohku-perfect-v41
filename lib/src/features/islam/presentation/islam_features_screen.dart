import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jodohku_malaysia/src/theme/app_theme.dart';
import 'package:jodohku_malaysia/src/features/islam/presentation/wali_dashboard_screen.dart';
import 'package:jodohku_malaysia/src/features/islam/presentation/taaruf_question_screen.dart';
import 'package:jodohku_malaysia/src/features/islam/presentation/vendor_directory_screen.dart';
import 'package:jodohku_malaysia/src/features/islam/presentation/jakim_verification_screen.dart';

class IslamFeaturesScreen extends StatelessWidget {
  const IslamFeaturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F0), // Light Theme
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ISLAM HERO SECTION (MAPPED FROM HIGH-FIDELITY)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: AppColors.shariaGreen,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('🌿 ', style: TextStyle(fontSize: 32)),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pusat Islam Jodohku', 
                            style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)
                          ),
                          Text(
                            'Panduan Perkahwinan Mengikut Syariat', 
                            style: GoogleFonts.outfit(fontSize: 12, color: Colors.white.withOpacity(0.8))
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '87%', 
                          style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Berdasarkan nilai agama, akhlak dan keserasian keluarga.', 
                            style: GoogleFonts.outfit(fontSize: 11, color: Colors.white, height: 1.4)
                          )
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // GRID ITEMS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
                children: [
                  _featCard('📜', 'Sijil JAKIM', 'Pengesahan halal anda', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const JakimVerificationScreen()))),
                  _featCard('🛡️', 'Mod Wali', 'Pemantauan mahram', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WaliDashboardScreen()))),
                  _featCard('💬', 'Soalan Taaruf', '30 soalan penting', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TaarufQuestionScreen()))),
                  _featCard('📖', 'Panduan Nikah', 'Munakahat Islam', () => _showMarriageGuide(context)),
                  _featCard('💍', 'Vendor Halal', 'Sewa & Pelamin', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VendorDirectoryScreen()))),
                ],
              ),
            ),
            
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _featCard(String icon, String title, String sub, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFEEEEEE)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(icon, style: const TextStyle(fontSize: 24)),
            const Spacer(),
            Text(title, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w800, color: const Color(0xFF333333))),
            const SizedBox(height: 4),
            Text(sub, style: GoogleFonts.outfit(fontSize: 10, color: const Color(0xFF999999))),
          ],
        ),
      ),
    );
  }

  void _showMarriageGuide(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(32),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Panduan Munakahat', style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text('Langkah-langkah perkahwinan suci dalam Islam.', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 32),
              _guideStep('1', 'Merisik', 'Langkah awal untuk mengenali latar belakang calon.'),
              _guideStep('2', 'Meminang', 'Pertemuan rasmi antara dua keluarga.'),
              _guideStep('3', 'Kursus Kawin', 'Mendapatkan sijil pra-perkahwinan JAKIM.'),
              _guideStep('4', 'Permohonan Nikah', 'Pendaftaran di Pejabat Agama Islam Daerah.'),
              _guideStep('5', 'Akad Nikah', 'Ikatan sah antara suami dan isteri.'),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: AppTheme.vibrantButton,
                child: const Text('FAHAM & TUTUP'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _guideStep(String num, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30, height: 30,
            decoration: const BoxDecoration(color: AppColors.shariaGreen, shape: BoxShape.circle),
            child: Center(child: Text(num, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(desc, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

