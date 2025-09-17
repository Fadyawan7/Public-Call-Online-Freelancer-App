import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/api_response_model.dart';
import 'package:flutter_restaurant/common/models/booking_details_model.dart';
import 'package:flutter_restaurant/common/models/image_model.dart';

import 'package:flutter_restaurant/common/models/response_model.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/booking/domain/models/booking_model.dart';
import 'package:flutter_restaurant/features/booking/domain/models/place_booking_model.dart';
import 'package:flutter_restaurant/features/booking/domain/reposotories/booking_repo.dart';
import 'package:flutter_restaurant/features/freelancer/domain/models/day_date_model.dart';

import 'package:flutter_restaurant/helper/api_checker_helper.dart';
import 'package:flutter_restaurant/helper/get_response_error_message.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart';
import 'package:http/http.dart' as http;

class BookingProvider extends ChangeNotifier {
  final BookingRepo? bookingRepo;
  final SharedPreferences? sharedPreferences;
  BookingProvider({ required this.sharedPreferences,required this.bookingRepo});

  List<BookingModel>? _runningOrderList;
  List<BookingModel>? _historyOrderList;
  ResponseModel? _responseModel;
  bool _isLoading = false;
  List<String> _availableTimes = [];
  List<DayData> _days = [];
  int _selectDateSlot = 0;
  int _selectTimeSlot = -1;
  int _selectAddressIndex = -1;
  int? _selectAddressId ;

  String? _date ='';
  String? _timeSlot ='';

  List<BookingModel>? get runningOrderList => _runningOrderList;
  List<BookingModel>? get historyOrderList => _historyOrderList;
  ResponseModel? get responseModel => _responseModel;

  bool get isLoading => _isLoading;
  List<XFile>? _images= [];
  List<String> _listImagePath= [];
  BookingDetailsModel? _bookingDetails;

  List<XFile>? get images => _images;
  List<String>? get listImagePath => _listImagePath;

  int totalPickedImage = 0;
  int get selectDateSlot => _selectDateSlot;
  int get selectTimeSlot => _selectTimeSlot;
  int get selectAddressIndex => _selectAddressIndex;
  int? get selectAddressId => _selectAddressId;

  String? get date=>_date;
  String? get timeSlot=>_timeSlot;
  List<String>  get availableTimes => _availableTimes;
  List<DayData>  get days => _days;
  BookingDetailsModel? get bookingDetails => _bookingDetails;



  void checkAvailableTimes(String selectedDate) {
    final now = DateTime.now();
    try {
      // Parse the date string in a more robust way
      final inputDate = DateFormat('y-MM-dd').parse(selectedDate);
      if (inputDate.isBefore(now)) {
        // Date is in the past
        if (now.hour < 12) {
          // Current time is morning
          _availableTimes = ["evening", "afternoon"];
        } else {
          // Current time is afternoon or evening
          _availableTimes = ["afternoon"];
        }
      } else {
        // Date is in the future
        _availableTimes = ["morning", "evening", "afternoon"];
      }
    } on FormatException catch (e) {
      print("Invalid date format: $e");
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void checkAvailableDates() {
    final today = DateTime.now();

    // Clear the existing list of days
    _days.clear();

    // Generate 7 dates starting from today
    for (int i = 0; i < 7; i++) {
      final desiredDate = today.add(Duration(days: i));
      final formattedDate = DateFormat('EEE', 'en_US').format(desiredDate);
      final day = desiredDate.day;

      _days.add(DayData(
        index: i,
        date: desiredDate,
        formattedDate: formattedDate,
        day: day,
      ));
    }

    // Notify listeners after the frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void updateTimeSlot(int index,String? timeSlot) {
    _selectTimeSlot = index;
    if(timeSlot != null){
      _timeSlot = timeSlot;
    }
    Future.microtask(() {
      notifyListeners(); // Delay the notification until after the build
    });
  }

  void updateSelectedAddress(int index,int addressId) {
    _selectAddressIndex = index;
    _selectAddressId = addressId;
    Future.microtask(() {
      notifyListeners();
    });
  }


  void updateDateSlot(int index,String? date) {
    resetSlots();
    _selectDateSlot = index;
    if(date != null) {
      _date = date;
    }
    Future.microtask(() {
      notifyListeners(); // Delay the notification until after the build
    });
  }
  void resetSlots() {
    _selectDateSlot = 0;
    _selectTimeSlot = -1;
    Future.microtask(() {
      notifyListeners(); // Delay the notification until after the build
    });
  }

  Future<void> pickImage() async {

    _images= await ImagePicker().pickMultiImage(limit: 8);
    if(_images != null) {
      for(XFile file in _images!){
        _listImagePath.add(file.path);
      }
    }
    totalPickedImage = _listImagePath.length;
    Future.microtask(() {
      notifyListeners();
    });
  }


  void removeImage(int index,bool fromColor){
    _listImagePath.removeAt(index);
    notifyListeners();
  }



  Future<ResponseModel> placeBooking(PlaceBookingBody placeBookingBody,List<String> imageList ,Function callback, String token, {bool isUpdate = true}) async {
    _isLoading = true;
    notifyListeners();
    ResponseModel responseModel;
    http.StreamedResponse response = await bookingRepo!.placeBooking(placeBookingBody,  imageList, token);
    Map map = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      _listImagePath=[];
      String? message = map["message"];
      responseModel = ResponseModel(true, message);
      callback(true,'Booking booked Successfully !');
    } else {

      String errorMessage = getErrorMessage(map);

      responseModel = ResponseModel(false, errorMessage);
      callback(false,errorMessage);

    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<void> getBookingList(BuildContext context,String? status) async {
    _isLoading = true;
    print('====BOKKINGS status===${status}');

    ApiResponseModel apiResponse = await bookingRepo!.getBookingList(status);
    print('====BOKKINGS API===${apiResponse.response != null && apiResponse.response!.statusCode == 200}');

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _runningOrderList = [];
      apiResponse.response!.data.forEach((booking) {
        BookingModel bookingModel = BookingModel.fromJson(booking);
        bookingModel = BookingModel.fromJson(booking);
        _runningOrderList!.add(bookingModel);
      });

    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }
    _isLoading = false;

    notifyListeners();
  }
  void stopLoader() {
    _isLoading = false;
    notifyListeners();
  }
  Future<ResponseModel?> getBookingDetails(String bookingID, {bool isApiCheck = true}) async {
    _bookingDetails = null;
    _isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
    ApiResponseModel apiResponse;

    apiResponse = await bookingRepo!.getBookingDetails(bookingID);

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      try { // Add a try-catch block for JSON parsing errors
        _bookingDetails = BookingDetailsModel.fromJson(apiResponse.response!.data);
        _responseModel = ResponseModel(true, apiResponse.response!.data.toString());
      } catch (e) {
        print("Error parsing JSON: $e");
        _bookingDetails = BookingDetailsModel(id: -1); // Or handle the error differently
        _responseModel = ResponseModel(false, "Error parsing booking details.");
      }
    } else {
      _bookingDetails = BookingDetailsModel(id: -1);
      if (isApiCheck) {
        ApiCheckerHelper.checkApi(apiResponse);
      }
    }

    _isLoading = false;
    notifyListeners();
    return _responseModel;
  }


  void updateBookingStatus(String bookingID, String? status,Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponseModel apiResponse = await bookingRepo!.updateBookingStatus(bookingID,status);
    _isLoading = false;

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      BookingModel? bookingModel;
      for (var booking in _runningOrderList ?? []) {
        if(booking.id.toString() == bookingID) {
          bookingModel = booking;
          bookingID = booking.bookingId.toString();
        }
      }
      _runningOrderList?.remove(bookingModel);
      String? message = 'Booking $bookingID $status Successfully !';
      callback(message, true,bookingID);
    } else {
      callback(ApiCheckerHelper.getError(apiResponse).errors?.first.message, false, '-1');
    }
    notifyListeners();
  }


  Future<void> setPlaceBooking(String placeBooking)async{
    await sharedPreferences!.setString(AppConstants.placeOrderData, placeBooking);
  }
  String? getPlaceBooking(){
    return sharedPreferences!.getString(AppConstants.placeOrderData);
  }
  Future<void> clearPlaceBooking()async{
    await sharedPreferences!.remove(AppConstants.placeOrderData);
  }
}