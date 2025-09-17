import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/no_data_widget.dart';
import 'package:flutter_restaurant/features/freelancer_portfolio/domain/models/freelancer_portfolio_model.dart';
import 'package:flutter_restaurant/features/freelancer_portfolio/providers/freelancer_portfolio_provider.dart';
import 'package:flutter_restaurant/features/freelancer_portfolio/widgets/booking_shimmer_widget.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class FreelancerPortfolioScreen extends StatefulWidget {
  const FreelancerPortfolioScreen({super.key});

  @override
  State<FreelancerPortfolioScreen> createState() =>
      _FreelancerPortfolioScreenState();
}

class _FreelancerPortfolioScreenState extends State<FreelancerPortfolioScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    Provider.of<FreelancerPortfolioProvider>(context, listen: false)
        .getFreelancerPortfolioList();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (CustomAppBarWidget(
        titleColor: Colors.white,
        context: context,
        title: getTranslated('my_portfolio', context),
        actionView: IconButton(
          icon: const Icon(Iconsax.add_circle, color: Colors.white),
          onPressed: () => {RouterHelper.getFreelancerPortfolioAddRoute()},
        ),
      )),
      body: Consumer<FreelancerPortfolioProvider>(
        builder: (context, freelancerPortfolio, child) {
          List<FreelancerPortfolioModel>? freelancerPortfolioList = [];
          if (freelancerPortfolio.freelancerPortfolioList != null) {
            freelancerPortfolioList =
                freelancerPortfolio.freelancerPortfolioList;
          }
          return !freelancerPortfolio.isLoading
              ? freelancerPortfolioList!.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: [
                        GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 0.7,
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: freelancerPortfolioList.length,
                            itemBuilder: (BuildContext context, index) {
                              String? imageUrl =
                                  '${freelancerPortfolioList![index].imageUrl}';
                              return Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Theme.of(context).hintColor,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                          ),
                                          child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(Dimensions
                                                          .paddingSizeSmall)),
                                              child: CustomImageWidget(
                                                placeholder:
                                                    Images.placeholderUser,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2.3,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2.3,
                                                fit: BoxFit.contain,
                                                image: imageUrl ?? '',
                                              )),
                                        ),
                                        const SizedBox(
                                            height:
                                                Dimensions.paddingSizeDefault),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 3),
                                          child: Text(
                                            getTranslated(
                                                'Service Title', context)!,
                                            style: rubikSemiBold.copyWith(
                                                color: ColorResources.black),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 3),
                                          child: Text(
                                            getTranslated(
                                                'Short Description', context)!,
                                            style: rubikSemiBold.copyWith(
                                                fontSize: 12,
                                                color:
                                                    ColorResources.getHintColor(
                                                        context)),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 5,
                                    right: 15,
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      onTap: () => {
                                        freelancerPortfolio
                                            .deleteFreelancerPortfolio(
                                                freelancerPortfolioList![index]
                                                    .id!,
                                                _callback)
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Theme.of(context)
                                                        .hintColor,
                                                    blurRadius: 1,
                                                    spreadRadius: 1,
                                                    offset: const Offset(0, 0))
                                              ],
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(Dimensions
                                                          .paddingSizeSmall))),
                                          child: const Padding(
                                            padding: EdgeInsets.all(2.0),
                                            child: Icon(
                                              Icons.delete_forever_rounded,
                                              color: Colors.red,
                                              size: 18,
                                            ),
                                          )),
                                    ),
                                  ),
                                ],
                              );
                            })
                      ]),
                    )
                  : const Center(child: NoDataWidget(isPortfolio: true))
              : const BookingShimmerWidget();
        },
      ),
    );
  }

  void _callback(String message, bool isSuccess) async {
    if (isSuccess) {
      showCustomSnackBarHelper(message, isError: false);
      Provider.of<FreelancerPortfolioProvider>(context, listen: false)
          .getFreelancerPortfolioList();
    } else {
      showCustomSnackBarHelper(message);
    }
  }
}
