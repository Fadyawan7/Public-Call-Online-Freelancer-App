import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:iconsax/iconsax.dart';

class BookingInfoItemWidget extends StatelessWidget {
  final IconData? iconData;
  final String? mainTxt;
  final String? subTxt;
  final Color? iconColor;
  final Color? mainTextColor;
  final Color? subTextColor;

  const BookingInfoItemWidget({
    super.key, this.iconData, this.mainTxt, this.subTxt, this.iconColor, this.mainTextColor, this.subTextColor,
  });


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(iconData,size: Dimensions.fontSizeExtraLarge,color:iconColor ,),
            const SizedBox(width: Dimensions.paddingSizeDefault),

            Text(getTranslated('$mainTxt', context)!, style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeSmall,color: mainTextColor)),
          ],
        ),
        Text('$subTxt', style: rubikBold.copyWith(fontSize: Dimensions.fontSizeDefault,color: subTextColor))
      ],
    );
  }
}