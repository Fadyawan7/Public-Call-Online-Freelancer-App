import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_alert_dialog_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_pop_scope_widget.dart';

import 'package:flutter_restaurant/features/auth/domain/models/social_login_model.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/auth/widgets/existing_account_bottom_sheet.dart';
import 'package:flutter_restaurant/features/profile/domain/models/userinfo_model.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class OnlySocialLoginWidget extends StatefulWidget {
  const OnlySocialLoginWidget({super.key});

  @override
  State<OnlySocialLoginWidget> createState() => _OnlySocialLoginWidgetState();
}

class _OnlySocialLoginWidgetState extends State<OnlySocialLoginWidget> {


  void route(bool isRoute, String? token, String errorMessage, String? tempToken, UserInfoModel? userInfoModel, String? socialLoginMedium) async {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context,listen: false);
    if (isRoute) {
      if(token != null){
        RouterHelper.getMainRoute(action: RouteAction.pushNamedAndRemoveUntil);
      }else if(tempToken != null){
        RouterHelper.getOtpRegistrationScreen(
          tempToken,
          authProvider.googleAccount?.email ?? '',
          userName: authProvider.googleAccount?.displayName ?? '',
        );
      }else if(userInfoModel != null){
        ResponsiveHelper.showDialogOrBottomSheet(
          context,
          CustomAlertDialogWidget(
            width: ResponsiveHelper.isDesktop(context) ? MediaQuery.of(context).size.width * 0.3 : null,
            child: ExistingAccountBottomSheet(userInfoModel: userInfoModel, loginMedium: socialLoginMedium!),
          ),
        );
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage),
            backgroundColor: Colors.red));
      }

    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage),
          backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {

    final double width = MediaQuery.of(context).size.width;
    final Size size = MediaQuery.of(context).size;
    final configModel = Provider.of<SplashProvider>(context, listen: false).configModel;


    return CustomPopScopeWidget(
      child: Scaffold(
        appBar:  null,
        body: SafeArea(child: Center(child: CustomScrollView(slivers: [
      
          SliverToBoxAdapter(child: Column(children: [
      
            SizedBox(height: ResponsiveHelper.isDesktop(context) ? size.height * 0.05: size.height * 0.08),
      
            Center(child: Container(
              width: width > 700 ? 450 : width,
              margin: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
              padding: width > 700 ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : null,
              decoration: width > 700 ? BoxDecoration(
                color: Theme.of(context).canvasColor, borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(
                  color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.07),
                  blurRadius: 30,
                  spreadRadius: 0,
                  offset: const Offset(0,10),
                ),],
              ) : null,
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      
                SizedBox(
                  height: ResponsiveHelper.isDesktop(context) ? size.height * 0.03 :
                  size.height * 0.05 ,
                ),
      
                const Directionality(
                  textDirection: TextDirection.ltr,
                  child: CustomAssetImageWidget(Images.logoEfoodSvg, height: 120, fit: BoxFit.scaleDown),
                ),
      
                SizedBox(height: size.height * 0.07),
      
                Text(getTranslated('welcome_to_eFood', context)!,
                  style: rubikRegular.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraLarge),
      
                  Row(children: [
      
                    Expanded(child: Container()),
      
                    Expanded(flex: 4,
                      child: Consumer<AuthProvider>(builder: (context, authProvider, child) {
                        return InkWell(
                          onTap: ()async{
                            try{
                              GoogleSignInAuthentication  auth = await authProvider.googleLogin();
                              GoogleSignInAccount googleAccount = authProvider.googleAccount!;
      
                              authProvider.socialLogin(SocialLoginModel(
                                email: googleAccount.email, token: auth.accessToken, uniqueId: googleAccount.id, medium: 'google',), route);
      
      
                            } catch(er) {
                              debugPrint('Google Sign-In error: $er');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Google Sign-In failed: ${er.toString()}'),
                                  backgroundColor: Colors.red,
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                            decoration: BoxDecoration(
                              color: Theme.of(context).hintColor.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.1)),
                            ),
                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      
                              Image.asset(Images.google,
                                height: ResponsiveHelper.isDesktop(context)
                                    ? 20 :ResponsiveHelper.isTab(context)
                                    ? 20 : 15,
                                width: ResponsiveHelper.isDesktop(context)
                                    ? 20 : ResponsiveHelper.isTab(context)
                                    ? 20 : 15,
                              ),
                              const SizedBox(width: Dimensions.paddingSizeExtraSmall),
      
                              Text(getTranslated("continue_with_google", context)!, style: rubikSemiBold.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: Theme.of(context).textTheme.bodyMedium?.color,
                              ),),
      
                            ],),
                          ),
                        );
                      }),
                    ),
      
                    Expanded(child: Container()),
      
                  ]),
                  const SizedBox(height: Dimensions.paddingSizeLarge),


      
                if( defaultTargetPlatform == TargetPlatform.iOS)...[
                  Row(children: [
      
                    Expanded(child: Container()),
      
                    Expanded(flex: 4,
                      child: Consumer<AuthProvider>(builder: (context, authProvider, child) {
                        return InkWell(
                          onTap: () async {
                            final credential = await SignInWithApple.getAppleIDCredential(scopes: [
                              AppleIDAuthorizationScopes.email,
                              AppleIDAuthorizationScopes.fullName,
                            ],
                              webAuthenticationOptions: WebAuthenticationOptions(
                                clientId: '${configModel?.appleLogin?.clientId}',
                                redirectUri: Uri.parse(AppConstants.baseUrl),
                              ),
                            );
                            authProvider.socialLogin(SocialLoginModel(
                              email: credential.email, token: credential.authorizationCode, uniqueId: credential.authorizationCode, medium: 'apple',
                            ), route);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                            decoration: BoxDecoration(
                              color: Theme.of(context).hintColor.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.1)),
                            ),
                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      
                              Image.asset(
                                Images.appleLogo, color: Theme.of(context).textTheme.bodyMedium?.color,
                                height: ResponsiveHelper.isDesktop(context)
                                    ? 20 :ResponsiveHelper.isTab(context)
                                    ? 20 : 15,
                                width: ResponsiveHelper.isDesktop(context)
                                    ? 20 : ResponsiveHelper.isTab(context)
                                    ? 20 : 15,
                              ),
                              const SizedBox(width: Dimensions.paddingSizeExtraSmall),
      
      
                              Text(getTranslated("continue_with_apple", context)!, style: rubikSemiBold.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: Theme.of(context).textTheme.bodyMedium?.color,
                              )),
      
                            ]),
                          ),
                        );
                      }),
                    ),
      
                    Expanded(child: Container()),
      
                  ]),
                  const SizedBox(height: Dimensions.paddingSizeLarge),
                ],
      
                  Center(child: Text(
                    getTranslated('or', context)!,
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: Theme.of(context).hintColor,
                    ),
                  )),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
      
                  Center(child: InkWell(
                    onTap: ()=> RouterHelper.getDashboardRoute('home', ),
                    child: RichText(text: TextSpan(children: [
      
                      TextSpan(text: '${getTranslated('continue_as_a', context)} ',
                        style: poppinsRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
      
                      TextSpan(text: getTranslated('guest', context),
                        style: poppinsRegular.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
      
                    ])),
                  )),
                  SizedBox(height: size.height * 0.03),

      
      
              ]),
            )),
      

          ])),
      

      
        ]))),
      ),
    );
  }
}

