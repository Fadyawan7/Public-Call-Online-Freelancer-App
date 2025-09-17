import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_restaurant/common/enums/data_source_enum.dart';
import 'package:flutter_restaurant/common/models/api_response_model.dart';
import 'package:flutter_restaurant/data/datasource/local/cache_response.dart';
import 'package:flutter_restaurant/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_restaurant/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_restaurant/helper/db_helper.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataSyncRepo {
  final DioClient dioClient;
  final SharedPreferences? sharedPreferences;

  DataSyncRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponseModel<T>> fetchData<T>(String uri, DataSourceEnum source) async {
    try {
      return await _fetchFromClient<T>(uri) ;
    } catch (e) {
      debugPrint('DataSyncRepo: ===> ${source} $e ($uri)');

      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel<T>> _fetchFromClient<T>(String uri) async {
    final response = await dioClient.get(uri);

    return ApiResponseModel.withSuccess(response as T);
  }


}
