import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jodohku_malaysia/src/theme/app_theme.dart';

class AiFilterSheet extends StatefulWidget {
  const AiFilterSheet({super.key});

  @override
  State<AiFilterSheet> createState() => _AiFilterSheetState();
}

class _AiFilterSheetState extends State<AiFilterSheet> {
  double _distance = 50.0;
  String _religiousStatus = 'Semua';
  bool _waliVerified = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFEEEEEE), borderRadius: BorderRadius.circular(10)))),
          const SizedBox(height: 24),
          Row(
            children: [
              const Icon(Icons.psychology_outlined, color: Color(0xFFBD8B52)),
              const SizedBox(width: 12),
              Text('Penapis Padanan AI', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF333333))),
            ],
          ),
          const SizedBox(height: 32),
          
          // DISTANCE
          _buildLabel('JARAK MAKSIMUM (KM)', '$_distance km'),
          Slider(
            value: _distance, min: 5, max: 200, 
            activeColor: const Color(0xFFBD8B52), 
            inactiveColor: const Color(0xFFF5F5F5),
            onChanged: (val) => setState(() => _distance = val.roundToDouble()),
          ),
          
          const SizedBox(height: 24),
          
          // RELIGIOUS PREF
          _buildLabel('PENILAIAN AGAMA', _religiousStatus),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: ['Semua', 'Sangat Taat', 'Pentingkan Halal', 'Sederhana'].map((status) => ChoiceChip(
              label: Text(status, style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w600)),
              selected: _religiousStatus == status,
              selectedColor: const Color(0xFFBD8B52),
              backgroundColor: const Color(0xFFFDF9F4),
              labelStyle: TextStyle(color: _religiousStatus == status ? Colors.white : const Color(0xFFBD8B52)),
              onSelected: (val) => setState(() => _religiousStatus = status),
            )).toList(),
          ),
          
          const SizedBox(height: 24),
          
          // WALI VERIFIED
          SwitchListTile(
            title: Text('Hanya Wali-sahaja', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF333333))),
            subtitle: Text('Tunjukkan profil yang telah mendapat kebenaran Wali sahaja.', style: GoogleFonts.outfit(fontSize: 12, color: const Color(0xFF999999))),
            value: _waliVerified,
            activeColor: AppColors.shariaGreen,
            onChanged: (val) => setState(() => _waliVerified = val),
            contentPadding: EdgeInsets.zero,
          ),
          
          const SizedBox(height: 40),
          
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: AppTheme.proButtonPrimary,
            child: const Text('APLIKASI AI MATCHER'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildLabel(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w900, color: const Color(0xFFCCCCCC), letterSpacing: 1.5)),
        Text(value, style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFFBD8B52))),
      ],
    );
  }
}
