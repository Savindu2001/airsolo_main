
import 'package:airsolo/common/widgets/image_text_widget/vertical_image_text.dart';
import 'package:airsolo/utils/constants/colors.dart';
import 'package:airsolo/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';

class AHomeCategories extends StatelessWidget {
  const AHomeCategories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 6,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index){
          return AVerticalImageText(title: 'Hostels', textColor: AColors.white, image: AImages.hostel, onTap: (){},);
        }
        ),
    );
  }
}