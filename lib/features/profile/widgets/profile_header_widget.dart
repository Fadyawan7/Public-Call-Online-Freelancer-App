// profile_header_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final bool fromSplash;

  const ProfileHeaderWidget({
    super.key,
    required this.fromSplash,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraLarge),
      child: Container(
        height: 60,
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (!fromSplash)
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios),
                    color: Colors.white,
                  ),
                ),
              ),
            Center(
              child: Text(
                getTranslated(fromSplash ? 'complete_profile' : 'my_profile', context)!,
                style: rubikSemiBold.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}