import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  fontFamily: GoogleFonts.poppins().fontFamily,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Color(0xFF004030),
    primary: Color(0xFF004030),
    secondary: Color(0xFF4A9782),
    onPrimary: Color(0xFFFFF9E5),
    brightness: Brightness.light,
  ),
  textTheme: TextTheme(
    headlineLarge: GoogleFonts.poppins(
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    headlineSmall: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
    titleMedium: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
    titleSmall: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
    bodyLarge: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.normal),
    bodyMedium: GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
    bodySmall: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.normal),
  ),
  appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
);
