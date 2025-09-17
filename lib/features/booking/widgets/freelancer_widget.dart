import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/booking_details_model.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/features/booking/providers/booking_provider.dart';
import 'package:flutter_restaurant/features/chat/providers/chat_provider.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class FreelancerWidget extends StatelessWidget {
  final BookingDetailsModel bookingDetailsModel;
  final bool isFreelancer;
  const FreelancerWidget({
    super.key,
    required this.bookingDetailsModel,
    required this.isFreelancer,
  });

  @override
  Widget build(BuildContext context) {
    final BookingProvider bookingProvider =
        Provider.of<BookingProvider>(context, listen: false);
    return Row(children: [
      GestureDetector(
        onTap: isFreelancer
            ? () => RouterHelper.getUserDetailsRoute(
                bookingDetail: bookingProvider.bookingDetails!)
            : null,
        child: ClipOval(
            child: CustomImageWidget(
          image:
              '${isFreelancer ? bookingProvider.bookingDetails!.userImage : bookingProvider.bookingDetails!.userImage}',
          width: 50,
          height: 50,
        )),
      ),
      const SizedBox(width: Dimensions.paddingSizeDefault),
      Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
            '${isFreelancer ? bookingProvider.bookingDetails!.userName : bookingProvider.bookingDetails!.freelancerName} ',
            style: rubikRegular,
            maxLines: 2,
            overflow: TextOverflow.ellipsis),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
      ])),
      Center(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.5),
                    offset: const Offset(0, 5),
                    spreadRadius: 5,
                    blurRadius: 15,
                  )
                ],
              ),
              child: Consumer<ChatProvider>(
                builder: (context, chatProvider, child) {
                  return InkWell(
                    onTap: () async {
                      await chatProvider.startNewChat(isFreelancer
                          ? bookingProvider.bookingDetails!.userId!
                          : bookingProvider.bookingDetails!.freelancerId!);
                      RouterHelper.getConversationScreen(
                          chat: chatProvider.newChat);
                    },
                    child: const CustomAssetImageWidget(Images.chat,
                        width: 30, height: 30),
                  );
                },
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.5),
                    offset: const Offset(0, 5),
                    spreadRadius: 5,
                    blurRadius: 15,
                  )
                ],
              ),
              child: InkWell(
                onTap: () => launchUrl(Uri.parse('tel:'),
                    mode: LaunchMode.externalApplication),
                child: const CustomAssetImageWidget(Images.callIcon,
                    width: 30, height: 30),
              ),
            ),
          ])),
    ]);
  }
}
