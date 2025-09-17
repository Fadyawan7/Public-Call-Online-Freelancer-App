class CityModel {
  int? _id;
  int? _countryId;
  String? _cityName;

  CityModel({
    int? id,
    String? cityName,
    int? countryId,
  }) {
    _id = id;
    _cityName = cityName;
    _countryId = countryId;
  }

  int? get id => _id;
  String? get cityName => _cityName;
  int? get countryId => _countryId;

  CityModel.fromJson(Map<String, dynamic> json) {
    _id = _parseInt(json['id']);
    _cityName = json['name']?.toString() ?? '';
    _countryId = _parseInt(json['country_id']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _cityName;
    data['country_id'] = _countryId;
    return data;
  }

  int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
