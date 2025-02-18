
import 'package:airsolo/utils/constants/colors.dart';
import 'package:flutter/material.dart';


/// Light & Dark Eleveted Button Theme
class AElevatedButtonTheme {
  AElevatedButtonTheme._();

  /// -- Light Theme
  static final lightElevetedButtonTheme = ElevatedButtonThemeData(
   style: ElevatedButton.styleFrom(
    elevation: 0,
    foregroundColor: Colors.white,
    backgroundColor: AColors.black,
    disabledForegroundColor: Colors.grey,
    disabledBackgroundColor: Colors.grey,
    side: const BorderSide(color: AColors.black),
    padding: const EdgeInsets.symmetric(vertical: 18),
    textStyle: const TextStyle( fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.white),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
   )
  );

  /// -- Dark Theme
  static final darkElevetedButtonTheme = ElevatedButtonThemeData(
   style: ElevatedButton.styleFrom(
    elevation: 0,
    foregroundColor: Colors.white,
    backgroundColor: AColors.primary,
    disabledForegroundColor: Colors.grey,
    disabledBackgroundColor: Colors.grey,
    side: const BorderSide(color: AColors.primary),
    padding: const EdgeInsets.symmetric(vertical: 18),
    textStyle: const TextStyle( fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.white),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
   )
  );
}