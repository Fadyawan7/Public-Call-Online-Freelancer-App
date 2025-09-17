// import 'dart:developer';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter_restaurant/features/chat/domain/models/conversation_model.dart';
// import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
//
// class PusherService with ChangeNotifier {
//   PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
//   List<ConversationModel>? _conversationList;
//   List<ConversationModel>? get conversationList => _conversationList;
//
//
//ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
//   void initializeEcho() async {
//
//     try {
//       await pusher.init(
//         apiKey: '631dc5bc314aacb19f61',
//         cluster: 'ap2',
//         onConnectionStateChange: onConnectionStateChange,
//         onError: onError,
//         onSubscriptionSucceeded: onSubscriptionSucceeded,
//         onEvent: onEvent,
//         onSubscriptionError: onSubscriptionError,
//         onDecryptionFailure: onDecryptionFailure,
//         onMemberAdded: onMemberAdded,
//         onMemberRemoved: onMemberRemoved,
//         authEndpoint: "https://publiccallonline.com/api/broadcasting/auth",
//         // onAuthorizer: onAuthorizer
//       );
//       await pusher.subscribe(channelName: 'chat.3');
//       await pusher.connect();
//     } catch (e) {
//       print("ERROR: $e");
//     }
//   }
//
//   @override
//   void dispose() {
//     pusher.disconnect();
//     super.dispose();
//   }
//   void onConnectionStateChange(dynamic currentState, dynamic previousState) {
//     log("Connection: $currentState");
//   }
//   void onError(String message, int? code, dynamic e) {
//     log("onError: $message code: $code exception: $e");
//   }
//   void onEvent(PusherEvent event) {
//     log("onEvent: ${event.data}");
//     ConversationModel conversationModel = ConversationModel.fromJson(event.data);
//
//     conversationModel = ConversationModel.fromJson(event.data);
//     _conversationList!.add(conversationModel);
//   }
//   void onSubscriptionSucceeded(String channelName, dynamic data) {
//     log("onSubscriptionSucceeded: $channelName data: $data");
//     final me = pusher.getChannel(channelName)?.me;
//     log("Me: $me");
//   }
//   void onSubscriptionError(String message, dynamic e) {
//     log("onSubscriptionError: $message Exception: $e");
//   }
//   void onDecryptionFailure(String event, String reason) {
//     log("onDecryptionFailure: $event reason: $reason");
//   }
//   void onMemberAdded(String channelName, PusherMember member) {
//     log("onMemberAdded: $channelName user: $member");
//   }
//   void onMemberRemoved(String channelName, PusherMember member) {
//     log("onMemberRemoved: $channelName user: $member");
//   }
//
// }