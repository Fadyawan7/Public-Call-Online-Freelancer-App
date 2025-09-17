import 'package:flutter/material.dart';
import 'package:flutter_restaurant/features/chat/domain/models/conversation_model.dart';
import 'package:flutter_restaurant/features/chat/providers/chat_provider.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class MessageBubbleWidget extends StatefulWidget {
  final ConversationModel? messages;
  final bool? isMe;
  const MessageBubbleWidget({super.key, this.messages, this.isMe });

  @override
  State<MessageBubbleWidget> createState() => _MessageBubbleWidgetState();
}

class _MessageBubbleWidgetState extends State<MessageBubbleWidget> {
  bool _initialFetchDone = false;
  final profileProvider = Provider.of<ProfileProvider>(Get.context!, listen: false);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialFetchDone) {
      _initialFetchDone = true;
    }
  }
  @override
  Widget build(BuildContext context) {

    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        final userId = profileProvider.loggedInUserId;
        final senderId = widget.messages?.senderId;
      return userId != senderId
            ? Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(Dimensions.paddingSizeSmall),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (widget.messages!.message != null && widget.messages!.message!.isNotEmpty)
                                  Flexible(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).hintColor.withOpacity(0.1),
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                            widget.messages!.message != null
                                                ? Dimensions.paddingSizeDefault
                                                : 0),
                                        child: Text(
                                            widget.messages!.message ?? '',style: Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: Dimensions.fontSizeLarge),),
                                      ),
                                    ),
                                  ),
                                widget.messages!.attachment != null
                                    ? const SizedBox(
                                    height: Dimensions.paddingSizeSmall)
                                    : const SizedBox(),
                                widget.messages!.attachment != null
                                    ? Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: ClipRRect(
                                    borderRadius:
                                    BorderRadius
                                        .circular(5),
                                    child: FadeInImage
                                        .assetNetwork(
                                      placeholder: Images
                                          .placeholderImage,
                                      height: 200,
                                      width: 200,
                                      fit: BoxFit.cover,
                                      image: '${AppConstants.baseUrl}/storage/${widget.messages!
                                          .attachment!.filePath!}',
                                      imageErrorBuilder: (c,
                                          o, s) =>
                                          Image.asset(
                                              Images
                                                  .placeholderImage,
                                              height: 100,
                                              width: 100,
                                              fit: BoxFit
                                                  .cover),
                                    ),
                                  ),
                                )
                                    : const SizedBox(),

                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      const SizedBox(),
                      Text(
                        widget.messages!.createdAt!.toString(),
                        style: rubikRegular.copyWith(
                            color: Theme.of(context).hintColor,
                            fontSize: Dimensions.fontSizeDefault),
                      ),
                    ],
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeDefault),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(Dimensions.paddingSizeSmall),
                    //color: Colors.red
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (widget.messages!.message != null && widget.messages!.message!.isNotEmpty)
                                  Flexible(
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFD8FDD2),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                            widget.messages!.message != null
                                                ? Dimensions
                                                    .paddingSizeDefault
                                                : 0),
                                        child: Text(
                                            widget.messages!.message ?? '',style: Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: Dimensions.fontSizeLarge),),
                                      ),
                                    ),
                                  ),
                                widget.messages!.attachment != null
                                    ? const SizedBox(
                                        height: Dimensions.paddingSizeSmall)
                                    : const SizedBox(),
                                widget.messages!.attachment != null
                                    ? Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: ClipRRect(
                                          borderRadius:
                                          BorderRadius
                                              .circular(5),
                                          child: FadeInImage
                                              .assetNetwork(
                                            placeholder: Images
                                                .placeholderImage,
                                            height: 200,
                                            width: 200,
                                            fit: BoxFit.cover,
                                            image: '${AppConstants.baseUrl}/storage/${widget.messages!
                                                .attachment!.filePath!}',
                                            imageErrorBuilder: (c,
                                                o, s) =>
                                                Image.asset(
                                                    Images
                                                        .placeholderImage,
                                                    height: 100,
                                                    width: 100,
                                                    fit: BoxFit
                                                        .cover),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      Text(
                        widget.messages!.createdAt!.toString(),
                        style: rubikRegular.copyWith(
                            color: Theme.of(context).hintColor,
                            fontSize: Dimensions.fontSizeDefault),
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }
}
