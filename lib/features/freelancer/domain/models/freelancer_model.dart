
class FreelancerModel {
  int? _id;
  String? _name;
  String? _phone;
  String? _email;
  String? _image;
  String? _about;
  String? _country;
  String? _city;
  String? _memberSince;
  String? _freelancerCategory;
  double? _latitude;
  double? _longitude;
  String? _status;
  String? _whatsapp;

  int? _totalJob;
  double? _avgRating;
  List<Portfolio>? _portfolio;
  List<FreelancerReviews>? _reviews;



  FreelancerModel(
      {
        int? id,
        String? name,
        String? phone,
        String? email,
        String? country,
        String? city,
        String? memberSince,
        String? image,
        String? about,
        String? whatsapp,

        String? freelancerCategory,
        double? latitude,
        double? longitude,
        String? status,
        int? totalJob,
        double? avgRating,
        List<Portfolio>? portfolio,
        List<FreelancerReviews>? reviews,

      }) {
    _id = id;
    _name = name;
    _image = image;
    _phone = phone;
    _email = email;
    _image = image;
    _about = about;
    _whatsapp = whatsapp;
    _freelancerCategory = freelancerCategory;
    _latitude = latitude;
    _longitude = longitude;
    _status =status;
    _totalJob = totalJob;
    _avgRating = avgRating;
    _portfolio =portfolio;
    _country=country;
    _city =city;
    _memberSince = memberSince;
    _reviews =reviews;

  }

  int? get id => _id;
  String? get name => _name;
  String? get phone => _phone;
  String? get image => _image;
  String? get email => _email;
  String? get about => _about;
  String? get status => _status;
  String? get whatsapp => _whatsapp;

  int? get totalJob => _totalJob;
  String? get country => _country;
  String? get city => _city;
  String? get memberSince => _memberSince;
  String? get freelancerCategory => _freelancerCategory;
  double? get latitude => _latitude;
  double? get longitude => _longitude;
  double? get avgRating => _avgRating;
  List<Portfolio>? get portfolio => _portfolio;
  List<FreelancerReviews>? get reviews => _reviews;


  FreelancerModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _email = json['email'];
    _name = json['name'];
    _image = json['image'];
    _phone = json['phone'];
    _about = json['about'];
    _country = json['country'];
    _whatsapp = json['whatsapp_number'];

    _city = json['city'];
    _memberSince = json['member_since'];
    _freelancerCategory = json['category'];
    _latitude = double.parse(json['latitude'].toString());
    _longitude =double.parse(json['longitude'].toString());
    _avgRating = double.tryParse('${json['average_rating']}');
    _status = json['current_status'];
    _totalJob = json['total_jobs'];
    if (json['portfolio'] != null) {
      _portfolio = [];
      json['portfolio'].forEach((v) {
        _portfolio!.add(Portfolio.fromJson(v));
      });
    }
    if (json['reviews'] != null) {
      _reviews = [];
      json['reviews'].forEach((v) {
        _reviews!.add(FreelancerReviews.fromJson(v));
      });
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['phone'] = _phone;
    data['email'] = _email;
    data['about'] = _about;
    data['image'] = _image;
    data['whatsapp_number'] = _whatsapp;

    data['category'] = _freelancerCategory;
    data['latitude'] = _latitude;
    data['longitude'] = _longitude;
    data['total_jobs'] = _totalJob;
    data['average_rating'] = _avgRating;
    data['current_status'] = _status;
    data['country'] = _country;
    data['city'] = _city;
    data['member_since'] = _memberSince;
    if (_portfolio != null) {
      data['portfolio'] = _portfolio!.map((v) => v.toJson()).toList();
    }
    if (_reviews != null) {
      data['reviews'] = _reviews!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Portfolio {
  int? _id;
  String? _imageUrl;
  Portfolio(
      {
        int? id,
        String? imageUrl,
      }) {
    _id = id;
    _imageUrl = imageUrl;

  }

  int? get id => _id;
  String? get imageUrl => _imageUrl;

  Portfolio.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _imageUrl = json['image_url'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['image_url'] = _imageUrl;
    return data;
  }
}
class FreelancerReviews {
  int? _id;
  int? _rating;
  String? _comment;
  String? _giverName;
  String? _giverImage;
  String? _takerName;
  String? _takerImage;
  String? _createdAt;

  FreelancerReviews(
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

  String? get createdAt => _createdAt;

  FreelancerReviews.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
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
    data['comment'] = _comment;
    data['giver_name'] = _giverName;
    data['giver_image'] = _giverImage;
    data['taker_name'] = _takerName;
    data['taker_image'] = _takerImage;
    data['created_at'] = _createdAt;
    return data;
  }
}
