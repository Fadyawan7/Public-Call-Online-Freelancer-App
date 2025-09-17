import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_outlined_button_widget.dart';
import 'package:flutter_restaurant/common/widgets/list_tile_widget.dart';
import 'package:flutter_restaurant/common/widgets/rate_review_widget.dart';
import 'package:flutter_restaurant/features/chat/providers/chat_provider.dart';
import 'package:flutter_restaurant/features/freelancer/domain/models/freelancer_model.dart';
import 'package:flutter_restaurant/features/freelancer/widgets/freelancer_basic_widget.dart';
import 'package:flutter_restaurant/features/freelancer/widgets/freelancer_portfolio_widget.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';

class FreelancerDetailsBottomSheet extends StatefulWidget {
  final FreelancerModel freelancer;

  const FreelancerDetailsBottomSheet({
    super.key,
    required this.freelancer,
  });

  @override
  State<FreelancerDetailsBottomSheet> createState() =>
      _FreelancerDetailsBottomSheetState();
}

class _FreelancerDetailsBottomSheetState
    extends State<FreelancerDetailsBottomSheet> with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    _tabController = TabController(length: 2, initialIndex: 1, vsync: this);
    _tabController.addListener(() {
      _selectedIndex = _tabController.index;
      if (mounted) {
        setState(() {});
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding:
          const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FreelancerBasicInfo(freelancer: widget.freelancer),
                SizedBox(
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: Dimensions.paddingSizeDefault,
                    ),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        final buttonList = [
                          CustomOutlinedButton(
                            label: "Book Now",
                            icon: Iconsax.add,
                            onPressed: () => {
                              RouterHelper.getBookingDateSlotRoute(
                                widget.freelancer.id.toString(),
                              ),
                              Navigator.of(context).pop()
                            },
                          ),
                          CustomOutlinedButton(
                            label: "Direction",
                            icon: Icons.directions,
                            onPressed: () async {
                              // Close the current dialog/popup
                              Navigator.of(context).pop();

                              // Open Google Maps with directions
                              final lat = widget.freelancer.latitude;
                              final lng = widget.freelancer.longitude;

                              if (lat == null || lng == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Location not available")),
                                );
                                return;
                              }

                              final url =
                                  'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving';

                              try {
                                if (await canLaunchUrl(Uri.parse(url))) {
                                  await launchUrl(Uri.parse(url));
                                } else {
                                  throw 'Could not launch $url';
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          "Could not open maps: ${e.toString()}")),
                                );
                              }
                            },
                          ),
                          CustomOutlinedButton(
                            label: "Call",
                            icon: Icons.phone,
                            onPressed: () => {
                              RouterHelper.getBookingDateSlotRoute(
                                widget.freelancer.id.toString(),
                              ),
                              Navigator.of(context).pop()
                            },
                          ),
                          Consumer<ChatProvider>(
                            builder: (context, chatProvider, child) {
                              return CustomOutlinedButton(
                                label: "Chat",
                                icon: Icons.chat,
                                onPressed: () async {
                                  await chatProvider
                                      .startNewChat(widget.freelancer.id!);
                                  RouterHelper.getConversationScreen(
                                      chat: chatProvider.newChat);
                                  Navigator.of(context).pop();
                                },
                              );
                            },
                          ),
                          CustomOutlinedButton(
                            label: "Whatsapp",
                            icon: Icons.phone_android_outlined,
                            onPressed: () => _launchWhatsApp(
                                context, widget.freelancer.whatsapp),
                          ),
                        ];

                        return Row(
                          children: [
                            buttonList[index],
                            const SizedBox(
                                width: Dimensions.paddingSizeDefault),
                          ],
                        );
                      },
                    ),
                  ),
                ),

                TabBar(
                  padding: EdgeInsets.zero,
                  labelPadding: EdgeInsets.zero,
                  dividerHeight: 0.1,
                  dividerColor: Theme.of(context).dividerColor.withOpacity(0.6),
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2.0,
                    ),
                  ),
                  controller: _tabController,
                  tabs: const <Widget>[
                    Tab(text: 'Reviews'),
                    Tab(text: 'About'),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2.9,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      SingleChildScrollView(
                        child: widget.freelancer.reviews!.isNotEmpty
                            ? Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(
                                      height: Dimensions.paddingSizeSmall),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: Dimensions.paddingSizeDefault,
                                      vertical: Dimensions.paddingSizeSmall,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Rate & review',
                                          style: rubikBold.copyWith(
                                            fontSize:
                                                Dimensions.paddingSizeDefault,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () => RouterHelper
                                              .getRateReviewListRoute(
                                            widget.freelancer.id.toString(),
                                          ),
                                          style: TextButton.styleFrom(
                                            minimumSize: Size.zero,
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap,
                                            padding: EdgeInsets.zero,
                                            foregroundColor: Colors.transparent,
                                          ),
                                          child: Text(
                                            getTranslated('view_all', context)!,
                                            style: rubikMedium.copyWith(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ListView.builder(
                                    key: PageStorageKey(widget.freelancer.id),
                                    shrinkWrap: true,
                                    itemCount:
                                        widget.freelancer.reviews!.length,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return RateReviewWidget(
                                        rating: widget
                                            .freelancer.reviews![index].rating,
                                        comment: widget
                                            .freelancer.reviews![index].comment,
                                        userImage: widget.freelancer
                                            .reviews![index].giverImage,
                                        userName: widget.freelancer
                                            .reviews![index].giverName,
                                        reviewDate: widget.freelancer
                                            .reviews![index].createdAt,
                                      );
                                    },
                                  ),
                                ],
                              )
                            : Center(
                                child: Text('No Reviews'),
                              ),
                      ),
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeSmall,
                                vertical: Dimensions.paddingSizeSmall,
                              ),
                              child: ReadMoreText(
                                '${widget.freelancer.about}',
                                trimMode: TrimMode.Line,
                                trimLines: 4,
                                trimLength: 200,
                                moreStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).primaryColor,
                                ),
                                lessStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).primaryColor,
                                ),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: Dimensions.fontSizeLarge,
                                  fontWeight: FontWeight.w500,
                                ),
                                trimCollapsedText: '...Show more',
                                trimExpandedText: ' show less',
                              ),
                            ),
                            Divider(
                              indent: Dimensions.paddingSizeDefault,
                              color:
                                  Theme.of(context).hintColor.withOpacity(0.1),
                            ),
                            ListTileWidget(
                              iconData: Icons.email_outlined,
                              mainTxt: 'Email',
                              subTxt: '${widget.freelancer.email}',
                            ),
                            Divider(
                              indent: Dimensions.paddingSizeDefault,
                              color:
                                  Theme.of(context).hintColor.withOpacity(0.1),
                            ),
                            ListTileWidget(
                              iconData: Icons.phone,
                              mainTxt: 'Contact',
                              subTxt: '${widget.freelancer.phone}',
                            ),
                            Divider(
                              indent: Dimensions.paddingSizeDefault,
                              color:
                                  Theme.of(context).hintColor.withOpacity(0.1),
                            ),
                            ListTileWidget(
                              iconData: Iconsax.global,
                              mainTxt: 'Country',
                              subTxt: '${widget.freelancer.country}',
                            ),
                            Divider(
                              indent: Dimensions.paddingSizeDefault,
                              color:
                                  Theme.of(context).hintColor.withOpacity(0.1),
                            ),
                            ListTileWidget(
                              iconData: Iconsax.calendar,
                              mainTxt: 'Member Since',
                              subTxt: '${widget.freelancer.memberSince}',
                            ),
                            Divider(
                              indent: Dimensions.paddingSizeDefault,
                              color:
                                  Theme.of(context).hintColor.withOpacity(0.1),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                //Freelancer Portfolio Widget
                if (widget.freelancer.portfolio!.isNotEmpty)
                  FreelancerPortfolioWidget(freelancer: widget.freelancer),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _launchWhatsApp(
    BuildContext context, String? whatsappNumber) async {
  // Close any open dialogs first
  Navigator.of(context).pop();

  // Phone number with country code (remove all non-digit characters)
  final whatsappUrl = Uri.parse(Platform.isAndroid
          ? "https://wa.me/$whatsappNumber" // Android URL format
          : "https://api.whatsapp.com/send?phone=$whatsappNumber" // iOS URL format
      );

  try {
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch WhatsApp')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error launching WhatsApp: ${e.toString()}')),
    );
  }
}
