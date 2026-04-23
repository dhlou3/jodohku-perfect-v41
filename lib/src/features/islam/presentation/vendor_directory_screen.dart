import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jodohku_malaysia/src/theme/app_theme.dart';

class VendorDirectoryScreen extends StatelessWidget {
  const VendorDirectoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F0), // Light Theme
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          'Vendor Halal & Nikah', 
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.black)
        ),
      ),
      body: Column(
        children: [
          // CATEGORY BAR
          _buildCategoryBar(),
          
          const SizedBox(height: 8),
          
          // VENDOR LIST
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              children: [
                _buildVendorCard(context, 'Pesta Photo', 'Photographer • KL', 4.9, 'RM 1,200', true),
                _buildVendorCard(context, 'Baitul Catering', 'Katering • Selangor', 4.8, 'RM 25/pax', true),
                _buildVendorCard(context, 'Mahkota Hall', 'Venue • Putrajaya', 4.7, 'RM 5,000', true),
                _buildVendorCard(context, 'Luxe Bridal', 'Busana • Shah Alam', 5.0, 'RM 800', false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBar() {
    return Container(
      height: 70,
      color: Colors.white,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: ['Semua', 'Gambar', 'Katering', 'Dewan', 'Pelamin', 'Hantaran'].map((c) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(c, style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold)),
            selected: c == 'Semua',
            onSelected: (val) {},
            selectedColor: const Color(0xFFBD8B52),
            backgroundColor: const Color(0xFFF8F5F0),
            labelStyle: TextStyle(color: c == 'Semua' ? Colors.white : const Color(0xFFBD8B52)),
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildVendorCard(BuildContext context, String name, String cat, double rating, String price, bool verify) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(24), 
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 70, height: 70, 
                decoration: BoxDecoration(color: const Color(0xFFF8F5F0), borderRadius: BorderRadius.circular(16)),
                child: const Icon(Icons.storefront_outlined, color: Color(0xFFCCCCCC)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(name, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF333333))),
                        if (verify) const Padding(padding: EdgeInsets.only(left: 4), child: Icon(Icons.verified, color: Colors.green, size: 14)),
                      ],
                    ),
                    Text(cat, style: GoogleFonts.outfit(fontSize: 12, color: const Color(0xFF999999))),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.star, color: Color(0xFFBD8B52), size: 14), 
                            Text(' $rating', style: GoogleFonts.outfit(color: const Color(0xFF333333), fontSize: 12, fontWeight: FontWeight.bold))
                          ]
                        ),
                        Text(price, style: GoogleFonts.outfit(color: const Color(0xFFBD8B52), fontWeight: FontWeight.w900, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Membuka WhatsApp ke $name...'))
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    side: const BorderSide(color: Color(0xFFEEEEEE)),
                  ),
                  child: const Text('HUBUNGI'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _showCheckout(context, name, price),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBD8B52),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('TEMPAH'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCheckout(BuildContext context, String name, String price) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 24),
            Text('Pengesahan Tempahan', style: GoogleFonts.playfairDisplay(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFFDF9F4), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFBD8B52).withOpacity(0.1))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('Jumlah Deposit', style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                  Text(price, style: GoogleFonts.outfit(color: const Color(0xFFBD8B52), fontWeight: FontWeight.w900, fontSize: 20)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('KAEDAH PEMBAYARAN', style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFFBD8B52))),
            const SizedBox(height: 12),
            _buildPaymentMethod('🏦  FPX Online Banking'),
            _buildPaymentMethod('💳  Kad Debit / Kredit'),
            _buildPaymentMethod('📱  Touch \'n Go eWallet'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/payment-success');
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFBD8B52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                child: const Text('BAYAR SEKARANG', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethod(String label) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(border: Border.all(color: const Color(0xFFF3F4F6)), borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 14)),
          const Icon(Icons.circle_outlined, size: 20, color: Colors.grey),
        ],
      ),
    );
  }
}

