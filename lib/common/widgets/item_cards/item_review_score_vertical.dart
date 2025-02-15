import 'package:airsolo/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AItemReviewScoreVertical extends StatelessWidget {
  const AItemReviewScoreVertical({
    super.key, required this.reviewTitle, required this.score, required this.reviewCount,
  });

  final String reviewTitle;
  final double score, reviewCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Icon(Iconsax.magic_star1, color: AColors.reviewStar,),
            
            Text('$score', style: Theme.of(context).textTheme.headlineSmall),
    
          ],
        ),
    
    
        Row(
          children: [
    
             Text(reviewTitle),
              Text('(${reviewCount.toInt()})'),
              
    
          ],
        ),
        
       
      ],
    );
  }
}

