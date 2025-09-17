import 'package:flutter/material.dart';
import 'package:flutter_restaurant/features/booking/providers/booking_provider.dart';
import 'package:flutter_restaurant/features/freelancer/widgets/date_widget.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class BookingDateSlotWidget extends StatelessWidget {
  const BookingDateSlotWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all( Dimensions.paddingSizeSmall),
        child: Container(
          height: 150,
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
              Row(
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
                            '${getTranslated('choose_your_date', context)}',
                            textAlign: TextAlign.start,
                            style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Colors.black),

                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                              height: 70,
                              child: Consumer<BookingProvider>(
                                builder: (context,bookingProvider,child){
                                  return ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall/2),
                                    itemCount: bookingProvider.days.length,
                                    itemBuilder: (context, index) {
                                      return DateWidget(
                                        date: bookingProvider.days[index].formattedDate.toUpperCase(),
                                        title:bookingProvider.days[index].day.toString(),
                                        isSelected: bookingProvider.selectDateSlot== index ? true : false,
                                        onTap: () => {
                                          bookingProvider.updateDateSlot(index, bookingProvider.days[index].date.toString()),
                                          bookingProvider.checkAvailableTimes(bookingProvider.days[index].date.toString())
                                        },
                                      );
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
              ),

            ],
          ),
        ));
  }
}
