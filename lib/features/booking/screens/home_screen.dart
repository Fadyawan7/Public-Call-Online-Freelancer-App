import 'package:flutter/material.dart';
import 'package:flutter_restaurant/features/category/providers/category_provider.dart';
import 'package:flutter_restaurant/features/booking/providers/booking_provider.dart';
import 'package:flutter_restaurant/features/booking/widgets/booking_list_widget.dart';
import 'package:flutter_restaurant/features/freelancer/providers/freelancer_provider.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_restaurant/common/widgets/not_logged_in_widget.dart';
import 'package:provider/provider.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
  static Future<void> loadData(bool reload, {bool isFcmUpdate = false}) async {
    final ProfileProvider profileProvider = Provider.of<ProfileProvider>(Get.context!, listen: false);
    final CategoryProvider categoryProvider = Provider.of<CategoryProvider>(Get.context!, listen: false);

    final isLogin = Provider.of<AuthProvider>(Get.context!, listen: false).isLoggedIn();

    if(isLogin){

      categoryProvider.getCategoryList();
      if(isFcmUpdate){
        Provider.of<AuthProvider>(Get.context!, listen: false).updateToken();
      }
    }else{
      profileProvider.setUserInfoModel = null;
    }
  }
}

class _BookingScreenState extends State<BookingScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  late bool _isLoggedIn;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, initialIndex: _selectedIndex, vsync: this);
    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();

    if(_isLoggedIn) {
      Provider.of<BookingProvider>(context, listen: false).getBookingList(context,'pending');
    }
    _tabController.addListener(() {
      _selectedIndex = _tabController.index;
      if(mounted){
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ( CustomAppBarWidget(
        titleColor: Colors.white,
        context: context,
        title: getTranslated('my_booking', context),
        isBackButtonExist: !ResponsiveHelper.isMobile(),
      )) as PreferredSizeWidget?,
      body: _isLoggedIn ? Consumer<BookingProvider>(
        builder: (context, order, child) {
          return Column(children: [

            Expanded(child: Center(child: SizedBox(width: Dimensions.webScreenWidth, child: Column(children: [
              Center(
                child: Container(
                  //width: 320,
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeLarge),
                  child: TabBar(
                    padding: EdgeInsets.zero,
                    labelPadding: EdgeInsets.zero,
                    controller: _tabController,
                    dividerHeight: 0,
                    indicator: const UnderlineTabIndicator(borderSide: BorderSide.none),
                    tabs: [
                      Tab(iconMargin: EdgeInsets.zero, child: Container(
                        height: double.maxFinite, width: double.maxFinite,
                        margin: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          color: _selectedIndex == 0 ? Theme.of(context).primaryColor : Theme.of(context).canvasColor,
                        ),
                        child: Center(child: Text(
                          getTranslated('Pending', context)!,
                          style: rubikRegular.copyWith(
                            color: _selectedIndex == 0 ? Theme.of(context).cardColor : Theme.of(context).primaryColor,
                            fontWeight: _selectedIndex == 0 ? FontWeight.w700 : FontWeight.w400,
                          ),
                        )),
                      )),

                      Tab(iconMargin: EdgeInsets.zero, child: Container(
                        height: double.maxFinite, width: double.maxFinite,
                        margin: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          color: _selectedIndex == 1 ? Theme.of(context).primaryColor : Theme.of(context).canvasColor,
                        ),
                        child: Center(child: Text(
                          getTranslated('Confirmed', context)!,
                          style: rubikRegular.copyWith(
                            color: _selectedIndex == 1 ? Theme.of(context).cardColor : Theme.of(context).primaryColor,
                            fontWeight: _selectedIndex == 0 ? FontWeight.w700 : FontWeight.w400,
                          ),
                        )),
                      )),
                      Tab(iconMargin: EdgeInsets.zero, child: Container(
                        height: double.maxFinite, width: double.maxFinite,
                        margin: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          color: _selectedIndex == 2 ? Theme.of(context).primaryColor : Theme.of(context).canvasColor,
                        ),
                        child: Center(child: Text(
                          getTranslated('History', context)!,
                          style: rubikRegular.copyWith(
                            color: _selectedIndex == 2 ? Theme.of(context).cardColor : Theme.of(context).primaryColor,
                            fontWeight: _selectedIndex == 0 ? FontWeight.w700 : FontWeight.w400,
                          ),
                        )),
                      )),
                    ],
                  ),
                ),
              ),

              Expanded(child: TabBarView(
                controller: _tabController,
                children: const [
                  BookingListWidget(status: 'pending'),

                  BookingListWidget(status: 'confirmed'),
                  BookingListWidget(status: 'history'),

                ],
              )),
            ])))),

          ]);
        },
      ) : const NotLoggedInWidget(),
    );
  }
}
