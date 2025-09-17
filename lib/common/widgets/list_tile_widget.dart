import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';

class ListTileWidget extends StatelessWidget {
  final IconData? iconData;
  final String? mainTxt;
  final String? subTxt;

  const ListTileWidget({
    super.key, this.iconData, this.mainTxt, this.subTxt,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: Row(
        children: [
          Icon(iconData,size: Dimensions.fontSizeOverLarge,color:Theme.of(context).hintColor ,),
          const SizedBox(width: Dimensions.paddingSizeDefault),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(getTranslated('${mainTxt}', context)!, style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).hintColor)),
              Text('${subTxt}', style: rubikBold.copyWith(fontSize: Dimensions.fontSizeDefault))
            ],
          )
        ],
      ),
    );
  }
}
