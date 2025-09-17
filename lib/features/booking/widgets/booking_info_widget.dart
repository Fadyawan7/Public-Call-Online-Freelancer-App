import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/list_tile_widget.dart';
import 'package:flutter_restaurant/features/booking/providers/booking_provider.dart';
import 'package:flutter_restaurant/features/menu/widgets/booking_info_item_widget.dart';
import 'package:flutter_restaurant/localization/app_localization.dart';

import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class BookingInfoWidget extends StatelessWidget {

  const BookingInfoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child:Center(child:
      Consumer<BookingProvider>(
        builder: (context,bookingProvider,child){
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BookingInfoItemWidget(
                iconData: Iconsax.calendar,
                mainTxt: 'Booking',
                subTxt: '#${bookingProvider.bookingDetails!.bookingId}',
                subTextColor: Theme.of(context).primaryColor,
              ),
              Divider(
                indent: Dimensions.paddingSizeDefault,
                color: Theme.of(context).hintColor.withOpacity(0.1),
              ),
              BookingInfoItemWidget(
                iconData: Iconsax.user_octagon,
                mainTxt: 'Freelancer ID',
                subTxt: '#${bookingProvider.bookingDetails!.freelancerViewId}',
              ),
              Divider(
                indent: Dimensions.paddingSizeDefault,
                color: Theme.of(context).hintColor.withOpacity(0.1),
              ),
              BookingInfoItemWidget(
                iconData: Iconsax.clock,
                mainTxt: 'Date & Time',
                subTxt: '${bookingProvider.bookingDetails!.date} - ${bookingProvider.bookingDetails!.time}',
              ),
              Divider(
                indent: Dimensions.paddingSizeDefault,
                color: Theme.of(context).hintColor.withOpacity(0.1),
              ),

              BookingInfoItemWidget(
                iconData: Iconsax.status,
                mainTxt: 'Status',
                subTxt: '${bookingProvider.bookingDetails!.status!.toCapitalized()} ',
                subTextColor: ColorResources.buttonTextColorMap['${bookingProvider.bookingDetails!.status}'],
              ),
              Divider(
                indent: Dimensions.paddingSizeDefault,
                color: Theme.of(context).hintColor.withOpacity(0.1),
              ),
            ],
          );
        },
      )
      )

    );
  }
}

