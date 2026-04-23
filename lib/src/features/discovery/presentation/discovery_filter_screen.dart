import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jodohku_malaysia/src/theme/app_theme.dart';
import 'package:jodohku_malaysia/src/features/subscription/presentation/payment_status_screen.dart';

class DiscoveryFilterScreen extends StatefulWidget {
  const DiscoveryFilterScreen({super.key});

  @override
  State<DiscoveryFilterScreen> createState() => _DiscoveryFilterScreenState();
}

class _DiscoveryFilterScreenState extends State<DiscoveryFilterScreen> {
  RangeValues _ageRange = const RangeValues(22, 35);
  RangeValues _heightRange = const RangeValues(150, 190);
  String _salat = '5 Waktu';
  bool _verifiedOnly = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Penapis Lanjut', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white)),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BASIC SECTION
            _buildFilterCard(
              title: 'HAD UMUR',
              subtitle: '${_ageRange.start.round()} - ${_ageRange.end.round()} Tahun',
              child: RangeSlider(
                values: _ageRange, min: 18, max: 60,
                activeColor: AppColors.primaryGold,
                inactiveColor: Colors.white10,
                onChanged: (val) => setState(() => _ageRange = val),
              ),
            ),
            
            // PREMIUM SECTION (LOCKED)
            _buildFilterCard(
              title: 'TINGGI (CM)',
              isPremium: true,
              subtitle: '150 - 190 cm',
              child: Opacity(
                opacity: 0.3,
                child: RangeSlider(
                  values: _heightRange, min: 140, max: 210,
                  activeColor: AppColors.primaryGold,
                  inactiveColor: Colors.white10,
                  onChanged: (val) {},
                ),
              ),
            ),
            
            _buildFilterCard(
              title: 'AMALAN SOLAT',
              child: _buildChoiceGroup(['5 Waktu', 'Berusaha', 'Kadang-kadang'], _salat, (v) => setState(() => _salat = v)),
            ),

            _buildFilterCard(
              title: 'STATUS MYKAD',
              child: _buildPremiumToggle('Hanya Ahli Disahkan', 'Lencana Hijau Sahaja', _verifiedOnly, (v) => setState(() => _verifiedOnly = v)),
            ),

            const SizedBox(height: 48),
            
            // CTA BUTTON
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: AppTheme.proButtonPrimary,
              child: const Text('TERAPKAN PENAPIS'),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterCard({required String title, required Widget child, String? subtitle, bool isPremium = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.surface.withOpacity(0.4), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textSubtle, letterSpacing: 1.5)),
              if (isPremium) const Icon(Icons.diamond_outlined, color: AppColors.primaryGold, size: 16),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildChoiceGroup(List<String> options, String selected, Function(String) onSelect) {
    return Wrap(
      spacing: 8,
      children: options.map((opt) {
        final isSel = selected == opt;
        return GestureDetector(
          onTap: () => onSelect(opt),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSel ? AppColors.primaryGold : Colors.white10,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(opt, style: TextStyle(color: isSel ? Colors.black : Colors.white, fontSize: 12, fontWeight: isSel ? FontWeight.bold : FontWeight.normal)),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPremiumToggle(String title, String sub, bool val, Function(bool) onToggle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
          Text(sub, style: const TextStyle(fontSize: 10, color: AppColors.textSubtle)),
        ]),
        Switch(value: val, activeColor: AppColors.primaryGold, onChanged: onToggle),
      ],
    );
  }
}
