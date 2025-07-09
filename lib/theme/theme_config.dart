import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData lightTheme = _buildTheme(Brightness.light);

ThemeData _buildTheme(Brightness brightness) {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: brightness,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: colorScheme,
    textTheme: GoogleFonts.poppinsTextTheme(),
  );
}