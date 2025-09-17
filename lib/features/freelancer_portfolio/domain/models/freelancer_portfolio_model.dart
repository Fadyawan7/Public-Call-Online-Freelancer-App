class FreelancerPortfolioModel {
  int? id;
  String? image;
  String? imageUrl;



  FreelancerPortfolioModel(
      {this.id,
        this.image,
        this.imageUrl


      });

  FreelancerPortfolioModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    imageUrl = json['image_url'];


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['about'] = image;
    data['image_url'] = imageUrl;

    return data;
  }
}
