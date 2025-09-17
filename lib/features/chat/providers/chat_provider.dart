import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_restaurant/common/models/api_response_model.dart';
import 'package:flutter_restaurant/features/chat/domain/models/conversation_model.dart';
import 'package:flutter_restaurant/features/notification/domain/reposotories/notification_repo.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/helper/api_checker_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/features/chat/domain/models/chat_model.dart';
import 'package:flutter_restaurant/features/chat/domain/reposotories/chat_repo.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepo? chatRepo;
  final NotificationRepo? notificationRepo;
  ChatProvider({required this.chatRepo, required this.notificationRepo});
  ChatModel? _newChat;
  ChatModel? get newChat => _newChat;
  List<bool>? _showDate;
  File? _imageFile;
  bool _isSendButtonActive = false;
  final bool _isSeen = false;
  final bool _isSend = true;
  bool _isMe = false;
  bool _isLoading= false;
  bool get isLoading => _isLoading;
  int? _currentChatOrderId;

  List<bool>? get showDate => _showDate;
  File? get imageFile => _imageFile;
  bool get isSendButtonActive => _isSendButtonActive;
  bool get isSeen => _isSeen;
  bool get isSend => _isSend;
  bool get isMe => _isMe;

  String _message = '';
  String get message => _message;

  List <XFile>?_chatImage = [];
  List<XFile>? get chatImage => _chatImage;
  int? get currentChatOrderId => _currentChatOrderId;

  List<ChatModel>? _chatList;
  List<ChatModel>? get chatList => _chatList;

  List<ConversationModel>? _conversationList = [];
  List<ConversationModel>? get conversationList => _conversationList;



  Future<void> startNewChat(int userId) async {
    _isLoading = true;
    ApiResponseModel apiResponse = await chatRepo!.startNewChat(userId);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _newChat = ChatModel.fromJson(apiResponse.response!.data);
      //
      // final responseBody = apiResponse.response!.body; // Get the response body as String
      // final data = jsonDecode(responseBody);
      // _newChat = ChatModel.fromJson(data);
    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }
    _isLoading = false;

    notifyListeners();
  }

  Future<void> getChatList() async {
    _isLoading = true;
    ApiResponseModel apiResponse = await chatRepo!.getChatList();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _chatList = [];
      apiResponse.response!.data.forEach((chats) {
        ChatModel chatModel = ChatModel.fromJson(chats);
        chatModel = ChatModel.fromJson(chats);
        _chatList!.add(chatModel);
      });
    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }
    _isLoading = false;

    notifyListeners();
  }


  Future<void> getConversationList(int chatId) async {

    _isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
    ApiResponseModel apiResponse = await chatRepo!.getConversationList(chatId);

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _conversationList = [];
      apiResponse.response!.data.forEach((conversations) {
        ConversationModel conversationModel = ConversationModel.fromJson(conversations);
        conversationModel = ConversationModel.fromJson(conversations);
        _conversationList!.add(conversationModel);
      });
    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }
    _isLoading = false;

    notifyListeners();
  }

  void pickImage(bool isRemove) async {
    if(isRemove) {
      _imageFile = null;
      _chatImage = null; // Changed to null for single image
    }else {
      final pickedFile = await ImagePicker().pickImage(
        imageQuality: 30,
        source: ImageSource.gallery, // You can specify camera or gallery
      );
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        _isSendButtonActive = true;
      }
    }
    notifyListeners();
  }



  void resetConversation(){
    _conversationList = [];
    notifyListeners();
  }



  void toggleSendButtonActivity() {
    _isSendButtonActive = !_isSendButtonActive;
    notifyListeners();
  }


  void setIsMe(bool value) {
    _isMe = value;
  }

  void addConversation(ConversationModel newConversation) {
    log('[Pusher] Parsed conversations: ${newConversation}');

    if(newConversation != null){
      _conversationList!.insert(0, newConversation);
    } // Add at the beginning
    notifyListeners();
  }
  Future<http.StreamedResponse> sendMessage(String message, BuildContext context, String token, int? chatId) async {
    http.StreamedResponse response;
    _isLoading = true;

      response = await chatRepo!.sendMessage(message, _imageFile, chatId, token);

    if (response.statusCode == 200) {
      getConversationList(chatId!);
      pickImage(true);
      _isLoading = false;
    }
    _isSendButtonActive = false;
    notifyListeners();
    _isLoading = false;
    return response;
  }

  Future<void> deleteChat(int chatId,int index) async {
    _isLoading = true;
    ApiResponseModel apiResponse = await chatRepo!.deleteChat(chatId);

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
      String? message = map["message"];
      print('======RESPONSEee====${message}');
      _chatList!.removeAt(index);
      _message = message!;
      notifyListeners();
    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }
    _isLoading = false;
    notifyListeners();
  }
}