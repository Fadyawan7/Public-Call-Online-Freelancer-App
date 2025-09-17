import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_restaurant/features/freelancer/domain/models/freelancer_model.dart';
import 'package:flutter_restaurant/features/freelancer/providers/freelancer_provider.dart';
import 'package:flutter_restaurant/features/freelancer/widgets/freelancer_portfolio_widget.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class FreelancerPosts extends StatefulWidget {
  const FreelancerPosts({super.key});

  @override
  State<FreelancerPosts> createState() => _FreelancerPostsState();
}

class _FreelancerPostsState extends State<FreelancerPosts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBarWidget(
          isBackButtonExist: false,
          titleColor: Colors.white,
          context: context,
          title: getTranslated('Freelancer Posts', context),
        ),
        body: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),

                // Freelancer Portfolio Widget
                Consumer<FreelancerProvider>(
                  builder: (context, freelancerProvider, child) {
                    final freelancerList =
                        freelancerProvider.freelancerList ?? [];

                    return Column(
                      children: freelancerList.map((freelancer) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: FreelancerPostsWidget(freelancer: freelancer),
                        );
                      }).toList(),
                    );
                  },
                ),

                const SizedBox(height: 15),
              ],
            ),
          ),
        ));
  }
}

class FreelancerPostsWidget extends StatefulWidget {
  const FreelancerPostsWidget({
    super.key,
    required this.freelancer,
  });

  final FreelancerModel freelancer;

  @override
  State<FreelancerPostsWidget> createState() => _FreelancerPostsWidgetState();
}

class _FreelancerPostsWidgetState extends State<FreelancerPostsWidget> {
  final SplashProvider splashProvider =
      Provider.of<SplashProvider>(Get.context!, listen: false);

  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final portfolio = widget.freelancer.portfolio ?? [];

    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        border:
            Border.all(color: Theme.of(context).primaryColor.withOpacity(0.5)),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 5,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeDefault,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorResources.borderColor,
                    border: Border.all(
                      color: Colors.white54,
                      width: 3,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(80),
                    child: CustomImageWidget(
                      placeholder: Images.placeholderUser,
                      width: 60,
                      height: 60,
                      fit: BoxFit.contain,
                      image: '${widget.freelancer.image}',
                    ),
                  ),
                ),
                //Freelancer Basic Widget
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: Dimensions.paddingSizeDefault),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.4,
                        child: Text(
                          getTranslated(widget.freelancer.name, context)!,
                          style: rubikSemiBold.copyWith(
                              color: ColorResources.black),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.5,
                        child: Text(
                          maxLines: 2,
                          softWrap: true,
                          getTranslated(widget.freelancer.about, context)!,
                          style: rubikSemiBold.copyWith(
                            fontSize: 12,
                            color: ColorResources.getHintColor(context),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 300,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: portfolio.length,
                  onPageChanged: (index) {
                    setState(() => _currentIndex = index);
                  },
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: CustomImageWidget(
                        containerHeight: 300,
                        containerWidth: MediaQuery.sizeOf(context).width,
                        fit: BoxFit.cover,
                        placeholder: Images.placeholderUser,
                        image:  portfolio[index].imageUrl,
                      ),
                    );
                  },
                ),
                if (portfolio.length > 1)
                  Positioned(
                    right: 10,
                    top: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_currentIndex + 1}/${portfolio.length}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                if (portfolio.length > 1)
                  Positioned(
                    bottom: 5,
                    right: 0,
                    left: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          portfolio.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            height: 6,
                            width: _currentIndex == index ? 16 : 6,
                            decoration: BoxDecoration(
                              color: _currentIndex == index
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.7),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
