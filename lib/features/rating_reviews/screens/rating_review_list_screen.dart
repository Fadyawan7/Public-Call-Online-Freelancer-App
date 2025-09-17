
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_pop_scope_widget.dart';
import 'package:flutter_restaurant/common/widgets/no_data_widget.dart';
import 'package:flutter_restaurant/common/widgets/rate_review_widget.dart';
import 'package:flutter_restaurant/features/freelancer_portfolio/widgets/booking_shimmer_widget.dart';
import 'package:flutter_restaurant/features/rating_reviews/providers/review_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';

import 'package:provider/provider.dart';

class RateReviewListScreen extends StatefulWidget {
  final int freelancerId;
  const RateReviewListScreen({super.key, required this.freelancerId});

  @override
  State<RateReviewListScreen>  createState() => _RateReviewListScreenState();
}

class _RateReviewListScreenState extends State<RateReviewListScreen> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Provider.of<ReviewProvider>(context, listen: false).getFreelancerReviewList(widget.freelancerId);
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopScopeWidget(
      child: Scaffold(
        appBar:  CustomAppBarWidget(
          title: getTranslated('rate_review', context), centerTitle: true,
          titleColor: Colors.white,
        ),
        body: SafeArea(
          child: Consumer<ReviewProvider>(
            builder: (context, reviewProvider, child) {
              return !reviewProvider.isLoading
                  ? reviewProvider.reviewList!.isNotEmpty
                  ? RefreshIndicator(
                onRefresh: () async {
                  await Provider.of<ReviewProvider>(context, listen: false)
                      .getFreelancerReviewList(widget.freelancerId);
                },
                backgroundColor: Theme.of(context).primaryColor,
                color: Theme.of(context).cardColor,
                child: ListView.builder(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  itemCount: reviewProvider.reviewList!.length,
                  physics: const AlwaysScrollableScrollPhysics(), // Enable scrolling
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Center(
                      child: SizedBox(
                        width: Dimensions.webScreenWidth,
                        child: RateReviewWidget(
                          rating: reviewProvider.reviewList![index].rating,
                          comment: reviewProvider.reviewList![index].comment,
                          userImage: reviewProvider.reviewList![index].giverImage,
                          userName: reviewProvider.reviewList![index].giverName,
                          reviewDate: reviewProvider.reviewList![index].createdAt,
                        ),
                      ),
                    );
                  },
                ),
              )
                  : const Center(child: NoDataWidget(isOrder: true))
                  : const BookingShimmerWidget();
            },
          ),
        ),
      ),
    );

  }

}
