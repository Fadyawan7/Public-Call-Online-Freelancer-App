import 'package:flutter_restaurant/common/models/language_model.dart';
import 'package:flutter_restaurant/common/enums/app_mode_enum.dart';
import 'package:flutter_restaurant/utill/images.dart';

class AppConstants {
  static const String appName = 'eFood';
  static const String appVersion = '11.2';
  static const AppMode appMode = AppMode.release;
  static const String baseUrl =  'https://publiccallonline.com';
  // static const String baseUrl =  'http://192.168.100.73:8000';


  static const String categoryUri = '/api/freelancers/categories';
  static const String bannerUri = '/api/banners';
  static const String latestProductUri = '/api/products/latest';
  static const String popularProductUri = '/api/products/popular';
  static const String subCategoryUri = '/api/categories/childes/';
  static const String categoryProductUri = '/api/categories/products/';
  static const String configUri = '/api/config';
  static const String trackUri = '/api/customer/order/track?order_id=';
  static const String messageUri = '/api/customer/message/get';
  static const String sendMessageUri = '/api/customer/message/send';
  static const String forgetPasswordUri = '/api/auth/forgot-password';
  static const String verifyTokenUri = '/api/auth/verify-token';
  static const String resetPasswordUri = '/api/auth/reset-password';
  static const String checkPhoneUri = '/api/auth/check-phone?phone=';
  static const String verifyPhoneUri = '/api/auth/verify-phone';
  static const String verifyOtpUri = '/api/auth/verify-otp';
  static const String verifyProfileInfo = '/api/customer/verify-profile-info';
  static const String checkEmailUri = '/api/auth/check-email';
  static const String verifyEmailUri = '/api/auth/verify-email';
  static const String registerUri = '/api/auth/register';
  static const String loginUri = '/api/auth/login';
  static const String tokenUri = '/api/update-fcm-token';
  static const String applyFreelancerUri = '/api/freelancers/register';
  static const String addressListUri = '/api/address/list';
  static const String removeAddressUri = '/api/address/delete/';
  static const String addAddressUri = '/api/address/store';
  static const String updateAddressUri = '/api/address/update/';
  static const String setMenuUri = '/api/products/set-menu';
  static const String customerInfoUri = '/api/user';
  static const String countryListUri = '/api/countries';
  static const String cityListUri = '/api/country/cities';

  static const String couponApplyUri = '/api/coupon/apply?code=';
  static const String bookingListUri = '/api/bookings';
  static const String freelancerBookingListUri = '/api/freelancers/bookings';

  static const String freelancerListUri = '/api/freelancers';
  static const String freelancerDetailUri = '/api/freelancers/show/';

  static const String bookingDetailsUri = '/api/bookings/show/';
  static const String updateBookingStatusUri = '/api/bookings/update';

  static const String notificationUri = '/api/notifications';
  static const String pushNotificationUri = 'https://fcm.googleapis.com/fcm/send';
  static const String updateProfileUri = '/api/update-profile';
  static const String updatePasswordUri = '/api/update-password';

  static const String searchUri = '/api/products/search';
  static const String reviewUri = '/api/reviews/store';
  static const String lastLocationUri = '/api/delivery-man/last-location?order_id=';
  static const String freelancerReviewUri = '/api/reviews/freelancer/';
  static const String searchLocationUri = '/api/mapapi/place-api-autocomplete';
  static const String placeDetailsUri = '/api/mapapi/place-api-details';
  static const String geocodeUri = '/api/mapapi/geocode-api';
  static const String getChatListUri = '/api/chats/';
  static const String getConversationsUrl = '/api/chats/';
  static const String sendMessageUrl = '/api/chats/';
  static const String startNewChatUrl = '/api/chats';
  static const String deleteUrl = '/api/chats';

  static const String customerRemove = '/api/customer/remove-account';
    static const String disableAccount = '/api/temporary-disabled';

  static const String policyPage = '/api/pages';
  static const String socialLogin = '/api/auth/social-login';
  static const String offlinePaymentMethod = '/api/offline-payment-method/list';
  static const String firebaseAuthVerify = '/api/auth/firebase-auth-verify';


  static const String registerWithOtp = '/api/auth/registration-with-otp';
  static const String registerWithSocialMedia = '/api/auth/registration-with-social-media';
  static const String existingAccountCheck = '/api/auth/existing-account-check';
  static const String subscribeToTopic = '/api/update-fcm-token';
  static const String searchSuggestion = '/api/products/search-suggestion';

  static const String placeBookingUri = '/api/bookings/create';

  static const String freelancerPortfolioAddUri = '/api/freelancers/portfolio/store';
  static const String freelancerPortfolioListUri = '/api/freelancers/portfolio';
  static const String freelancerPortfolioDeleteUri = '/api/freelancers/portfolio/delete';


  // Shared Key
  static const String theme = 'theme';
  static const String token = 'token';
  static const String languageCode = 'language_code';
  static const String countryCode = 'country_code';
  static const String cartList = 'cart_list';
  static const String userPassword = 'user_password';
  static const String userAddress = 'user_address';
  static const String userNumber = 'user_number';
  static const String userLogData = 'user_log_data';
  static const String searchAddress = 'search_address';
  static const String topic = 'notify';
  static const String onBoardingSkip = 'on_boarding_skip';
  static const String placeOrderData = 'place_order_data';
  static const String branch = 'branch';
  static const String cookiesManagement = 'cookies_management';
  static const String guestId = 'guest_id';
  static const String walletToken = 'wallet_token';




  static List<LanguageModel> languages = [
    LanguageModel(imageUrl: Images.unitedKingdom, languageName: 'English', countryCode: 'US', languageCode: 'en'),
    LanguageModel(imageUrl: Images.arabic, languageName: 'Arabic', countryCode: 'SA', languageCode: 'ar'),
  ];

  static const int balanceInputLen = 10;


  static final List<Map<String, String>> walletTransactionSortingList = [
    {
      'title' : 'all_transactions',
      'value' : 'all'
    },
    {
      'title' : 'order_transactions',
      'value' : 'order_place'
    },
    {
      'title' : 'converted_from_loyalty_point',
      'value' : 'loyalty_point_to_wallet'
    },
    {
      'title' : 'added_via_payment_method',
      'value' : 'add_fund'
    },
    {
      'title' : 'earned_by_referral',
      'value' : 'referral_order_place'
    },
    {
      'title' : 'earned_by_bonus',
      'value' : 'add_fund_bonus'
    },
    {
      'title' : 'added_by_admin',
      'value' : 'add_fund_by_admin'
    },
  ];

}
