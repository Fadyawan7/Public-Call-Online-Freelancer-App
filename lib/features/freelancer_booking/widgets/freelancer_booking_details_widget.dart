import 'package:flutter/material.dart';
import 'package:flutter_restaurant/features/booking/providers/booking_provider.dart';
import 'package:flutter_restaurant/features/booking/widgets/booking_attachments_widget.dart';
import 'package:flutter_restaurant/features/booking/widgets/booking_info_widget.dart';
import 'package:flutter_restaurant/features/booking/widgets/freelancer_widget.dart';
import 'package:flutter_restaurant/features/freelancer_booking/widgets/booking_user_widget.dart';
import 'package:flutter_restaurant/features/freelancer_booking/widgets/freelancer_booking_info_widget.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/date_converter_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class FreelancerBookingDetailsWidget extends StatelessWidget {
  const FreelancerBookingDetailsWidget({super.key, this.bookingId});
  final int? bookingId;

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    return Consumer<BookingProvider>(
        builder: (context, booking, _) {
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(getTranslated('Booking Info', context)!, style: rubikBold),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    boxShadow: [BoxShadow(
                      color: Theme.of(context).shadowColor.withOpacity(0.5), blurRadius: Dimensions.radiusSmall,
                      spreadRadius: 1, offset: const Offset(2, 2),
                    )],
                  ),
                  child: const FreelancerBookingInfoWidget(),
                ),


                const SizedBox(height: Dimensions.paddingSizeDefault),

                if(booking.bookingDetails?.freelancerName != null) Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(getTranslated('User Detail', context)!, style: rubikBold),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      boxShadow: [BoxShadow(
                        color: Theme.of(context).shadowColor.withOpacity(0.5), blurRadius: 5, spreadRadius: 1, offset: const Offset(2, 2),
                      )],
                    ),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child:  BookingUserWidget(bookingDetailsModel: booking.bookingDetails!),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),
                ]),

                const SizedBox(height: Dimensions.paddingSizeDefault),

                if(booking.bookingDetails?.description?.isNotEmpty ?? false) ...[
                  Text(getTranslated('Issue Explanation', context)!, style: rubikBold),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      boxShadow: [BoxShadow(
                        color: Theme.of(context).shadowColor.withOpacity(0.5), blurRadius: 5, spreadRadius: 1, offset: const Offset(2, 2),
                      )],
                    ),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                      Text(booking.bookingDetails?.description ?? '', style: rubikRegular.copyWith(color: Theme.of(context).hintColor)),
                    ]),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  if(booking.bookingDetails?.attachments != null && booking.bookingDetails!.attachments!.isNotEmpty ) ...[
                        Text(getTranslated('Attachments', context)!, style: rubikBold),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            boxShadow: [BoxShadow(
                              color: Theme.of(context).shadowColor.withOpacity(0.5),
                              blurRadius: Dimensions.radiusSmall, spreadRadius: 1, offset: const Offset(2, 2),
                            )],
                          ),
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          child: BookingAttachmentsWidget(bookingProvider: booking, splashProvider: splashProvider),
                        ),
                    ]
                ],
              ]),
            ),

          ]);
        }
    );
  }
}