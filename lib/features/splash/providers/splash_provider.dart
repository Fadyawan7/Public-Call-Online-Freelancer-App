import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/enums/data_source_enum.dart';
import 'package:flutter_restaurant/common/models/api_response_model.dart';
import 'package:flutter_restaurant/common/models/config_model.dart';
import 'package:flutter_restaurant/common/models/offline_payment_model.dart';
import 'package:flutter_restaurant/common/providers/data_sync_provider.dart';
import 'package:flutter_restaurant/data/datasource/local/cache_response.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/splash/domain/reposotories/splash_repo.dart';
import 'package:flutter_restaurant/helper/date_converter_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:provider/provider.dart';

import '../../../common/models/policy_model.dart';
import '../../../helper/api_checker_helper.dart';

class SplashProvider extends DataSyncProvider {
  final SplashRepo? splashRepo;
  SplashProvider({required this.splashRepo});

  ConfigModel? _configModel;

  final DateTime _currentTime = DateTime.now();
  PolicyModel? _policyModel;
  bool _cookiesShow = true;
  List<OfflinePaymentModel?>? _offlinePaymentModelList;





  ConfigModel? get configModel => _configModel;

  DateTime get currentTime => _currentTime;
  PolicyModel? get policyModel => _policyModel;
  bool get cookiesShow => _cookiesShow;
  List<OfflinePaymentModel?>? get offlinePaymentModelList => _offlinePaymentModelList;




  bool isLoading = false;

  Future<ConfigModel?> initConfig(BuildContext context, DataSourceEnum source) async {
      ApiResponseModel<Response> apiResponseModel = await splashRepo!.getConfig(source: DataSourceEnum.client);
      print('===COINFIG');
      if(apiResponseModel.isSuccess) {
        _configModel = ConfigModel.fromJson(apiResponseModel.response?.data);

        if(context.mounted) {
          await _onConfigAction(context);
        }

      }

    return _configModel;
  }

  Future<void> _onConfigAction(BuildContext context) async {
    if (configModel != null) {

      if(context.mounted){
        final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);

      }



      if(!kIsWeb && context.mounted) {
        if(!Provider.of<AuthProvider>(context, listen: false).isLoggedIn()){
          await Provider.of<AuthProvider>(context, listen: false).updateToken();
        }
      }


      notifyListeners();

    }
  }




  Future<bool> initSharedData() {
    return splashRepo!.initSharedData();
  }

  Future<bool> removeSharedData() {
    return splashRepo!.removeSharedData();
  }


  Future<void> getPolicyPage() async {

    fetchAndSyncData(
      fetchFromLocal: ()=> splashRepo!.getPolicyPage(source: DataSourceEnum.local),
      fetchFromClient: ()=> splashRepo!.getPolicyPage(source: DataSourceEnum.client),
      onResponse: (data, _){
        _policyModel = PolicyModel.fromJson(data);
        notifyListeners();
      },
    );

  }

}