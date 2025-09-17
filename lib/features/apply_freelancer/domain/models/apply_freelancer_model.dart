class ApplyFreelancerModel {
  int? categoryId;
  String? about;
  int? perHour;
  String? whatsapp;



  ApplyFreelancerModel(
      {this.categoryId,
        this.about,
        this.perHour,
        this.whatsapp


      });

  ApplyFreelancerModel.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    about = json['about'];
    perHour = json['per_hour_charges'];
    whatsapp = json['whatsapp_number'];


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_id'] = categoryId;
    data['about'] = about;
    data['per_hour_charges'] = perHour;
    data['whatsapp_number'] = whatsapp;

    return data;
  }
}
