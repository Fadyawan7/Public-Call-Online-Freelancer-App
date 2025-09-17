import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/enums/html_type_enum.dart';
import 'package:flutter_restaurant/common/models/booking_details_model.dart';
import 'package:flutter_restaurant/common/models/config_model.dart';
import 'package:flutter_restaurant/common/models/product_model.dart';
import 'package:flutter_restaurant/features/address/domain/models/address_model.dart';
import 'package:flutter_restaurant/features/address/screens/add_new_address_screen.dart';
import 'package:flutter_restaurant/features/address/screens/address_screen.dart';
import 'package:flutter_restaurant/features/apply_freelancer/screens/apply_freelancer_screen.dart';
import 'package:flutter_restaurant/features/apply_freelancer/screens/request_submitted_screen.dart';
import 'package:flutter_restaurant/features/auth/screens/create_account_screen.dart';
import 'package:flutter_restaurant/features/auth/screens/login_screen.dart';
import 'package:flutter_restaurant/features/auth/screens/send_otp_screen.dart';
import 'package:flutter_restaurant/features/booking/screens/booking_detail_screen.dart';
import 'package:flutter_restaurant/features/booking/screens/new_booking.dart';
import 'package:flutter_restaurant/features/chat/domain/models/chat_model.dart';
import 'package:flutter_restaurant/features/chat/domain/models/conversation_model.dart';
import 'package:flutter_restaurant/features/chat/screens/chat_screen.dart';
import 'package:flutter_restaurant/features/chat/screens/conversation_screen.dart';

import 'package:flutter_restaurant/features/dashboard/screens/dashboard_screen.dart';
import 'package:flutter_restaurant/features/force_update/screens/force_update_screen.dart';
import 'package:flutter_restaurant/features/forgot_password/screens/create_new_password_screen.dart';
import 'package:flutter_restaurant/features/forgot_password/screens/forgot_password_screen.dart';
import 'package:flutter_restaurant/features/forgot_password/screens/verification_screen.dart';
import 'package:flutter_restaurant/features/freelancer/domain/models/freelancer_model.dart';
import 'package:flutter_restaurant/features/freelancer/screens/freelancer_screen.dart';
import 'package:flutter_restaurant/features/freelancer_booking/screens/freelancer_booking_detail_screen.dart';
import 'package:flutter_restaurant/features/freelancer_booking/screens/freelancer_booking_screen.dart';
import 'package:flutter_restaurant/features/freelancer_portfolio/screens/freelancer_portfolio_add_screen.dart';
import 'package:flutter_restaurant/features/freelancer_portfolio/screens/freelancer_portfolio_screen.dart';

import 'package:flutter_restaurant/features/html/screens/html_viewer_screen.dart';
import 'package:flutter_restaurant/features/language/screens/choose_language_screen.dart';
import 'package:flutter_restaurant/features/maintenance/screens/maintenance_screen.dart';
import 'package:flutter_restaurant/features/notification/screens/notification_screen.dart';
import 'package:flutter_restaurant/features/onboarding/screens/onboarding_screen.dart';

import 'package:flutter_restaurant/features/page_not_found/screens/page_not_found_screen.dart';
import 'package:flutter_restaurant/features/profile/screens/change_password_screen.dart';

import 'package:flutter_restaurant/features/profile/screens/profile_screen.dart';
import 'package:flutter_restaurant/features/profile/screens/user_detail_screen.dart';
import 'package:flutter_restaurant/features/rating_reviews/screens/submit_rate_review_screen.dart';
import 'package:flutter_restaurant/features/rating_reviews/screens/rating_review_list_screen.dart';

import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/features/splash/screens/splash_screen.dart';
import 'package:flutter_restaurant/features/support/screens/support_screen.dart';
import 'package:flutter_restaurant/features/welcome/screens/welcome_screen.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web_plugins/url_strategy.dart';


enum RouteAction{push, pushReplacement, popAndPush, pushNamedAndRemoveUntil}

class RouterHelper {

  static const String splashScreen = '/splash';
  // static const String splashAnimationScreen = '/splash_animation';
  static const String languageScreen = '/select-language';
  static const String onBoardingScreen = '/on_boarding';
  static const String welcomeScreen = '/welcome';
  static const String loginScreen = '/login';
  static const String verify = '/verify';
  static const String forgotPassScreen = '/forgot-password';
  static const String createNewPassScreen = '/create-new-password';
  static const String createAccountScreen = '/create-account';
  static const String dashboard = '/';
  static const String maintain = '/maintain';
  static const String update = '/update';
  static const String dashboardScreen = '/main';
  static const String searchScreen = '/search';
  static const String searchResultScreen = '/search-result';
  static const String categoryScreen = '/category';
  static const String notificationScreen = '/notification';
  static const String checkoutScreen = '/checkout';
  static const String paymentScreen = '/payment';
  static const String orderSuccessScreen = '/order-completed';
  static const String bookingDetailsScreen = '/booking-details';
  static const String userDetailsScreen = '/user-details';

  static const String freelancerBookingDetailsScreen = '/freelancer-booking-details';
  static const String rateReviewListScreen = '/rate-review-list';

  static const String submitRateScreen = '/submit-rate-review';
  static const String bookingDateSlotScreen = '/booking-date-slot';
  static const String profileScreen = '/profile';
  static const String freelancerDetailScreen = '/freelancer-detail';

  static const String applyFreelancerScreen = '/apply-freelancer';

  static const String addressScreen = '/address';
  static const String mapScreen = '/map';
  static const String addAddressScreen = '/add-address';
  static const String selectLocationScreen = '/select-location';
  static const String chatScreen = '/messages';
  static const String supportScreen = '/support';
  static const String termsScreen = '/terms';
  static const String policyScreen = '/privacy-policy';
  static const String aboutUsScreen = '/about-us';
  static const String homeScreen = '/home';
  static const String orderWebPayment = '/order-web-payment';
  static const String popularItemRoute = '/POPULAR_ITEM_ROUTE';
  static const String returnPolicyScreen = '/return-policy';
  static const String refundPolicyScreen = '/refund-policy';
  static const String cancellationPolicyScreen = '/cancellation-policy';
  static const String homeItem = '/home-item';
  static const String otpVerification = '/send-otp-verification';
  static const String otpRegistration = '/otp-registration';
  static const String freelancerScreen = '/freelancer';
  static const String freelancerBookingScreen = '/freelancer-booking';
  static const String freelancerPortfolioListScreen = '/freelancer-portfolio-list';
  static const String freelancerPortfolioAddScreen = '/freelancer-portfolio-add';
  static const String chatListScreen = '/chat-list';
  static const String conversationScreen = '/user-conversation';

  static const String changePasswordScreen = '/change-password';



  static HistoryUrlStrategy historyUrlStrategy = HistoryUrlStrategy();

  static String getSplashRoute({RouteAction? action}) => _navigateRoute(splashScreen, route: action);
  static String getLanguageRoute(bool isFromMenu, {RouteAction? action}) => _navigateRoute('$languageScreen?page=${isFromMenu ? 'menu' : 'splash'}', route: action);
  static String getOnBoardingRoute({RouteAction? action}) => _navigateRoute(onBoardingScreen, route: action);
  static String getWelcomeRoute() => _navigateRoute(welcomeScreen, route: RouteAction.pushReplacement);
  static String getLoginRoute({RouteAction? action}) => _navigateRoute(loginScreen, route: action);
  static String getForgetPassRoute() => _navigateRoute(forgotPassScreen);
  static String getNewPassRoute(String emailOrPhone, String token) => _navigateRoute('$createNewPassScreen?email_or_phone=${Uri.encodeComponent(emailOrPhone)}&token=$token');
  static String getVerifyRoute(String page, String email,  {String? session, RouteAction? action}) {
    String data = Uri.encodeComponent(jsonEncode(email));
    String authSession = base64Url.encode(utf8.encode(session ?? ''));
    return _navigateRoute('$verify?page=$page&email=$data&data=$authSession', route: action);
  }
  static String getBookingDetailsRoute(String? id,{RouteAction? action}) => _navigateRoute('$bookingDetailsScreen?id=$id' );
  static String getFreelancerBookingDetailsRoute(String? id) => _navigateRoute('$freelancerBookingDetailsScreen?id=$id');


  static String getUserDetailsRoute({ BookingDetailsModel? bookingDetail, RouteAction? action}) {

    String bookingDetailData = base64Url.encode(utf8.encode(jsonEncode(bookingDetail?.toJson())));

    return _navigateRoute('$userDetailsScreen?bookingDetailData=$bookingDetailData', route: action);
  }


  static String getChatRoute({ FreelancerModel? freelancer, RouteAction? action}) {

    String freelancerData = base64Url.encode(utf8.encode(jsonEncode(freelancer?.toJson())));

    return _navigateRoute('$chatScreen?freelancer=$freelancerData', route: action);
  }

  static String getCreateAccountRoute()=> _navigateRoute(createAccountScreen);
  static String getMainRoute({RouteAction? action}) => _navigateRoute(dashboard, route: action);
  static String getMaintainRoute({RouteAction? action}) => _navigateRoute(maintain, route: RouteAction.pushNamedAndRemoveUntil);
  static String getUpdateRoute({RouteAction? action}) => _navigateRoute(update, route: action);
  static String getHomeRoute({required String fromAppBar, RouteAction? action})=> _navigateRoute('$homeScreen?from=$fromAppBar', route: action);
  static String getDashboardRoute(String page, {RouteAction? action}) => _navigateRoute('$dashboardScreen?page=$page', route: action);
  static String getSearchRoute() => _navigateRoute(searchScreen);
  static String getSearchResultRoute(String text) {
    return _navigateRoute('$searchResultScreen?text=${Uri.encodeComponent(jsonEncode(text))}');
  }
  static String getNotificationRoute() => _navigateRoute(notificationScreen);
  static String getChatListRoute() => _navigateRoute(chatListScreen);

  static String getCheckoutRoute(double? amount, String page, String? code, bool isCutlery) {
    String amount0= base64Url.encode(utf8.encode(amount.toString()));
    return _navigateRoute('$checkoutScreen?amount=$amount0&page=$page&&code=$code${isCutlery ? '&cutlery=1' : ''}');
  }
  static String getMapRoute(AddressModel addressModel) {
    List<int> encoded = utf8.encode(jsonEncode(addressModel.toJson()));
    String data = base64Encode(encoded);
    return _navigateRoute('$mapScreen?address=$data');
  }

  static String getPaymentRoute(String url, {bool fromCheckout = true}) {
    return _navigateRoute('$paymentScreen?url=${Uri.encodeComponent(url)}&from_checkout=$fromCheckout');
  }
  static String getRateReviewListRoute(String? id) => _navigateRoute('$rateReviewListScreen?id=$id');
  static String getChangePasswordRoute() => _navigateRoute(changePasswordScreen);

  static String getSubmitRateReviewRoute({required bookingId, required takerId}) => _navigateRoute('$submitRateScreen?id=$bookingId&taker_id=$takerId');
  static String getProfileRoute(String page, {RouteAction action = RouteAction.push}) => _navigateRoute('$profileScreen?page=$page',route: action);
  static String getFreelancerBookingRoute({RouteAction action = RouteAction.push}) => _navigateRoute(freelancerBookingScreen, route: action);

  static String getApplyFreelancerRoute({RouteAction action = RouteAction.push}) => _navigateRoute(applyFreelancerScreen, route: action);
  static String getFreelancerPortfolioListRoute({RouteAction action = RouteAction.push}) => _navigateRoute(freelancerPortfolioListScreen, route: action);
  static String getFreelancerPortfolioAddRoute({RouteAction action = RouteAction.push}) => _navigateRoute(freelancerPortfolioAddScreen, route: action);

  static String getBookingDateSlotRoute(String freelancerId) => _navigateRoute('$bookingDateSlotScreen?freelancer_id=$freelancerId', route: RouteAction.push);



  static String getFreelancerDetailRoute({FreelancerModel? freelancerModel,RouteAction action = RouteAction.push}) {
    String freelancerModel0 = base64Url.encode(utf8.encode(jsonEncode(freelancerModel!.toJson())));
    return _navigateRoute('$freelancerDetailScreen?freelancerDetail=$freelancerModel0',route: action);
  }
  static String getAddressRoute() => _navigateRoute(addressScreen);

  static String getAddAddressRoute(String page, String action, AddressModel addressModel) {
    String data = base64Url.encode(utf8.encode(jsonEncode(addressModel.toJson())));
    return _navigateRoute('$addAddressScreen?page=$page&action=$action&address=$data');
  }
  static String getSelectLocationRoute() => _navigateRoute(selectLocationScreen);
  static String getOrderSuccessScreen(String? status,String? message) {
    return _navigateRoute('$orderSuccessScreen?status=$status&message=$message');
  }
  static String getSupportRoute() => _navigateRoute(supportScreen);
  static String getTermsRoute() => _navigateRoute(termsScreen);
  static String getPolicyRoute() => _navigateRoute(policyScreen);
  static String getAboutUsRoute() => _navigateRoute(aboutUsScreen);

  static String getFreelancerScreen() => _navigateRoute(freelancerScreen);

  static String getOtpVerificationScreen() => _navigateRoute(otpVerification);
  static String getOtpRegistrationScreen(String? tempToken, String userInput, {String? userName, RouteAction action = RouteAction.pushNamedAndRemoveUntil}){
    String data = '';
    if(tempToken != null && tempToken.isNotEmpty){
      data = Uri.encodeComponent(jsonEncode(tempToken));
    }
    String input = Uri.encodeComponent(jsonEncode(userInput));
    String name = '';
    name = Uri.encodeComponent(jsonEncode(userName ?? ''));
    return _navigateRoute('$otpRegistration?tempToken=$data&input=$input&userName=$name', route: action);

  }

  static String getConversationScreen({ChatModel? chat, RouteAction? action}) {

    String chatData = base64Url.encode(utf8.encode(jsonEncode(chat?.toJson())));

    return _navigateRoute('$conversationScreen?chat=$chatData', route: action);
  }

  static String _navigateRoute( String path,{ RouteAction? route = RouteAction.push}) {

    if(route == RouteAction.pushNamedAndRemoveUntil){
      Get.context?.go(path);

      if(kIsWeb) {
        historyUrlStrategy.replaceState(null, '', '/');
      }


    }else if(route == RouteAction.pushReplacement){
      Get.context?.pushReplacement(path);

    }else{
      Get.context?.push(path);
    }
    return path;
  }



  static  Widget _routeHandler(BuildContext context, Widget route,  {bool isBranchCheck = false, required String? path}) {
    print('=====PATH-====${path}');
   return Provider.of<SplashProvider>(context, listen: false).configModel == null
       ? SplashScreen(routeTo: path) : _isMaintenance(Provider.of<SplashProvider>(context, listen: false).configModel!)
       ? const MaintenanceScreen()
       :  route ;

  }

  static _isMaintenance(ConfigModel configModel) {
    if(configModel.maintenanceMode == 1){
      return true;
    }else{
      return false;
    }
  }

  static String? _getPath(GoRouterState state)=> '${state.fullPath}?${state.uri.query}';

  static final goRoutes = GoRouter(

    navigatorKey: navigatorKey,
    initialLocation: ResponsiveHelper.isMobilePhone() ? getSplashRoute() : getMainRoute(),
    errorBuilder: (ctx, _)=> const PageNotFoundScreen(),
    routes: [
      GoRoute(path: splashScreen, builder: (context, state) => const SplashScreen()),
      GoRoute(path: maintain, builder: (context, state) => _routeHandler(context, path: _getPath(state), const MaintenanceScreen())),
      GoRoute(path: languageScreen, builder: (context, state) => ChooseLanguageScreen(fromMenu: state.uri.queryParameters['page'] == 'menu')),
      GoRoute(path: onBoardingScreen, builder: (context, state) => OnBoardingScreen()),
      GoRoute(path: welcomeScreen, builder: (context, state) => _routeHandler(context, path: _getPath(state), const WelcomeScreen())),
      GoRoute(path: loginScreen, builder: (context, state) => _routeHandler(context, path: _getPath(state), const LoginScreen())),
      GoRoute(path: verify, builder: (context, state) {
        return _routeHandler(context, path: _getPath(state), VerificationScreen(
          fromPage: state.uri.queryParameters['page'] ?? '',
          userInput: jsonDecode(state.uri.queryParameters['email'] ?? ''),
          session: state.uri.queryParameters['data'] == 'null'
              ? null
              : utf8.decode(base64Url.decode(state.uri.queryParameters['data'] ?? '')),
        ));
      }),
      GoRoute(path: forgotPassScreen, builder: (context, state) => _routeHandler(context, path: _getPath(state), const ForgotPasswordScreen())),
      GoRoute(path: createNewPassScreen, builder: (context, state) => _routeHandler(context, path: _getPath(state), CreateNewPasswordScreen(
        emailOrPhone: Uri.decodeComponent(state.uri.queryParameters['email_or_phone'] ?? ''),
        resetToken: state.uri.queryParameters['token'],
      ))),
      GoRoute(path: createAccountScreen, builder: (context, state) => _routeHandler(context, path: _getPath(state),  const CreateAccountScreen())),
      GoRoute(path: freelancerBookingScreen, builder: (context, state) => _routeHandler(context, path: _getPath(state),  const FreelancerBookingScreen())),

      GoRoute(path: dashboardScreen, builder: (context, state) {
        return _routeHandler(context, path: _getPath(state), DashboardScreen(
          pageIndex: state.uri.queryParameters['page'] == 'booking'
              ? 0 : state.uri.queryParameters['page'] == 'freelancer'
              ? 1 : state.uri.queryParameters['page'] == 'chat'
              ? 2 : state.uri.queryParameters['page'] == 'menu'
              ? 3 : 0,
        ), isBranchCheck: true);
      }),

      GoRoute(path: homeScreen, builder: (context, state) => _routeHandler(context, path: _getPath(state),  const DashboardScreen(pageIndex: 0), isBranchCheck: true)),
      GoRoute(path: dashboard, builder: (context, state) => _routeHandler(context, path: _getPath(state), const DashboardScreen(pageIndex: 0), isBranchCheck: true)),

      GoRoute(path: update, builder: (context, state) => _routeHandler(context, path: _getPath(state), const ForceUpdateScreen())),



      GoRoute(path: conversationScreen, builder: (context, state) {
        ChatModel? chat;
        try{
          chat = ChatModel.fromJson(jsonDecode(utf8.decode(base64Url.decode('${state.uri.queryParameters['chat']?.replaceAll(' ', '+')}'))));

        }catch(error){
          debugPrint('route- order_model - $error');
        }
        return _routeHandler(context, path: _getPath(state),  ConversationScreen(
          chat: chat,
        ));
      }),
      GoRoute(path: submitRateScreen, builder: (context, state) =>  _routeHandler(context, path: _getPath(state), SubmitRateReviewScreen(
        bookingId: int.parse('${state.uri.queryParameters['id']}'),
        takerId: int.parse('${state.uri.queryParameters['taker_id']}'),
      ))),
      GoRoute(path: addAddressScreen, builder: (context, state) {
        bool isUpdate = state.uri.queryParameters['action'] == 'update';
        AddressModel? addressModel;

        if(isUpdate) {
          String decoded = utf8.decode(base64Url.decode('${state.uri.queryParameters['address']?.replaceAll(' ', '+')}'));
          addressModel = AddressModel.fromJson(jsonDecode(decoded));
        }
        return _routeHandler(context, path: _getPath(state), AddNewAddressScreen(
          fromCheckout: state.uri.queryParameters['page'] == 'checkout',
          isEnableUpdate: isUpdate,
          address: isUpdate ? addressModel : null,
        ),
        );
      }),

      GoRoute(path: rateReviewListScreen, builder: (context, state) =>  _routeHandler(context, path: _getPath(state), RateReviewListScreen(
        freelancerId: int.parse(state.uri.queryParameters['id'] ?? ''),
      ))),
      GoRoute(path: bookingDateSlotScreen, builder: (context, state) => _routeHandler(context, path: _getPath(state), BookingDateSlotScreen(
        freelancerId: state.uri.queryParameters['freelancer_id'],
      ))),
      GoRoute(path: notificationScreen, builder: (context, state) => _routeHandler(context, path: _getPath(state), const NotificationScreen())),



      GoRoute(path: chatScreen, builder: (context, state) =>  _routeHandler(context, path: _getPath(state),  ChatScreen())),

      GoRoute(path: freelancerScreen, builder: (context, state)=> _routeHandler(context, path: _getPath(state),  const FreelancerScreen())),

      GoRoute(path: changePasswordScreen, builder: (context, state) => _routeHandler(context, path: _getPath(state),  const ChangePasswordScreen())),

      GoRoute(path: profileScreen, builder: (context, state) => _routeHandler(context, path: _getPath(state),   ProfileScreen(
        fromSplash: state.uri.queryParameters['page'] == 'splash',

      ))),
      GoRoute(path: applyFreelancerScreen, builder: (context, state) => _routeHandler(context, path: _getPath(state),  const ApplyFreelancerScreen())),
      GoRoute(path: freelancerPortfolioListScreen, builder: (context, state) => _routeHandler(context, path: _getPath(state),  const FreelancerPortfolioScreen())),
      GoRoute(path: freelancerPortfolioAddScreen, builder: (context, state) => _routeHandler(context, path: _getPath(state),  const FreelancerPortfolioAddScreen())),

      GoRoute(path: addressScreen, builder: (context, state) => _routeHandler(context, path: _getPath(state),  const AddressScreen())),
      GoRoute(path: supportScreen, builder: (context, state) => const SupportScreen()),
      GoRoute(path: termsScreen, builder: (context, state) => const HtmlViewerScreen(htmlType: HtmlType.termsAndCondition)),
      GoRoute(path: policyScreen, builder: (context, state) => const HtmlViewerScreen(htmlType: HtmlType.privacyPolicy)),
      GoRoute(path: aboutUsScreen, builder: (context, state) => const HtmlViewerScreen(htmlType: HtmlType.aboutUs)),


      GoRoute(path: orderSuccessScreen, builder: (context, state) {

        return _routeHandler(context, path: _getPath(state), RequestSubmitedScreen(
          status: (state.uri.queryParameters['status'] == 'success' || state.uri.queryParameters['status'] == 'payment-success')
              ? 0 : state.uri.queryParameters['status'] == 'payment-fail'
              ? 1 : state.uri.queryParameters['status'] == 'order-fail' ?  2 : 3,
          message: state.uri.queryParameters['message'],
        ),
        );
      }),

      GoRoute(path: otpVerification, builder: (context, state) => const SendOtpScreen()),

      GoRoute(path: bookingDetailsScreen, builder: (context, state) =>  _routeHandler(context, path: _getPath(state), BookingDetailsScreen(
        bookingId: int.parse(state.uri.queryParameters['id'] ?? ''),
      ))),


      GoRoute(path: userDetailsScreen, builder: (context, state) {
        BookingDetailsModel? bookingDetailsModel;
        try{
          bookingDetailsModel = BookingDetailsModel.fromJson(jsonDecode(utf8.decode(base64Url.decode('${state.uri.queryParameters['bookingDetailData']?.replaceAll(' ', '+')}'))));
          debugPrint('route - ${bookingDetailsModel}');

        }catch(error){
          debugPrint('route - $error');
        }
        return _routeHandler(context, path: _getPath(state), UserDetailsScreen(
          bookingDetailsModel: bookingDetailsModel!,
        ));
      }),



      GoRoute(path: freelancerBookingDetailsScreen, builder: (context, state) =>  _routeHandler(context, path: _getPath(state), FreelancerBookingDetailsScreen(
        bookingId: int.parse(state.uri.queryParameters['id'] ?? ''),
      ))),




    ],
  );
}


class HistoryUrlStrategy extends PathUrlStrategy {
  @override
  void pushState(Object? state, String title, String url) => replaceState(state, title, url);
}


