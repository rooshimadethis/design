import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CyberTheme {
  // ---------------------------------------------------------------------------
  // 🎨 Color Tokens
  // ---------------------------------------------------------------------------
  static const Color bgDark = Color(0xFF050510);
  static const Color cardBg = Color(0xFF0F0F1F);
  static const Color neonPink = Color(0xFFFF00BF);
  static const Color neonCyan = Color(0xFF00FFFF);
  static const Color neonGreen = Color(0xFF00FF41);
  static const Color matrixDim = Color(0xFF003B00);
  static const Color textMain = Colors.white;
  static const Color textDim = Colors.white54;

  // ---------------------------------------------------------------------------
  // 🧬 ThemeData Factory
  // ---------------------------------------------------------------------------
  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: bgDark,
      brightness: Brightness.dark,

      // Define the color scheme
      colorScheme: const ColorScheme.dark(
        primary: neonPink,
        secondary: neonCyan,
        surface: cardBg,
        surfaceContainer: cardBg,
        onSurface: textMain,
        tertiary: neonGreen,
      ),

      // Text Theme
      textTheme: TextTheme(
        // Headers (Hacker / Data)
        displayLarge: GoogleFonts.orbitron(
          color: textMain,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: GoogleFonts.orbitron(
          color: textMain,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: GoogleFonts.orbitron(
          color: textMain,
          fontWeight: FontWeight.w600,
        ),

        // Body (Readability)
        bodyLarge: GoogleFonts.inter(color: textMain),
        bodyMedium: GoogleFonts.inter(color: textDim),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: neonCyan),
    );
  }
}
