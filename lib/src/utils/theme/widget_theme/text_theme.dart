import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class AirAppTextTheme {
  static TextTheme lightTheme = TextTheme(
    headlineLarge: GoogleFonts.poppins(
      color: Colors.black87,
      fontWeight: FontWeight.bold
      
    ),

    headlineMedium: GoogleFonts.poppins(
      color: Colors.black,
      fontSize: 24,
      fontWeight: FontWeight.bold
    ),

    headlineSmall: GoogleFonts.poppins(
      color: Colors.black54
    )
  );

  static TextTheme darkTheme = TextTheme(
    headlineLarge: GoogleFonts.poppins(
      color: Colors.white,
      fontWeight: FontWeight.bold
    ),

    headlineMedium: GoogleFonts.poppins(
      color: Colors.white,
      fontSize: 24,
      fontWeight: FontWeight.bold
    ),

    headlineSmall: GoogleFonts.poppins(
      color: Colors.white60
    )
  );
}

