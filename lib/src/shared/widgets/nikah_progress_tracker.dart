import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jodohku_malaysia/src/theme/app_theme.dart';

class NikahProgressTracker extends StatelessWidget {
  const NikahProgressTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Laluan Perkahwinan', 
                style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF333333))
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFFDF9F4), borderRadius: BorderRadius.circular(8)),
                child: Text(
                  '60% SIAP', 
                  style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w900, color: const Color(0xFFBD8B52), letterSpacing: 1)
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          _buildStep('Pengesahan Identiti (MyKad)', 'Selesai ✓', true, true),
          _buildStep('Upload Sijil Pre-Nikah', 'Selesai ✓', true, true),
          _buildStep('Daftar Sijil JAKIM', 'Sedang Diproses...', true, true),
          _buildStep('Kebenaran Wali (Mahram)', 'Belum Mula', false, true),
          _buildStep('Hantar Borang SPPKM', 'Belum Mula', false, false),
        ],
      ),
    );
  }

  Widget _buildStep(String title, String status, bool isDone, bool showLine) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 14, height: 14,
              decoration: BoxDecoration(
                color: isDone ? const Color(0xFFBD8B52) : const Color(0xFFEEEEEE), 
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: isDone ? [BoxShadow(color: const Color(0xFFBD8B52).withOpacity(0.3), blurRadius: 10)] : [],
              ),
            ),
            if (showLine)
              Container(
                width: 2, height: 40, 
                color: isDone ? const Color(0xFFBD8B52).withOpacity(0.2) : const Color(0xFFF5F5F5)
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title, 
                style: GoogleFonts.outfit(
                  fontSize: 14, 
                  color: isDone ? const Color(0xFF333333) : const Color(0xFFCCCCCC), 
                  fontWeight: isDone ? FontWeight.bold : FontWeight.w500
                )
              ),
              const SizedBox(height: 2),
              Text(
                status, 
                style: GoogleFonts.outfit(
                  fontSize: 11, 
                  color: isDone ? const Color(0xFFBD8B52) : const Color(0xFFDDDDDD),
                  fontWeight: FontWeight.w600
                )
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }
}

