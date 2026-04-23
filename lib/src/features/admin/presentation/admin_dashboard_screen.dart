import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jodohku_malaysia/src/theme/app_theme.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      body: Row(
        children: [
          // PRO SIDEBAR (Director Mode)
          _buildSidebar(),
          
          // MAIN CONTENT
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopBar(),
                  const SizedBox(height: 40),
                  
                  // GLOBAL METRICS (Phase 6 Scaling)
                  Row(
                    children: [
                      _StatCard('Global Revenue', 'RM 1.2M', '+45%', Icons.public, AppColors.primaryGold),
                      const SizedBox(width: 24),
                      _StatCard('Staff Online', '24 Admins', 'Live', Icons.admin_panel_settings, AppColors.accentCyan),
                      const SizedBox(width: 24),
                      _StatCard('User CAC', 'RM 4.50', 'Target: <5', Icons.trending_down, Colors.greenAccent),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                  
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // LEFT: GLOBAL HEATMAP (Simulation)
                      Expanded(
                        flex: 2,
                        child: _buildIntelligencePanel('Global User Heatmap (Density)', [
                          _buildMapRow('Kuala Lumpur', '45,231 Users', 0.9, Colors.orangeAccent),
                          _buildMapRow('Johor Bahru', '22,102 Users', 0.5, AppColors.primaryGold),
                          _buildMapRow('London, UK', '8,432 Users', 0.3, AppColors.accentCyan),
                          _buildMapRow('Singapore', '12,940 Users', 0.4, Colors.white70),
                        ]),
                      ),
                      const SizedBox(width: 24),
                      // RIGHT: FINANCIAL REPORTS
                      Expanded(
                        flex: 1,
                        child: _buildIntelligencePanel('Financial Reports', [
                          _buildReportBtn('Laporan Bulanan - Okt 2026', Icons.file_download_outlined),
                          _buildReportBtn('Laporan Cukai (LHDN) 2026', Icons.account_balance_outlined),
                          _buildReportBtn('Analisis Churn (Premium)', Icons.analytics_outlined),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGold, minimumSize: const Size(double.infinity, 45)),
                            child: const Text('JANA LAPORAN BARU', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                          )
                        ]),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 260, color: const Color(0xFF0F172A), padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Jodohku', style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primaryGold, letterSpacing: 2)),
        Text('Director\'s Command Center', style: GoogleFonts.outfit(fontSize: 10, color: AppColors.textSubtle)),
        const SizedBox(height: 60),
        _buildSidebarItem(Icons.public, 'Global Operations', true),
        _buildSidebarItem(Icons.group_work_outlined, 'Staff Management', false),
        _buildSidebarItem(Icons.account_balance_wallet_outlined, 'Financials', false),
        _buildSidebarItem(Icons.security_update_good, 'System Health', false),
        const Spacer(),
        _buildSidebarItem(Icons.logout, 'Log Keluar', false),
      ]),
    );
  }

  Widget _buildSidebarItem(IconData icon, String label, bool active) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: active ? AppColors.primaryGold.withOpacity(0.1) : Colors.transparent, borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Icon(icon, color: active ? AppColors.primaryGold : AppColors.textSubtle, size: 20),
        const SizedBox(width: 16),
        Text(label, style: GoogleFonts.outfit(color: active ? Colors.white : AppColors.textSubtle, fontWeight: active ? FontWeight.bold : FontWeight.normal, fontSize: 13)),
      ]),
    );
  }

  Widget _StatCard(String label, String value, String sub, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white10)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 16),
          Text(value, style: GoogleFonts.outfit(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(label, style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textSubtle)),
            Text(sub, style: TextStyle(color: sub.contains('+') || sub == 'Live' ? Colors.greenAccent : Colors.white54, fontSize: 11, fontWeight: FontWeight.bold)),
          ]),
        ]),
      ),
    );
  }

  Widget _buildIntelligencePanel(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white10)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primaryGold, letterSpacing: 1)),
        const SizedBox(height: 24),
        ...children,
      ]),
    );
  }

  Widget _buildMapRow(String city, String count, double intensity, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(city, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          Text(count, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
        ]),
        const SizedBox(height: 8),
        Container(height: 4, decoration: BoxDecoration(color: color.withOpacity(intensity), borderRadius: BorderRadius.circular(10))),
      ],
    ),
  );
  }

  Widget _buildReportBtn(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        Icon(icon, color: AppColors.textSubtle, size: 18),
        const SizedBox(width: 12),
        Expanded(child: Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12))),
        const Icon(Icons.chevron_right, color: Colors.white24, size: 16),
      ]),
    );
  }

  Widget _buildTopBar() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text('Global Operations Dashboard', style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
      _buildDirectorBadge(),
    ]);
  }

  Widget _buildDirectorBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: AppColors.primaryGold.withOpacity(0.1), borderRadius: BorderRadius.circular(100), border: Border.all(color: AppColors.primaryGold.withOpacity(0.3))),
      child: Row(
        children: [
          const Icon(Icons.stars, color: AppColors.primaryGold, size: 16),
          const SizedBox(width: 8),
          Text('SYSTEM DIRECTOR', style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryGold)),
        ],
      ),
    );
  }
}
