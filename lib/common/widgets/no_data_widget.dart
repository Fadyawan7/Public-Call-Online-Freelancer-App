import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/features/address/domain/models/address_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';

class NoDataWidget extends StatelessWidget {
  final bool isOrder;
  final bool isChat;
  final bool isNothing;
  final bool isFooter;
  final bool isAddress;
  final bool isPortfolio;
  final bool isNotification;

  const NoDataWidget({
    super.key,
    this.isChat = false,
    this.isNothing = false,
    this.isOrder = false,
    this.isFooter = true,
    this.isAddress = false,
    this.isPortfolio = false,
    this.isNotification = false,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Center(
      child: SingleChildScrollView(physics: const BouncingScrollPhysics(), child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [

        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: !ResponsiveHelper.isDesktop(context) && height < 600 ? height : height - 450,
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                  SizedBox(
                    height: 110, width: 110,
                    child: CustomAssetImageWidget(
                       isOrder || isPortfolio ? Images.emptyBoxSvg : isChat ? Images.emptyBoxSvg
                          : isAddress ? Images.noAddressSvg :isNotification ? Images.notification : Images.noFoodImage ,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                  Text(
                    getTranslated(
                      isPortfolio? 'no_portfolio_history' : isOrder ? 'no_order_history' : isChat ? 'no_chat_history' : isNothing ? 'No Notification History'
                          : isAddress ? 'no_saved_address_found' : 'nothing_found', context,
                    )!,
                    style: rubikSemiBold.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeLarge),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Text(
                    getTranslated(
                      isOrder ? 'you_havent_made_any_purchase_yet' : isNotification ? 'No Notifications Found' : isPortfolio ? 'you_havent_add_any_portfolio_yet' : isChat ? 'you_havent_started_any_chat'
                          : isAddress ? 'please_add_your_address_for_your_better_experience' : '', context,
                    )!,
                    style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor), textAlign: TextAlign.center,
                  ),


                ]),
              ),
          ]),
        ),


      ])),
    );
  }
}
