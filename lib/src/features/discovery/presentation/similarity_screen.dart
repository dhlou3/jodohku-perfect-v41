import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jodohku_malaysia/src/theme/app_theme.dart';

class SimilarityScreen extends StatelessWidget {
  final String userName;
  final double score;

  const SimilarityScreen({super.key, required this.userName, required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            // HEADING
            Text('Kenapa Anda Serasi?', style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            Text('Analisis Kecerdasan AI Jodohku', style: GoogleFonts.outfit(color: AppColors.primaryGold, fontSize: 13, fontWeight: FontWeight.bold)),
            
            const SizedBox(height: 48),
            
            // CIRCULAR SCORE
            _buildScoreCircle(),
            
            const SizedBox(height: 48),
            
            // BREAKDOWN CATEGORIES
            _buildBreakdownItem('Nilai Kekeluargaan', 98, AppColors.accentCyan),
            _buildBreakdownItem('Amalan Agama', 92, AppColors.primaryGold),
            _buildBreakdownItem('Gaya Hidup', 85, Colors.pinkAccent),
            _buildBreakdownItem('Visi Kewangan', 80, Colors.greenAccent),
            
            const SizedBox(height: 48),
            
            // COMMON INTERESTS (Chips)
            Align(alignment: Alignment.centerLeft, child: Text('PERSAMAAN MINAT', style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textSubtle, letterSpacing: 1.5))),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: ['Nasi Lemak', 'Melancong', 'Sukan', 'Membaca', 'Kucing'].map((h) => Chip(
                label: Text(h, style: const TextStyle(color: Colors.white, fontSize: 12)),
                backgroundColor: Colors.white.withOpacity(0.05),
                side: const BorderSide(color: Colors.white10),
              )).toList(),
            ),
            
            const SizedBox(height: 64),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: AppTheme.proButtonPrimary,
              child: Text('MULAKAN TAARUF BERSAMA $userName'),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCircle() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 150, height: 150,
          child: CircularProgressIndicator(value: score / 100, strokeWidth: 10, color: AppColors.primaryGold, backgroundColor: Colors.white10),
        ),
        Column(
          children: [
            Text('${score.round()}%', style: GoogleFonts.outfit(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white)),
            Text('SERASI', style: GoogleFonts.outfit(fontSize: 12, color: AppColors.primaryGold, fontWeight: FontWeight.bold, letterSpacing: 2)),
          ],
        ),
      ],
    );
  }

  Widget _buildBreakdownItem(String label, double val, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
              Text('${val.round()}%', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(value: val / 100, backgroundColor: Colors.white10, color: color, minHeight: 6),
        ],
      ),
    );
  }
}
