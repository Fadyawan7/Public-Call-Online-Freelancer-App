class SignUpModel {
  String? name;
  String? phone;
  String? email;
  String? password;

  SignUpModel({this.name, this.phone, this.email='', this.password});

  SignUpModel.fromJson(Map<String, dynamic> json) {
    name = json['f_name'];
    phone = json['phone'];
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['password'] = password;
    return data;
  }
}
