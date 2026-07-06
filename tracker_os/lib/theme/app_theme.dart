import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Neo-Brutalist Colors
  static const Color primary = Color(0xFF00FF9F);
  static const Color secondary = Color(0xFFBD00FF);
  static const Color tertiary = Color(0xFF00E0FF);
  static const Color accent = Color(0xFFFF005C);
  static const Color background = Color(0xFF0A0A0A);
  static const Color surface = Color(0xFF141414);
  static const Color onSurface = Color(0xFFE5E2E1); // from design
  
  // Specific semantic colors
  static const Color border = Colors.black;

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        tertiary: tertiary,
        error: accent,
        surface: surface,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.anybody(
          fontSize: 80,
          fontWeight: FontWeight.w900,
          color: onSurface,
          letterSpacing: -0.04 * 80,
        ),
        displayMedium: GoogleFonts.anybody(
          fontSize: 48,
          fontWeight: FontWeight.w900,
          color: onSurface,
          letterSpacing: -0.02 * 48,
        ),
        headlineLarge: GoogleFonts.anybody(
          fontSize: 40,
          fontWeight: FontWeight.w800,
          color: onSurface,
          letterSpacing: -0.02 * 40,
        ),
        headlineMedium: GoogleFonts.anybody(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: onSurface,
        ),
        bodyLarge: GoogleFonts.archivoNarrow(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: onSurface,
        ),
        bodyMedium: GoogleFonts.archivoNarrow(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: onSurface,
        ),
        labelLarge: GoogleFonts.spaceMono(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: onSurface,
        ),
        labelMedium: GoogleFonts.spaceMono(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: onSurface,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.anybody(fontSize: 24, fontWeight: FontWeight.bold, color: onSurface),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.black,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: border, width: 3),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: border, width: 3),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: border, width: 3),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: primary, width: 3),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: GoogleFonts.spaceMono(color: onSurface.withOpacity(0.7)),
      ),
    );
  }
}
