import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/booking_details_model.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/features/booking/providers/booking_provider.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';

import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class   BookingUserWidget extends StatelessWidget {
  final BookingDetailsModel bookingDetailsModel;
  const BookingUserWidget({
    super.key, required this.bookingDetailsModel,
  });

  @override
  Widget build(BuildContext context) {
    final BookingProvider bookingProvider = Provider.of<BookingProvider>(context, listen: false);

    return Row(children: [

      GestureDetector(
        onTap: ()=>RouterHelper.getUserDetailsRoute(bookingDetail:bookingProvider.bookingDetails! ),
        child: ClipOval(child: CustomImageWidget(
          image: '${bookingProvider.bookingDetails!.userImage}',
          width: 50, height: 50,
        )),
      ),
      const SizedBox(width: Dimensions.paddingSizeDefault),

      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('${ bookingProvider.bookingDetails!.userName} ', style: rubikRegular, maxLines: 2, overflow: TextOverflow.ellipsis),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

      ])),

      Center(child: Row(mainAxisAlignment: MainAxisAlignment.end, mainAxisSize: MainAxisSize.min, children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.5), offset: const Offset(0, 5),
              spreadRadius: 5, blurRadius: 15,
            )],
          ),
          child: InkWell(
            onTap: () {
              // RouterHelper.getChatRoute(orderId: orderProvider.trackModel?.id);
            },
            child: const CustomAssetImageWidget(Images.chat, width: 30, height: 30),
          ),
        ),
        const SizedBox(width: Dimensions.paddingSizeSmall),

        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.5), offset: const Offset(0, 5),
              spreadRadius: 5, blurRadius: 15,
            )],
          ),
          child: InkWell(
            onTap: () => launchUrl(Uri.parse('tel:'), mode: LaunchMode.externalApplication),

            child: const CustomAssetImageWidget(Images.callIcon, width: 30, height: 30),
          ),
        ),
      ])),

    ]);
  }
}