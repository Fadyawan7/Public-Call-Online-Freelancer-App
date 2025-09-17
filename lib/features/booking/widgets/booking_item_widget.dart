import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/booking/domain/models/booking_model.dart';
import 'package:flutter_restaurant/features/booking/providers/booking_provider.dart';
import 'package:flutter_restaurant/helper/date_converter_helper.dart';
import 'package:flutter_restaurant/helper/price_converter_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/app_localization.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';


class BookingItemWidget extends StatelessWidget {
  final BookingModel bookingItem;
  final String status;
  final BookingProvider bookingProvider;
  const BookingItemWidget({super.key, required this.bookingProvider, required this.status, required this.bookingItem});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [


      GestureDetector(
        onTap: ()=> RouterHelper.getBookingDetailsRoute(bookingItem.id.toString()),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeDefault),
          margin: const EdgeInsets.only(left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeSmall),
          decoration:BoxDecoration(
            color: Theme.of(context).canvasColor,
            border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          ),
          child: Column(children: [
            Row(children: [
              const SizedBox(width: Dimensions.paddingSizeSmall),
              Expanded(
                flex: 3,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(
                      '#${bookingItem.bookingId.toString()}',
                      style: rubikBold.copyWith(color: Theme.of(context).primaryColor),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                      decoration: BoxDecoration(
                        color: ColorResources.buttonBackgroundColorMap['${bookingItem.status}'],
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      ),
                      child: Text(
                        '${getTranslated('${bookingItem.status?.toCapitalized()}', context)}',
                        style: rubikSemiBold.copyWith(color: ColorResources.buttonTextColorMap['${bookingItem.status}'], fontSize: Dimensions.fontSizeDefault),
                      ),
                    ),
                  ]),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Row( children: [
                    CircleAvatar(
                      radius: 26, // Slightly smaller than before for better proportions
                      backgroundImage: bookingItem.freelancerImage != null
                          ? NetworkImage(bookingItem.freelancerImage!)
                          : null,
                      child: bookingItem.freelancerImage == null
                          ? Text(
                        '${bookingItem.freelancerName}',
                        style: rubikBold.copyWith(color: Colors.black.withOpacity(0.7), fontSize: Dimensions.fontSizeDefault),
                      )
                          : null,
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    Text(
                      '${bookingItem.freelancerName}',
                      style: rubikBold.copyWith(color: Colors.black.withOpacity(0.7), fontSize: Dimensions.fontSizeLarge),
                    ),
                  ]),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(
                      '${bookingItem.date}',
                      style: rubikBold.copyWith(color: Theme.of(context).hintColor.withOpacity(0.7), fontSize: Dimensions.fontSizeDefault),
                    ),
                    const SizedBox(width: Dimensions.fontSizeDefault),

                    Text(bookingItem.time!.toCapitalized(), style: rubikSemiBold.copyWith(
                      color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeDefault,
                    )),
                  ]),
                  // Divider(
                  //   indent: Dimensions.paddingSizeDefault,
                  //   color: Theme.of(context).hintColor.withOpacity(0.1),
                  // ),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: Container(
                  //         height: Dimensions.paddingSizeLarge * 2,
                  //         margin: EdgeInsets.zero,
                  //         child: Consumer<BookingProvider>(
                  //           builder: (context, bookingProvider, child) {
                  //             return Row(
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               children: [
                  //                 Text(
                  //                   "View",
                  //                   style: rubikSemiBold.copyWith(
                  //                     color: Theme.of(context).primaryColor, // Text color
                  //                     fontSize: Dimensions.fontSizeLarge,
                  //                   ),
                  //                 ),
                  //               ],
                  //             );
                  //           },
                  //         ),
                  //       ),
                  //     ),
                  //
                  //   ],
                  // ),
                ]),
              ),

            ]),

          ]),
        ),
      ),

    ]);
  }
}

