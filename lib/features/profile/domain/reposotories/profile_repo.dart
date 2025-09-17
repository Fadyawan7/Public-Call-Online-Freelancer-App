import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_restaurant/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_restaurant/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_restaurant/common/models/api_response_model.dart';
import 'package:flutter_restaurant/features/profile/domain/models/userinfo_model.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepo{
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  ProfileRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponseModel> getAddressTypeList() async {
    try {
      List<String> addressTypeList = [
        'Select Address type',
        'Home',
        'Office',
        'Other',
      ];
      Response response = Response(requestOptions: RequestOptions(path: ''), data: addressTypeList, statusCode: 200);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getUserInfo() async {
    try {

      final response = await dioClient!.get(AppConstants.customerInfoUri);

      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getCountryList() async {
    try {

      final response = await dioClient!.get(AppConstants.countryListUri);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getCityList(int? countryID) async {
    try {

      final response = await dioClient!.get('${AppConstants.cityListUri}?country_id=$countryID');
      print('=====USERCITIES====${response.data}');

      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<http.StreamedResponse> updateProfile(UserInfoModel userInfoModel,File? file, String token) async {

    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.baseUrl}${AppConstants.updateProfileUri}'));

    request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});
    if(file != null) {
      request.files.add(http.MultipartFile('image', file.readAsBytes().asStream(), file.lengthSync(), filename: file.path.split('/').last));
    }

    Map<String, String> fields = {};

      fields.addAll(<String, String>{
        '_method': 'post', 'name': userInfoModel.name!,  'phone': userInfoModel.phone!, 'email': userInfoModel.email!,'country_id':userInfoModel.countryId!.toString(),'city_id':userInfoModel.cityId!.toString()
      });

      if(userInfoModel.userType == 'freelancer'){
        fields.addAll(<String, String>{
          'about': userInfoModel.aboutMe!,  'whatsapp_number': userInfoModel.whatsapp!
        });
      }


    request.fields.addAll(fields);
    http.StreamedResponse response = await request.send();
    return response;
  }

  Future<http.StreamedResponse> updatePassword( String password,String confirmPassword, String token) async {

    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.baseUrl}${AppConstants.updatePasswordUri}'));

    request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});
    Map<String, String> fields = {};
      fields.addAll(<String, String>{
        '_method': 'post',  'new_password': password,'new_password_confirmation': confirmPassword,
      });

    request.fields.addAll(fields);
    http.StreamedResponse response = await request.send();
    return response;
  }

}