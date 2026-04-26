import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Elite Premium Theme Palette
  static const Color background = Color(0xFF0B0E14); // Web --bg-midnight
  static const Color surface = Color(0xFF131720);
  static const Color midnight = Color(0xFF0B0E14);
  static const Color primaryGold = Color(0xFFBD8B52); // Web --gold
  static const Color accentGold = Color(0xFFF3D1A5);
  static const Color shariaGreen = Color(0xFF10B981);
  static const Color premiumTan = Color(0xFFFCFAF7); // Web --bg-cream
  
  static const Color textMain = Colors.white;
  static const Color textSubtle = Color(0x99FFFFFF); // Transparent white
  static const Color textDark = Color(0xFF334155);


  // Functional Colors
  static const Color verified = Color(0xFFFEF3C7);
  static const Color verifiedText = Color(0xFFD97706);
  static const Color active = Color(0xFFDBEAFE);
  static const Color activeText = Color(0xFF2563EB);
  
  static const Color glass = Color(0x11FFFFFF);
  static const Color glassBorder = Color(0x33FFFFFF);
  static const Color otpBox = Color(0x0DFFFFFF);

  static const Gradient luxuryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x66020617), Color(0xF2020617)],
  );
}

class AppTheme {
  // THEME DATA
  static ThemeData get proTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primaryGold,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryGold,
        brightness: Brightness.dark,
        primary: AppColors.primaryGold,
        secondary: AppColors.shariaGreen,
        surface: AppColors.surface,
      ),
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.outfit(fontSize: 40, fontWeight: FontWeight.w900, color: Colors.white),
        titleLarge: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        bodyMedium: GoogleFonts.outfit(fontSize: 16, color: Colors.white.withOpacity(0.9)),
      ),
    );
  }

  // REUSABLE BUTTON STYLES (MATCHES SCREENSHOTS)
  static ButtonStyle get vibrantButton => ElevatedButton.styleFrom(
    backgroundColor: AppColors.primaryGold,
    foregroundColor: Colors.black,
    minimumSize: const Size(double.infinity, 64),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
    elevation: 8,
    shadowColor: AppColors.primaryGold.withOpacity(0.4),
    textStyle: GoogleFonts.outfit(fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1.5),
  );

  static ButtonStyle get outlineButton => OutlinedButton.styleFrom(
    foregroundColor: Colors.white,
    minimumSize: const Size(double.infinity, 64),
    side: BorderSide(color: Colors.white.withOpacity(0.2)),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
    backgroundColor: Colors.white.withOpacity(0.05),
    textStyle: GoogleFonts.outfit(fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1.5),
  );

  // INPUT DECORATION (GLASSMORPHISM)
  static InputDecoration glassInput(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.outfit(color: Colors.white24, fontSize: 16),
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.1), width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: AppColors.primaryGold, width: 2),
      ),
    );
  }
}

