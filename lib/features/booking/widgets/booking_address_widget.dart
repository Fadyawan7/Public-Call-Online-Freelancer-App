import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/features/booking/providers/booking_provider.dart';
import 'package:flutter_restaurant/features/menu/widgets/booking_info_item_widget.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/helper/get_direction_googlemap_widget.dart';
import 'package:flutter_restaurant/localization/app_localization.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingAddressInfoWidget extends StatelessWidget {

  const BookingAddressInfoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        child:Center(child:
        Consumer<BookingProvider>(
          builder: (context,bookingProvider,child){
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Iconsax.house,size:Dimensions.fontSizeExtraLarge),
                    Text(bookingProvider.bookingDetails!.deliveryAddress!.address ?? 'N/A',style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: Dimensions.fontSizeDefault
                    ),),
                  ],
                ),


                Divider(
                  indent: Dimensions.paddingSizeDefault,
                  color: Theme.of(context).hintColor.withOpacity(0.1),
                ),
                if ((bookingProvider.bookingDetails?.status == 'completed' ||
                    bookingProvider.bookingDetails?.status == 'confirmed') &&
                    (Provider.of<ProfileProvider>(context, listen: false).isFreelancer ?? false))
                  ...[
                    Center(
                      child: Container(
                        width: width > 700 ? 700 : width/2,
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: CustomButtonWidget(
                          height: Dimensions.paddingSizeLarge*2,
                          iconData: Icons.directions,
                          btnTxt: 'Get Direction',
                          onTap: () async {
                            double latitude = double.parse(bookingProvider.bookingDetails!.deliveryAddress!.latitude!); // Example: San Francisco latitude
                            double longitude = double.parse(bookingProvider.bookingDetails!.deliveryAddress!.longitude!); // Example: San Francisco longitude
                            try {
                              await openMap(latitude, longitude);
                            } catch (e) {
                              if (e is PlatformException) {
                                throw 'Failed to open the map. Please make sure Google Maps is installed.';
                              } else {
                                throw 'An unexpected error occurred: $e';
                              }                        }
                          },
                        ),
                      ),
                    ),
                  ]
              ],
            );
          },
        )
        )

    );
  }
}

