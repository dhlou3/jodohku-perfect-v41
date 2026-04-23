import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jodohku_malaysia/src/theme/app_theme.dart';

class JakimVerificationScreen extends StatelessWidget {
  const JakimVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F0),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          'Sijil JAKIM', 
          style: GoogleFonts.amiri(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // JAKIM CERT CARD (MAPPED FROM PROTOTYPE)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.shariaGreen,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Column(
                children: [
                  const Text('🌿', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 20),
                  Text(
                    'JABATAN KEMAJUAN ISLAM MALAYSIA',
                    style: GoogleFonts.outfit(
                      fontSize: 10, 
                      color: Colors.white.withOpacity(0.6),
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'SIJIL PENGESAHAN AHLI',
                    style: GoogleFonts.outfit(
                      fontSize: 22, 
                      color: Colors.white, 
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Ahmad bin Abdullah',
                          style: GoogleFonts.outfit(
                            fontSize: 20, 
                            color: Colors.white, 
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'No. Pendaftaran: JKM-2024-087432',
                          style: GoogleFonts.outfit(
                            fontSize: 12, 
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.verified, color: Colors.white, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Disahkan secara digital oleh JAKIM',
                        style: GoogleFonts.outfit(
                          fontSize: 11, 
                          color: Colors.white, 
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // VERIFICATION LIST
            _buildVerifyItem('Pengesahan IC', true),
            _buildVerifyItem('Pengesahan No. Telefon', true),
            _buildVerifyItem('Sijil Kursus Pra-Nikah', false),

            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.shariaGreen,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text('KEMUKAKAN SIJIL BARU'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerifyItem(String title, bool isDone) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF5F5F5))),
      ),
      child: Row(
        children: [
          Container(
            width: 24, height: 24,
            decoration: BoxDecoration(
              color: isDone ? AppColors.shariaGreen : const Color(0xFFE6D5C3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isDone ? Icons.check : Icons.hourglass_empty, 
              color: Colors.white, 
              size: 14,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title, 
              style: GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 15),
            ),
          ),
          Text(
            isDone ? 'Disahkan' : 'Belum Selesai',
            style: GoogleFonts.outfit(
              fontSize: 12, 
              color: isDone ? AppColors.shariaGreen : Colors.grey, 
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
