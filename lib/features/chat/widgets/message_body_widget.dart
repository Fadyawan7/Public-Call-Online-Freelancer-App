import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/chat/domain/models/conversation_model.dart';
import 'package:flutter_restaurant/features/chat/providers/chat_provider.dart';
import 'package:flutter_restaurant/features/chat/widgets/message_bubble_shimmer_widget.dart';
import 'package:flutter_restaurant/features/chat/widgets/message_bubble_widget.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class MessageBodyWidget extends StatefulWidget {
  const MessageBodyWidget({
    super.key,
    required this.isAdmin,
    required this.authProvider,
    required TextEditingController inputMessageController,
    required this.chatId, this.loggedUserId,
  }) : _inputMessageController = inputMessageController;

  final bool isAdmin;
  final AuthProvider authProvider;
  final TextEditingController _inputMessageController;
  final int? chatId;
  final int? loggedUserId;
  @override
  State<MessageBodyWidget> createState() => _MessageBodyWidgetState();
}

class _MessageBodyWidgetState extends State<MessageBodyWidget> {
  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
  @override
  void initState() {
    super.initState();
    _initializeEcho();

  }
  void _initializeEcho() async {

    try {
      await pusher.init(
        apiKey: '631dc5bc314aacb19f61',
        cluster: 'ap2',
        onConnectionStateChange: onConnectionStateChange,
        onError: onError,
        onSubscriptionSucceeded: onSubscriptionSucceeded,
        onEvent: onEvent,
        onSubscriptionError: onSubscriptionError,
        onDecryptionFailure: onDecryptionFailure,
        onMemberAdded: onMemberAdded,
        onMemberRemoved: onMemberRemoved,
        authEndpoint: "https://publiccallonline.com/api/broadcasting/auth",
        // onAuthorizer: onAuthorizer
      );
      await pusher.subscribe(channelName: 'chat.${widget.chatId}');
      await pusher.connect();
    } catch (e) {
      print("ERROR: $e");
    }
  }

  @override
  void dispose() {
    pusher.disconnect();
    super.dispose();
  }
  void onConnectionStateChange(dynamic currentState, dynamic previousState) {
    log("Connection: $currentState");
  }
  void onError(String message, int? code, dynamic e) {
    log("onError: $message code: $code exception: $e");
  }
  void onEvent(PusherEvent event) {
    try {
      if (event.eventName != null && event.eventName == 'new-message' ) {
        final dynamic eventData = jsonDecode(event.data!);
          final conversation = ConversationModel.fromJson(eventData);
          if (context.mounted) {
            Provider.of<ChatProvider>(context, listen: false)
                .addConversation(conversation);
          }

      }
    } catch (e, stackTrace) {
      log('[Pusher] Error processing event',
          error: e,
          stackTrace: stackTrace);
    }
  }
  void onSubscriptionSucceeded(String channelName, dynamic data) {
    log("onSubscriptionSucceeded: $channelName data: $data");
    final me = pusher.getChannel(channelName)?.me;
    log("Me: $me");
  }
  void onSubscriptionError(String message, dynamic e) {
    log("onSubscriptionError: $message Exception: $e");
  }
  void onDecryptionFailure(String event, String reason) {
    log("onDecryptionFailure: $event reason: $reason");
  }
  void onMemberAdded(String channelName, PusherMember member) {
    log("onMemberAdded: $channelName user: $member");
  }
  void onMemberRemoved(String channelName, PusherMember member) {
    log("onMemberRemoved: $channelName user: $member");
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),

      child: Consumer<ChatProvider>(builder: (context, chatProvider,child) {
        return Column(children: [

          chatProvider.conversationList!.isEmpty && chatProvider.isLoading  ? Expanded(child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: 24,
            itemBuilder: (context, index)=> MessageBubbleShimmerWidget(isMe: index.isOdd),
          )) : chatProvider.conversationList!.isEmpty && !chatProvider.isLoading ? Expanded(child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [

            const CustomAssetImageWidget(
              Images.noMessageSvg,
              width:  125,
              height: 100,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            Text(getTranslated('no_message_found', context)!, style: rubikSemiBold),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Text(widget.isAdmin ? "${getTranslated('start_typing_to_chat_with_restaurant', context)!} ${getTranslated('admin', context)!}"
                :  "${getTranslated('start_typing_to_chat_with_restaurant', context)!} ${getTranslated('deliveryman', context)!}",
                style: rubikRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: Theme.of(context).hintColor.withOpacity(0.7),
                )),

          ])) : Expanded(child: ListView.builder(
            reverse: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: chatProvider.conversationList!.length,
            itemBuilder: (context, index) {
              return MessageBubbleWidget(
                messages: chatProvider.conversationList![index],
                isMe: widget.loggedUserId == chatProvider.conversationList![index].senderId,
              );
            },
          )),

          /// for Message input section
          Container(
            color: Theme.of(context).cardColor,
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeLarge),
            child: Column(children: [

             if(chatProvider.imageFile?.path.isNotEmpty ?? false)...[
               Consumer<ChatProvider>(builder: (context, chatProvider, _) {

                 return SizedBox(
                   height: 200,
                   child: Padding(padding: const EdgeInsets.all(8.0), child: Stack(children: [

                     Container(width: 200, height: 200,
                       decoration: const BoxDecoration(
                         color: Colors.white,
                         borderRadius: BorderRadius.all(Radius.circular(20)),
                       ),
                       child: ClipRRect(
                         borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault)),
                         child: ResponsiveHelper.isWeb()? Image.network(
                           chatProvider.imageFile!.path,
                           width: 100, height: 100,
                           fit: BoxFit.cover,
                         ) : Image.file(
                           File(chatProvider.imageFile!.path),
                           width: 100, height: 100,
                           fit: BoxFit.cover,
                         ),
                       ) ,
                     ),

                     Positioned(
                       top:0, right:0,
                       child: InkWell(
                         onTap: () => chatProvider.pickImage(true),
                         child: Container(
                           decoration: const BoxDecoration(
                               color: Colors.white,
                               borderRadius: BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault))
                           ),
                           child: const Padding(
                             padding: EdgeInsets.all(4.0),
                             child: Icon(Icons.clear,color: Colors.red,size: 18,),
                           ),
                         ),
                       ),
                     ),

                   ])),
                 );

               }),
             ],
              Row(children: [

                InkWell(
                  onTap: () async {
                    chatProvider.pickImage(false);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                    width: 45, height: 45,
                    child: CustomAssetImageWidget(Images.image, color: Theme.of(context).hintColor, fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                Expanded(
                  child: TextField(
                    inputFormatters: [LengthLimitingTextInputFormatter(Dimensions.messageInputLength)],
                    controller: widget._inputMessageController,
                    textCapitalization: TextCapitalization.sentences,
                    style: rubikRegular,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        borderSide: BorderSide(color: Theme.of(context).hintColor.withOpacity(0.5)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        borderSide: BorderSide(color: Theme.of(context).hintColor.withOpacity(0.5)),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        borderSide: BorderSide(color: Theme.of(context).hintColor.withOpacity(0.5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        borderSide: BorderSide(color: Theme.of(context).hintColor.withOpacity(0.5)),
                      ),
                      hintText: getTranslated('start_a_new_message', context),
                      hintStyle: rubikRegular.copyWith(color: Theme.of(context).hintColor.withOpacity(0.8), fontSize: Dimensions.fontSizeDefault),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeDefault),
                    ),
                    onSubmitted: (String newText) {
                      if(newText.trim().isNotEmpty && !chatProvider.isSendButtonActive) {
                        chatProvider.toggleSendButtonActivity();
                      }else if(newText.isEmpty && chatProvider.isSendButtonActive) {
                        chatProvider.toggleSendButtonActivity();
                      }
                    },
                    onChanged: (String newText) {
                      if(newText.trim().isNotEmpty && !chatProvider.isSendButtonActive) {
                        chatProvider.toggleSendButtonActivity();
                      }else if(newText.isEmpty && chatProvider.isSendButtonActive) {
                        chatProvider.toggleSendButtonActivity();
                      }
                    },

                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                InkWell(
                  onTap: () async {
                    if(chatProvider.isSendButtonActive){
                      chatProvider.sendMessage(widget._inputMessageController.text, context, widget.authProvider.getUserToken(), widget.chatId);
                      widget._inputMessageController.clear();
                      chatProvider.toggleSendButtonActivity();

                    }else{
                      showCustomSnackBarHelper(getTranslated('write_somethings', context));
                    }
                  },
                  child: Container(
                    width: 45, height: 45,
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      color: Theme.of(context).primaryColor,
                    ),
                    child: chatProvider.isLoading ? SizedBox(
                      width: 25, height: 25,
                      child: CircularProgressIndicator(color: Theme.of(context).cardColor,),
                    ) : const Icon(Icons.send_rounded, color: Colors.white, size: Dimensions.fontSizeLarge),
                  ),
                ),

              ]),

            ]),
          ),

        ]);
      }
      ),
    );
  }
}