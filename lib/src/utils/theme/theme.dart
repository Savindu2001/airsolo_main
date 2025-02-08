import 'package:airsolo/src/utils/theme/widget_theme/text_theme.dart';
import 'package:flutter/material.dart';

class AirAppTheme {

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    textTheme: AirAppTextTheme.lightTheme,
    );
  static ThemeData darkTheme  = ThemeData(
    brightness: Brightness.dark,
    textTheme: AirAppTextTheme.darkTheme
    );
}