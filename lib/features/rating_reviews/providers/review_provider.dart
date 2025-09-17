
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/api_response_model.dart';
import 'package:flutter_restaurant/common/models/booking_details_model.dart';
import 'package:flutter_restaurant/common/models/response_model.dart';
import 'package:flutter_restaurant/features/booking/domain/models/booking_model.dart';
import 'package:flutter_restaurant/features/booking/domain/reposotories/booking_repo.dart';
import 'package:flutter_restaurant/features/booking/providers/booking_provider.dart';
import 'package:flutter_restaurant/features/rating_reviews/domain/models/review_body_model.dart';
import 'package:flutter_restaurant/helper/api_checker_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


class ReviewProvider extends ChangeNotifier {
  final BookingRepo? bookingRepo;

  ReviewProvider({required this.bookingRepo});

  bool _isReviewSubmitted = false;
  List<int> _ratingList = [];
  List<Reviews>? _reviewList = [];
  List<bool> _loadingList = [];
  List<bool> _submitList = [];
  bool _isLoading = false;
  int _rateIndex = -1;

  bool get isReviewSubmitted => _isReviewSubmitted;
  List<int> get ratingList => _ratingList;



  List<Reviews>? get reviewList => _reviewList;
  List<bool> get loadingList => _loadingList;
  List<bool> get submitList => _submitList;
  bool get isLoading => _isLoading;
  int get rateIndex => _rateIndex;


  void initRatingData(List<BookingDetailsModel> bookingDetailsList) {
    _ratingList = [];
    _loadingList = [];
    _submitList = [];
    for (int i = 0; i < bookingDetailsList.length; i++) {
      _ratingList.add(0);
      _loadingList.add(false);
      _submitList.add(false);
    }
  }

  void setRatingIndex(int index, {bool isUpdate = true}) {
    _rateIndex = index;

    if(isUpdate) {
      notifyListeners();
    }
  }

  void setRating(int index, int rate) {
    _ratingList[index] = rate;
    notifyListeners();
  }




  Future<ResponseModel> submitBookingReview(ReviewBody reviewBody) async {
    _isLoading = true;
    notifyListeners();
    ApiResponseModel response = await bookingRepo!.submitReview(reviewBody);
    ResponseModel responseModel;
    if (response.response != null && response.response!.statusCode == 200) {
      responseModel = ResponseModel(true, getTranslated('review_submitted_successfully', Get.context!));
      updateSubmitted(true);

      notifyListeners();
    } else {
      responseModel = ResponseModel(false, ApiCheckerHelper.getError(response).errors?.first.message);
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  updateSubmitted(bool value) {
    _isReviewSubmitted = value;
  }


  Future<void> getFreelancerReviewList(int? freelancerId) async {
    _reviewList = [];

    _isLoading = true;
    notifyListeners();
    ApiResponseModel apiResponse = await bookingRepo!.getFreelancerReviewList(freelancerId);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {

      apiResponse.response!.data.forEach((review) {
        Reviews reviews = Reviews.fromJson(review);
        reviews = Reviews.fromJson(review);
        _reviewList!.add(reviews);
      });

    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }
    _isLoading = false;

    notifyListeners();
  }

}

