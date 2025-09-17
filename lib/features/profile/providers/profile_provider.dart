import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/api_response_model.dart';
import 'package:flutter_restaurant/common/models/city_model.dart';
import 'package:flutter_restaurant/common/models/country_model.dart';
import 'package:flutter_restaurant/common/models/response_model.dart';
import 'package:flutter_restaurant/features/profile/domain/models/userinfo_model.dart';
import 'package:flutter_restaurant/features/profile/domain/reposotories/profile_repo.dart';
import 'package:flutter_restaurant/helper/api_checker_helper.dart';
import 'package:flutter_restaurant/helper/get_response_error_message.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ProfileProvider with ChangeNotifier {
  final ProfileRepo? profileRepo;

  ProfileProvider({required this.profileRepo});

  UserInfoModel? _userInfoModel;

  UserInfoModel? get userInfoModel => _userInfoModel;
  set setUserInfoModel(UserInfoModel? user) => _userInfoModel = user;

  List<CountryModel>? _countryList;
  List<CountryModel>? get countryList => _countryList;

  List<CityModel>? _cityList = [];
  List<CityModel>? get cityList => _cityList;

  int _selectedCountryID = -1;
  int _loggedInUserId = -1;
  bool? _isFreelancer = false;
  bool? get isFreelancer => _isFreelancer;

  int? get loggedInUserId => _loggedInUserId;

  int? get selectedCountryID => _selectedCountryID;
  int _selectedCityID = -1;
  int? get selectedCityID => _selectedCityID;
  bool _isCountryChanged = false;
  String? _countryCode;
  String? get countryCode => _countryCode;
  bool get isCountryChanged => _isCountryChanged;

  void setCountryID({int? countryID,String? selectedCountryCode ,bool isUpdate = true, bool isReload = false}) {
    if(isReload){
      _selectedCountryID = -1;
    }else{
      _selectedCountryID = countryID!;
      _countryCode = selectedCountryCode;
      _isCountryChanged = true;
    }
    if(isUpdate){
      notifyListeners();
    }
  }


  void setCityID({int? cityID,bool isUpdate = true, bool isReload = false}) {
    if(isReload){
      _selectedCityID = -1;
    }else{
      _selectedCityID = cityID!;
    }
    if(isUpdate){
      notifyListeners();
    }
  }


  void resetCountryID() {
    _selectedCountryID = -1;
    notifyListeners();

  }
  void resetCityID() {
    _selectedCityID = -1;
    notifyListeners();

  }

  Future<void> getCountryList() async {
    if(_countryList == null ) {
      _isLoading = true;

      ApiResponseModel apiResponse = await profileRepo!.getCountryList();
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _countryList = [];
         apiResponse.response.data.forEach((country) => _countryList!.add(CountryModel.fromJson(country)));


      } else {
        ApiCheckerHelper.checkApi(apiResponse);
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getCityList(int? countryID) async {
      _isLoading = true;
      ApiResponseModel apiResponse = await profileRepo!.getCityList(countryID);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _cityList = [];
        apiResponse.response.data.forEach((city) => _cityList!.add(CityModel.fromJson(city)));
        print('=====CITY ===${_cityList}');
      } else {
        ApiCheckerHelper.checkApi(apiResponse);
      }
      _isLoading = false;
      notifyListeners();

  }

  Future<void> getUserInfo(bool reload, {bool isUpdate = true}) async {
    if(reload){
      _userInfoModel = null;
    }

    if(_userInfoModel == null){
      ApiResponseModel apiResponse = await profileRepo!.getUserInfo();
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _userInfoModel = UserInfoModel.fromJson(apiResponse.response!.data);
        _loggedInUserId = _userInfoModel!.id!;
        _isFreelancer = _userInfoModel!.userType == 'freelancer';
      } else {
        ApiCheckerHelper.checkApi(apiResponse);
      }
    }

    if(isUpdate){
      notifyListeners();
    }

  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<ResponseModel> updateUserInfo(UserInfoModel updateUserModel, File? file, String token) async {
    _isLoading = true;
    notifyListeners();
    ResponseModel responseModel;

    http.StreamedResponse response = await profileRepo!.updateProfile(updateUserModel, file, token);
    Map map = jsonDecode(await response.stream.bytesToString());
    print("====REESPONSE===${map}");

    if (response.statusCode == 200) {


      String? message = map["message"];
      _userInfoModel = updateUserModel;
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

  Future<ResponseModel> updateUserPassword(String password,String confirmPassword, String token) async {
    _isLoading = true;
    notifyListeners();
    ResponseModel responseModel;

    http.StreamedResponse response = await profileRepo!.updatePassword( password,confirmPassword, token);
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

}
