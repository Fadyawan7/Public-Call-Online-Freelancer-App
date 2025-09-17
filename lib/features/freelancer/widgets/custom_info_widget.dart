import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/rating_bar_widget.dart';
import 'package:flutter_restaurant/features/freelancer/domain/models/freelancer_model.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';

Container CustomInfoWidget(FreelancerModel freelancer) {
  return Container(
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14)
    ),
    child: Padding(
      padding: const EdgeInsets.only(
        left: 6, right: Dimensions.paddingSizeDefault/2,
        top: 10, bottom: Dimensions.paddingSizeDefault/2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(1),
              child: ClipOval(
                child: CustomImageWidget(
                  placeholder: Images.placeholderUser, height: 40, width: 40, fit: BoxFit.cover,
                  image:
                  '${freelancer.image }',
                ) ,
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeDefault/2),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      '${freelancer.name}' ?? '',
                      style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeDefault,fontWeight: FontWeight.bold,color: Theme.of(Get.context!).primaryColor),
                    ) ,
                    Text(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      '${freelancer.freelancerCategory}' ?? '',
                      style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall,fontWeight: FontWeight.w900),
                    ) ,
                  ],
                ),
                // const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              ]),
            ),
          ]),
          const SizedBox(height: Dimensions.paddingSizeDefault/2),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  overflow: TextOverflow.ellipsis,
                  'Total Orders: 20',
                  style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall,color: Colors.grey),
                ) ,
                RatingBarWidget(rating: 4.0, size: Dimensions.paddingSizeLarge,textSize: Dimensions.paddingSizeLarge,),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}