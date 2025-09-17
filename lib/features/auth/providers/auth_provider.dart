// ignore_for_file: empty_catches

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/api_response_model.dart';
import 'package:flutter_restaurant/common/models/config_model.dart';
import 'package:flutter_restaurant/common/models/response_model.dart';
import 'package:flutter_restaurant/features/auth/domain/enum/auth_enum.dart';
import 'package:flutter_restaurant/features/auth/domain/models/signup_model.dart';
import 'package:flutter_restaurant/features/auth/domain/models/social_login_model.dart';
import 'package:flutter_restaurant/features/auth/domain/models/user_log_data.dart';
import 'package:flutter_restaurant/features/auth/domain/reposotories/auth_repo.dart';
import 'package:flutter_restaurant/features/profile/domain/models/userinfo_model.dart';
import 'package:flutter_restaurant/helper/get_response_error_message.dart';
import 'package:flutter_restaurant/helper/number_checker_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/app_localization.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../../../helper/api_checker_helper.dart';
import '../../../localization/language_constrants.dart';
import '../../../helper/custom_snackbar_helper.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  final AuthRepo? authRepo;

  AuthProvider({required this.authRepo});

  // for registration section
  bool _isLoading = false;
  String? _registrationErrorMessage = '';
  bool _isCheckedPhone = false;
  Timer? _timer;
  bool _isForgotPasswordLoading = false;
  bool _isNumberLogin = false;
  int? currentTime;
  String? _loginErrorMessage = '';
  bool _isPhoneNumberVerificationButtonLoading = false;
  bool resendButtonLoading = false;
  String? _verificationMsg = '';
  String _email = '';
  String _phone = '';
  String _verificationCode = '';
  bool _isEnableVerificationCode = false;
  bool _isActiveRememberMe = false;
  bool? _isAvailable;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // Use the web client ID from Firebase console
    serverClientId:
        '906367301565-lupte21f5ai9nu8mu98ualkou76rgvjr.apps.googleusercontent.com',
    scopes: ['email', 'profile'],
  );
  GoogleSignInAccount? googleAccount;

  bool get isAvailable => _isAvailable ?? true;

  String? get loginErrorMessage => _loginErrorMessage;
  bool get isLoading => _isLoading;
  bool get isCheckedPhone => _isCheckedPhone;
  bool get isNumberLogin => _isNumberLogin;
  String get verificationCode => _verificationCode;
  String? get registrationErrorMessage => _registrationErrorMessage;
  set setIsLoading(bool value) => _isLoading = value;
  bool get isForgotPasswordLoading => _isForgotPasswordLoading;
  set setForgetPasswordLoading(bool value) => _isForgotPasswordLoading = value;
  bool get isPhoneNumberVerificationButtonLoading =>
      _isPhoneNumberVerificationButtonLoading;
  String? get verificationMessage => _verificationMsg;
  String get email => _email;
  String get phone => _phone;
  set setIsPhoneVerificationButttonLoading(bool value) =>
      _isPhoneNumberVerificationButtonLoading = value;
  bool get isEnableVerificationCode => _isEnableVerificationCode;
  bool get isActiveRememberMe => _isActiveRememberMe;

  updateRegistrationErrorMessage(String message) {
    _registrationErrorMessage = message;
    notifyListeners();
  }

  Future<ResponseModel> registration(
      SignUpModel signUpModel, String token) async {
    _isLoading = true;
    notifyListeners();
    ResponseModel responseModel;

    http.StreamedResponse response =
        await authRepo!.registration(signUpModel, token);
    Map map = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      String? message = map["message"];
      responseModel = ResponseModel(true, message);
    } else {
      String errorMessage = getErrorMessage(map);

      // Create a ResponseModel with the error message and errors map
      responseModel = ResponseModel(false, errorMessage);
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> login(
      String? userInput, String? password, String? type) async {
    _isLoading = true;
    _loginErrorMessage = '';
    notifyListeners();

    ApiResponseModel apiResponse =
        await authRepo!.login(userInput: userInput, password: password);

    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      String? token;
      String? tempToken;
      Map map = apiResponse.response!.data;
      if (map.containsKey('temporary_token')) {
        tempToken = map["temporary_token"];
      } else if (map.containsKey('token')) {
        token = map["token"];
      }
      print("Type is ${token}");

      if (token != null) {
        await _updateAuthToken(token);
        final ProfileProvider profileProvider =
            Provider.of<ProfileProvider>(Get.context!, listen: false);
        profileProvider.getUserInfo(false, isUpdate: false);
      } else if (tempToken != null) {
        await sendVerificationCode(
            Provider.of<SplashProvider>(Get.context!, listen: false)
                .configModel!,
            SignUpModel(email: userInput, phone: userInput),
            type: type);
      }

      responseModel = ResponseModel(token != null, 'verification');
    } else {
      _loginErrorMessage = 'Invalid Credentials ! Try again';
      print('=====LOGINERROR===${apiResponse.error}');
      responseModel = ResponseModel(false, _loginErrorMessage);
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel?> forgetPassword(
      {required ConfigModel config, required String email}) async {
    ResponseModel? responseModel;
    _isForgotPasswordLoading = true;
    notifyListeners();

    responseModel = await _forgetPassword(email);

    _isForgotPasswordLoading = false;
    notifyListeners();

    return responseModel;
  }

  Future<ResponseModel> _forgetPassword(String email) async {
    _isForgotPasswordLoading = true;
    resendButtonLoading = true;
    notifyListeners();

    ApiResponseModel apiResponse = await authRepo!.forgetPassword(email);
    ResponseModel responseModel;

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      responseModel =
          ResponseModel(true, apiResponse.response!.data["message"]);
    } else {
      responseModel = ResponseModel(
          false, ApiCheckerHelper.getError(apiResponse).errors![0].message);
      ApiCheckerHelper.checkApi(apiResponse);
    }
    resendButtonLoading = false;
    _isForgotPasswordLoading = false;
    notifyListeners();

    return responseModel;
  }

  Future<void> updateToken() async {
    if (await authRepo!.getDeviceToken() != '@') {
      print('------------(update device token) -----from updateToken');

      await authRepo!.updateDeviceToken();
    }
  }

  Future<ResponseModel> verifyToken(String email) async {
    _isPhoneNumberVerificationButtonLoading = true;
    notifyListeners();
    ApiResponseModel apiResponse =
        await authRepo!.verifyToken(email, _verificationCode);
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      responseModel =
          ResponseModel(true, apiResponse.response!.data["message"]);
    } else {
      responseModel = ResponseModel(
          false, ApiCheckerHelper.getError(apiResponse).errors![0].message);
    }
    return responseModel;
  }

  Future<ResponseModel> resetPassword(
      String? mail, String? resetToken, String password, String confirmPassword,
      {required String type}) async {
    _isForgotPasswordLoading = true;
    notifyListeners();
    ApiResponseModel apiResponse = await authRepo!
        .resetPassword(mail, resetToken, password, confirmPassword, type: type);
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      responseModel =
          ResponseModel(true, apiResponse.response!.data["message"]);
      print("ResponseModel ${responseModel.toString()} ");
    } else {
      responseModel = ResponseModel(
          false, ApiCheckerHelper.getError(apiResponse).errors![0].message);
    }
    _isForgotPasswordLoading = false;
    notifyListeners();
    return responseModel;
  }

  updateEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void clearVerificationMessage() {
    _verificationMsg = '';
  }

  Future<ResponseModel> checkEmail(String email, String? fromPage) async {
    _isPhoneNumberVerificationButtonLoading = true;
    resendButtonLoading = true;

    _verificationMsg = '';
    notifyListeners();
    ApiResponseModel apiResponse = await authRepo!.checkEmail(email);

    ResponseModel responseModel;

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      responseModel = ResponseModel(true, apiResponse.response!.data["token"]);

      bool isReplaceRoute =
          GoRouter.of(Get.context!).routeInformationProvider.value.uri.path ==
              RouterHelper.verify;

      if (fromPage != null && fromPage == FromPage.profile.name) {
        RouterHelper.getVerifyRoute(
          FromPage.profile.name,
          email,
          action:
              isReplaceRoute ? RouteAction.pushReplacement : RouteAction.push,
        );
      } else {
        RouterHelper.getVerifyRoute(
          FromPage.login.name,
          email,
          action:
              isReplaceRoute ? RouteAction.pushReplacement : RouteAction.push,
        );
      }
    } else {
      _verificationMsg =
          ApiCheckerHelper.getError(apiResponse).errors![0].message;
      showCustomSnackBarHelper(_verificationMsg);
      responseModel = ResponseModel(false, _verificationMsg);
    }
    _isPhoneNumberVerificationButtonLoading = false;
    resendButtonLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> verifyEmail(String email) async {
    _isPhoneNumberVerificationButtonLoading = true;
    _verificationMsg = '';
    notifyListeners();
    ApiResponseModel apiResponse =
        await authRepo!.verifyEmail(email, _verificationCode);

    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      String token = apiResponse.response!.data["token"];
      await _updateAuthToken(token);
      final ProfileProvider profileProvider =
          Provider.of<ProfileProvider>(Get.context!, listen: false);
      profileProvider.getUserInfo(true);
      responseModel =
          ResponseModel(true, apiResponse.response!.data["message"]);
    } else {
      _verificationMsg =
          ApiCheckerHelper.getError(apiResponse).errors![0].message;
      showCustomSnackBarHelper(_verificationMsg);
      responseModel = ResponseModel(false, _verificationMsg);
    }
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    return responseModel;
  }

  updateVerificationCode(String query, {bool isUpdate = true}) {
    if (query.length == 6) {
      _isEnableVerificationCode = true;
    } else {
      _isEnableVerificationCode = false;
    }
    _verificationCode = query;
    if (isUpdate) {
      notifyListeners();
    }
  }

  toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe;
    notifyListeners();
  }

  bool isLoggedIn() {
    return authRepo!.isLoggedIn();
  }

  Future<bool> clearSharedData(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    _isLoading = true;
    notifyListeners();

    bool isSuccess = await authRepo!.clearSharedData();
    await authProvider.socialLogout();
    await authRepo?.dioClient?.updateHeader(getToken: null);

    print('------------(update device token) -----from clearSharedData');
    authRepo?.updateDeviceToken();

    _isLoading = false;
    notifyListeners();
    return isSuccess;
  }

  void saveUserNumberAndPassword(UserLogData userLogData) {
    print('--------user data----${jsonEncode(userLogData.toJson())}');
    authRepo!.saveUserNumberAndPassword(jsonEncode(userLogData.toJson()));
  }

  UserLogData? getUserData() {
    UserLogData? userData;

    try {
      String rawData = authRepo!.getUserLogData();

      // Check if data is not empty before parsing
      if (rawData.isNotEmpty) {
        userData = UserLogData.fromJson(jsonDecode(rawData));
      } else {
        debugPrint('Error: getUserLogData returned empty string');
      }
    } catch (error) {
      debugPrint('error ===> $error');
    }

    return userData;
  }

  Future<bool> clearUserLogData() async {
    return authRepo!.clearUserLog();
  }

  String getUserToken() {
    return authRepo!.getUserToken();
  }

  Future deleteUser() async {
    _isLoading = true;
    notifyListeners();
    ApiResponseModel response = await authRepo!.deleteUser();
    _isLoading = false;
    if (response.response!.statusCode == 200) {
      Provider.of<SplashProvider>(Get.context!, listen: false)
          .removeSharedData();
      showCustomSnackBarHelper(
          getTranslated('your_account_remove_successfully', Get.context!));
      RouterHelper.getLoginRoute(action: RouteAction.pushReplacement);
    } else {
      Get.context?.pop();
      ApiCheckerHelper.checkApi(response);
    }
  }

  Future<GoogleSignInAuthentication> googleLogin() async {
    try {
      // Sign out any existing user first to ensure clean state
      await _googleSignIn.signOut();

      googleAccount = await _googleSignIn.signIn();
      if (googleAccount == null) {
        throw Exception('Google Sign-In was cancelled');
      }

      final GoogleSignInAuthentication auth =
          await googleAccount!.authentication;
      if (auth.accessToken == null) {
        throw Exception('Failed to get access token');
      }

      return auth;
    } catch (e) {
      debugPrint('Google Sign-In error: $e');
      rethrow;
    }
  }

  Future socialLogin(SocialLoginModel socialLogin, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponseModel apiResponse = await authRepo!.socialLogin(socialLogin);
    print(
        '------------(update device token) -----from socialLogin ${apiResponse.response}');

    _isLoading = false;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
      String? message = '';
      String? token = '';
      String? tempToken = '';
      UserInfoModel? userInfoModel;
      try {
        message = map['error_message'] ?? '';
      } catch (e) {
        debugPrint('error ===> $e');
      }

      try {
        token = map['token'];
      } catch (e) {}

      try {
        tempToken = map['temp_token'];
      } catch (e) {}

      if (map.containsKey('user')) {
        try {
          userInfoModel = UserInfoModel.fromJson(map['user']);
          callback(
              true, null, message, null, userInfoModel, socialLogin.medium);
        } catch (e) {}
      }
      print('------------(update device token) -----from socialLogin ${token}');

      if (token != null) {
        authRepo!.saveUserToken(token);
        print('------------(update device token) -----from socialLogin');

        await authRepo!.updateDeviceToken();
        final ProfileProvider profileProvider =
            Provider.of<ProfileProvider>(Get.context!, listen: false);
        profileProvider.getUserInfo(true);
        clearUserLogData();
        callback(true, token, message, null, null, null);
      }

      if (tempToken != null) {
        callback(true, null, message, tempToken, null, null);
      }

      notifyListeners();
    } else {
      String? errorMessage =
          ApiCheckerHelper.getError(apiResponse).errors?.first.message;
      callback(false, '', errorMessage, null, null, null);
      notifyListeners();
    }
  }

  Future<void> socialLogout() async {
    final UserInfoModel? user =
        Provider.of<ProfileProvider>(Get.context!, listen: false).userInfoModel;
    try {
      await _googleSignIn.signOut();
      await _googleSignIn.disconnect();
    } catch (e) {
      log("Error: $e");
    }
  }

  void startVerifyTimer() {
    _timer?.cancel();
    currentTime = 0;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (currentTime! > 0) {
        currentTime = currentTime! - 1;
      } else {
        _timer?.cancel();
      }
      notifyListeners();
    });
  }

  Future<void> sendVerificationCode(ConfigModel config, SignUpModel signUpModel,
      {String? type, String? fromPage}) async {
    resendButtonLoading = true;
    notifyListeners();
    checkEmail(signUpModel.email!, fromPage ?? '');

    resendButtonLoading = false;
    notifyListeners();
  }

  Future<void> _updateAuthToken(String token) async {
    authRepo!.saveUserToken(token);
    print('------------(update device token) -----from _updateAuthToken');

    await authRepo!.updateDeviceToken();
  }

  toggleIsNumberLogin({bool? value, bool isUpdate = true}) {
    if (value == null) {
      _isNumberLogin = !_isNumberLogin;
    } else {
      _isNumberLogin = value;
    }

    if (isUpdate) {
      notifyListeners();
    }
  }

  Future<ResponseModel> verifyProfileInfo(String userInput, String type) async {
    _isPhoneNumberVerificationButtonLoading = true;
    _verificationMsg = '';
    notifyListeners();
    ApiResponseModel apiResponse =
        await authRepo!.verifyProfileInfo(userInput, _verificationCode, type);
    ResponseModel? responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final ProfileProvider profileProvider =
          Provider.of<ProfileProvider>(Get.context!, listen: false);
      profileProvider.getUserInfo(true);
      showCustomSnackBarHelper(apiResponse.response!.data['message'],
          isError: false);
      responseModel = ResponseModel(true, 'verification');
    } else {
      _verificationMsg =
          ApiCheckerHelper.getError(apiResponse).errors![0].message;
      showCustomSnackBarHelper(_verificationMsg);
      responseModel = ResponseModel(false, _verificationMsg);
    }
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    return (responseModel);
  }

  Future<(ResponseModel, String?)> registerWithSocialMedia(String name,
      {required String email, String? phone}) async {
    _isPhoneNumberVerificationButtonLoading = true;
    _loginErrorMessage = '';
    notifyListeners();
    ApiResponseModel apiResponse = await authRepo!
        .registerWithSocialMedia(name, email: email, phone: phone);
    ResponseModel responseModel;
    String? token;
    String? tempToken;

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
      if (map.containsKey('token')) {
        token = map["token"];
      }
      if (map.containsKey('temp_token')) {
        tempToken = map["temp_token"];
      }

      if (token != null) {
        await _updateAuthToken(token);
        final ProfileProvider profileProvider =
            Provider.of<ProfileProvider>(Get.context!, listen: false);
        profileProvider.getUserInfo(true);
        responseModel = ResponseModel(true, 'verification');
      } else if (tempToken != null) {
        responseModel = ResponseModel(true, 'verification');
      } else {
        responseModel = ResponseModel(false, '');
      }
    } else {
      _loginErrorMessage =
          ApiCheckerHelper.getError(apiResponse).errors![0].message;
      showCustomSnackBarHelper(_loginErrorMessage);
      responseModel = ResponseModel(false, _loginErrorMessage);
    }
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    return (responseModel, tempToken);
  }

  Future<(ResponseModel?, String?)> existingAccountCheck(
      {String? email,
      required String phone,
      required int userResponse,
      required String medium}) async {
    _isPhoneNumberVerificationButtonLoading = true;
    notifyListeners();
    ApiResponseModel apiResponse = await authRepo!.existingAccountCheck(
        email: email, phone: phone, userResponse: userResponse, medium: medium);
    ResponseModel responseModel;
    String? token;
    String? tempToken;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;

      if (map.containsKey('token')) {
        token = map["token"];
      }

      if (map.containsKey('temp_token')) {
        tempToken = map["temp_token"];
      }

      if (token != null) {
        await _updateAuthToken(token);
        final ProfileProvider profileProvider =
            Provider.of<ProfileProvider>(Get.context!, listen: false);
        profileProvider.getUserInfo(true);
        responseModel = ResponseModel(true, 'token');
      } else if (tempToken != null) {
        responseModel = ResponseModel(true, 'tempToken');
      } else {
        responseModel = ResponseModel(true, '');
      }
    } else {
      _loginErrorMessage =
          ApiCheckerHelper.getError(apiResponse).errors![0].message;
      showCustomSnackBarHelper(_loginErrorMessage);
      responseModel = ResponseModel(false, _loginErrorMessage);
    }
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    return (responseModel, tempToken);
  }

  Future disableAccount({bool? temporaryDisabled}) async {
    _isLoading = true;
    notifyListeners();

    bool newStatus = temporaryDisabled ?? !isAvailable;
    ApiResponseModel response =
        await authRepo!.disableAccount(temporaryDisabled: newStatus);
    _isLoading = false;

    if (response.response!.statusCode == 200) {
      _isAvailable = !newStatus;
      showCustomSnackBarHelper(
          newStatus ? 'Status changed to Busy' : 'Status changed to Available',
          isError: false);

      // Update profile info to get latest status
      final ProfileProvider profileProvider =
          Provider.of<ProfileProvider>(Get.context!, listen: false);
      profileProvider.getUserInfo(true);
    } else {
      Get.context?.pop();
      ApiCheckerHelper.checkApi(response);
    }
    notifyListeners();
  }

  void togglePhoneNumberButton() {
    _isPhoneNumberVerificationButtonLoading =
        !_isPhoneNumberVerificationButtonLoading;
    notifyListeners();
  }

  void updateAvailabilityStatus(bool? status) {
    _isAvailable = status ?? true;
    notifyListeners();
  }
}
