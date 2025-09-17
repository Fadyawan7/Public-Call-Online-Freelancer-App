import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_loader_widget.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/chat/domain/models/chat_model.dart';
import 'package:flutter_restaurant/features/chat/domain/models/conversation_model.dart';
import 'package:flutter_restaurant/features/chat/providers/chat_provider.dart';
import 'package:flutter_restaurant/features/chat/widgets/message_body_widget.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/pusher_service.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ConversationScreen extends StatefulWidget {
  final ChatModel? chat;
  const ConversationScreen({super.key, required this.chat});
  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController _inputMessageController = TextEditingController();
  final ProfileProvider profileProvider = Provider.of<ProfileProvider>(Get.context!, listen: false);

  @override
  void initState() {
    super.initState();

    _loadMessage();
  }


  @override
  Widget build(BuildContext context) {

    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    final theme = Theme.of(context);
    return Consumer<ChatProvider>(builder: (context, chatProvider, _) {
      return Scaffold(
        appBar:AppBar(centerTitle: true, title: Text( getTranslated('${widget.chat!.userName}', context)!,
          style: rubikSemiBold.copyWith(
            fontSize: Dimensions.fontSizeExtraLarge,
            color: Colors.white,
          ),
        ),
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            onPressed: () {
                context.pop();
                Provider.of<ChatProvider>(Get.context!,listen: false).resetConversation();
            },
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            padding: EdgeInsets.zero,
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(width: 50,height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(width: 1,color: theme.cardColor),
                  color: theme.primaryColor.withOpacity(0.1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  //todo need to add images
                  child: CustomImageWidget(
                    fit: BoxFit.cover,
                    placeholder: Images.profile,
                    image: '${widget.chat!.userImage}',
                  ),
                ),
              ),
            ),
          ],
        ),
        body:  Consumer<ChatProvider>(
            builder: (context, chatProvider, _) {
              return  MessageBodyWidget(
                isAdmin: false,
                authProvider: authProvider,
                inputMessageController: _inputMessageController,
                chatId: widget.chat!.id,
                loggedUserId:profileProvider.userInfoModel?.id ,
              );
            }
        ) ,
      );
    }
    );
  }


  void _loadMessage() async {

    final ChatProvider chatProvider = Provider.of<ChatProvider>(context, listen: false);
    await chatProvider.getConversationList(widget.chat!.id!);
    await profileProvider.getUserInfo(true);
    print('=====ID====${profileProvider.userInfoModel!.id}');
  }

}



