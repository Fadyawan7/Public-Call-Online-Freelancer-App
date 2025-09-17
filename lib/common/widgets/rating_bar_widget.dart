import 'package:flutter/material.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';

class RatingBarWidget extends StatelessWidget {
  final double rating;
  final double size;
  final double textSize;
  const RatingBarWidget({super.key, this.rating=0.0, this.size = 18, required this.textSize});

  @override
  Widget build(BuildContext context) {

    return rating > 0 ? Row(mainAxisSize: MainAxisSize.min, children: [
      Text(rating.toStringAsFixed(1), style: rubikSemiBold.copyWith(fontSize: textSize)),
      const SizedBox(width: Dimensions.paddingSizeExtraSmall),
      for(int i=0; i<rating;i++)
      Icon(Icons.star, size: size,color: Colors.orange,),



    ]) : const SizedBox();
  }
}

