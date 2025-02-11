import 'package:airsolo/common/widgets/custome_shapes/containers/primary_hader_container.dart';
import 'package:airsolo/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class ServiceHomeScreen extends StatelessWidget {
  const ServiceHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final darkMode = AHelperFunctions.isDarkMode(context);
    return   Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [

            // Custom Circle Design
            APrimaryHeaderContainer(
              child: Container()
              ),

            
          ],
        ),
      ),
    );
  }
}
