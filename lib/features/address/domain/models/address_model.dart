
class AddressModel {
  int? id;
  String? contactPersonName;
  String? contactPersonNumber;
  String? floorNumber;
  String? houseNumber;
  String? streetNumber;

  String? addressType;
  String? address;
  String? latitude;
  String? longitude;
  String? createdAt;
  String? updatedAt;
  bool? isDefault;

  AddressModel({
    this.id,
    this.addressType,
    this.contactPersonNumber,
    this.address,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
    this.contactPersonName,
    this.houseNumber,
    this.floorNumber,
    this.streetNumber,
    this.isDefault,
  });

  AddressModel copyWith(bool isDefaultValue) {
    isDefault = isDefaultValue;
    return this;
  }

  AddressModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addressType = json['address_type'];
    contactPersonNumber = json['contact_person_number'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    contactPersonName = json['contact_person_name'];
    streetNumber = json['road'];
    floorNumber = json['floor'];
    houseNumber = json['house'];
    isDefault = '${json['is_default']}'.contains('1');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['address_type'] = addressType;
    data['contact_person_number'] = contactPersonNumber;
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['contact_person_name'] = contactPersonName;
    data['road'] = streetNumber;
    data['floor'] = floorNumber;
    data['house'] = houseNumber;
    data['is_default'] = (isDefault ?? false) ? 1 : 0;
    return data;
  }
}
