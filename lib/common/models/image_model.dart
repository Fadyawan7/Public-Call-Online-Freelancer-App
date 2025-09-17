import 'package:image_picker/image_picker.dart';

class ImageModel {
  XFile? image;
  String? imageString;

  ImageModel({ this.image, this.imageString});

  ImageModel.fromJson(Map<String, dynamic> json) {

    image = json['image'];
    imageString = json['image_string'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['image'] = image;
    data['image_string'] = imageString;
    return data;
  }
}

