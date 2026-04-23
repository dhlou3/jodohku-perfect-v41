import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jodohku_malaysia/src/theme/app_theme.dart';

class PaymentStatusScreen extends StatelessWidget {
  final bool isSuccess;
  final String transactionId;
  final String tierName;

  const PaymentStatusScreen({
    super.key,
    required this.isSuccess,
    required this.transactionId,
    required this.tierName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SUCCESS ANIMATION ICON
            Container(
              width: 100, height: 100,
              decoration: BoxDecoration(
                color: isSuccess ? Colors.greenAccent.withOpacity(0.1) : Colors.redAccent.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: isSuccess ? Colors.greenAccent : Colors.redAccent, width: 2),
              ),
              child: Icon(isSuccess ? Icons.check : Icons.close, color: isSuccess ? Colors.greenAccent : Colors.redAccent, size: 50),
            ),
            const SizedBox(height: 32),
            
            Text(isSuccess ? 'Pembayaran Berjaya!' : 'Pembayaran Gagal', style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            Text(
              isSuccess ? 'Selamat Datang ke Ahli $tierName Jodohku.' : 'Maaf, transaksi anda tidak dapat diproses oleh bank.',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(color: AppColors.textSubtle, fontSize: 14),
            ),
            
            const SizedBox(height: 48),
            
            // RECEIPT DETAILS
            if (isSuccess)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white10)),
                child: Column(
                  children: [
                    _buildReceiptRow('ID Transaksi', transactionId),
                    const Divider(color: Colors.white10, height: 24),
                    _buildReceiptRow('Pelan', tierName),
                    const Divider(color: Colors.white10, height: 24),
                    _buildReceiptRow('Tarikh', 'Hari Ini'),
                  ],
                ),
              ),
              
            const SizedBox(height: 64),
            
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: AppTheme.proButtonPrimary,
              child: Text(isSuccess ? 'MASUK KE DASHBOARD' : 'CUBA LAGI'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textSubtle)),
        Text(value, style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }
}
