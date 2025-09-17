import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_restaurant/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_restaurant/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_restaurant/common/models/api_response_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';


class ChatRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  ChatRepo({required this.dioClient, required this.sharedPreferences});




  Future<ApiResponseModel> startNewChat(int userId) async {
    try {
      Map<String, dynamic> data = <String, dynamic>{};
      data['user_id'] = userId;
      data['_method'] = 'post';
      final response = await dioClient!.post(AppConstants.startNewChatUrl, data: data);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getChatList() async {
    try {
      final response = await dioClient!.get(AppConstants.getChatListUri);
      return ApiResponseModel.withSuccess(response);

    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));

    }
  }

  Future<ApiResponseModel> getConversationList(int chatId) async {
    try {
      final response = await dioClient!.get('${AppConstants.getConversationsUrl}$chatId/messages');
      print('====MESSAGES===${response.data}');
      return ApiResponseModel.withSuccess(response);

    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));

    }
  }
  Future<http.StreamedResponse> sendMessage(String message, File? file, int? chatId, String token) async {
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.baseUrl}${AppConstants.sendMessageUrl}$chatId/messages'));
    request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});
    if(file != null) {
      request.files.add(http.MultipartFile('file', file.readAsBytes().asStream(), file.lengthSync(), filename: file.path.split('/').last));
    }

    Map<String, String> fields = {};


    fields.addAll(<String, String>{
      'message': message,
    });
    request.fields.addAll(fields);
    http.StreamedResponse response = await request.send();
    return response;
  }

  Future<ApiResponseModel> deleteChat(int chatId) async {
    try {
      Map<String, dynamic> data = <String, dynamic>{};
      data['chatId'] = chatId;
      data['_method'] = 'delete';
      final response = await dioClient!.post('${AppConstants.deleteUrl}/$chatId', data: data);
      print('=====DELETECHAT====${response.data}');

      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }
}