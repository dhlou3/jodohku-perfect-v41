import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jodohku_malaysia/src/theme/app_theme.dart';

class SafeVenueScreen extends StatelessWidget {
  const SafeVenueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F0), // Light Theme
      body: Column(
        children: [
          // LUXURY SEARCH & HEADER
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
              boxShadow: [
                BoxShadow(color: Color(0x0A000000), blurRadius: 20, offset: Offset(0, 10)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Lokasi Selamat', 
                      style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF333333))
                    ),
                    const Icon(Icons.location_on, color: Color(0xFFBD8B52), size: 28),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  style: const TextStyle(color: Color(0xFF333333)),
                  decoration: InputDecoration(
                    hintText: 'Cari Kedai Kopi Halal / Cafe...',
                    hintStyle: const TextStyle(color: Color(0xFFCCCCCC), fontSize: 14),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFFBD8B52)),
                    filled: true,
                    fillColor: const Color(0xFFF8F5F0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // MAP PREVIEW
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDF9F4),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFEEEEEE)),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(Icons.map_outlined, size: 60, color: const Color(0xFFBD8B52).withOpacity(0.2)),
                        _buildMapPin(40, -60, 'Kopi Halal'),
                        _buildMapPin(-20, 50, 'Dapur Bonda'),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  Text(
                    'REKOMENDASI DEKAT ANDA', 
                    style: GoogleFonts.outfit(
                      fontSize: 10, 
                      fontWeight: FontWeight.w800, 
                      color: const Color(0xFFBD8B52), 
                      letterSpacing: 1.5
                    )
                  ),
                  
                  const SizedBox(height: 12),
                  
                  _buildVenueCard('Sajen Cafe', 'Bukit Bintang, KL', 'JAKIM-2281'),
                  _buildVenueCard('Dapur Bonda', 'Shah Alam, Selangor', 'JAKIM-4432'),
                  _buildVenueCard('Kopi Halal', 'George Town, Penang', 'JAKIM-1123'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPin(double top, double left, String name) {
    return Positioned(
      top: 100 + top, left: 150 + left,
      child: Column(
        children: [
          const Icon(Icons.location_on, color: Color(0xFFBD8B52), size: 32),
          Text(
            name, 
            style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF333333))
          ),
        ],
      ),
    );
  }

  Widget _buildVenueCard(String name, String loc, String cert) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(24), 
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.shariaGreen.withOpacity(0.1), 
              borderRadius: BorderRadius.circular(16)
            ),
            child: const Icon(Icons.verified, color: AppColors.shariaGreen, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF333333))),
                Text(loc, style: GoogleFonts.outfit(fontSize: 12, color: const Color(0xFF999999))),
              ],
            ),
          ),
          Text(
            cert, 
            style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.shariaGreen)
          ),
        ],
      ),
    );
  }
}

