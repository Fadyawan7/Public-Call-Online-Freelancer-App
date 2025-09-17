import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/no_data_widget.dart';
import 'package:flutter_restaurant/features/booking/domain/models/booking_model.dart';
import 'package:flutter_restaurant/features/booking/providers/booking_provider.dart';
import 'package:flutter_restaurant/features/booking/widgets/booking_item_widget.dart';
import 'package:flutter_restaurant/features/booking/widgets/booking_shimmer_widget.dart';
import 'package:flutter_restaurant/helper/date_converter_helper.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:provider/provider.dart';

class BookingListWidget extends StatefulWidget {
  final String? status;
  const BookingListWidget({super.key, required this.status});


  @override
  State<BookingListWidget> createState() => _BookingListWidgetState();
}

class _BookingListWidgetState extends State<BookingListWidget> {
  @override
  void initState() {
    super.initState();
    Provider.of<BookingProvider>(context, listen: false).getBookingList(context,widget.status);
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, booking, index) {
        List<BookingModel>? bookingList =[];
        if(booking.runningOrderList != null) {
          bookingList = booking.runningOrderList ;
        }

        return !booking.isLoading ? bookingList!.isNotEmpty ? RefreshIndicator(
          onRefresh: () async {
            await Provider.of<BookingProvider>(context, listen: false).getBookingList(context,widget.status);
          },
          backgroundColor: Theme.of(context).primaryColor,
          color: Theme.of(context).cardColor,
          child: SingleChildScrollView(
            child: Column(children: [
              Center(
                child: SizedBox(
                  width: Dimensions.webScreenWidth,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    itemCount: bookingList.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return BookingItemWidget(bookingProvider: booking, status: widget.status!, bookingItem: bookingList![index]);
                    },
                  ),
                ),
              ),
            ]),
          ),
        ) : const Center(child: NoDataWidget(isOrder: true)) : const BookingShimmerWidget();
      },
    );
  }
}
