import 'package:flutter/material.dart';
import 'package:flutter_restaurant/features/address/screens/add_new_address_screen.dart';
import 'package:flutter_restaurant/localization/app_localization.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';

class TimeZoneWidget extends StatelessWidget {
  final String? title;
  final bool isSelected;
  final Function onTap;
  const TimeZoneWidget({super.key, required this.title, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall/2),
      child: InkWell(
        onTap: onTap as void Function()?,
        child: Container(
          // width: 75,
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            border: Border.all(
              color: Theme.of(context).primaryColor.withOpacity(0.3), // Or any desired border color
              width: 1.0, // Adjust border width as needed
            ),

          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text(title!.toCapitalized(), style: rubikMedium.copyWith(
                  color: isSelected ? Theme.of(context).cardColor : Colors.black.withOpacity(0.6),
                )),

              ]),
        ),
      ),
    );
  }
}
