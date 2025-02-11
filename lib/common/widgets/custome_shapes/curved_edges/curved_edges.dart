import 'package:flutter/material.dart';

class ACustomCurvedEdges extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
   
    var path  = Path();
    path.lineTo(0, size.height);

    final firstCave = Offset(0, size.height - 20); 
    final lastCave = Offset(30, size.height - 20);
    path.quadraticBezierTo(firstCave.dx, firstCave.dy, lastCave.dx, lastCave.dy);


    final secondFirstCave = Offset(0, size.height - 20); 
    final secondLastCave = Offset(size.width -30, size.height - 20);
    path.quadraticBezierTo(secondFirstCave.dx, secondFirstCave.dy, secondLastCave.dx, secondLastCave.dy);



    final thirdFirstCave = Offset(size.width, size.height - 20); 
    final thirdLastCave = Offset(size.width, size.height);
    path.quadraticBezierTo(thirdFirstCave.dx, thirdFirstCave.dy, thirdLastCave.dx, thirdLastCave.dy);


    path.lineTo(size.width, 0);
    path.close();
    return path;

  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
  
}