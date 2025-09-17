class CountryModel {
  int? _id;
  String? _countryName;
  String? _countryFlag;
  String? _countryCode;

  CountryModel(
      {int? id,
        String? countryName,
        String? countryFlag,
        String? countryCode,

      }) {
    _id = id;
    _countryName = countryName;
    _countryFlag = countryFlag;
    _countryCode = countryCode;

  }

  int? get id => _id;
  String? get countryName => _countryName;
  String? get countryFlag => _countryFlag;
  String? get countryCode => _countryCode;

  CountryModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'] ?? 0;
    _countryName = json['name'] ?? '';
    _countryFlag = json['emoji'] ?? '';
    _countryCode = json['phonecode'] ?? '';

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _countryName;
    data['emoji'] = _countryFlag;
    data['phonecode'] = _countryCode;

    return data;
  }
}
