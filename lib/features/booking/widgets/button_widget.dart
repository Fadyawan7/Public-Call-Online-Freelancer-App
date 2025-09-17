import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_restaurant/common/models/product_model.dart';
import 'package:flutter_restaurant/common/providers/theme_provider.dart';
import 'package:flutter_restaurant/common/widgets/custom_alert_dialog_widget.dart';
import 'package:flutter_restaurant/common/widgets/slider_button_widget.dart';
import 'package:flutter_restaurant/features/booking/providers/booking_provider.dart';
import 'package:flutter_restaurant/features/booking/widgets/booking_cancel_dialog_widget.dart';
import 'package:flutter_restaurant/features/language/providers/localization_provider.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';

import 'package:flutter_restaurant/helper/price_converter_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:provider/provider.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Consumer<BookingProvider>(builder: (context, bookingProvider, _) {
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      final userType = profileProvider.userInfoModel!.userType;
      final bookingStatus = bookingProvider.bookingDetails?.status;
      final width = MediaQuery.of(context).size.width;
      final isLtr = Provider.of<LocalizationProvider>(context).isLtr;

      Widget buildActionButton({
        required String text,
        required Color backgroundColor,
        required Color textColor,
        required VoidCallback onPressed,
      }) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: TextButton(
              style: TextButton.styleFrom(
                minimumSize: const Size(1, 50),
                backgroundColor: backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: onPressed,
              child: Text(
                getTranslated(text, context)!,
                style: rubikBold.copyWith(
                  color: textColor,
                  fontSize: Dimensions.fontSizeLarge,
                ),
              ),
            ),
          ),
        );
      }

      Widget buildSwipeToComplete() {
        return Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
            border: Border.all(color: Theme.of(context).dividerColor.withOpacity(.05)),
            color: Theme.of(context).canvasColor,
          ),
          child: Transform.rotate(
            angle: isLtr ? 0 : pi,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: SliderButtonWidget(
                action: () {
                  bookingProvider.updateBookingStatus(
                    bookingProvider.bookingDetails!.id.toString(),
                    'completed',
                    _callback,
                  );

                },
                label: Text(
                  getTranslated('Swipe to Complete Booking', context)!,
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).primaryColor),
                ),
                dismissThresholds: 0.5,
                dismissible: false,
                icon: const Center(
                  child: Icon(
                    Icons.double_arrow_sharp,
                    color: Colors.white,
                    size: Dimensions.paddingSizeLarge,
                  ),
                ),
                radius: 10,
                boxShadow: const BoxShadow(blurRadius: 0.0),
                buttonColor: Theme.of(context).primaryColor,
                backgroundColor: Theme.of(context).canvasColor,
                baseColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
        );
      }

      return Column(
        children: [
          if (userType != "freelancer" && bookingStatus == 'pending') ...[
            Center(
              child: Container(
                color: Theme.of(context).cardColor,
                width: width > 700 ? 700 : width,
                child: Row(
                  children: [
                    buildActionButton(
                      text: 'Cancel Booking',
                      backgroundColor: Theme.of(context).hintColor.withOpacity(0.2),
                      textColor: ColorResources.homePageSectionTitleColor,
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => BookingCancelDialogWidget(
                            popUpTxt: "are_you_sure_to_cancel",
                            status: "cancelled",
                            bookingID: bookingProvider.bookingDetails!.id.toString(),
                            callback: (String message, bool isSuccess, String bookingID) {
                              if (isSuccess) {
                                showCustomSnackBarHelper(message, isError: false);
                                RouterHelper.getMainRoute(action: RouteAction.pushNamedAndRemoveUntil);
                              } else {
                                showCustomSnackBarHelper(message, isError: true);
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (userType == "freelancer" && bookingStatus == 'pending') ...[
            Center(
              child: Container(
                color: Theme.of(context).cardColor,
                width: width > 700 ? 700 : width,
                child: Row(
                  children: [
                    buildActionButton(
                      text: 'Confirm Booking',
                      backgroundColor: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).cardColor,
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => BookingCancelDialogWidget(
                            popUpTxt: "are_you_sure_to_confirm",
                            status: "confirmed",
                            bookingID: bookingProvider.bookingDetails!.id.toString(),
                            callback: (String message, bool isSuccess, String bookingID) {
                              if (isSuccess) {
                                bookingProvider.getBookingDetails(bookingID).then((_) {
                                  showCustomSnackBarHelper(message, isError: false);
                                });
                              } else {
                                showCustomSnackBarHelper(message, isError: true);
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],

          if (bookingStatus == 'completed' &&
              ((bookingProvider.bookingDetails!.userReview == false && profileProvider.userInfoModel!.userType != "freelancer")||
            bookingProvider.bookingDetails!.freelancerReview == false && profileProvider.userInfoModel!.userType == "freelancer")
          ) ...[
            Center(
              child: Container(
                width: width > 700 ? 700 : width,
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: CustomButtonWidget(
                  btnTxt: getTranslated('review', context),
                  onTap: () {
                    String? takerId = userType == "freelancer"
                        ? bookingProvider.bookingDetails!.userId.toString()
                        : bookingProvider.bookingDetails!.freelancerId.toString();
                    RouterHelper.getSubmitRateReviewRoute(bookingId: bookingProvider.bookingDetails!.id, takerId: takerId);
                  },
                ),
              ),
            ),
          ],
          if (bookingStatus == "confirmed" && userType == "freelancer") ...[
            // buildSwipeToComplete(),
            Center(
              child: Container(
                color: Theme.of(context).cardColor,
                width: width > 700 ? 700 : width,
                child: Row(
                  children: [
                    buildActionButton(
                      text: 'Complete Booking',
                      backgroundColor: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).cardColor,
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => BookingCancelDialogWidget(
                            popUpTxt: "are_you_sure_to_complete",
                            status: "completed",
                            bookingID: bookingProvider.bookingDetails!.id.toString(),
                            callback: (String message, bool isSuccess, String bookingID) {
                              if (isSuccess) {
                                bookingProvider.getBookingDetails(bookingID).then((_) {
                                  showCustomSnackBarHelper(message, isError: false);
                                });
                              } else {
                                showCustomSnackBarHelper(message, isError: true);
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

          ],
        ],
      );
    });
  }

  void _callback(String message, bool isSuccess, String bookingID) async {
    if (isSuccess) {
      Provider.of<BookingProvider>(Get.context!, listen: false).getBookingDetails(bookingID.toString()).then((_) {
        showCustomSnackBarHelper('Booking completed Successfully!', isError: false);
      });
      showCustomSnackBarHelper(message, isError: false);
    } else {
      showCustomSnackBarHelper(message);
    }
  }

}
