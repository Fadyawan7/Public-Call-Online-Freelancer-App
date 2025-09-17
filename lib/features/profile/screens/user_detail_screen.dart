import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/booking_details_model.dart';
import 'package:flutter_restaurant/common/widgets/no_data_widget.dart';
import 'package:flutter_restaurant/common/widgets/rate_review_widget.dart';
import 'package:flutter_restaurant/features/booking/widgets/user_detail_widget.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class UserDetailsScreen extends StatefulWidget {
  final BookingDetailsModel bookingDetailsModel;

  const UserDetailsScreen({super.key, required this.bookingDetailsModel, });

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffold = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final filteredReviews = widget.bookingDetailsModel.reviews
        ?.where((review) => review.takerId != Provider.of<ProfileProvider>(context).loggedInUserId)
        .toList() ?? [];
    return Scaffold(
      key: _scaffold,
      appBar: AppBar(

        title: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text('User Detail', style: rubikSemiBold.copyWith(
            color: Theme.of(context).cardColor,
          )),
          const SizedBox(height: Dimensions.paddingSizeSmall),


        ]),
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          onPressed: () => context.pop(),
          color: Theme.of(context).cardColor,
          highlightColor: Colors.transparent,
          icon: const Icon(Icons.arrow_back_ios),
        ),
        elevation: 0,
        centerTitle: true,
      ),

      body: Column(
          children: [
            Expanded(child: CustomScrollView(slivers: [
              SliverToBoxAdapter(child:Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      const SizedBox(height:Dimensions.paddingSizeDefault),
                      UserDetailWidget(bookingDetailsModel: widget.bookingDetailsModel,),


                      const SizedBox(height:Dimensions.paddingSizeLarge),
                      Divider(
                        indent: Dimensions.paddingSizeDefault,
                        color: Theme.of(context).hintColor.withOpacity(0.1),
                      ),
                      Text(getTranslated('User Review', context)!, style: const TextStyle(fontSize: Dimensions.fontSizeLarge,fontWeight: FontWeight.bold)),

                      filteredReviews.isNotEmpty ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              const SizedBox(height: Dimensions.paddingSizeDefault),

                              ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: filteredReviews.length,
                                itemBuilder: (context, index) {
                                  final review = filteredReviews[index];

                                  return RateReviewWidget(
                                    rating: review.rating,
                                    comment:review.comment,
                                    userImage: review.giverImage,
                                    userName: review.giverName,
                                    reviewDate: review.createdAt,

                                  );
                                },
                              ),
                            ],
                          ),
                        ) : const NoDataWidget(isOrder: true,),

                    ]),
              )
              ),
            ])),

          ]),
    );
  }

}




