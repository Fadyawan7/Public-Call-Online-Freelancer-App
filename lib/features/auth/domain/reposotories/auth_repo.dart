import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_restaurant/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_restaurant/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_restaurant/common/models/api_response_model.dart';
import 'package:flutter_restaurant/features/auth/domain/models/signup_model.dart';
import 'package:flutter_restaurant/features/auth/domain/models/social_login_model.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class AuthRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  AuthRepo({required this.dioClient, required this.sharedPreferences});

  // Future<ApiResponseModel> registration(SignUpModel signUpModel) async {
  //   try {
  //     print('=====REGISTERR===${signUpModel.toJson()}');
  //
  //     Response response = await dioClient!.post(
  //       AppConstants.registerUri,
  //       data: signUpModel.toJson(),
  //     );
  //     print('=====REGISTERR1===${response}');
  //
  //     return ApiResponseModel.withSuccess(response);
  //   } catch (e) {
  //     return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
  //   }
  // }


  Future<http.StreamedResponse> registration(SignUpModel signUpModel, String token) async {

    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.baseUrl}${AppConstants.registerUri}'));

    request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});
    Map<String, String> fields = {};
    fields.addAll(<String, String>{
      '_method': 'post',  'name': signUpModel.name!,'email': signUpModel.email!,'password': signUpModel.password!
    });

    request.fields.addAll(fields);
    http.StreamedResponse response = await request.send();
    return response;
  }

  Future<ApiResponseModel> login({String? userInput, String? password}) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.loginUri,
        data: {"email": userInput, "password": password},
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }



  Future<ApiResponseModel> registerWithSocialMedia(String name, {required String email,String? phone}) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.registerWithSocialMedia,
        data: {"name": name, "email": email, "phone": phone},
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> existingAccountCheck({String? email, required String phone, required int userResponse, required String medium}) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.existingAccountCheck,
        data: {"email": email, 'phone': phone,  "user_response": userResponse, "medium": medium},
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<void> subscribeTokenToTopic(token, topic) async {
    await dioClient?.post(AppConstants.subscribeToTopic, data: {"fcm_token": '$token'});
  }


  Future<ApiResponseModel> updateDeviceToken({String? fcmToken}) async {
    try {
      String? deviceToken = '@';

      if (defaultTargetPlatform == TargetPlatform.iOS) {
        FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
        NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
          alert: true, announcement: false, badge: true, carPlay: false,
          criticalAlert: false, provisional: false, sound: true,
        );
        if(settings.authorizationStatus == AuthorizationStatus.authorized) {
          deviceToken = (await getDeviceToken())!;
        }
      }else {
        deviceToken = (await getDeviceToken())!;
      }

      if(!kIsWeb){
        if(fcmToken == null) {
          FirebaseMessaging.instance.subscribeToTopic(AppConstants.topic);
        }else{
          FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.topic);
        }
      }else{
        await subscribeTokenToTopic(deviceToken, fcmToken ?? AppConstants.topic);
      }


      Map<String, dynamic> data = {"_method": "post", "fcm_token": fcmToken ?? deviceToken};

      debugPrint('eroor ====> $data');

      Response response = await dioClient!.post(
        AppConstants.tokenUri,
        data: data,
      );
      debugPrint('eroorr ====> ${response.data}');

      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<String?> getDeviceToken() async {
    String? deviceToken = '@';
    try{
      deviceToken = (await FirebaseMessaging.instance.getToken())!;

    }catch(error){
      debugPrint('eroor ====> $error');
    }
    return deviceToken;
  }

  // for forgot password
  Future<ApiResponseModel> forgetPassword(String email) async {
    try {
      Response response = await dioClient!.post(AppConstants.forgetPasswordUri, data: {"email": email});
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> verifyToken(String email, String token) async {
    try {
      Response response = await dioClient!.post(AppConstants.verifyTokenUri, data: {"email": email, "token": token});
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> resetPassword(String? mail, String? resetToken, String password, String confirmPassword, {required String type}) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.resetPasswordUri,
        data: {"_method": "put", "token": resetToken, "password": password, "password_confirmation": confirmPassword, "email": mail},
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // for verify email number
  Future<ApiResponseModel> checkEmail(String email) async {
    try {
      Response response = await dioClient!.post(AppConstants.checkEmailUri, data: {"email": email});
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> verifyEmail(String email, String token) async {
    try {
      Response response = await dioClient!.post(AppConstants.verifyEmailUri, data: {"email": email, "token": token});
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }



  //verify phone number

  Future<ApiResponseModel> checkPhone(String phone) async {
    try {
      Response response = await dioClient!.post(AppConstants.baseUrl + AppConstants.checkPhoneUri + phone, data: {"phone" : phone});
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> verifyPhone(String phone, String token) async {
    try {
      Response response = await dioClient!.post(
          AppConstants.verifyPhoneUri, data: {"phone": phone.trim(), "token": token});
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> verifyOtp(String phone, String token) async {
    try {
      Response response = await dioClient!.post(
          AppConstants.verifyOtpUri, data: {"phone": phone.trim(), "token": token});
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<ApiResponseModel> verifyProfileInfo(String userInput, String token, String type) async {
    try {
      print('=====EMAIL===${userInput}');
      Response response = await dioClient!.post(
          AppConstants.verifyOtpUri, data: {"email": userInput, "token": token});
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }




  // for  user token
  Future<void> saveUserToken(String token) async {
    dioClient!.updateHeader(getToken: token);

    try {

      await sharedPreferences!.setString(AppConstants.token, token);
    } catch (e) {
      rethrow;
    }
  }

  String getUserToken() {
    return sharedPreferences!.getString(AppConstants.token) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences!.containsKey(AppConstants.token);
  }

  Future<bool> clearSharedData() async {
    if(!kIsWeb) {
      Future.delayed(const Duration(milliseconds: 100)).then((value) async =>
      await FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.topic));
    }

   try{
     await dioClient!.post(
       AppConstants.updateProfileUri,
       data: {"_method": "put", "fcm_token": '@'},
     );
   }catch(error){
      debugPrint('error $error');
   }
    print('------------(update device token) -----from clearSharedData|repo');

    await updateDeviceToken(fcmToken: '@');
    await sharedPreferences!.remove(AppConstants.token);
    await sharedPreferences!.remove(AppConstants.cartList);
    await sharedPreferences!.remove(AppConstants.userAddress);
    await sharedPreferences!.remove(AppConstants.searchAddress);
    return true;
  }

  Future<void> saveUserNumberAndPassword(String userData) async {
    try {
      await sharedPreferences!.setString(AppConstants.userLogData, userData);
    } catch (e) {
      rethrow;
    }
  }

  String getUserLogData() {
    return sharedPreferences!.getString(AppConstants.userLogData) ?? "";
  }

  Future<bool> clearUserLog() async {
    return await sharedPreferences!.remove(AppConstants.userLogData);
  }

  Future<ApiResponseModel> deleteUser() async {
    try{
      Response response = await dioClient!.delete(AppConstants.customerRemove);
      return ApiResponseModel.withSuccess(response);
    }catch(e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }

  }

  Future<ApiResponseModel> disableAccount({bool temporaryDisabled = false}) async {
    try{
      Response response = await dioClient!.post(
        AppConstants.disableAccount,
        data: {'temporary_disabled': temporaryDisabled},
      );
      return ApiResponseModel.withSuccess(response);
    }catch(e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  

  Future<ApiResponseModel> socialLogin(SocialLoginModel socialLogin) async {
    try {
      print('------------(update device token) -----from socialLogin ${socialLogin.toJson()}');

      Response response = await dioClient!.post(
        AppConstants.socialLogin,
        data: socialLogin.toJson(),
      );
      print('------------(update device token) -----from socialLogin ${response}');

      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }



  Future<ApiResponseModel> firebaseAuthVerify({required String phoneNumber, required String session, required String otp, required bool isForgetPassword}) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.firebaseAuthVerify,
        data: {
          'sessionInfo' : session,
          'phoneNumber' : phoneNumber,
          'code' : otp,
          'is_reset_token' : isForgetPassword ? 1 : 0,
        },
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }




}
