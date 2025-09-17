import 'package:flutter/material.dart';
import 'package:flutter_restaurant/features/chat/domain/models/chat_model.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';

class ChatItemWidget extends StatelessWidget {
  final ChatModel chats;

  const ChatItemWidget({
    super.key,required this.chats,
  });


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        RouterHelper.getConversationScreen(chat: chats);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).hintColor.withOpacity(0.1), // Use theme's divider color
              width: 1.0,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeSmall,
          vertical: Dimensions.paddingSizeSmall,
        ),
        child: Row(
          children: [
            // User Avatar with fallback for null image
            CircleAvatar(
              radius: 28, // Slightly smaller than before for better proportions
              backgroundImage: chats.userImage != null
                  ? NetworkImage(chats.userImage!)
                  : null,
              child: chats.userImage == null
                  ? Text(
                chats.userName!.isNotEmpty
                    ? chats.userName![0].toUpperCase()
                    : '?',
                style: Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: Dimensions.fontSizeLarge),
              )
                  : null,
            ),
            const SizedBox(width: Dimensions.paddingSizeDefault),
            // User Info Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          chats.userName ?? 'Unknown User',
                          style: rubikRegular.copyWith(
                            fontSize: Dimensions.fontSizeLarge,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(chats.createdAt! , // Formatted date
                        style: rubikRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  if (chats.lastMessage != null)
                    Text(
                      chats.lastMessage!,
                      style: rubikRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}