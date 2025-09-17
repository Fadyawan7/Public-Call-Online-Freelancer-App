import 'dart:core';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/no_data_widget.dart';
import 'package:flutter_restaurant/common/widgets/rate_review_widget.dart';
import 'package:flutter_restaurant/features/booking/providers/booking_provider.dart';
import 'package:flutter_restaurant/features/booking/widgets/booking_details_shimmer_widget.dart';
import 'package:flutter_restaurant/features/booking/widgets/button_widget.dart';
import 'package:flutter_restaurant/features/freelancer_booking/widgets/freelancer_booking_details_widget.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class FreelancerBookingDetailsScreen extends StatefulWidget {
  final int? bookingId;
  const FreelancerBookingDetailsScreen({super.key, required this.bookingId});

  @override
  State<FreelancerBookingDetailsScreen> createState() => _FreelancerBookingDetailsScreenState();
}

class _FreelancerBookingDetailsScreenState extends State<FreelancerBookingDetailsScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffold = GlobalKey();

  @override
  void initState() {
    super.initState();
    Provider.of<BookingProvider>(context, listen: false).getBookingDetails(widget.bookingId.toString());

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      appBar: AppBar(
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text('Booking Detail', style: rubikSemiBold.copyWith(
            color: Theme.of(context).textTheme.bodyLarge!.color,
          )),
          const SizedBox(height: Dimensions.paddingSizeSmall),


        ]),
        backgroundColor: Theme.of(context).cardColor,
        leading: IconButton(
          onPressed: () => context.pop(),
          color: Theme.of(context).primaryColor,
          highlightColor: Colors.transparent,
          icon: const Icon(Icons.arrow_back_ios),
        ),
        elevation: 0,
        centerTitle: true,
      ),

      body: Column(
          children: [
        Expanded(child: CustomScrollView(slivers: [
          SliverToBoxAdapter(child:
          Consumer<BookingProvider>(
            builder: (context, booking, child) {

              return booking.bookingDetails == null  ?
              BookingDetailsShimmerWidget(enabled: !booking.isLoading && booking.bookingDetails == null ) :
              (booking.bookingDetails != null ?? false) ?
               Column(

                   children: [
                const FreelancerBookingDetailsWidget(),
                Divider(
                  indent: Dimensions.paddingSizeDefault,
                  color: Theme.of(context).hintColor.withOpacity(0.1),
                ),

                  if(booking.bookingDetails!.reviews!.isNotEmpty)
                  Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(getTranslated('Booking Review', context)!, style: rubikBold),
                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: booking.bookingDetails!.reviews!.length,
                        itemBuilder: (context, index) {
                          return RateReviewWidget(
                            rating: booking.bookingDetails!.reviews![index].rating,
                            comment: booking.bookingDetails!.reviews![index].comment,
                            userImage: booking.bookingDetails!.reviews![index].giverImage,
                            userName: booking.bookingDetails!.reviews![index].giverName,
                            reviewDate: booking.bookingDetails!.reviews![index].createdAt,

                          );
                        },
                      ),
                    ],
                  ),
                ),

              ]) : const Center(child: NoDataWidget(isFooter: false));
            },
          )),
        ])),

       const ButtonWidget(),



      ]),
    );
  }

}




