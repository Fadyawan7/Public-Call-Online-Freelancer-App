import 'dart:convert';
import 'dart:io';
import 'package:flutter_restaurant/features/rating_reviews/domain/models/review_body_model.dart';
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

class BookingRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  BookingRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponseModel> getBookingList(String? status) async {
    try {

      final response = await dioClient!.get('${AppConstants.bookingListUri}'
      '?status=${status}');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getFreelancerReviewList(int? freelancerId) async {
    try {

      final response = await dioClient!.get('${AppConstants.freelancerReviewUri}$freelancerId');

      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getBookingDetails(String bookingID) async {
    try {
      final response = await dioClient!.get('${AppConstants.bookingDetailsUri}$bookingID');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<ApiResponseModel> updateBookingStatus(String bookingID ,String? status) async {
    try {
      Map<String, dynamic> data = <String, dynamic>{};
      data['booking_id'] = int.parse(bookingID);
      data['status'] = status;
      data['_method'] = 'post';
      final response = await dioClient!.post(AppConstants.updateBookingStatusUri, data: data);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }



  Future<http.StreamedResponse> placeBooking(
      PlaceBookingBody bookingBody,
      List<String> imageList,
      String token,
      ) async {
    // Create a MultipartRequest
    http.MultipartRequest request = http.MultipartRequest(
      'POST',
      Uri.parse('${AppConstants.baseUrl}${AppConstants.placeBookingUri}'),
    );

    // Add headers
    request.headers.addAll(<String, String>{
      'Authorization': 'Bearer $token',
    });

    // Convert bookingBody to a map
    Map<String, dynamic> data = bookingBody.toJson();
 print("======BOOKINGDATA====${data}");
    // Add fields to the request
    request.fields.addAll(<String, String>{
      '_method': 'post',
      'freelancer_id': data['freelancer_id'].toString(),
      'time': data['time'],
      'date': data['date'],
      'description': data['description'],
      'address_id': data['address_id'].toString(),

    });

    // Add each image to the request
    for (String path in imageList) {
      request.files.add(await http.MultipartFile.fromPath(
        'attachments[]', // Use "attachments[]" for Laravel to handle multiple files
        path,
        filename: "${DateTime.now().millisecondsSinceEpoch}.${path.split('.').last}",
      ));
    }

    // Send the request
    http.StreamedResponse response = await request.send();
    return response;
  }

  Future<ApiResponseModel> submitReview(ReviewBody reviewBody) async {
    try {
      final response = await dioClient!.postMultipart(AppConstants.reviewUri, data: reviewBody.toJson());
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }
}

