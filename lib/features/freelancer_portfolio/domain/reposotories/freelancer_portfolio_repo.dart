import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:dio/dio.dart';
import 'package:flutter_restaurant/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_restaurant/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_restaurant/common/models/api_response_model.dart';
import 'package:flutter_restaurant/features/booking/domain/models/place_booking_model.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';

class FreelancerPortfolioRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  FreelancerPortfolioRepo({required this.dioClient, required this.sharedPreferences});


  Future<http.StreamedResponse> freelancerPortfolioAdd( File? file, String token) async {

    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.baseUrl}${AppConstants.freelancerPortfolioAddUri}'));

    request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});
    if(file != null) {
      request.files.add(http.MultipartFile('image', file.readAsBytes().asStream(), file.lengthSync(), filename: file.path.split('/').last));
    }
    print('=======PORTFOLIO ADDD ===${request.files.length}');

    http.StreamedResponse response = await request.send();
    return response;
  }

  Future<ApiResponseModel> getFreelancerPortfolioList() async {
    try {
      final response = await dioClient!.get(AppConstants.freelancerPortfolioListUri);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }
  Future<ApiResponseModel> deleteFreelancerPortfolio(int portfolioID ) async {
    try {
      Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = portfolioID;
      data['_method'] = 'post';

      final response = await dioClient!.post(AppConstants.freelancerPortfolioDeleteUri, data: data);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }
}

