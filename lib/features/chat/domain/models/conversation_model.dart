import 'dart:convert';

class ConversationModel {
  int? id;
  int? chatId;
  int? senderId;
  String? message;
  bool? isRead;
  String? status;
  String? createdAt;
  Attachment? attachment;

  ConversationModel({
    this.id,
    this.chatId,
    this.senderId,
    this.message,
    this.isRead,
    this.status,
    this.createdAt,
    this.attachment,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json["id"],
      chatId: json["chat_id"],
      senderId: json["sender_id"],
      message: json["message"],
      isRead: json["is_read"],
      status: json["status"],
      createdAt: json["created_at"],
      attachment: json["attachment"] != null
          ? Attachment.fromJson(json["attachment"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['chat_id'] = chatId;
    data['sender_id'] = senderId;
    data['message'] = message;
    data['is_read'] = isRead;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['attachment'] = attachment?.toJson();
    return data;
  }
}

class Attachment {
  int? id;
  int? chatMessageId;
  String? filePath;
  String? fileType;
  String? createdAt;
  String? updatedAt;

  Attachment({
    this.id,
    this.chatMessageId,
    this.filePath,
    this.fileType,
    this.createdAt,
    this.updatedAt,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      id: json["id"],
      chatMessageId: json["chat_message_id"],
      filePath: json["file_path"],
      fileType: json["file_type"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['chat_message_id'] = chatMessageId;
    data['file_path'] = filePath;
    data['file_type'] = fileType;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}