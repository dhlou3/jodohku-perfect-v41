import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jodohku_malaysia/src/theme/app_theme.dart';

class WaliDashboardScreen extends StatelessWidget {
  const WaliDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F0), // Light Theme
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          'Mod Wali (Zon Penjaga)', 
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.black)
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // GUARDIAN STATUS HERO (Pusat Islam style)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: AppColors.shariaGreen,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Column(
                children: [
                  const Text('🛡️', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 16),
                  Text(
                    'Amanah & Terjaga', 
                    style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Anda sedang memantau 2 perbualan di bawah jagaan anda.', 
                    textAlign: TextAlign.center, 
                    style: GoogleFonts.outfit(fontSize: 12, color: Colors.white.withOpacity(0.8))
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('AKTIVITI MODERASI'),
                  _buildModerationCard('Ahmad Faiz \u2194 Nur Aisyah', '7 mesej disahkan selamat', true),
                  _buildModerationCard('Fatimah \u2194 Khairul', '2 mesej diblokir oleh AI', false),
                  
                  const SizedBox(height: 24),
                  _buildSectionTitle('TETAPAN KESELAMATAN'),
                  _buildToggle('Notifikasi SMS Segera', 'Dapatkan SMS bila ada mesej sensitif', true),
                  _buildToggle('Auto-Tapis Kata', 'Sekat perkataan tidak sopan secara automatik', true),
                  _buildToggle('Laporan Mingguan', 'Terima PDF analisis aktiviti', false),
                ],
              ),
            ),
            
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildModerationCard(String title, String status, bool isSafe) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSafe ? AppColors.shariaGreen.withOpacity(0.1) : Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isSafe ? Icons.check_circle_outline : Icons.warning_amber_rounded,
              color: isSafe ? AppColors.shariaGreen : Colors.red,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14, color: const Color(0xFF333333))),
                Text(status, style: GoogleFonts.outfit(color: isSafe ? AppColors.shariaGreen : Colors.red, fontSize: 11, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFFCCCCCC)),
        ],
      ),
    );
  }

  Widget _buildToggle(String t, String s, bool v) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                Text(t, style: GoogleFonts.outfit(color: const Color(0xFF333333), fontWeight: FontWeight.bold, fontSize: 13)),
                Text(s, style: GoogleFonts.outfit(color: const Color(0xFF999999), fontSize: 11)),
              ]
            ),
          ),
          Switch(
            value: v, 
            onChanged: (val) {},
            activeColor: AppColors.shariaGreen,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String t) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 12, left: 4),
      child: Text(
        t, 
        style: GoogleFonts.outfit(
          fontSize: 10, 
          fontWeight: FontWeight.w800, 
          color: const Color(0xFFBD8B52), 
          letterSpacing: 1.5
        )
      ),
    );
  }
}

