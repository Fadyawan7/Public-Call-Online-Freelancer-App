import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:flutter_restaurant/common/widgets/not_logged_in_widget.dart';
import 'package:flutter_restaurant/features/apply_freelancer/widgets/profile_custom_painter_widget.dart';
import 'package:flutter_restaurant/features/apply_freelancer/widgets/profile_shimmer_widget.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/profile/domain/models/userinfo_model.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/features/profile/widgets/profile_city_dropdown_widget.dart';
import 'package:flutter_restaurant/features/profile/widgets/profile_country_dropdown_widget.dart';
import 'package:flutter_restaurant/features/profile/widgets/profile_header_widget.dart';
import 'package:flutter_restaurant/features/profile/widgets/profile_image_widget.dart';
import 'package:flutter_restaurant/features/profile/widgets/profile_textfield_widget.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/helper/profile_completed_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final bool fromSplash;

  const ProfileScreen({super.key, required this.fromSplash});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> profileFormKey = GlobalKey<FormState>();
  final TextEditingController countrySearchController = TextEditingController();
  final TextEditingController citySearchController = TextEditingController();

  FocusNode? _firstNameFocus;
  FocusNode? _lastNameFocus;
  FocusNode? _emailFocus;
  FocusNode? _phoneNumberFocus;

  TextEditingController? _firstNameController;
  TextEditingController? _emailController;
  TextEditingController? _phoneNumberController;
  TextEditingController? _aboutMeController;
  TextEditingController? _whatsappNumberController;

  TextEditingController? _countryNameController;
  TextEditingController? _cityNameController;
  File? file;
  bool? isFreelancer = false;
  late bool _isLoggedIn;

  @override
  void initState() {
    super.initState();
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    isFreelancer = profileProvider.isFreelancer;
    _isLoggedIn = authProvider.isLoggedIn();

    _initializeControllers();
    _loadUserData(profileProvider, authProvider);
  }

  void _initializeControllers() {
    _firstNameFocus = FocusNode();
    _lastNameFocus = FocusNode();
    _emailFocus = FocusNode(skipTraversal: true);
    _phoneNumberFocus = FocusNode();

    _firstNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _countryNameController = TextEditingController();
    _cityNameController = TextEditingController();

    _whatsappNumberController = TextEditingController();
    _aboutMeController = TextEditingController();

  }

  Future<void> _loadUserData(
      ProfileProvider profileProvider, AuthProvider authProvider) async {
    if (_isLoggedIn) {
      await profileProvider.getUserInfo(true);
      final userInfoModel = profileProvider.userInfoModel;

      if (userInfoModel != null) {
        _firstNameController!.text = userInfoModel.name ?? '';
        _phoneNumberController!.text = userInfoModel.phone ?? '';
        _emailController!.text = userInfoModel.email ?? '';
        _countryNameController!.text = userInfoModel.countryName ?? '';
        _cityNameController!.text = userInfoModel.cityName ?? '';

        _aboutMeController!.text = userInfoModel.aboutMe ?? '';
        _whatsappNumberController!.text = userInfoModel.whatsapp ?? '';

        await profileProvider.getCountryList();

        if (userInfoModel.countryId != -1) {
          profileProvider.setCountryID(
            countryID: userInfoModel.countryId,
            isUpdate: true,
          );

          profileProvider.getCityList(userInfoModel.countryId);
        } else {
          profileProvider.resetCountryID();
          profileProvider.resetCityID();
        }
      }
    }
  }

  @override
  void dispose() {
    _firstNameFocus?.dispose();
    _lastNameFocus?.dispose();
    _emailFocus?.dispose();
    _phoneNumberFocus?.dispose();

    _firstNameController?.dispose();
    _emailController?.dispose();
    _phoneNumberController?.dispose();
    _aboutMeController?.dispose();

    countrySearchController.dispose();
    citySearchController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile(ProfileProvider profileProvider) async {
    if (profileFormKey.currentState?.validate() ?? false) {
      final firstName = _firstNameController!.text.trim();
      final phoneNumber = _phoneNumberController!.text.trim();
      final email = _emailController!.text.trim();
      final countryId = (profileProvider.userInfoModel?.countryId == null ||
          profileProvider.userInfoModel!.countryId == -1)
          ? profileProvider.selectedCountryID!
          : profileProvider.userInfoModel!.countryId;

      final cityId = (profileProvider.userInfoModel?.cityId == null ||
          profileProvider.userInfoModel!.cityId == -1)
          ? profileProvider.selectedCityID!
          : profileProvider.userInfoModel!.cityId;

      final whatsappNumber = _whatsappNumberController!.text.trim();
      final aboutMe = _aboutMeController!.text.trim();

      final isChanged = profileProvider.userInfoModel!.name == firstName &&
          profileProvider.userInfoModel!.phone == phoneNumber &&
          profileProvider.userInfoModel!.email == email &&
          profileProvider.selectedCountryID == -1 &&
          profileProvider.selectedCityID == -1 &&
          file == null;

      if (isChanged) {
        showCustomSnackBarHelper(
            getTranslated('change_something_to_update', context));
      } else if (profileProvider.selectedCountryID! == -1) {
        showCustomSnackBarHelper(getTranslated('select_country', context));
      } else if (profileProvider.selectedCityID! == -1 && profileProvider.userInfoModel!.cityId == -1) {
        showCustomSnackBarHelper(getTranslated('select_city', context));
      } else if (phoneNumber.isEmpty) {
        showCustomSnackBarHelper(getTranslated('enter_phone_number', context));
      } else {
        final updateUserInfoModel = UserInfoModel()
          ..name = firstName
          ..phone = phoneNumber
          ..email = email
          ..cityId = cityId
          ..countryId = countryId
          ..whatsapp = whatsappNumber
          ..aboutMe = aboutMe;

        final responseModel = await profileProvider.updateUserInfo(
          updateUserInfoModel,
          file,
          Provider.of<AuthProvider>(context, listen: false).getUserToken(),
        );

        if (responseModel.isSuccess) {
          await profileProvider.getUserInfo(true);

          if (mounted) {
            showCustomSnackBarHelper(
              getTranslated(responseModel.message, context),
              isError: false,
            );

            if (widget.fromSplash) {
              await ProfileHelper.setProfileCompleted(true);
              RouterHelper.getMainRoute(
                  action: RouteAction.pushNamedAndRemoveUntil);
            }
          }
        } else if (mounted) {
          showCustomSnackBarHelper(responseModel.message);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Consumer<ProfileProvider>(
                builder: (context, profileProvider, child) {
                  final requestSubmitted =
                      profileProvider.userInfoModel?.freelancerProfileRequest ==
                          'pending';

                  return profileProvider.userInfoModel != null &&
                          (profileProvider.countryList != null &&
                              profileProvider.countryList!.isNotEmpty)
                      ? Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ProfileHeaderWidget(
                                  fromSplash: widget.fromSplash),
                              Expanded(
                                child: CustomPaint(
                                  size: Size(width, height),
                                  painter: ProfileCustomPainterWidget(context),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Profile Image
                                      ProfileImageWidget(
                                        imageUrl: profileProvider
                                            .userInfoModel!.image,
                                        onImageSelected: (File? imageFile) {
                                          setState(() => file = imageFile);
                                        },
                                      ),

                                      // Profile Form
                                      Expanded(
                                        child: SingleChildScrollView(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal:
                                                Dimensions.paddingSizeDefault,
                                          ),
                                          child: Form(
                                            key: profileFormKey,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                    height: Dimensions
                                                        .paddingSizeLarge),

                                                // First Name
                                                ProfileTextFieldWidget(
                                                  isShowBorder: true,
                                                  controller:
                                                      _firstNameController,
                                                  focusNode: _firstNameFocus,
                                                  nextFocus: _lastNameFocus,
                                                  inputType: TextInputType.name,
                                                  capitalization:
                                                      TextCapitalization.words,
                                                  level: getTranslated(
                                                      'first_name', context)!,
                                                  isFieldRequired: true,
                                                  isShowPrefixIcon: true,
                                                  prefixIconUrl:
                                                      Images.profileIconSvg,
                                                  onValidate: (value) => value!
                                                          .isEmpty
                                                      ? '${getTranslated('please_enter', context)!} ${getTranslated('first_name', context)!}'
                                                      : null,
                                                ),
                                                const SizedBox(
                                                    height: Dimensions
                                                        .paddingSizeLarge),

                                                // Email
                                                ProfileTextFieldWidget(
                                                  isEnabled: false,
                                                  isShowBorder: true,
                                                  controller: _emailController,
                                                  focusNode: _emailFocus,
                                                  nextFocus: _phoneNumberFocus,
                                                  inputType: TextInputType
                                                      .emailAddress,
                                                  level: getTranslated(
                                                      'email', context)!,
                                                  isShowPrefixIcon: true,
                                                  isShowSuffixIcon:
                                                      _emailController!
                                                          .text.isNotEmpty,
                                                  suffixIconUrl:
                                                      Images.verifiedSvg,
                                                  prefixIconUrl:
                                                      Images.emailSvg,
                                                ),
                                                const SizedBox(
                                                    height: Dimensions
                                                        .paddingSizeSmall),

                                                // Country

                                                const SizedBox(
                                                    height: Dimensions
                                                        .paddingSizeSmall),
                                                profileProvider.userInfoModel!
                                                            .countryId ==
                                                        -1
                                                    ? CountryDropdownWidget(
                                                        searchController:
                                                            countrySearchController,
                                                      )
                                                    : ProfileTextFieldWidget(
                                                  isEnabled: false,
                                                        isShowBorder: true,
                                                        controller:
                                                            _countryNameController,
                                                        level: getTranslated(
                                                            'Country',
                                                            context)!,
                                                        isShowPrefixIcon: false,
                                                        prefixIconUrl:
                                                            Images.phoneSvg,
                                                      ),
                                                const SizedBox(
                                                    height: Dimensions
                                                        .paddingSizeSmall),

                                                // City

                                                const SizedBox(
                                                    height: Dimensions
                                                        .paddingSizeSmall),
                                                profileProvider.userInfoModel!
                                                            .cityId ==
                                                        -1
                                                    ? CityDropdownWidget(
                                                        searchController:
                                                            citySearchController,
                                                      )
                                                    : ProfileTextFieldWidget(
                                                  isEnabled: false,
                                                        isShowBorder: true,
                                                        controller:
                                                            _cityNameController,
                                                        level: getTranslated(
                                                            'City', context)!,
                                                        isShowPrefixIcon: false,
                                                        prefixIconUrl:
                                                            Images.phoneSvg,
                                                      ),
                                                const SizedBox(
                                                    height: Dimensions
                                                        .paddingSizeLarge),

                                                // Phone
                                                ProfileTextFieldWidget(
                                                  isShowBorder: true,
                                                  controller:
                                                      _phoneNumberController,
                                                  focusNode: _phoneNumberFocus,
                                                  inputType:
                                                      TextInputType.phone,
                                                  level: getTranslated(
                                                      'phone', context)!,
                                                  isShowPrefixIcon: true,
                                                  prefixIconUrl:
                                                      Images.phoneSvg,
                                                ),

                                                if (isFreelancer!) ...[
                                                  const SizedBox(
                                                      height: Dimensions
                                                          .paddingSizeLarge),
                                                  ProfileTextFieldWidget(
                                                    isShowBorder: true,
                                                    controller:
                                                        _phoneNumberController,
                                                    focusNode:
                                                        _phoneNumberFocus,
                                                    inputType:
                                                        TextInputType.phone,
                                                    level: getTranslated(
                                                        'whatsapp', context)!,
                                                    isShowPrefixIcon: true,
                                                    isShowSuffixIcon:
                                                        _phoneNumberController!
                                                            .text.isNotEmpty,
                                                    prefixIconUrl:
                                                        Images.phoneSvg,
                                                  ),
                                                  const SizedBox(
                                                      height: Dimensions
                                                          .paddingSizeLarge),
                                                  Text(
                                                    getTranslated(
                                                        'about_me', context)!,
                                                    style:
                                                        rubikSemiBold.copyWith(
                                                      color: ColorResources
                                                          .getGreyBunkerColor(
                                                              context),
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  CustomTextFieldWidget(
                                                    controller:
                                                        _aboutMeController,
                                                    maxLines: 5,
                                                    capitalization:
                                                        TextCapitalization
                                                            .sentences,
                                                    hintText: getTranslated(
                                                        'personalize_your_profile',
                                                        context),
                                                    fillColor: Theme.of(context)
                                                        .cardColor,
                                                    isShowBorder: true,
                                                    borderColor:
                                                        Theme.of(context)
                                                            .hintColor
                                                            .withOpacity(0.5),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                      // Update Button
                                      SafeArea(
                                        child: Center(
                                          child: Container(
                                            width: width > 700 ? 700 : width,
                                            padding: const EdgeInsets.all(
                                                Dimensions.paddingSizeSmall),
                                            child: CustomButtonWidget(
                                              backgroundColor: !requestSubmitted
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : Theme.of(context)
                                                      .primaryColor
                                                      .withOpacity(0.4),
                                              isLoading:
                                                  profileProvider.isLoading,
                                              btnTxt: getTranslated(
                                                !requestSubmitted
                                                    ? 'update'
                                                    : 'request_submitted',
                                                context,
                                              ),
                                              onTap: !requestSubmitted
                                                  ? () => _updateProfile(
                                                      profileProvider)
                                                  : null,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const ProfileShimmerWidget();
                },
              ),
            )
      ,
    );
  }
}
