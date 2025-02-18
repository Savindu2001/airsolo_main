
import 'package:airsolo/common/widgets/custome_shapes/containers/circle_container.dart';
import 'package:airsolo/common/widgets/custome_shapes/curved_edges/curved_edges_widgets.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class APrimaryHeaderContainer extends StatelessWidget {
  const APrimaryHeaderContainer({
    super.key, required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final  darkMode = AHelperFunctions.isDarkMode(context);
    return ACustomCurvedWidget(
      child: Container(
                  color: darkMode? AColors.primary : AColors.homePrimary,
                  padding: const EdgeInsets.all(0),
                
                  child: Container(
                    child: Stack(
                      children: [
                    
                        // Background Shapes
                    
                          Positioned(top: -150,right: -250,child: ACircularContainer(backgroundColor: darkMode ? AColors.black.withOpacity(0.1) : AColors.white.withOpacity(0.1))),
                          Positioned(top: 150,right: 250,child: ACircularContainer(backgroundColor: darkMode ? AColors.black.withOpacity(0.1) : AColors.white.withOpacity(0.1))),
                          Positioned(top: 150,right: 250,child: ACircularContainer(width: 100, height:100, backgroundColor: darkMode ? AColors.black.withOpacity(0.1) : AColors.white.withOpacity(0.1))),
                          Positioned(top: 180,right: 100,child: ACircularContainer(width: 50, height:50, backgroundColor: darkMode ? AColors.black.withOpacity(0.1) : AColors.white.withOpacity(0.1))),
                    
                          child
                    
                        
                    
                        
                      ],
                    ),
                  ),
                ),
    );
  }
}
