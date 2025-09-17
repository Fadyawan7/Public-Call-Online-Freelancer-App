import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_restaurant/common/models/config_model.dart';
import 'package:flutter_restaurant/common/models/product_model.dart';

class BookingModel {
  int? _id;
  int? _userId;
  int? _freelancerId;
  String? _bookingId;
  String? _status;
  String? _description;
  String? _freelancerName;
  String? _freelancerImage;
  String? _date;
  String? _time;



  BookingModel(
      {
        int? id,
        int? userId,
        int? freelancerId,
        String? bookingId,
        String? status,
        String? date,
        String? time,
        String? description,
        String? freelancerName,
        String? freelancerImage,




      }) {
    _id = id;
    _userId = userId;
    _freelancerId = freelancerId;
    _bookingId = bookingId;
    _status = status;
    _date=date;
    _description = description;
    _freelancerName = freelancerName;
    _freelancerImage = freelancerImage;
    _time = time;
  }

  int? get id => _id;
  int? get userId => _userId;
  int? get freelancerId => _freelancerId;
  String? get bookingId => _bookingId;
  String? get status => _status;
  String? get description => _description;
  String? get freelancerName => _freelancerName;
  String? get freelancerImage => _freelancerImage;
  String? get date => _date;
  String? get time => _time;


  BookingModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _userId = json['user_id'];
    _freelancerId = json['freelancer_id'];
    _bookingId = json['booking_id'];
    _status = json['status'];
    _description = json['description'];
    _freelancerName = json['freelancer_name'];
    _freelancerImage = json['freelancer_image'];
    _date = json['date'];
    _time = json['time'];


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['user_id'] = _userId;
    data['freelancer_id'] = _freelancerId;
    data['booking_id'] = _bookingId;
    data['status'] = _status;
    data['description'] = _description;
    data['freelancer_name'] = _freelancerName;
    data['freelancer_image'] = _freelancerImage;
    data['date'] = _date;
    data['time'] = _time;

    return data;
  }
}

