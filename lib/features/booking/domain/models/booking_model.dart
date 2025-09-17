
class BookingModel {
  int? _id;
  int? _userId;
  int? _freelancerId;
  String? _bookingId;
  String? _status;
  String? _description;
  String? _freelancerName;
  String? _freelancerImage;
  String? _userName;
  String? _userImage;
  String? _date;
  String? _time;
  bool? _userReview;
  bool? _freelancerReview;
  String? _freelancerViewId;



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
        String? userName,
        String? userImage,
        String? freelancerViewId,
        bool? userReview,
        bool? freelancerReview,

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

    _userName = userName;
    _userImage = userImage;

    _time = time;
    _userReview = userReview;
    _freelancerReview = freelancerReview;
    _freelancerViewId = freelancerViewId;

  }

  int? get id => _id;
  int? get userId => _userId;
  int? get freelancerId => _freelancerId;
  String? get bookingId => _bookingId;
  String? get status => _status;
  String? get description => _description;
  String? get freelancerName => _freelancerName;
  String? get freelancerImage => _freelancerImage;
  String? get userName => _userName;
  String? get userImage => _userImage;
  String? get date => _date;
  String? get time => _time;
  String? get freelancerViewId => _freelancerViewId;
  bool? get userReview => _userReview;
  bool? get freelancerReview => _freelancerReview;


  BookingModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _userId = json['user_id'];
    _freelancerId = json['freelancer_id'];
    _bookingId = json['booking_id'];
    _status = json['status'];
    _description = json['description'];
    _freelancerName = json['freelancer_name'];
    _freelancerImage = json['freelancer_image'];
    _userName = json['user_name'];
    _userImage = json['user_image'];
    _date = json['date'];
    _time = json['time'];

    _freelancerViewId = json['freelancer_view_id'];
    _freelancerReview = json['freelancer_review'];
    _userReview = json['user_review'];


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

    data['user_name'] = _userName;
    data['user_image'] = _userImage;
    data['date'] = _date;
    data['time'] = _time;
    data['freelancer_view_id'] = _freelancerViewId;
    data['freelancer_review'] = _freelancerReview;
    data['user_review'] = _userReview;

    return data;
  }
}

