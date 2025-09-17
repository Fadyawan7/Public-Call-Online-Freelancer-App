import 'package:flutter/material.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';

class DateWidget extends StatelessWidget {
  final String? title;
  final String? date;

  final bool isSelected;
  final Function onTap;
  const DateWidget({Key? key, required this.title, required this.isSelected, required this.onTap, this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall/2),
      child: InkWell(
        onTap: onTap as void Function()?,
        child: Container(
          width: 75,
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
            border: Border.all(
              color: Theme.of(context).primaryColor.withOpacity(0.3), // Or any desired border color
              width: 1.0, // Adjust border width as needed
            ),

          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(date.toString(), style: rubikBold.copyWith(
                  color: isSelected ? Theme.of(context).cardColor : Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall
                )),
                Text(title!, style: rubikMedium.copyWith(
                  color: isSelected ? Theme.of(context).cardColor : Colors.black.withOpacity(0.6),
                )),

              ]),
        ),
      ),
    );
  }
}
