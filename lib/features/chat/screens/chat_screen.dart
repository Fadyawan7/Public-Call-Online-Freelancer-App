import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/no_data_widget.dart';
import 'package:flutter_restaurant/features/chat/providers/chat_provider.dart';
import 'package:flutter_restaurant/features/chat/widgets/chat_item_widget.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  @override
  void initState() {
    super.initState();
    _loadMessage();
  }


  @override
  void dispose() {
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(builder: (context, chatProvider, _) {

      return Scaffold(
        appBar: AppBar(

          centerTitle: true,
          title: Text(getTranslated('Conversation', context)!,
          style: rubikSemiBold.copyWith(
            fontSize: Dimensions.fontSizeExtraLarge,
            color: Theme.of(context).cardColor,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,

        ),
        body: Consumer<ChatProvider>(
            builder: (context, chatProvider, _) {
              return  const Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                child: MessageListWidget(),
              );
            }
        ) ,
      );
    }
    );
  }


  void _loadMessage() async {
    final ChatProvider chatProvider = Provider.of<ChatProvider>(context, listen: false);


    await chatProvider.getChatList();
  }

}


class MessageListWidget extends StatelessWidget {
  const MessageListWidget({
    super.key,
  });


  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;

    return Scaffold(

        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Consumer<ChatProvider>(
                builder: (context, chatProvider, child) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      await Provider.of<ChatProvider>(context,
                          listen: false)
                          .getChatList();
                    },
                    backgroundColor: Theme.of(context).primaryColor,
                    color: Theme.of(context).cardColor,
                    child: chatProvider.chatList == null
                        ? _ChatListShimmerWidget(
                        isEnabled:
                        chatProvider.chatList == null)
                        : chatProvider.chatList!.isNotEmpty
                        ? ListView.builder(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                      itemCount: chatProvider.chatList?.length ?? 0,
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final chatItem = chatProvider.chatList![index];
                        return Dismissible(
                          key: Key(chatItem.id.toString()), // Each item needs a unique key
                          direction: DismissDirection.endToStart, // Only allow swipe from right to left
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            color: Colors.red,
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          confirmDismiss: (direction) async {
                            // Show confirmation dialog
                            return await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Delete Message"),
                                content: const Text("Are you sure you want to delete this message?"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: const Text("Delete", style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                          },
                          onDismissed: (direction) {
                            // Remove the item from the data source
                            chatProvider.deleteChat(chatItem.id!,index).then((chat){
                              showCustomSnackBarHelper('Chat Deleted Successfully !',isError: false);

                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom: index == (chatProvider.chatList?.length ?? 0) - 1
                                  ? 50
                                  : Dimensions.paddingSizeDefault,
                            ),
                            child: ChatItemWidget(chats: chatItem),
                          ),
                        );
                      },
                    )
                        : SizedBox(
                        height: size.height,
                        child: const Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            NoDataWidget(
                                isFooter: false,
                                isChat: true),
                          ],
                        )),
                  );
                },
              ),
            ),
          ],
        ));
  }
}

class _ChatListShimmerWidget extends StatelessWidget {
  const _ChatListShimmerWidget({required this.isEnabled});
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(ResponsiveHelper.isDesktop(context)
          ? 0
          : Dimensions.paddingSizeSmall),
      itemCount: 5,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          color: Theme.of(context).hintColor.withOpacity(0.1),
        ),
        margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
        clipBehavior: Clip.hardEdge,
        child: Shimmer(
            enabled: isEnabled,
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Row(children: [
                Container(
                    width: 20,
                    height: 20,
                    color: Theme.of(context).hintColor.withOpacity(0.2)),
                const SizedBox(width: Dimensions.paddingSizeDefault),
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(
                          Dimensions.paddingSizeExtraSmall),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                              width: 150,
                              height: 20,
                              color:
                              Theme.of(context).hintColor.withOpacity(0.2)),
                          const SizedBox(height: Dimensions.paddingSizeDefault),
                          Container(
                              width: 200,
                              height: 20,
                              color:
                              Theme.of(context).hintColor.withOpacity(0.2)),
                        ],
                      )),
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),
                Container(
                    width: 20,
                    height: 20,
                    color: Theme.of(context).hintColor.withOpacity(0.2)),
              ]),
            )),
      ),
    );
  }
}




