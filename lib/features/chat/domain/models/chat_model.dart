class ChatModel {
  int? id;
  int? userId;
  String? userImage;
  String? userName;
  String? lastMessage;
  String? createdAt;
  String? updatedAt;

  ChatModel({this.id,this.userId,this.userImage,this.userName,this.lastMessage,this.createdAt,this.updatedAt});

  ChatModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    userImage = json['user_image'];
    userName = json['user_name'];
    lastMessage = json['last_message'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['user_image'] = userImage;
    data['user_name'] = userName;
    data['last_message'] = lastMessage;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;

    return data;
  }
}

