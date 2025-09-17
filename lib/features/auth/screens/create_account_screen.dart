import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/response_model.dart';
import 'package:flutter_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_restaurant/features/auth/domain/models/signup_model.dart';
import 'package:flutter_restaurant/features/auth/domain/models/user_log_data.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/helper/email_checker_helper.dart';
import 'package:flutter_restaurant/helper/profile_completed_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:provider/provider.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String? _countryDialCode;

  @override
  void initState() {
    super.initState();
    _countryDialCode = "+973";
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final config =  Provider.of<SplashProvider>(context, listen: false).configModel;
    ProfileProvider profileProvider =  Provider.of<ProfileProvider>(context, listen: false);

    return Scaffold(
      appBar:CustomAppBarWidget(
        titleColor: Colors.white,
        title: getTranslated('create_account', context)!,
        isBackButtonExist: Navigator.canPop(context),
        onBackPressed: ()=> Navigator.pop(context),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),

        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) => SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(

                children: [
                  Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                    child: Center(
                      child: Container(
                        width: width > 700 ? 700 : width,
                        padding: width > 700 ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : null,
                        decoration: width > 700 ? BoxDecoration(
                          color: Theme.of(context).canvasColor, borderRadius: BorderRadius.circular(10),
                          boxShadow: [BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 5, spreadRadius: 1)],
                        ) : null,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            // for first name section
                            Text(
                              getTranslated('first_name', context)!,
                              style: Theme.of(context).textTheme.displayMedium!.copyWith(color: ColorResources.getHintColor(context)),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                            CustomTextFieldWidget(
                              hintText: 'John',
                              isShowBorder: true,
                              controller: _firstNameController,
                              focusNode: _firstNameFocus,
                              nextFocus: _lastNameFocus,
                              inputType: TextInputType.name,
                              capitalization: TextCapitalization.words,
                            ),
                            const SizedBox(height: Dimensions.paddingSizeLarge),
                            Text(
                              getTranslated('email', context)!,
                              style: Theme.of(context).textTheme.displayMedium!.copyWith(color: ColorResources.getHintColor(context)),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            CustomTextFieldWidget(
                              hintText: getTranslated('demo_gmail', context),
                              isShowBorder: true,
                              controller: _emailController,
                              focusNode: _emailFocus,
                              nextFocus:  _passwordFocus,
                              inputType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: Dimensions.paddingSizeLarge),


                            // for password section
                            Text(
                              getTranslated('password', context)!,
                              style: Theme.of(context).textTheme.displayMedium!.copyWith(color: ColorResources.getHintColor(context)),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                            CustomTextFieldWidget(
                              hintText: getTranslated('password_hint', context),
                              isShowBorder: true,
                              isPassword: true,
                              controller: _passwordController,
                              focusNode: _passwordFocus,
                              nextFocus: _confirmPasswordFocus,
                              isShowSuffixIcon: true,
                            ),
                            const SizedBox(height: 22),

                            // for confirm password section
                            Text(
                              getTranslated('confirm_password', context)!,
                              style: Theme.of(context).textTheme.displayMedium!.copyWith(color: ColorResources.getHintColor(context)),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                            CustomTextFieldWidget(
                              hintText: getTranslated('password_hint', context),
                              isShowBorder: true,
                              isPassword: true,
                              controller: _confirmPasswordController,
                              focusNode: _confirmPasswordFocus,
                              isShowSuffixIcon: true,
                              inputAction: TextInputAction.done,
                            ),

                            const SizedBox(height: 22),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                authProvider.registrationErrorMessage!.isNotEmpty
                                    ? CircleAvatar(backgroundColor: Theme.of(context).primaryColor, radius: 5)
                                    : const SizedBox.shrink(),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    authProvider.registrationErrorMessage ?? "",
                                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                          fontSize: Dimensions.fontSizeSmall,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                  ),
                                )
                              ],
                            ),

                            // for signup button
                            const SizedBox(height: 10),
                            !authProvider.isLoading
                                ? CustomButtonWidget(
                              btnTxt: getTranslated('signup', context),
                              onTap: () async {
                                String firstName = _firstNameController.text.trim();
                                String number = _numberController.text.trim();
                                String email = _emailController.text.trim();
                                String password = _passwordController.text.trim();
                                String confirmPassword = _confirmPasswordController.text.trim();

                                if (firstName.isEmpty) {
                                  showCustomSnackBarHelper(getTranslated('enter_first_name', context));
                                } else if (email.isEmpty) {
                                  showCustomSnackBarHelper(getTranslated('enter_email_address', context));
                                } else if (EmailCheckerHelper.isNotValid(email)) {
                                  showCustomSnackBarHelper(getTranslated('enter_valid_email', context));
                                } else if (password.isEmpty) {
                                  showCustomSnackBarHelper(getTranslated('enter_password', context));
                                } else if (password.length < 8) {
                                  showCustomSnackBarHelper(getTranslated('password_should_be', context));
                                } else if (confirmPassword.isEmpty) {
                                  showCustomSnackBarHelper(getTranslated('enter_confirm_password', context));
                                } else if (password != confirmPassword) {
                                  showCustomSnackBarHelper(getTranslated('password_did_not_match', context));
                                } else {
                                  SignUpModel signUpModel = SignUpModel(
                                    name: firstName,
                                    email: email,
                                    password: password,
                                    phone: '$_countryDialCode$number',
                                  );

                                  // Optimized registration handler
                                  final authProvider = Provider.of<AuthProvider>(context, listen: false);
                                  final signUpResponse = await authProvider.registration(
                                    signUpModel,
                                    authProvider.getUserToken(),
                                  );

                                  if (signUpResponse.isSuccess) {
                                    // Handle successful registration
                                    await _handleSuccessfulRegistration(
                                      context: context,
                                      authProvider: authProvider,
                                      email: email,
                                      password: password,
                                      signUpResponse: signUpResponse,
                                    );
                                  } else {
                                    // Handle registration error
                                    showCustomSnackBarHelper(
                                      getTranslated(signUpResponse.message, context),
                                      isError: true,
                                    );
                                  }
                                }
                              },
                            )
                                : Center(
                                    child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                                  )),

                            // for already an account
                            const SizedBox(height: 11),
                            InkWell(
                              onTap: ()=> RouterHelper.getLoginRoute(action: RouteAction.pushReplacement),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      getTranslated('already_have_account', context)!,
                                      style: Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor.withOpacity(0.7)),
                                    ),
                                    const SizedBox(width: Dimensions.paddingSizeSmall),
                                    Text(getTranslated('login', context)!,
                                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                        fontSize: Dimensions.fontSizeDefault,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Theme.of(context).colorScheme.error,
                                        color: Theme.of(context).colorScheme.error,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Future<void> _handleSuccessfulRegistration({
    required BuildContext context,
    required AuthProvider authProvider,
    required String email,
    required String password,
    required ResponseModel signUpResponse,
  }) async {
    // Show success message
    showCustomSnackBarHelper(
      getTranslated(signUpResponse.message, context),
      isError: false,
    );

    // Set profile as not completed
    await ProfileHelper.setProfileCompleted(false);

    // Perform login after registration
    final loginResponse = await authProvider.login(email, password, 'email');

    if (loginResponse.isSuccess) {
      // Handle remember me preference
      if (authProvider.isActiveRememberMe) {
        authProvider.saveUserNumberAndPassword(UserLogData(
          email: email,
          password: password,
        ));
      } else {
        authProvider.clearUserLogData();
      }

      // Navigate to profile
      if (mounted) {
        RouterHelper.getProfileRoute(
          'splash',
          action: RouteAction.pushNamedAndRemoveUntil,
        );
      }
    } else {
      // Handle login error after successful registration
      if (mounted) {
        showCustomSnackBarHelper(
          getTranslated(loginResponse.message, context),
          isError: true,
        );
      }
    }
  }
}
