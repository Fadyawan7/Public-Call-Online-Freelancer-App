import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_pop_scope_widget.dart';
import 'package:flutter_restaurant/features/auth/domain/models/user_log_data.dart';
import 'package:flutter_restaurant/features/language/providers/localization_provider.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/helper/number_checker_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/common/widgets/custom_text_field_widget.dart';

import 'package:flutter_restaurant/features/auth/widgets/social_login_widget.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final FocusNode _emailNumberFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  TextEditingController? _emailPhoneController;
  TextEditingController? _passwordController;
  GlobalKey<FormState>? _formKeyLogin;
  String? countryCode;

  @override
  void initState() {
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();
    _emailPhoneController = TextEditingController();
    _passwordController = TextEditingController();

    final AuthProvider authProvider =  Provider.of<AuthProvider>(context, listen: false);

    authProvider.setIsLoading = false;
    authProvider.setIsPhoneVerificationButttonLoading = false;
    UserLogData? userData = authProvider.getUserData();

    if(userData != null) {
      if(userData.phoneNumber != null){
        _emailPhoneController!.text = NumberCheckerHelper.getPhoneNumber(userData.phoneNumber ?? '', userData.countryCode ?? '') ?? '';
        authProvider.toggleIsNumberLogin(isUpdate: false);
      }else if(userData.email != null){
        _emailPhoneController?.text = userData.email?.trim() ?? '';
      }
      _passwordController!.text = userData.password ?? '';
    }

    countryCode = "+973";

  }

  @override
  void dispose() {
    _emailPhoneController!.dispose();
    _passwordController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   final double width = MediaQuery.of(context).size.width;
   final size = MediaQuery.of(context).size;
   final LocalizationProvider localizationProvider = Provider.of<LocalizationProvider>(context, listen: false);

   return CustomPopScopeWidget(
     child: Scaffold(
        body: SafeArea(
          child: Center(child: CustomScrollView(slivers: [
     
            SliverToBoxAdapter(
            child: Column(children: [
     
              Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                child: Center(
                  child: Container(
                    width: width > 700 ? 500 : width,
                    padding: width > 700 ? const EdgeInsets.all(Dimensions.paddingSizeExtraLarge) : null,
                    decoration: width > 700 ? BoxDecoration(
                      color: Theme.of(context).canvasColor, borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 5, spreadRadius: 1)],
                    ) : null,
                    child: Consumer<AuthProvider>(
                      builder: (context, authProvider, child) => Form(
                        key: _formKeyLogin,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          SizedBox(height:  size.height * 0.1),

                          Consumer<SplashProvider>(
                              builder: (context, splash, child) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                                    child: Directionality(
                                      textDirection: TextDirection.ltr,
                                      child: CustomImageWidget(
                                        image: '${splash.configModel!.companyLogo}',
                                        fit: BoxFit.contain,
                                        width: 150, height: 90,
                                      ),
                                    ),
                                  ),
                                );
                              }
                          ),
                          const SizedBox(height: 35),
     
                          Selector<AuthProvider, bool>(
                            selector: (context, authProvider) => authProvider.isNumberLogin,
                            builder: (_, isNumberLogin, ___) {


                              return CustomTextFieldWidget(
                                countryDialCode: isNumberLogin ? countryCode : null,
                                onCountryChanged: (CountryCode value) {
                                  countryCode = value.dialCode;
                                },
                                hintText: getTranslated('email', context),
                                prefixIconUrl: Images.emailSvg,
                                isShowPrefixIcon: true,
                                prefixIconColor: Theme.of(context).primaryColor,
                                isShowBorder: true,
                                isRequired: true,
                                focusNode: _emailNumberFocus,
                                nextFocus: _passwordFocus,
                                controller: _emailPhoneController,
                                // inputType: TextInputType.emailAddress,
                                label: getTranslated('email', context),
                              );
                            },
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),
     
                          CustomTextFieldWidget(
                            hintText: 'Password',
                            label: getTranslated('password', context),
                            isShowBorder: true,
                            isRequired: true,
                            isPassword: true,
                            isShowSuffixIcon: true,
                            prefixIconColor: Theme.of(context).primaryColor,

                            focusNode: _passwordFocus,
                            controller: _passwordController,
                            inputAction: TextInputAction.done,
                            prefixIconUrl: Images.lockSvg,
                            isShowPrefixIcon: true,
                          ),
                          const SizedBox(height: 22),
     
                          // for remember me section
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
     
                            InkWell(
                              onTap: ()=> authProvider.toggleRememberMe(),
                              child: Row(children: [
     
                                Container(width: 18, height: 18,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Theme.of(context).primaryColor),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: authProvider.isActiveRememberMe
                                      ? Icon(Icons.done, color: Theme.of(context).primaryColor, size: 14)
                                      : const SizedBox.shrink(),
                                ),
                                const SizedBox(width: Dimensions.paddingSizeSmall),
     
                                Text(getTranslated('remember_me', context)!,
                                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: ColorResources.getHintColor(context),
                                  ),
                                ),
     
                              ]),
                            ),
     
                            InkWell(
                              onTap: () {
                                RouterHelper.getForgetPassRoute();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  localizationProvider.isLtr ? "${getTranslated('forgot_password', context)!}?"
                                      : "${getTranslated('forgot_password', context)!}؟",
                                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                              ),
                            ),
     
                          ]),
     
                          // const SizedBox(height: 22),
                          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
     
                            authProvider.loginErrorMessage!.isNotEmpty
                                ? CircleAvatar(backgroundColor: Theme.of(context).primaryColor, radius: 5)
                                : const SizedBox.shrink(),
                            const SizedBox(width: 8),
     
                            Expanded(
                              child: Text(
                                authProvider.loginErrorMessage ?? "",
                                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
     
                          ]),
                          const SizedBox(height: 10),
     
                          !authProvider.isLoading && !authProvider.isPhoneNumberVerificationButtonLoading ? CustomButtonWidget(
                            btnTxt: getTranslated('sign_in', context),
                            onTap: () async {

                              String password = _passwordController!.text.trim();

                              if (_emailPhoneController!.text.isEmpty) {
                                showCustomSnackBarHelper(getTranslated('enter_email_or_phone', context));
                              }else if (password.isEmpty) {
                                showCustomSnackBarHelper(getTranslated('enter_password', context));
                              }else if (password.length < 8) {
                                showCustomSnackBarHelper(getTranslated('password_should_be', context));
                              }else {

                                String userInput = _emailPhoneController!.text.trim();
                                String type =  'email';
                                 ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);


                                await authProvider.login(userInput, password, type).then((status) async {
                                  if (status.isSuccess) {
                                    await profileProvider.getUserInfo(true);
                                    if (authProvider.isActiveRememberMe) {
                                      authProvider.saveUserNumberAndPassword(UserLogData(
                                        email: userInput,
                                        password: password,
                                      ));
                                    } else {
                                      authProvider.clearUserLogData();
                                    }

                                    RouterHelper.getDashboardRoute('home', action: RouteAction.pushNamedAndRemoveUntil);
                                  }
                                });

                              }
                            },
                          ) :
                          Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),
     
                            Center(
                              child: Text(
                                getTranslated('or', context)! ,
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeDefault),
     

     
                            const Center(child: SocialLoginWidget()),
                          const SizedBox(height: Dimensions.paddingSizeLarge),
     
                          InkWell(
                            onTap: ()=> RouterHelper.getCreateAccountRoute(),
                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
     
                              Text(getTranslated('create_an_account', context)!,
                                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: Theme.of(context).textTheme.bodyMedium?.color,
                                ),
                              ),
                              const SizedBox(width: Dimensions.paddingSizeSmall),
     
                              Text(getTranslated('signup_here', context)!,
                                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Theme.of(context).colorScheme.error,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
     
                            ]),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),
     
                        ]),
                      ),
                    ),
                  ),
                ),
              ),
     
            ]),
          ),
     
     

          ]),
          ),
        ),
      ),
   );
  }
}
