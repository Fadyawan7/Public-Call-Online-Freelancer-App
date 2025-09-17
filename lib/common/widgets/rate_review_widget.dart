import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/booking_details_model.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/rating_bar_widget.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';

class RateReviewWidget extends StatelessWidget {
  final String? userImage;
  final String? userName;
  final String? comment;
  final int? rating;
  final String? reviewDate;

  const RateReviewWidget({
    super.key, this.userImage, this.userName, this.comment, this.rating, this.reviewDate,
  });


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,// Use Row for horizontal layout
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,// Use Row for horizontal layout
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorResources.borderColor,
                    border: Border.all(color: Colors.white54, width: 3),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: CustomImageWidget(
                      placeholder: Images.placeholderUser,
                      width: 55,
                      height: 55,
                      fit: BoxFit.cover,
                      image: '$userImage',
                    ),
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault), // Spacing
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,// Use Row for horizontal layout
                  children: [
                    Text(
                      '$userName',
                      style: rubikBold.copyWith(fontWeight: FontWeight.bold,fontSize: Dimensions.fontSizeLarge),
                    ),
                    Text(
                      '$reviewDate',
                      style: rubikMedium.copyWith(color: Theme.of(context).hintColor,fontSize: Dimensions.fontSizeLarge),
                    ),
                  ],
                ),
              ],
            ),
            RatingBarWidget(rating: rating!.toDouble(), size: Dimensions.fontSizeLarge, textSize: Dimensions.fontSizeLarge,),

          ],
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault,),

        Text(
          "$comment",
          style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
          overflow: TextOverflow.ellipsis,
          maxLines: 3, // Limit to 3 lines for better control

        ),

        Divider(
          indent: Dimensions.paddingSizeDefault,
          color: Theme.of(context).hintColor.withOpacity(0.3),
        ),
      ],
    );
  }
}
