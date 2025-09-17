class UserInfoModel {
  int? id;
  String? name;
  String? email;
  String? image;
  String? phone;
  String? whatsapp;
  bool? temporaryDisabled;

  String? cmFirebaseToken;
  String? userType;
  String? aboutMe;
  String? freelancerRequestStatus;
  String? freelancerRequestNote;

  int? categoryId;
  int? countryId;
  int? cityId;
  String? countryName;
  String? cityName;
  String? freelancerProfileRequest;


  UserInfoModel(
      {this.id,
        this.name,
        this.email,
        this.image,
        this.phone,
        this.cmFirebaseToken,
        this.aboutMe,
        this.categoryId,
        this.userType,
        this.freelancerRequestStatus,
        this.cityId,
        this.countryId,
        this.countryName,
        this.cityName,
        this.freelancerRequestNote,
        this.freelancerProfileRequest,
        this.whatsapp,
        this.temporaryDisabled,
      });

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    image = json['image'];
    phone = json['phone'] ?? '';
    cmFirebaseToken = json['fcm_token'] ?? '';
    categoryId = json['category_id'] ?? '';
    countryId = json['country_id'] ?? '';
    cityId = json['city_id'] ?? '';
    freelancerRequestNote = json['freelancer_request_note'] ?? '';
    temporaryDisabled = json['temporary_disabled'] ?? false;

    categoryId = json['category_id'] ?? '';

    freelancerRequestStatus = json['freelancer_request_status'] ?? '';
    userType = json['user_type'] ??'';
    countryName = json['country_name'] ??'';
    cityName = json['city_name'] ??'';

    freelancerProfileRequest = json['freelancer_profile_update_request'] ??'';
    aboutMe = json['about'] ?? '';
    whatsapp = json['whatsapp_number'] ?? '';


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['image'] = image;
    data['phone'] = phone;
    data['fcm_token'] = cmFirebaseToken;
    data['temporary_disabled'] = temporaryDisabled;
    if (freelancerRequestNote != null) {
      data['freelancer_request_note'] = freelancerRequestNote;
    }
    if (categoryId != null) {
      data['category_id'] = categoryId;
    }
    if (countryId != null) {
      data['country_id'] = countryId;
    }
    if (categoryId != null) {
      data['country_name'] = countryName;
    }
    if (cityId != null) {
      data['city_name'] = cityName;
    }
    if (cityId != null) {
      data['city_id'] = cityId;
    }
    if (aboutMe != null) {
      data['about'] = aboutMe;
    }
    if (whatsapp != null) {
      data['whatsapp_number'] = aboutMe;
    }
    if (freelancerRequestStatus != null) {
      data['freelancer_request_status'] = freelancerRequestStatus;
    }
    if (userType != null) {
      data['user_type'] = userType;
    }

    if (freelancerProfileRequest != null) {
      data['freelancer_profile_update_request'] = freelancerProfileRequest;
    }
    return data;
  }
}

