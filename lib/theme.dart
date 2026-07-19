import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Gradients
  static const List<Color> orangeGradient = [
    Color(0xFFFF9E7A), // Peach orange
    Color(0xFFFF6347), // Soft tomato red/orange
  ];

  static const List<Color> cardGradient = [
    Color(0xFFFFF2EC), // Very soft warm orange-white
    Color(0xFFFFFFFF), // White
  ];

  static const Color primary = Color(0xFFFF7A50);
  static const Color secondary = Color(0xFFFF9E7A);
  static const Color background = Color(0xFFA1A3A6); // The background color of the canvas in the mockup
  static const Color appBackground = Color(0xFFF6F8FA); // Soft background of the phone screen
  static const Color cardBg = Colors.white;
  static const Color textDark = Color(0xFF2C3E50);
  static const Color textLight = Color(0xFF7F8C8D);
  static const Color accentOrange = Color(0xFFFFF0EB);
  static const Color buttonDark = Color(0xFF2B2D31); // Dark neumorphic/matte button color in mockup
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
        colors: AppColors.orangeGradient,
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
