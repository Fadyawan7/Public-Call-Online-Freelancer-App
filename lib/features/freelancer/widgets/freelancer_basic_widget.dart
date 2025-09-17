import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/rating_bar_widget.dart';
import 'package:flutter_restaurant/features/freelancer/domain/models/freelancer_model.dart';
import 'package:flutter_restaurant/localization/app_localization.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';

class FreelancerBasicInfo extends StatelessWidget {
  const FreelancerBasicInfo({
    super.key,
    required this.freelancer,
  });

  final FreelancerModel freelancer;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            vertical: Dimensions.paddingSizeExtraSmall,
            horizontal: Dimensions.paddingSizeDefault,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${freelancer.name}',
                style: rubikBold.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: Dimensions.fontSizeOverLarge,
                ),
              ),
              Text(
                '${freelancer.freelancerCategory}',
                style: rubikMedium.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                ),
              ),
              Row(
                children: [
                  RatingBarWidget(
                    rating: freelancer.avgRating ?? 0.0,
                    size: Dimensions.paddingSizeDefault,
                    textSize: Dimensions.paddingSizeDefault,
                  ),
                  const SizedBox(
                      width: Dimensions.paddingSizeExtraSmall),
                  Text(
                    '(${freelancer.totalJob})',
                    style: rubikRegular.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                  width: Dimensions.paddingSizeExtraSmall),
              Text(
                freelancer.status!.toCapitalized(),
                style: rubikBold.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: freelancer.status! == 'busy'
                      ? Colors.red
                      : Theme.of(context).secondaryHeaderColor,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeDefault,
          ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ColorResources.borderColor,
            border: Border.all(
              color: Colors.white54,
              width: 3,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(80),
            child: CustomImageWidget(
              placeholder: Images.placeholderUser,
              width: 80,
              height: 80,
              fit: BoxFit.contain,
              image: '${freelancer.image}',
            ),
          ),
        ),
      ],
    );
  }
}