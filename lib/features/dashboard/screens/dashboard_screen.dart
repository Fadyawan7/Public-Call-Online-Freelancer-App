import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_pop_scope_widget.dart';
import 'package:flutter_restaurant/common/widgets/third_party_chat_widget.dart';
import 'package:flutter_restaurant/features/address/providers/location_provider.dart';
import 'package:flutter_restaurant/features/chat/screens/chat_screen.dart';

import 'package:flutter_restaurant/features/dashboard/widgets/bottom_nav_item_widget.dart';
import 'package:flutter_restaurant/features/freelancer/screens/freelancer_screen.dart';
import 'package:flutter_restaurant/features/booking/screens/home_screen.dart';
import 'package:flutter_restaurant/features/menu/screens/menu_screen.dart';

import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/app_localization.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  final int pageIndex;
  const DashboardScreen({super.key, required this.pageIndex});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {
  PageController? _pageController;
  int _pageIndex = 1; // Set initial page index to 1
  late List<Widget> _screens;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _pageIndex = 1; // Set initial page index to 1

    final splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final LocationProvider locationProvider = Provider.of<LocationProvider>(context, listen: false);

    if(splashProvider.policyModel == null) {
      Provider.of<SplashProvider>(context, listen: false).getPolicyPage();
    }
    BookingScreen.loadData(false);
    locationProvider.checkPermission(()=> locationProvider.getCurrentLocation(context, false).then((currentAddress) {
      locationProvider.onChangeCurrentAddress(currentAddress);
    }), canBeIgnoreDialog: true);

    _pageController = PageController(initialPage: 1); // Set initial page to 1

    _screens = [
      const BookingScreen(),
      const FreelancerScreen(),
      const ChatScreen(),

      MenuScreen(onTap: (int pageIndex) {
        _setPage(pageIndex);
      }),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

    return CustomPopScopeWidget(
        isExit: _pageIndex == 0,
        onPopInvoked: () async {
          if (_pageIndex != 0) {
            _setPage(0);
          }
        },
        child: Scaffold(
          key: _scaffoldKey,
          // floatingActionButton: !ResponsiveHelper.isDesktop(context) && _pageIndex == 0
          //     ? Container(margin: const EdgeInsets.only(bottom: 80), child: const ThirdPartyChatWidget()) : null,
          body: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: defaultTargetPlatform == TargetPlatform.iOS ? 80 : 65),
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _screens.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return _screens[index];
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Consumer<SplashProvider>(
                    builder: (ctx, splashController, _) {

                      return Container(
                        width: size.width,
                        height: defaultTargetPlatform == TargetPlatform.iOS ? 80 : 65,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusLarge)),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5)],
                        ),
                        child: Center(
                          child: SizedBox(
                            width: size.width, height: 80,
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                              BottomNavItemWidget(
                                title: getTranslated('booking', context)!,
                                icon: Icons.calendar_month,
                                isSelected: _pageIndex == 0,
                                onTap: () => _setPage(0),
                              ),

                              BottomNavItemWidget(
                                title: getTranslated('freelancer', context)!.toCapitalized(),
                                icon: Icons.map_outlined,
                                isSelected: _pageIndex == 1,
                                onTap: () => _setPage(1),
                              ),


                              BottomNavItemWidget(
                                title: getTranslated('chat', context)!,
                                icon: Icons.chat_bubble_outline,
                                isSelected: _pageIndex == 2,
                                onTap: () => _setPage(2),
                              ),

                              BottomNavItemWidget(
                                title: getTranslated('menu', context)!,
                                icon: Icons.menu,
                                isSelected: _pageIndex == 3,
                                onTap: () => _setPage(3),
                              ),
                            ]),
                          ),
                        ),
                      );
                    }
                ),
              ),

            ],
          ),
        ));
  }

  void _setPage(int pageIndex) {
    print('====HELooo====');
    _pageController?.jumpToPage(pageIndex);
    setState(() {
      _pageIndex = pageIndex;
    });
  }
}