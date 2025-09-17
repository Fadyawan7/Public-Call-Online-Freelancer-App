
import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/response_model.dart';
import 'package:flutter_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:flutter_restaurant/common/widgets/not_logged_in_widget.dart';
import 'package:flutter_restaurant/features/apply_freelancer/domain/models/apply_freelancer_model.dart';
import 'package:flutter_restaurant/features/auth/domain/enum/auth_enum.dart';
import 'package:flutter_restaurant/features/auth/domain/models/signup_model.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/category/domain/category_model.dart';
import 'package:flutter_restaurant/features/category/providers/category_provider.dart';
import 'package:flutter_restaurant/features/freelancer/providers/freelancer_provider.dart';
import 'package:flutter_restaurant/features/profile/domain/models/userinfo_model.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/features/profile/widgets/profile_custom_painter_widget.dart';
import 'package:flutter_restaurant/features/profile/widgets/profile_shimmer_widget.dart';
import 'package:flutter_restaurant/features/profile/widgets/profile_textfield_widget.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class  ApplyFreelancerScreen extends StatefulWidget {
  const ApplyFreelancerScreen({super.key});

  @override
  State<ApplyFreelancerScreen> createState() => _ApplyFreelancerScreenState();
}

class _ApplyFreelancerScreenState extends State<ApplyFreelancerScreen> {
  FocusNode? _firstNameFocus;
  FocusNode? _aboutMe;
  FocusNode? _phoneNumberFocus;

  TextEditingController? _firstNameController;
  TextEditingController? _aboutMeController;
  TextEditingController? _phoneNumberController;


  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<FormState> profileFormKey = GlobalKey<FormState>();
  late bool _isLoggedIn;
  final GlobalKey dropdownKey = GlobalKey();


  @override
  void initState() {
    super.initState();
    final ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);

    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);

    setProfileFormField(profileProvider, authProvider);
  }

  void setProfileFormField(ProfileProvider profileProvider, AuthProvider authProvider){
    _isLoggedIn = authProvider.isLoggedIn();
    _firstNameFocus = FocusNode();
    _aboutMe = FocusNode();
    _phoneNumberFocus = FocusNode();

    _firstNameController = TextEditingController();
    _aboutMeController = TextEditingController();
    _phoneNumberController = TextEditingController();

    if(_isLoggedIn) {
      profileProvider.getUserInfo(true).then((_) {
        UserInfoModel? userInfoModel = profileProvider.userInfoModel;
        if(userInfoModel != null){
          _firstNameController!.text = userInfoModel.name ?? '';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    final freelancerProvider = Provider.of<FreelancerProvider>(context, listen: false);

    final TextEditingController searchController = TextEditingController();


    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;


    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        appBar: ( !_isLoggedIn ? CustomAppBarWidget(
          context: context,
          title:  getTranslated('apply_freelancer', context)!,
          centerTitle: true ,
        ) : null) as PreferredSizeWidget? ,
        body: _isLoggedIn ? Consumer<ProfileProvider>(
          builder: (context, profileProvider, child) {

            return profileProvider.userInfoModel != null ? Container(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Column(mainAxisSize: MainAxisSize.min, children: [

                const SizedBox(width: double.infinity, height: Dimensions.paddingSizeExtraLarge),
                Container(height: 100, color: Colors.transparent, child: Row(children: [
                    Padding(
                      padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                      child: IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back_ios),
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeExtraLarge),

                    Text(getTranslated('apply_freelancer', context)!,
                        style: rubikSemiBold.copyWith(
                      fontSize: Dimensions.fontSizeLarge, color: Colors.white,
                    )),
                ])),

                Expanded(child: CustomPaint(
                  size: Size(width, height),
                  painter: ProfileCustomPainterWidget(context),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    /// for profile image
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraLarge),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: ColorResources.borderColor,
                        border: Border.all(color: Colors.white54, width: 3),
                        shape: BoxShape.circle,
                      ),
                      child: Stack(
                        clipBehavior: Clip.none, children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: CustomImageWidget(
                            placeholder: Images.placeholderUser, width: 80, height: 80, fit: BoxFit.cover,
                            image: '${profileProvider.userInfoModel!.image}',
                          ),
                        ),
                      ],
                      ),
                    ),

                    /// for profile edit section
                    Expanded(child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                      child: Form(key: profileFormKey, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                        // for first name section
                        const SizedBox(height: Dimensions.paddingSizeLarge),
                        ProfileTextFieldWidget(
                          isShowBorder: true,
                          controller: _firstNameController,
                          focusNode: _firstNameFocus,
                          inputType: TextInputType.name,
                          capitalization: TextCapitalization.words,
                          level: getTranslated('first_name', context)!,
                          isShowPrefixIcon: true,
                          isEnabled: false,
                          prefixIconUrl: Images.profileIconSvg,
                          onValidate: (value) => value!.isEmpty
                              ? '${getTranslated('please_enter', context)!} ${getTranslated('first_name', context)!}' : null,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeLarge),
                        Text(
                          getTranslated('freelancer_category', context)!,
                          style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),


                        Consumer<FreelancerProvider>(
                          builder: (context,freelancerProvider,child){
                            return DropdownButtonHideUnderline(child: DropdownButton2<String>(

                              key: dropdownKey,
                              iconStyleData: IconStyleData(icon: Icon(Icons.keyboard_arrow_down_rounded, color: Theme.of(context).hintColor)),
                              isExpanded: true,
                              hint: Text(
                                getTranslated('select_freelancer_category', context)!,
                                style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),
                              ),
                              selectedItemBuilder: (BuildContext context) {
                                return categoryProvider.categoryList!
                                    .map((CategoryModel category) {
                                  return Row(
                                    children: [
                                      Text(
                                        category.name ?? "",
                                        style: rubikRegular.copyWith(
                                          fontSize: Dimensions.fontSizeDefault,
                                          color: Theme.of(context).textTheme.bodyMedium?.color,
                                        ),
                                      ),
                                      // CustomImageWidget(
                                      //   height: 30,
                                      //   width: 30,
                                      //   placeholder: Images.categoryBanner, fit: BoxFit.cover,
                                      //   image: '${category.image}',
                                      // ),
                                    ],
                                  );
                                }).toList();
                              },

                              items: categoryProvider.categoryList!.map((CategoryModel category) => DropdownMenuItem<String>(
                                value: category.id.toString(),
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                                  Text(category.name ?? "", style: rubikRegular.copyWith(
                                    fontSize: Dimensions.fontSizeDefault,
                                    color: Theme.of(context).textTheme.bodyMedium?.color,
                                  )),

                                  CustomImageWidget(
                                    height: 30,
                                    width: 30,
                                    placeholder: Images.categoryBanner, fit: BoxFit.cover,
                                    image: '${category.image}',
                                  ),

                                ]),
                              )).toList(),

                              value: freelancerProvider.selectedCategoryID == -1 ? null
                                  : categoryProvider.categoryList!.firstWhere((category) => category.id == freelancerProvider.selectedCategoryID).id.toString(),

                              onChanged: (String? value) {
                                freelancerProvider.setCategoryID(categoryID: int.parse(value!));
                              },

                              dropdownSearchData: DropdownSearchData(
                                searchController: searchController,
                                searchInnerWidgetHeight: 50,
                                searchInnerWidget: Container(
                                  height: 50,
                                  padding: const EdgeInsets.only(
                                    top: Dimensions.paddingSizeSmall,
                                    left: Dimensions.paddingSizeSmall,
                                    right: Dimensions.paddingSizeSmall,
                                  ),
                                  child: TextFormField(
                                    controller: searchController,
                                    expands: true,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                      hintText: getTranslated('select_freelancer_category', context)!,
                                      hintStyle: const TextStyle(fontSize: Dimensions.fontSizeSmall),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                      ),
                                    ),
                                  ),
                                ),
                                searchMatchFn: (item, searchValue) {
                                  CategoryModel category = categoryProvider.categoryList!
                                      .firstWhere((element) => element.id.toString() == item.value);
                                  return category.name?.toLowerCase().contains(searchValue.toLowerCase()) ?? false;
                                },
                              ),
                              buttonStyleData: ButtonStyleData(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Theme.of(context).hintColor),
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),),
                                padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                              ),

                            ));
                          },
                        ),
                        const SizedBox(height: Dimensions.paddingSizeLarge),
                        Consumer<AuthProvider>(
                            builder: (context, authProvider, child) {
                              return ProfileTextFieldWidget(
                                isShowBorder: true,
                                controller: _phoneNumberController,
                                focusNode: _phoneNumberFocus,
                                inputType: TextInputType.phone,
                                level: getTranslated('whatsapp', context)!,
                                isShowPrefixIcon: true,
                                isToolTipSuffix:  _phoneNumberController!.text.isNotEmpty? true : false,
                                prefixIconUrl: Images.whatsapp,

                              );
                            }
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        Text(
                          getTranslated('about_me', context)!,
                          style: rubikSemiBold.copyWith(color: ColorResources.getGreyBunkerColor(context)), overflow: TextOverflow.ellipsis,
                        ),

                        CustomTextFieldWidget(
                          controller: _aboutMeController,
                          maxLines: 5,
                          capitalization: TextCapitalization.sentences,
                          hintText: getTranslated('personalize_your_profile', context),
                          fillColor: Theme.of(context).cardColor,
                          isShowBorder: true,
                          borderColor: Theme.of(context).hintColor.withOpacity(0.5),
                          onChanged: (text) {
                            // reviewProvider.setReview(index, text);
                          },
                        ),


                      ])),
                    )),



                    SafeArea(
                      child: Center(
                        child: Container(
                          width: width > 700 ? 700 : width,
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          margin: ResponsiveHelper.isDesktop(context)
                              ? const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall) : EdgeInsets.zero,
                          child: CustomButtonWidget(
                            isLoading: profileProvider.isLoading,
                            btnTxt: getTranslated('apply', context),
                            onTap: () async {
                              String aboutMe = _aboutMeController!.text.trim();
                              String whatsappNumber = _phoneNumberController!.text.trim();

                              if(profileFormKey.currentState != null && profileFormKey.currentState!.validate()){

                                if ( freelancerProvider.selectedCategoryID == -1) {
                                  showCustomSnackBarHelper(getTranslated('select_freelancer_category', context));
                                }else if ( whatsappNumber.isEmpty  ) {
                                  showCustomSnackBarHelper(getTranslated('Whatsapp number is required', context));
                                } else if ( aboutMe.isEmpty  ) {
                                  showCustomSnackBarHelper(getTranslated('about_me_empty', context));
                                } else {
                                  ApplyFreelancerModel applyFreelancerModel = ApplyFreelancerModel();
                                  applyFreelancerModel.about = aboutMe;
                                  applyFreelancerModel.categoryId = freelancerProvider.selectedCategoryID ;
                                  applyFreelancerModel.whatsapp = whatsappNumber ;

                                  // updateUserInfoModel.email = email;
                                  //
                                  // ApplyFreelancerModel applyFreelancerRequest = ApplyFreelancerModel(
                                  //   categoryId: freelancerProvider.selectedCategoryID,
                                  //   about: aboutMe,
                                  //   perHour: 0,
                                  //   whatsapp: whatsappNumber
                                  // );
                                  print('=====RESPONSEwhatsappNumber====${applyFreelancerModel.toJson()}');

                                  freelancerProvider.applyFreelancer(applyFreelancerModel, _callback);
                                }
                              }
                            }
                          ),
                        ),
                      ),
                    ),

                  ]),
                )),

              ])) : const ProfileShimmerWidget();
          },
        ) : const NotLoggedInWidget(),
      ),
    );
  }
  void _callback(bool isSuccess, String message) async {
    if(isSuccess) {
      Provider.of<FreelancerProvider>(context, listen: false).resetCategoryID();
      Provider.of<ProfileProvider>(context, listen: false).getUserInfo(true);
      RouterHelper.getOrderSuccessScreen('success',message);
    }else {
      showCustomSnackBarHelper(message);
    }
  }
}

