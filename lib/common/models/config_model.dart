class ConfigModel {
  String? _companyName;
  String? _companyLogo;
  String? _companyAddress;
  String? _companyPhone;
  String? _companyEmail;
  String? _companyWhatsapp;
  String? _termsAndConditions;
  String? _privacyPolicy;
  String? _aboutUs;
  AppleLogin? _appleLogin;
  AppStoreConfig? _appStoreConfig;
  PlayStoreConfig? _playStoreConfig;
  String? _timeFormat;
  String? _currencySymbol;
  String? _currencySymbolPosition;

  bool? _maintenanceMode;

  ConfigModel(
  {
  String? companyName,
  String? companyLogo,
  String? companyAddress,
  String? companyPhone,
  String? companyEmail,
  String? companyWhatsapp,
  String? termsAndConditions,
  String? privacyPolicy,
  String? aboutUs,
  AppleLogin? appleLogin,
  AppStoreConfig? appStoreConfig,
  PlayStoreConfig? playStoreConfig,
  String? timeFormat,
  String? currencySymbol,
  String? currencySymbolPosition,

  bool? maintenanceMode,

  }) {
  _appleLogin = appleLogin;
  _companyAddress = companyAddress;
  _companyName = companyName;
  _companyLogo = companyLogo;
  _companyEmail = companyEmail;
  _companyPhone = companyPhone;
  _companyWhatsapp = companyWhatsapp;
  _termsAndConditions = termsAndConditions;
  _privacyPolicy = privacyPolicy;
  _aboutUs = aboutUs;
  _timeFormat = timeFormat;
  _currencySymbol = currencySymbol;
  _currencySymbolPosition = currencySymbolPosition;

  _maintenanceMode = maintenanceMode;
  if (appStoreConfig != null) {
  _appStoreConfig = appStoreConfig;
  }
  if (playStoreConfig != null) {
  _playStoreConfig = playStoreConfig;
  }

  }

  String? get companyAddress => _companyAddress;
  String? get companyName => _companyName;
  String? get companyLogo => _companyLogo;
  String? get companyEmail => _companyEmail;
  String? get companyPhone => _companyPhone;
  String? get companyWhatsapp => _companyWhatsapp;
  String? get termsAndConditions => _termsAndConditions;
  String? get privacyPolicy => _privacyPolicy;
  String? get aboutUs => _aboutUs;
  AppleLogin? get appleLogin => _appleLogin;
  bool? get maintenanceMode => _maintenanceMode;
  String? get timeFormat => _timeFormat;
  String? get currencySymbol => _currencySymbol;
  String? get currencySymbolPosition => _currencySymbolPosition;

  AppStoreConfig? get appStoreConfig => _appStoreConfig;
  PlayStoreConfig? get playStoreConfig => _playStoreConfig;

  ConfigModel.fromJson(Map<String, dynamic> json) {
  _companyAddress = json['company_address'] ?? '';
  _companyName = json['company_name'] ?? '';
  _companyLogo = json['company_logo'] ?? '';
  _companyPhone = json['company_phone'] ?? '';
  _companyEmail = json['company_email'];
  _companyWhatsapp = json['company_whatsapp'] ?? '';
  _termsAndConditions = json['terms_and_conditions'];
  _privacyPolicy = json['privacy_policy'] ?? '';
  _aboutUs = json['about_us'] ?? '';
  _appleLogin = json['apple_login'] != null
  ? AppleLogin.fromJson(json['apple_login'])
      : null;
  _appStoreConfig = json['app_store_config'] != null
  ? AppStoreConfig.fromJson(json['app_store_config'])
      : null;
  _playStoreConfig = json['play_store_config'] != null
  ? PlayStoreConfig.fromJson(json['play_store_config'])
      : null;
  _maintenanceMode=json['maintenance_mode'];
  _timeFormat =  json['time_format'].toString();
  _currencySymbol = json['currency_symbol'];
  _currencySymbolPosition = json['currency_symbol_position'];

  }

  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['company_address'] = _companyAddress;
  data['company_name'] = _companyName;
  data['company_logo'] = _companyLogo;
  data['company_phone'] = _companyPhone;
  data['company_email'] = _companyEmail;
  data['company_whatsapp'] = _companyWhatsapp;
  data['terms_and_conditions'] = _termsAndConditions;
  data['privacy_policy'] = _privacyPolicy;
  data['about_us'] = _aboutUs;
  data['maintenance_mode'] = _maintenanceMode;
  data['currency_symbol'] = _currencySymbol;
  data['currency_symbol_position'] = _currencySymbolPosition;

  if (_appStoreConfig != null) {
  data['app_store_config'] = _appStoreConfig!.toJson();
  }

  if (_appStoreConfig != null) {
  data['app_store_config'] = _appStoreConfig!.toJson();
  }
  return data;
  }


}




class AppleLogin {
  bool? status;
  String? medium;
  String? clientId;

  AppleLogin({this.status, this.medium});

  AppleLogin.fromJson(Map<String, dynamic> json) {
    status = '${json['status']}' == '1';
    medium = json['login_medium'];
    clientId = json['client_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['login_medium'] = medium;
    data['client_id'] = clientId;

    return data;
  }
}


class AppStoreConfig{
  bool? _status;
  String? _link;
  String? _minVersion;

  AppStoreConfig({bool? status, String? link, String? minVersion}){
    _status = status;
    _link = link;
    _minVersion = minVersion;
  }

  bool? get status => _status;
  String? get link => _link;
  String? get minVersion =>_minVersion;


  AppStoreConfig.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    if(json['link'] != null){
      _link = json['link'];
    }
    if(json['min_version'] !=null  && json['min_version'] != ''){

      _minVersion = json['min_version'];
    }

  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = _status;
    data['link'] = _link;
    data['min_version'] = _minVersion;

    return data;
  }
}
class PlayStoreConfig{
  bool? _status;
  String? _link;
  String? _minVersion;

  PlayStoreConfig({bool? status, String? link, String? minVersion}){
    _status = status;
    _link = link;
    _minVersion = minVersion;
  }

  bool? get status => _status;
  String? get link => _link;
  String? get minVersion =>_minVersion;


  PlayStoreConfig.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    if(json['link'] != null){
      _link = json['link'];
    }
    if(json['min_version'] !=null  && json['min_version'] != ''){
      _minVersion = json['min_version'];
    }

  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = _status;
    data['link'] = _link;
    data['min_version'] = _minVersion;

    return data;
  }
}