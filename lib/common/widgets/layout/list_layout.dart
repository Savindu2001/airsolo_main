import 'package:flutter/material.dart';

class AListLayout extends StatelessWidget {
  const AListLayout({super.key, required this.itemBuilder, required this.itemCount});

  final Widget? Function(BuildContext, int) itemBuilder;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      
      
    );
  }
}
