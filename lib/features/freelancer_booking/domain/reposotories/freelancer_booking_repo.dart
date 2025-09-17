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

class FreelancerBookingRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  FreelancerBookingRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponseModel> getBookingList(String? status) async {
    try {

      final response = await dioClient!.get('${AppConstants.freelancerBookingListUri}'
      '?status=${status}');
      print('====BOKKINGS===${response.data}');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getOrderDetails(String orderID) async {
    try {
      final response = await dioClient!.get('${AppConstants.bookingDetailsUri}$orderID');
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

    // Add fields to the request
    request.fields.addAll(<String, String>{
      '_method': 'post',
      'freelancer_id': data['freelancer_id'].toString(),
      'time': data['time'],
      'date': data['date'],
      'description': data['description'],
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

}

