import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MarshmallowTheme {
  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color(0xFFE11D48), // Bright Red
      scaffoldBackgroundColor: const Color(0xFFFFF1F2), // Very pale pink
      colorScheme: const ColorScheme.light(
        primary: Color(0xFFE11D48),
        secondary: Color(0xFFFFFFFF), // White for stripes/marshmallows
        surface: Color(0xFFFFFFFF),
        onSurface: Color(0xFF881337), // Dark Red Text
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.grandstander(
          fontSize: 42,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: GoogleFonts.patrickHand(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: GoogleFonts.patrickHand(fontSize: 18),
      ),
      useMaterial3: true,
    );
  }
}
