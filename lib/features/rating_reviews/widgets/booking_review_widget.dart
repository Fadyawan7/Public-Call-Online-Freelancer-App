import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:flutter_restaurant/features/booking/domain/models/booking_model.dart';
import 'package:flutter_restaurant/features/booking/providers/booking_provider.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/features/rating_reviews/domain/models/review_body_model.dart';
import 'package:flutter_restaurant/features/rating_reviews/providers/review_provider.dart';

import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class BookingReviewWidget extends StatefulWidget {
  final int bookingID;
  final int takerID;

  const BookingReviewWidget({super.key, required this.bookingID, required this.takerID});

  @override
  State<BookingReviewWidget> createState() => _BookingReviewWidgetState();
}

class _BookingReviewWidgetState extends State<BookingReviewWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    final ReviewProvider reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
    reviewProvider.setRatingIndex(-1, isUpdate: false);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Consumer<ReviewProvider>(
      builder: (context, reviewProvider, child) {
        return SingleChildScrollView(
          child: Column(children: [

            Center(child: Container(
              margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
              child: SizedBox(width: Dimensions.webScreenWidth, child: Container(
                padding:const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeSmall,
                  vertical: Dimensions.paddingSizeSmall,
                ),
                margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                child: Column(children: [
                  /// for Rate
                  Text(
                    getTranslated('rate_his_service', context)!,
                    style: rubikSemiBold.copyWith(color: ColorResources.getGreyBunkerColor(context)), overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  SizedBox(
                    height: 70,
                    child: ListView.builder(
                      itemCount: 5, // Number of stars
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, i) {

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                child: Container(
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                  decoration: BoxDecoration(
                                    color: reviewProvider.rateIndex >= i
                                        ? ColorResources.getSecondaryColor(context).withOpacity(0.1)
                                        : Colors.transparent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    reviewProvider.rateIndex >= i ? Iconsax.star1 :Iconsax.star, // Use star icon
                                    size: Dimensions.paddingSizeDefault*2,
                                    color: reviewProvider.rateIndex >= i
                                        ? Theme.of(context).primaryColor
                                        : Theme.of(context).textTheme.bodyLarge!.color,
                                  ),
                                ),
                                onTap: () {
                                  reviewProvider.setRatingIndex(i); // Set rating index (0-based)
                                },
                              ),

                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  /// for opinion box
                  Text(
                    getTranslated('share_your_opinion', context)!,
                    style: rubikSemiBold.copyWith(color: ColorResources.getGreyBunkerColor(context)), overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  CustomTextFieldWidget(
                    capitalization: TextCapitalization.sentences,
                    hintText: getTranslated('write_your_review_here', context),
                    fillColor: Theme.of(context).cardColor,
                    isShowBorder: true,
                    borderColor: Theme.of(context).hintColor.withOpacity(0.5),
                    maxLines: 5,
                    controller: _controller,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  /// for Submit button
                  Column(children: [
                    !reviewProvider.isLoading ? Padding(
                      padding:const EdgeInsets.symmetric(horizontal:  Dimensions.paddingSizeExtraLarge),
                      child: CustomButtonWidget(
                        btnTxt: getTranslated(reviewProvider.isReviewSubmitted ? 'submitted' : 'submit', context),
                        onTap: reviewProvider.isReviewSubmitted ? null : () {
                          if (reviewProvider.rateIndex == -1) {
                            showCustomSnackBarHelper('Give a rating');
                          }
                          else if (_controller.text.isEmpty) {
                            showCustomSnackBarHelper('Write a review');
                          }
                          else {
                            FocusScopeNode currentFocus = FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                            ReviewBody reviewBody = ReviewBody(
                              takerId: widget.takerID,
                              rating: reviewProvider.rateIndex + 1,
                              comment: _controller.text,
                              bookingId: widget.bookingID,
                            );
                            reviewProvider.submitBookingReview(reviewBody).then((value) {
                              if (value.isSuccess) {
                                showCustomSnackBarHelper(value.message, isError: false);
                                _controller.text = '';
                                Provider.of<BookingProvider>(context, listen: false).getBookingList(context,'pending');

                                RouterHelper.getMainRoute(action: RouteAction.pushNamedAndRemoveUntil);
                              } else {
                                showCustomSnackBarHelper(value.message);
                              }
                            });
                          }
                        },
                      ),
                    ) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                    const SizedBox(height: Dimensions.paddingSizeLarge),
                  ]),

                ]),
              )),
            )),



          ]),
        );
      },
    );
  }
}

