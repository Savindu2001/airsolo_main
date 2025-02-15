import 'package:airsolo/common/widgets/item_cards/vertical_item_image_card.dart';
import 'package:flutter/material.dart';

class AItemCardSlider extends StatelessWidget {
  const AItemCardSlider({
    super.key, required this.image, required this.title, 
  });


  final String image, title;



  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 10,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index){
          return AItemCardImageVertical( image: image, title: title,);
        }
        ),
    );
  }
}
