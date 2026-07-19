import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Gradients
  static const List<Color> primaryGradient = [
    Color(0xFF2563EB), // Premium Blue
    Color(0xFF10B981), // Premium Green
  ];

  static const List<Color> cardGradient = [
    Color(0xFFEFF6FF), // Soft Blue tint
    Color(0xFFFFFFFF), // White
  ];

  static const Color primary = Color(0xFF2563EB); // Blue
  static const Color secondary = Color(0xFF10B981); // Green
  static const Color background = Color(0xFFA1A3A6); 
  static const Color appBackground = Color(0xFFF8FAFC); // Clean slate bg
  static const Color cardBg = Colors.white;
  static const Color textDark = Color(0xFF0F172A); // Slate Dark
  static const Color textLight = Color(0xFF64748B); // Slate Light
  static const Color accentBlue = Color(0xFFEFF6FF); // Soft blue indicator tint
  static const Color accentGreen = Color(0xFFECFDF5); // Soft green indicator tint
  static const Color buttonDark = Color(0xFF09090B); // Matte black button
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        background: AppColors.appBackground,
      ),
      textTheme: GoogleFonts.outfitTextTheme().copyWith(
        titleLarge: GoogleFonts.outfit(
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
        bodyLarge: GoogleFonts.inter(
          color: AppColors.textDark,
        ),
        bodyMedium: GoogleFonts.inter(
          color: AppColors.textLight,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBg,
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.04),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonDark,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          textStyle: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class PremiumCardDecoration {
  static BoxDecoration get gradientHeader {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: AppColors.primaryGradient,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(32),
        bottomRight: Radius.circular(32),
      ),
    );
  }

  static BoxDecoration get containerShadow {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  static BoxDecoration get outlineCard {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: const Color(0xFFEFEFEF), width: 1),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.02),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
