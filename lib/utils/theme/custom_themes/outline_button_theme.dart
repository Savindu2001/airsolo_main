import 'package:airsolo/utils/constants/colors.dart';
import 'package:flutter/material.dart';


/// Light & Dark Outline Button Theme
class AOutlineButton {

  AOutlineButton._();

  /* -- Light Theme --  */
  static final lightOutlineButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
    elevation: 0,
    foregroundColor: Colors.black,
    side: const BorderSide(color: AColors.primary),
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    textStyle: const TextStyle( fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.black),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))
   )
  );

  /* -- Dark Theme --  */
  static final darkOutlineButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
    elevation: 0,
    foregroundColor: Colors.white,
    side: const BorderSide(color: AColors.accent),
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    textStyle: const TextStyle( fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.white),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))
   )
  );

  
}
