import 'package:airsolo/utils/theme/custom_themes/appbar_theme.dart';
import 'package:airsolo/utils/theme/custom_themes/bottom_sheet_theme.dart';
import 'package:airsolo/utils/theme/custom_themes/checkbox_theme.dart';
import 'package:airsolo/utils/theme/custom_themes/chip_theme.dart';
import 'package:airsolo/utils/theme/custom_themes/eleveted_button_theme.dart';
import 'package:airsolo/utils/theme/custom_themes/outline_button_theme.dart';
import 'package:airsolo/utils/theme/custom_themes/text_field_theme.dart';
import 'package:airsolo/utils/theme/custom_themes/text_theme.dart';
import 'package:flutter/material.dart';

class AAppTheme {
  AAppTheme._();

  /// -- Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    textTheme: ATextTheme.lightTextTheme,
    elevatedButtonTheme: AElevatedButtonTheme.lightElevetedButtonTheme, 
    appBarTheme: AAppBarTheme.lightAppBarTheme,
    bottomSheetTheme: ABottomSheetTheme.lightBottomSheetTheme,
    outlinedButtonTheme: AOutlineButton.lightOutlineButtonTheme,
    inputDecorationTheme: ATextFormFieldTheme.lightInputDecorationTheme,
    chipTheme: AChipTheme.lightChipTheme,
    checkboxTheme: ACheckBoxTheme.lightCheckBoxTheme,
  );

  /// -- Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    textTheme: ATextTheme.darkTextTheme, 
    elevatedButtonTheme: AElevatedButtonTheme.darkElevetedButtonTheme,
    appBarTheme: AAppBarTheme.darkAppBarTheme,
    bottomSheetTheme: ABottomSheetTheme.darkBottomSheetTheme,
    outlinedButtonTheme: AOutlineButton.darkOutlineButtonTheme,
    inputDecorationTheme: ATextFormFieldTheme.darkInputDecorationTheme,
    chipTheme: AChipTheme.darkChipTheme,
    checkboxTheme: ACheckBoxTheme.darkCheckBoxTheme,
    
  );
}