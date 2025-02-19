import 'package:airsolo/common/widgets/appbar/appbar.dart';
import 'package:airsolo/common/widgets/icon/a_circular_icon.dart';
import 'package:airsolo/common/widgets/item_cards/vertical_item_card.dart';
import 'package:airsolo/common/widgets/layout/grid_layout.dart';
import 'package:airsolo/features/app/screens/home/main_home.dart';
import 'package:airsolo/utils/constants/image_strings.dart';
import 'package:airsolo/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:iconsax/iconsax.dart';

class AWishListPage extends StatelessWidget {
  const AWishListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AAppBar(
        showBackArrow: true,
        title: Text('Wishlist',style: Theme.of(context).textTheme.headlineMedium,),
        actions: [
          ACircular_Icon(icon: Iconsax.add, onPressed: () => Get.to(const MainHomeScreen()),)
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(ASizes.defaultSpace),
          child: Column(
            children: [
              AGridLayout(itemCount: 6, itemBuilder: (_, index )=> const AItemCardVertical(scoreName: 'Awosome', businessName: 'Savee Hostel', city: 'Dambulla', country: 'sri lanka', image: AImages.hostel, score: 8.9, reviewCount: 234, discount: 0, showDiscount: false,))
            ],
          ),
        ),
      ),
    );
  }
}