import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/enums/data_source_enum.dart';
import 'package:flutter_restaurant/common/models/config_model.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/features/profile/screens/profile_screen.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/helper/profile_completed_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/helper/version_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  final String? routeTo;
  const SplashScreen({super.key, this.routeTo});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
  final GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();
  StreamSubscription<List<ConnectivityResult>>? subscription;

  late AnimationController animationController;
  late Animation<Offset> leftSlideAnimation;
  bool isNotLoaded = true;

  @override
  void initState() {
    super.initState();

    _checkConnectivity();


    _splashAnimation();

    Provider.of<SplashProvider>(context, listen: false).initSharedData();
    _route();

  }

  @override
  void dispose() {
    animationController.dispose();
    subscription?.cancel();

    super.dispose();
  }

  void _splashAnimation(){
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..repeat(reverse: true);

    leftSlideAnimation = Tween<Offset>(begin: const Offset(-4, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: animationController, curve: Curves.ease),
    );

    animationController.forward();
  }

  void _route() async {

    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    splashProvider.initConfig(context, DataSourceEnum.client).then((value) async {
      _onConfigAction(value, splashProvider, Get.context!);

    });
  }

  void _onConfigAction(ConfigModel? value, SplashProvider splashProvider, BuildContext context) async {

    if (value != null) {

      final config = splashProvider.configModel!;
      String? minimumVersion;

      if(defaultTargetPlatform == TargetPlatform.android  && config.playStoreConfig != null) {
        minimumVersion = config.playStoreConfig!.minVersion;

      }else if(defaultTargetPlatform == TargetPlatform.iOS  &&  config.appStoreConfig != null) {
        minimumVersion = config.appStoreConfig!.minVersion;
      }

      if(config.maintenanceMode == 1 ) {
        RouterHelper.getMaintainRoute(action: RouteAction.pushNamedAndRemoveUntil);

      }else if(VersionHelper.parse('$minimumVersion') > VersionHelper.parse(AppConstants.appVersion)) {
        RouterHelper.getUpdateRoute(action: RouteAction.pushNamedAndRemoveUntil);
      }else if (Provider.of<AuthProvider>(Get.context!, listen: false).isLoggedIn()) {
        final ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);

        Provider.of<AuthProvider>(Get.context!, listen: false).updateToken();

        await profileProvider.getUserInfo(true);

        profileProvider.userInfoModel!.countryId == -1 ?  RouterHelper.getProfileRoute('splash',action: RouteAction
             .pushReplacement) :
         RouterHelper.getMainRoute(action: RouteAction.pushNamedAndRemoveUntil);
      } else {
        if(widget.routeTo != null){
          Get.context!.pushReplacement(widget.routeTo!);
        }else{
          Future.delayed(const Duration(milliseconds: 10)).then((v){
            RouterHelper.getLoginRoute(action: RouteAction.pushNamedAndRemoveUntil);

          });

        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return const CustomAssetImageWidget(
      Images.splashBackground,
      fit: BoxFit.cover,
    );
  }

  void _checkConnectivity() {
    bool isFirst = true;
    subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      bool isConnected = result.contains(ConnectivityResult.wifi) || result.contains(ConnectivityResult.mobile);

      if(isFirst && !isConnected) {
        showCustomSnackBarHelper(getTranslated('no_internet_connection', context), isError: true);
      }
      else if(!isFirst && mounted) {  // Check if widget is still mounted
        showCustomSnackBarHelper(getTranslated(isConnected ? 'connected' : 'no_internet_connection', context), isError: !isConnected);

        if(isConnected && mounted && ModalRoute.of(context)?.settings.name == RouterHelper.splashScreen) {
          _route();
        }
      }
      isFirst = false;
    });
  }

}





