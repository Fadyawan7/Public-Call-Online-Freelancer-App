import 'package:flutter_restaurant/common/models/product_model.dart';

class BookingDetailsModel {
  int? _id;
  String? _bookingId;
  int? _userId;
  int? _freelancerId;


  String? _date;
  String? _time;

  String? _status;
  String? _description;
  String? _attachmentUrl;
  List<String>? _attachments;
  String? _userName;
  String? _userImage;
  String? _freelancerImage;
  String? _freelancerName;
  List<Reviews>? _reviews;
  String? _freelancerViewId;
  bool? _userReview;
  bool? _freelancerReview;
  DeliveryAddress? _deliveryAddress;

  BookingDetailsModel(
      {
        int? id,
        String? bookingId,
        int? userId,
        int? takerId,

        int? freelancerId,
        String? date,
        String? time,
        String? status,
        String? description,
        String? attachmentUrl,
        List<String>? attachments,
        String? userName,
        String? userImage,
        String? freelancerImage,
        String? freelancerName,
        List<Reviews>? reviews,
        String? freelancerViewId,
        bool? userReview,
        bool? freelancerReview,
        DeliveryAddress? deliveryAddress,

      }) {
    _id = id;
    _bookingId = bookingId;
    _userId = userId;

    _freelancerId = freelancerId;
    _date = date;
    _time = time;
    _status = status;
    _description = description;
    _attachmentUrl = attachmentUrl;
    _attachments = attachments;
    _userName = userName;
    _userImage = userImage;
    _freelancerImage = freelancerImage;
    _freelancerName = freelancerName;
    _reviews =reviews;
    _freelancerViewId = freelancerViewId;
    _freelancerReview = freelancerReview;
    _freelancerViewId = freelancerViewId;
    _deliveryAddress = deliveryAddress;

  }

  int? get id => _id;


  String? get bookingId => _bookingId;
  int? get userId => _userId;
  int? get freelancerId => _freelancerId;
  List<Reviews>? get reviews => _reviews;

  String? get date => _date;
  String? get time => _time;
  String? get status => _status;
  String? get description => _description;
  String? get attachmentUrl => _attachmentUrl;
  List<String>? get attachments => _attachments;
  String? get userName => _userName;
  String? get userImage => _userImage;
  String? get freelancerImage => _freelancerImage;
  String? get freelancerName => _freelancerName;
  String? get freelancerViewId => _freelancerViewId;
  bool? get userReview => _userReview;
  bool? get freelancerReview => _freelancerReview;
  DeliveryAddress? get deliveryAddress => _deliveryAddress;

  BookingDetailsModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _bookingId = json['booking_id'];
    _userId = json['user_id'];

    _freelancerId = json['freelancer_id'];
    _date = json['date'];
    _time = json['time'];
    _status = json['status'];
    _description = json['description'];
    _attachmentUrl = json['attachments_url'];
      _attachments = json["attachments"] != null  // Handle potential nulls!
          ? List<String>.from(json["attachments"])
          : [];
    if (json['reviews'] != null) {
      _reviews = [];
      json['reviews'].forEach((v) {
        _reviews!.add(Reviews.fromJson(v));
      });
    }
    _userName = json['user_name'];
    _userImage = json['user_image'];
    _freelancerName = json['freelancer_name'];
    _freelancerImage = json['freelancer_image'];
    _freelancerViewId = json['freelancer_view_id'];
    _freelancerReview = json['freelancer_review'];
    _userReview = json['user_review'];
    _deliveryAddress = json['address'] != null
        ? DeliveryAddress.fromJson(json['address'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['booking_id'] = _bookingId;
    data['user_id'] = _userId;

    data['freelancer_id'] = _freelancerId;
    data['date'] = _date;
    data['time'] = _time;
    data['status'] = _status;
    data['description'] = _description;
    data['attachments_url'] = _attachmentUrl;
    data['attachments'] = List<dynamic>.from(attachments!.map((x) => x));
    data['user_name'] = _userName;
    data['user_image'] = _userImage;
    data['freelancer_name'] = _freelancerName;
    data['freelancer_image'] = _freelancerImage;
    if (_reviews != null) {
      data['reviews'] = _reviews!.map((v) => v.toJson()).toList();
    }
    data['freelancer_view_id'] = _freelancerViewId;
    data['freelancer_review'] = _freelancerReview;
    data['user_review'] = _userReview;
    if (_deliveryAddress != null) {
      data['address'] = _deliveryAddress!.toJson();
    }
    return data;
  }
}

class Reviews {
  int? _id;
  int? _takerId;

  int? _rating;
  String? _comment;
  String? _giverName;
  String? _giverImage;
  String? _takerName;
  String? _takerImage;
  String? _createdAt;

  Reviews(
      {
        int? id,
        int? rating,
        String? comment,
        String? giverName,
        String? giverImage,
        String? takerName,
        String? takerImage,
        String? createdAt,

      }) {
    _id = id;
    _takerId = takerId;

    _rating = rating;
    _comment = comment;
    _giverName = giverName;
    _giverImage = giverImage;
    _takerName = takerName;
    _takerImage = takerImage;
    _createdAt = createdAt;
  }

  int? get id => _id;
  int? get rating => _rating;
  String? get comment => _comment;
  String? get giverName => _giverName;
  String? get giverImage => _giverImage;
  String? get takerName => _takerName;
  String? get takerImage => _takerImage;
  int? get takerId => _takerId;
  String? get createdAt => _createdAt;

  Reviews.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _takerId = json['taker_id'];

    _rating = json['rating'];
    _comment = json['comment'];
    _giverName = json['giver_name'];
    _giverImage = json['giver_image'];
    _takerName = json['taker_name'];
    _takerImage = json['taker_image'];
    _createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['rating'] = _rating;
    data['taker_id'] = _takerId;

    data['comment'] = _comment;
    data['giver_name'] = _giverName;
    data['giver_image'] = _giverImage;
    data['taker_name'] = _takerName;
    data['taker_image'] = _takerImage;
    data['created_at'] = _createdAt;
    return data;
  }
}

class DeliveryAddress {
  int? _id;
  int? _userId;
  String? _contactPersonName;
  String? _contactPersonNumber;
  String? _address;
  String? _addressType;
  String? _road;
  String? _house;
  String? _floor;

  String? _latitude;
  String? _longitude;
  String? _createdAt;
  String? _updatedAt;



  DeliveryAddress(
      {int? id,
        String? addressType,
        String? contactPersonNumber,
        String? address,
        String? latitude,
        String? longitude,
        String? createdAt,
        String? updatedAt,
        int? userId,
        String? contactPersonName,
        String? road,
        String? house,
        String? floor,
      }) {
    _id = id;
    _addressType = addressType;
    _contactPersonNumber = contactPersonNumber;
    _address = address;
    _latitude = latitude;
    _longitude = longitude;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _userId = userId;
    _contactPersonName = contactPersonName;
    _road = road;
    _house =house;
    _floor = floor;
  }

  int? get id => _id;
  String? get addressType => _addressType;
  String? get contactPersonNumber => _contactPersonNumber;
  String? get address => _address;
  String? get latitude => _latitude;
  String? get longitude => _longitude;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  int? get userId => _userId;
  String? get contactPersonName => _contactPersonName;
  String? get house => _house;
  String? get road => _road;
  String? get floor => _floor;


  DeliveryAddress.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _addressType = json['address_type'];
    _contactPersonNumber = json['contact_person_number'];
    _address = json['address'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _userId = json['user_id'];
    _contactPersonName = json['contact_person_name'];
    _road = json['road'];
    _house = json['house'];
    _floor = json['floor'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['address_type'] = _addressType;
    data['contact_person_number'] = _contactPersonNumber;
    data['address'] = _address;
    data['latitude'] = _latitude;
    data['longitude'] = _longitude;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['user_id'] = _userId;
    data['contact_person_name'] = _contactPersonName;
    data['road'] = _road;
    data['house'] = _house;
    data['floor'] = _floor;

    return data;
  }
}