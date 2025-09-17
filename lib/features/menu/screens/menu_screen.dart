import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/menu/widgets/options_widget.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class MenuScreen extends StatefulWidget {
  final Function? onTap;
  const MenuScreen({super.key,  this.onTap});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Change as needed
      statusBarIconBrightness: Brightness.dark, // Change as needed
    ));

    return Scaffold(

      backgroundColor: Theme.of(context).canvasColor,
      appBar: null,
      body:  Consumer<AuthProvider>(
        builder: (context, authProvider, _) {

          final bool isLoggedIn = authProvider.isLoggedIn();
          print('=====LOGGEDUSER===${isLoggedIn}');
          return Column(children: [

            Consumer<ProfileProvider>(
              builder: (context, profileProvider, child) => Container(
                decoration: BoxDecoration(color: Theme.of(context).cardColor),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: Dimensions.paddingSizeExtraLarge, right: Dimensions.paddingSizeExtraLarge,
                    top: 50, bottom: Dimensions.paddingSizeExtraLarge,
                  ),
                  child: Row(children: [

                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(1),
                      child: ClipOval(
                        child: isLoggedIn ? CustomImageWidget(
                          placeholder: Images.placeholderUser, height: 80, width: 80, fit: BoxFit.cover,
                          image:
                              '${profileProvider.userInfoModel != null ? profileProvider.userInfoModel!.image : ''}',
                        ) : const CustomAssetImageWidget(Images.placeholderUserSvg, height: 80, width: 80, fit: BoxFit.contain),
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeDefault),

                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                        isLoggedIn && profileProvider.userInfoModel == null ? Shimmer(
                          duration: const Duration(seconds: 2),
                          enabled: true,
                          child: Container(
                            height: Dimensions.paddingSizeDefault, width: 200,
                            decoration: BoxDecoration(
                              color: Theme.of(context).shadowColor,
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            ),
                          ),
                        ) : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isLoggedIn ? '${profileProvider.userInfoModel?.name}' : getTranslated('guest', context)!,
                              style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
                            ),

                            if(isLoggedIn) Text(
                              profileProvider.userInfoModel?.email ?? '',
                              style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
                            ) ,
                            const SizedBox(height:Dimensions.paddingSizeExtraSmall),

                            if(profileProvider.userInfoModel?.userType == 'freelancer')
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: Dimensions.paddingSizeExtraSmall),
                              decoration: BoxDecoration(
                                color: ColorResources.buttonBackgroundColorMap['pending'],
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              ),
                              child: Text(
                                '${getTranslated('${profileProvider.userInfoModel?.userType}', context)}',
                                style: rubikSemiBold.copyWith(color: ColorResources.buttonTextColorMap['${profileProvider.userInfoModel?.userType}'], fontSize: Dimensions.fontSizeSmall),
                              ),
                            ),
                          ],
                        ),
                        // const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                      ]),
                    ),



                  ]),
                ),
              ),
            ),

            Expanded(child: OptionsWidget(onTap: widget.onTap)),

          ]);
        }
      ),
    );
  }
}
