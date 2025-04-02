import 'package:airsolo/bindings/general_bindings.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      themeMode: ThemeMode.system,
      theme: AAppTheme.lightTheme,
      initialBinding: GeneralBindings(),
      darkTheme: AAppTheme.darkTheme,
      home: const Scaffold(backgroundColor: AColors.primary, body: Center(child: CircularProgressIndicator(color: Colors.white,),),)
    );
  }
}


