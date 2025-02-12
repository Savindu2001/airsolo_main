import 'package:airsolo/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class AShadowStyle{


  static final verticalItemShadow = BoxShadow(
    color:  AColors.darkGrey.withOpacity(0.1),
    blurRadius: 50,
    spreadRadius: 7,
    offset: const Offset(0, 2),
  );

  static final horizantalItemShadow = BoxShadow(
    color:  AColors.darkGrey.withOpacity(0.1),
    blurRadius: 50,
    spreadRadius: 7,
    offset: const Offset(0, 2),
  );


  
}