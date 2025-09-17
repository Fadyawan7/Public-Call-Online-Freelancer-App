
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/booking_details_model.dart';
import 'package:flutter_restaurant/features/booking/domain/models/booking_model.dart';
import 'package:flutter_restaurant/features/booking/providers/booking_provider.dart';
import 'package:flutter_restaurant/features/rating_reviews/providers/review_provider.dart';
import 'package:flutter_restaurant/features/rating_reviews/widgets/booking_review_widget.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';

import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/common/widgets/custom_app_bar_widget.dart';

import 'package:provider/provider.dart';

class SubmitRateReviewScreen extends StatefulWidget {
  final int bookingId;
  final int takerId;

  const SubmitRateReviewScreen({super.key, required this.bookingId, required this.takerId});

  @override
  State<SubmitRateReviewScreen>  createState() => _SubmitRateReviewScreenState();
}

class _SubmitRateReviewScreenState extends State<SubmitRateReviewScreen> with TickerProviderStateMixin {
  BookingModel? bookingModel;
  List<BookingDetailsModel> bookingDetailsList = [];


  Future<void> _initLoading() async {
    final ReviewProvider reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
    reviewProvider.updateSubmitted(false);
  }


  @override
  void initState() {
    super.initState();
    _initLoading();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ( CustomAppBarWidget(context: context, title: getTranslated('rate_review', context), titleColor: Colors.white,)) as PreferredSizeWidget?,

      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),

        child: Consumer<BookingProvider>(builder: (context, booking, _) {
          return Column(children: [
            Center(child: Container( color: Theme.of(context).cardColor,
                child: BookingReviewWidget( bookingID: widget.bookingId,takerID:widget.takerId ,),
        
            )),
        
        
          ]);
        }),
      ),
    );
  }
}
