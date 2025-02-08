import 'package:airsolo/src/features/authentication/screens/splash_screen.dart';
import 'package:airsolo/src/utils/theme/theme.dart';
import 'package:flutter/material.dart';


void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: AirAppTheme.lightTheme,
      darkTheme: AirAppTheme.darkTheme ,
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}

