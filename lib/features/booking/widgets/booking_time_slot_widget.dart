import 'package:flutter/material.dart';
import 'package:flutter_restaurant/features/booking/providers/booking_provider.dart';
import 'package:flutter_restaurant/features/freelancer/widgets/time_zone_widget.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class BookingTimeSlotWidget extends StatelessWidget {
  const BookingTimeSlotWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all( Dimensions.paddingSizeSmall),
        child: Container(
          height: 110,
          padding: const EdgeInsets.symmetric(
              vertical: Dimensions.paddingSizeDefault,
              horizontal: Dimensions.paddingSizeDefault/2),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300]!,
                blurRadius:8,
                spreadRadius: 0.1,
              )
            ],
          ),
          child: Column(
            children: [
              Consumer<BookingProvider>(
                  builder:(context,bookingProvider,child){
                    return Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding:const EdgeInsets.fromLTRB(
                                6, 0, 6, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${getTranslated('choose_your_time', context)}',
                                  textAlign: TextAlign.start,
                                  style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Colors.black),

                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                    height: 40,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall/2),
                                      itemCount: bookingProvider.availableTimes.length,
                                      itemBuilder: (context, index) {
                                        return TimeZoneWidget(
                                          title:bookingProvider.availableTimes[index],
                                          isSelected: bookingProvider.selectTimeSlot== index ? true : false,
                                          onTap: () => {
                                            bookingProvider.updateTimeSlot(index, bookingProvider.availableTimes[index]),
                                          },
                                        );
                                      },
                                    )
                                  // : const Center(child: CircularProgressIndicator()),
                                ),

                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }
              ),

            ],
          ),
        ));
  }
}
