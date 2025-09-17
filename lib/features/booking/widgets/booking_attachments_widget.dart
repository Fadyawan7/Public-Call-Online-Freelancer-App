import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/features/booking/providers/booking_provider.dart';
import 'package:flutter_restaurant/features/chat/widgets/image_diaglog_widget.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';


class BookingAttachmentsWidget extends StatelessWidget {
  const BookingAttachmentsWidget({
    super.key,
    required this.bookingProvider,
    required this.splashProvider,
  });

  final BookingProvider bookingProvider;
  final SplashProvider splashProvider;

  @override
  Widget build(BuildContext context) {

    return Column(
        children: [
      GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2 ,
        crossAxisSpacing: Dimensions.paddingSizeExtraSmall,
        mainAxisSpacing: Dimensions.paddingSizeExtraSmall,
        childAspectRatio: (bookingProvider.bookingDetails!.attachments!.length ?? 0) == 2 ? 0.8 : 1,
      ),
      itemCount: min((bookingProvider.bookingDetails!.attachments!.length ?? 0), 4),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () => showDialog(context: context, builder: (ctx)  =>  ImageDialogWidget(imageUrl:'${bookingProvider.bookingDetails!.attachmentUrl}/${bookingProvider.bookingDetails!.attachments![index]}'), ),

          child: ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            child: CustomImageWidget(
              image: '${bookingProvider.bookingDetails!.attachmentUrl}/${bookingProvider.bookingDetails!.attachments![index]}',
              height: 30, width: 30,
            ),
          ),
        );
      } ,
    )
        ]);
  }
}