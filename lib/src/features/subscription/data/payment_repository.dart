import 'dart:async';

class PaymentRepository {
  // 🏢 Jodohku REVENUE ENGINE
  // Simulation of FPX / Stripe / ToyyibPay integration

  static const Map<String, double> tierPrices = {
    'Gold': 29.00,
    'Platinum': 69.00,
    'Sovereign': 149.00,
  };

  Future<PaymentResult> processPayment({
    required String userId,
    required String tierName,
    required String paymentMethod, // 'FPX', 'Card', 'GrabPay'
  }) async {
    // 1. SIMULATE NETWORK DELAY (Stripe/FPX Handshake)
    await Future.delayed(const Duration(seconds: 2));

    // 2. LOGIC: Verification of payment success
    // In production, this calls the external gateway API
    bool isSuccess = true; 

    if (isSuccess) {
      return PaymentResult(
        isSuccess: true,
        transactionId: 'NM-${DateTime.now().millisecondsSinceEpoch}',
        amount: tierPrices[tierName] ?? 0.0,
        tierName: tierName,
      );
    } else {
      return PaymentResult(isSuccess: false, message: 'Pembayaran Ditolak oleh Bank.');
    }
  }
}

class PaymentResult {
  final bool isSuccess;
  final String transactionId;
  final double amount;
  final String tierName;
  final String message;

  PaymentResult({
    required this.isSuccess,
    this.transactionId = '',
    this.amount = 0.0,
    this.tierName = '',
    this.message = '',
  });
}
