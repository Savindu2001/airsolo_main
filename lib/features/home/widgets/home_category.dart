import 'package:airsolo/common/widgets/image_text_widget/vertical_image_text.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AHomeCategories extends StatelessWidget {
  const AHomeCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        'title': 'Hostels',
        'image': AImages.hostel,
        'onTap': () => Get.toNamed('/hostels'),
      },
      {
        'title': 'Taxi',
        'image': AImages.taxi,
        'onTap': () => Get.toNamed('/taxi'),
      },
      {
        'title': 'Information',
        'image': AImages.place,
        'onTap': () => Get.toNamed('/info'),
      },
      {
        'title': 'Events',
        'image': AImages.event,
        'onTap': () => Get.toNamed('/activities'),
      },
      {
        'title': 'Activities',
        'image': AImages.restaurant,
        'onTap': () => Get.toNamed('/activities'),
      },
      {
        'title': 'Cities',
        'image': AImages.place,
        'onTap': () => Get.toNamed('/cities'),
      },
    ];

    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (_, index) {
          final category = categories[index];
          return AVerticalImageText(
            title: category['title'] as String,
            image: category['image'] as String,
            textColor: AColors.white,
            onTap: category['onTap'] as VoidCallback,
          );
        },
      ),
    );
  }
}
