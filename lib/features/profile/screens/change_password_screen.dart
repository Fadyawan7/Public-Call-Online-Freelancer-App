
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/response_model.dart';
import 'package:flutter_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/features/profile/widgets/profile_shimmer_widget.dart';
import 'package:flutter_restaurant/features/profile/widgets/profile_textfield_widget.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class  ChangePasswordScreen extends StatefulWidget {

  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {

  FocusNode? _passwordFocus;
  FocusNode? _confirmPasswordFocus;

  TextEditingController? _passwordController;
  TextEditingController? _confirmPasswordController;

  File? file;
  XFile? data;
  final picker = ImagePicker();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<FormState> profileFormKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    _passwordFocus = FocusNode();
    _confirmPasswordFocus = FocusNode();

    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

  }



  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar:  CustomAppBarWidget(
        titleColor: Colors.white,
        title: 'Change Password',
        isBackButtonExist: Navigator.canPop(context),
        onBackPressed: ()=> Navigator.pop(context),

      ),
      key: _scaffoldKey,
      body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),

        child: Consumer<ProfileProvider>(
          builder: (context, profileProvider, child) {

            return profileProvider.userInfoModel != null ? Column(mainAxisSize: MainAxisSize.min, children: [


              // const SizedBox(height: 50),
              Expanded(child: Column(mainAxisSize: MainAxisSize.min, children: [
                /// for profile image

                /// for profile edit section
                Expanded(child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  child: Form(key: profileFormKey, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[

                    const SizedBox(height: Dimensions.paddingSizeLarge),
                    /// for password section
                      ProfileTextFieldWidget(
                          hintText: getTranslated('password_hint', context),
                          isShowBorder: true,
                          controller: _passwordController,
                          focusNode: _passwordFocus,
                          nextFocus: _confirmPasswordFocus,
                          isPassword: true,
                          isShowSuffixIcon: true,
                          level: getTranslated('password', context)!,
                          isFieldRequired: true,
                          isShowPrefixIcon: true,
                          prefixIconUrl: Images.lockerSvg,
                          onValidate: (value) {
                            if(value == null || value.isEmpty){
                              return null;
                            }else{
                              if(value.isNotEmpty && value.length < 8){
                                return getTranslated('password_hint', context)!;
                              }else {
                                return null;
                              }
                            }
                          }
                        //value!.isEmpty || value.length < 6
                        //  ? '${getTranslated('please_enter', context)!} ${getTranslated('password', context)!}' : null,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),
                      ProfileTextFieldWidget(
                          hintText: getTranslated('password_hint', context),
                          isShowBorder: true,
                          controller: _confirmPasswordController,
                          focusNode: _confirmPasswordFocus,
                          isPassword: true,
                          isShowSuffixIcon: true,
                          inputAction: TextInputAction.done,
                          level: getTranslated('confirm_password', context)!,
                          isShowPrefixIcon: true,
                          prefixIconUrl: Images.lockerSvg,
                          onValidate: (value) {
                            if(value == null || value.isEmpty){
                              if(_passwordController?.text == null || _passwordController!.text.isEmpty){
                                return null;
                              }
                              else{
                                return getTranslated('enter_confirm_password', context)!;
                              }
                            }else{
                              if(value.isNotEmpty && value.length < 8){
                                return getTranslated('password_hint', context)!;
                              }else if(value != _passwordController?.text){
                                return '${getTranslated('password_did_not_match', context)}';
                              }else{
                                return null;
                              }
                            }
                          }
                        //_passwordController?.text != _confirmPasswordController?.text
                        //  ? '${getTranslated('please_enter', context)!} ${getTranslated('confirm_password', context)!}' : null,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),


                  ])),
                )),

                SafeArea(
                  child: Center(
                    child: Container(
                      width: 700,
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: CustomButtonWidget(
                        backgroundColor:  Theme.of(context).primaryColor ,
                        isLoading: profileProvider.isLoading,
                        btnTxt: getTranslated('update' , context),
                        onTap: ()  async {


                          if(profileFormKey.currentState != null && profileFormKey.currentState!.validate()){
                            String password = _passwordController!.text.trim();
                            String confirmPassword = _confirmPasswordController!.text.trim();

                            bool isPasswordEmpty = password.isEmpty;
                            bool isConfirmPasswordEmpty = confirmPassword.isEmpty;


                            if (isPasswordEmpty || isConfirmPasswordEmpty) {
                              showCustomSnackBarHelper(getTranslated('change_something_to_update', context));
                            } else {

                              ResponseModel responseModel = await profileProvider.updateUserPassword(
                                password, confirmPassword,
                                Provider.of<AuthProvider>(context, listen: false).getUserToken(),
                              );


                              if(responseModel.isSuccess) {
                                profileProvider.getUserInfo(true);

                                if(context.mounted){
                                  _passwordController?.clear();
                                  _confirmPasswordController?.clear();
                                  showCustomSnackBarHelper(getTranslated(responseModel.message, context), isError: false);
                                }
                              }else {
                                showCustomSnackBarHelper(responseModel.message);
                              }
                            }

                          }
                        }
                      ),
                    ),
                  ),
                ),

              ])),

            ]) : const ProfileShimmerWidget();
          },
        ),
      ),
    );
  }
}
