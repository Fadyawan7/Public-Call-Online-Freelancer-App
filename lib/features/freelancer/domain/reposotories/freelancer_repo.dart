import 'package:flutter_restaurant/common/models/response_model.dart';
import 'package:flutter_restaurant/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_restaurant/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_restaurant/common/models/api_response_model.dart';
import 'package:flutter_restaurant/features/apply_freelancer/domain/models/apply_freelancer_model.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FreelancerRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  FreelancerRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponseModel> getFreelancerList({int? categoryId}) async {
    try {
      final Map<String, dynamic> queryParams = {};

      // Only add category_id if it's not null and not -1
      if (categoryId != null && categoryId != -1) {
        queryParams['category_id'] = categoryId;
      }

      final response = await dioClient!.get(
        AppConstants.freelancerListUri,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> applyFreelancer(ApplyFreelancerModel applyFreelancerModelRequest) async {
    try {
      Map<String, dynamic> data = applyFreelancerModelRequest.toJson();
      print('=====RESPONSE====${data}');

      final response = await dioClient!.post(AppConstants.applyFreelancerUri, data: data);
      print('=====RESPONSE====${response.data}');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> searchFreelancer(String text) async {
    try {
      final response = await dioClient!.get('${AppConstants.freelancerListUri}?keyword=$text');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }
  Future<ApiResponseModel> getFreelancerDetails(String freelancerID) async {
    try {
      final response = await dioClient!.get('${AppConstants.freelancerDetailUri}$freelancerID');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }
}