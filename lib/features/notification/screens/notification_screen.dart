import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_loader_widget.dart';
import 'package:flutter_restaurant/helper/date_converter_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/features/notification/providers/notification_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_restaurant/common/widgets/no_data_widget.dart';
import 'package:flutter_restaurant/features/notification/widgets/notification_dialog_widget.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
 final SplashProvider splashProvider = Provider.of<SplashProvider>(Get.context!, listen: false);
 @override
  void initState() {
    Provider.of<NotificationProvider>(context, listen: false).getNotificationList(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: (CustomAppBarWidget(context: context, titleColor: Colors.white,title: getTranslated('notification', context))) as PreferredSizeWidget?,
      body: Consumer<NotificationProvider>(
          builder: (context, notificationProvider, child) {
            List<DateTime> dateTimeList = [];
            return notificationProvider.notificationList != null ? notificationProvider.notificationList!.isNotEmpty ? RefreshIndicator(
              onRefresh: () async {
                await notificationProvider.getNotificationList(context);
              },
              backgroundColor: Theme.of(context).primaryColor,
              color: Theme.of(context).cardColor,
              child: SingleChildScrollView(child: Column(children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.isDesktop(context) ?  Dimensions.paddingSizeLarge : 0.0),
                  child: Center(child: Container(
                    constraints: BoxConstraints(minHeight:height - 400),
                    width: width > Dimensions.webScreenWidth ? Dimensions.webScreenWidth : width,
                    padding: width > 700 ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : null,
                    child: ListView.builder(
                        itemCount: notificationProvider.notificationList?.length,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {

                          return InkWell(
                            onTap: () => ResponsiveHelper.showDialogOrBottomSheet(
                              context, NotificationDialogWidget(notificationModel: notificationProvider.notificationList![index]),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(children: [
                                    const SizedBox(height: Dimensions.paddingSizeDefault),

                                    Row(children: [
                                      SizedBox(height: 50,width: 50, child: CustomImageWidget(
                                        image: '${splashProvider.configModel!.companyLogo}',
                                        height: 50,width: 50,fit: BoxFit.cover,
                                      )),
                                      const SizedBox(width: Dimensions.paddingSizeExtraLarge),

                                      Expanded(child: Text(
                                        notificationProvider.notificationList![index].title!,
                                        style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                          fontSize: Dimensions.fontSizeLarge,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      )),

                                      Text(notificationProvider.notificationList![index].createdAt!,
                                        style: Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: Dimensions.fontSizeExtraSmall),
                                      ),

                                    ]),
                                    const SizedBox(height: Dimensions.paddingSizeLarge),

                                    Container(height: 1, color: Theme.of(context).hintColor.withOpacity(0.7).withOpacity(.2))
                                  ]),
                                ),
                              ],
                            ),
                          );
                        }),
                  )),
                ),


              ])),
            ) : const NoDataWidget(isNotification: true,) : Center(
              child: CustomLoaderWidget(color: Theme.of(context).primaryColor),
            );
          }
      ),
    );
  }
}
