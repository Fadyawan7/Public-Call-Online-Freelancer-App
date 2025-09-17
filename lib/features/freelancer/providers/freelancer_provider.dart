import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/api_response_model.dart';

import 'package:flutter_restaurant/common/models/response_model.dart';
import 'package:flutter_restaurant/features/apply_freelancer/domain/models/apply_freelancer_model.dart';
import 'package:flutter_restaurant/features/freelancer/domain/models/freelancer_model.dart';
import 'package:flutter_restaurant/features/freelancer/domain/reposotories/freelancer_repo.dart';
import 'package:flutter_restaurant/helper/api_checker_helper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FreelancerProvider extends ChangeNotifier {
  final FreelancerRepo? freelancerRepo;
  final SharedPreferences? sharedPreferences;
  FreelancerProvider({ required this.sharedPreferences,required this.freelancerRepo});

  List<FreelancerModel>? _freelancerList;
  ResponseModel? _responseModel;
  bool _isLoading = false;
  int _selectedCategoryID = -1;
  DateTime? now = DateTime.now();
  int? get selectedCategoryID => _selectedCategoryID;
  FreelancerModel? _freelancerDetails;
  List<FreelancerModel> _predictionList = [];

  FreelancerModel? _selectedFreelancer;



  ApplyFreelancerModel? _applyFreelancerModel;
  FreelancerModel? get freelancerDetails => _freelancerDetails;

  ApplyFreelancerModel? get applyFreelancerModel => _applyFreelancerModel;

  FreelancerModel?  get selectedFreelancer => _selectedFreelancer;


  List<FreelancerModel>? get freelancerList => _freelancerList;
  ResponseModel? get responseModel => _responseModel;
  bool get isLoading => _isLoading;

  void setSelectedFreelancer({FreelancerModel? freelancer}) {
    _selectedFreelancer = freelancer ?? null;
    notifyListeners();
  }
  Future<void> getFreelancerList({int? categoryId}) async {
    try {
      final ApiResponseModel apiResponse = await freelancerRepo!.getFreelancerList(categoryId: categoryId);

      if (apiResponse.response?.statusCode == 200) {
        _freelancerList = (apiResponse.response!.data as List)
            .map((freelancer) => FreelancerModel.fromJson(freelancer))
            .toList();
      } else {
        ApiCheckerHelper.checkApi(apiResponse);
      }
    } catch (e) {
      // Handle any potential errors
      debugPrint('Error fetching freelancer list: $e');
      // You might want to set an error state here
    } finally {
      notifyListeners();
    }
  }

  void setCategoryID({int? categoryID, bool isUpdate = true, bool isReload = false}) {
    if(isReload){
      _selectedCategoryID = -1;
    }else{
      _selectedCategoryID = categoryID!;
    }
    if(isUpdate){
      notifyListeners();
    }
  }

  void resetCategoryID() {
    _selectedCategoryID = -1;
    notifyListeners();

  }



  Future<List<FreelancerModel>> searchFreelancer(BuildContext context, String text) async {
    if(text.isNotEmpty) {
      ApiResponseModel apiResponse = await freelancerRepo!.searchFreelancer(text);

      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _predictionList = [];
        apiResponse.response!.data.forEach((freelancer) {
          FreelancerModel freelancerModel = FreelancerModel.fromJson(freelancer);
          freelancerModel = FreelancerModel.fromJson(freelancer);

          _predictionList.add(freelancerModel);

        });
      } else {
        ApiCheckerHelper.checkApi(apiResponse);
      }
    }
    return _predictionList;
  }
  Future<void> applyFreelancer(ApplyFreelancerModel applyFreelancerModelRequest, Function callback, {bool isUpdate = true}) async {
    _isLoading = true;
    if(isUpdate){
      notifyListeners();
    }

    ApiResponseModel apiResponse = await freelancerRepo!.applyFreelancer(
        applyFreelancerModelRequest
    );
    print('=====RESPONSE====${apiResponse.response}');

    _isLoading = false;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      String? message = apiResponse.response!.data['message'];
      callback(true, message);
    } else {
      callback(false, ApiCheckerHelper.getError(apiResponse).errors![0].message);
    }

    notifyListeners();
  }


  void stopLoader() {
    _isLoading = false;
    notifyListeners();
  }

  Future<ResponseModel?> getFreelancerDetails(String freelancerID, {bool isApiCheck = true}) async {
    _freelancerDetails = null;
    _isLoading = true;
    ApiResponseModel apiResponse;

    apiResponse = await freelancerRepo!.getFreelancerDetails(freelancerID);

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      try { // Add a try-catch block for JSON parsing errors
        _freelancerDetails = FreelancerModel.fromJson(apiResponse.response!.data);
        _responseModel = ResponseModel(true, apiResponse.response!.data.toString());
      } catch (e) {
        print("Error parsing JSON: $e");
        _freelancerDetails = FreelancerModel(id: -1); // Or handle the error differently
        _responseModel = ResponseModel(false, "Error parsing booking details.");
      }
    } else {
      _freelancerDetails = FreelancerModel(id: -1);
      if (isApiCheck) {
        ApiCheckerHelper.checkApi(apiResponse);
      }
    }

    _isLoading = false;
    notifyListeners();
    return _responseModel;
  }

  double getDistanceBetween(LatLng startLatLng, LatLng endLatLng){
    return Geolocator.distanceBetween(
      startLatLng.latitude, startLatLng.longitude, endLatLng.latitude, endLatLng.longitude,
    );
  }

}