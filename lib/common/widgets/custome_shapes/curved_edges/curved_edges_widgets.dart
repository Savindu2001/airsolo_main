
import 'package:airsolo/common/widgets/custome_shapes/curved_edges/curved_edges.dart';
import 'package:flutter/material.dart';

class ACustomCurvedWidget extends StatelessWidget {
  const ACustomCurvedWidget({
    super.key, this.child,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ACustomCurvedEdges(),
      child: child
    );
  }
}
