import 'package:airsolo/utils/constants/sizes.dart';
import 'package:airsolo/utils/constants/texts.dart';
import 'package:flutter/material.dart';

class ServiceHomeScreen extends StatelessWidget {
  const ServiceHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:  Text(ATexts.serviceScreenTitle, style: Theme.of(context).textTheme.headlineLarge,),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(ASizes.defaultSpace),
        child: Column(
          children: [

            //Hotel & Hostel Category


            //Hotels & Hostels  List 


          ],
        ),
      ),
    );
  }
}