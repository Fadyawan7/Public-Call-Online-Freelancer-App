import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_alert_dialog_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/menu/widgets/portion_widget.dart';
import 'package:flutter_restaurant/features/menu/widgets/theme_switch_button_widget.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/app_localization.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class OptionsWidget extends StatelessWidget {
  final Function? onTap;
  const OptionsWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {

    final bool isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    return Consumer<AuthProvider>(builder: (context, authProvider, _)=> SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Ink(
        child: Column(children: [

          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              child: Text(getTranslated('general', context)!, style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
            ),

            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
              ),
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
              margin: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Consumer<ProfileProvider>(
                builder: (context, profileProvider,child){
                  return Column(children: [
                    PortionWidget(imageIcon: Images.profileSvg, title: getTranslated('profile', context)!, onRoute:()=> RouterHelper.getProfileRoute('main')),

                    if(profileProvider.userInfoModel != null && profileProvider.userInfoModel!.userType == 'freelancer')...[
                      // Status Toggle Widget
                      InkWell(
                        onTap: null, // Disable tap as the switch handles interaction
                        child: Container(
                          padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                          child: Row(children: [
                            Container(
                              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).shadowColor.withOpacity(0.3),
                              ),
                              child: Icon(Icons.work_outline, size: 16, color: Theme.of(context).hintColor),
                            ),
                            const SizedBox(width: Dimensions.paddingSizeSmall),
                            
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              const SizedBox(height: Dimensions.paddingSizeDefault),
                              Row(
                                children: [
                                  Text('Work Status', style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                                  const Spacer(),
                                  const ThemeSwitchButtonWidget(),
                                ],
                              ),
                              Divider(
                                color: Theme.of(context).hintColor.withOpacity(0.1),
                              ),
                            ])),
                          ]),
                        ),
                      ),

                      PortionWidget(icon: Icons.calendar_month, title: getTranslated('my_bookings', context)!, onRoute:()=> RouterHelper.getFreelancerBookingRoute()),
                      PortionWidget(icon: Iconsax.gallery, title: getTranslated('my_portfolio', context)!, onRoute:()=> RouterHelper.getFreelancerPortfolioListRoute()),
                    ],
                    PortionWidget(icon: Iconsax.home, title: getTranslated('my_address', context)!, onRoute:()=> RouterHelper.getAddressRoute()),
                    PortionWidget(icon:  Icons.change_circle, title: getTranslated('change_password', context)!, onRoute:()=> RouterHelper.getChangePasswordRoute()),

                    PortionWidget(imageIcon: Images.notification, title: getTranslated('notification', context)!, onRoute:()=> RouterHelper.getNotificationRoute()),

                    Consumer<ProfileProvider>(
                      builder: (context,profileProvider,child){
                        String? applicationStatus = profileProvider.userInfoModel?.freelancerRequestStatus ?? '';
                        String? applicationStatusNote = profileProvider.userInfoModel?.freelancerRequestNote ?? '';

                        return PortionWidget(
                            iconColor:(applicationStatus.isEmpty || applicationStatus== 'no-request') ? Colors.green:Colors.red.withOpacity(0.6) ,
                            icon: Icons.person_add_sharp,
                            textColor:(applicationStatus.isEmpty  || applicationStatus== 'no-request')? Colors.green:Colors.red.withOpacity(0.6) ,
                            imageIcon: Images.addressSvg,
                            title:'Apply For Worker - ( ${applicationStatus.toCapitalized().replaceAll('-', ' ') } )',
                            suffix: (applicationStatus == 'needed_more_data' || applicationStatus == 'rejected') ? applicationStatusNote : null,
                            onRoute: (applicationStatus.isEmpty || (applicationStatus != 'approved' && applicationStatus != 'pending'))
                              ? () => RouterHelper.getApplyFreelancerRoute()
                              : null,
                        );
                      }
                      ,
                    )

                    // PortionWidget(imageIcon: Images.languageSvg, title: getTranslated('language', context)!, onRoute:()=> RouterHelper.getLanguageRoute(true), hideDivider: true),
                  ]);
                },
              ),
            )
          ]),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              child: Text(getTranslated('menu_more', context)!, style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
            ),

            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
              ),
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
              margin: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Column(children: [
                PortionWidget(imageIcon: Images.supportSvg, title: getTranslated('help_and_support', context)!, onRoute:()=> RouterHelper.getSupportRoute()),
                PortionWidget(imageIcon: Images.documentSvg, title: getTranslated('privacy_policy', context)!, onRoute:()=> RouterHelper.getPolicyRoute()),
                PortionWidget(imageIcon: Images.documentAltSvg, title: getTranslated('terms_and_condition', context)!, onRoute:()=> RouterHelper.getTermsRoute()),
                PortionWidget(imageIcon: Images.infoSvg, title: getTranslated('about_us', context)!, onRoute:()=> RouterHelper.getAboutUsRoute()),

                isLoggedIn ? PortionWidget(
                  iconColor: Theme.of(context).primaryColor,
                  icon: Icons.delete,
                  imageIcon: null,
                  title: getTranslated('delete_account', context)!,
                  onRoute:()=> ResponsiveHelper.showDialogOrBottomSheet(context, Consumer<AuthProvider>(
                      builder: (context, authProvider, _) {
                        return CustomAlertDialogWidget(
                          isLoading: authProvider.isLoading,
                          title: getTranslated('are_you_sure_to_delete_account', context),
                          subTitle: getTranslated('it_will_remove_your_all_information', context),
                          icon: Icons.question_mark_sharp,
                          isSingleButton: authProvider.isLoading,
                          leftButtonText: getTranslated('yes', context),
                          rightButtonText: getTranslated('no', context),
                          onPressLeft: () => authProvider.deleteUser(),
                        );
                      }
                  )),
                ): const SizedBox(),

                InkWell(
                  onTap: (){
                    if(authProvider.isLoggedIn()) {
                      ResponsiveHelper.showDialogOrBottomSheet(context, Consumer<AuthProvider>(
                          builder: (context, authProvider, _) {
                          return CustomAlertDialogWidget(
                            isLoading: authProvider.isLoading,
                            title: getTranslated('want_to_sign_out', context),
                            icon: Icons.contact_support,
                            isSingleButton: authProvider.isLoading,
                            leftButtonText: getTranslated('yes', context),
                            rightButtonText: getTranslated('no', context),
                            onPressLeft: () {
                              authProvider.clearSharedData(context).then((condition) {
                                  context.pop();
                                  RouterHelper.getLoginRoute(action: RouteAction.pushNamedAndRemoveUntil);

                              });
                            },

                          );
                        }
                      ));

                    }else {
                      RouterHelper.getLoginRoute();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                    child: Row(children: [
                      Container(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                        margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                        ),
                        child: CustomAssetImageWidget(
                          isLoggedIn ? Images.logoutSvg : Images.login, height: 16, width: 16,
                          color: isLoggedIn ? null : Theme.of(context).primaryColor,
                        ),
                      ),

                      Text(getTranslated(isLoggedIn ? 'logout' : 'login', context)!, style: rubikRegular)
                    ]),
                  ),
                ),

              ]),
            )
          ]),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          Text('${getTranslated('v', context)} ${AppConstants.appVersion}', style: rubikRegular.copyWith(
            color: Theme.of(context).textTheme.titleMedium?.color?.withOpacity(0.4),
          )),
          const SizedBox(height: Dimensions.paddingSizeExtraLarge),

        ]),
      ),
    ));
  }
}
