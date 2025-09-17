import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/response_model.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:flutter_restaurant/features/category/providers/category_provider.dart';
import 'package:flutter_restaurant/features/booking/providers/booking_provider.dart';
import 'package:flutter_restaurant/features/booking/widgets/booking_list_widget.dart';
import 'package:flutter_restaurant/features/freelancer/providers/freelancer_provider.dart';
import 'package:flutter_restaurant/features/freelancer_portfolio/providers/freelancer_portfolio_provider.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_restaurant/common/widgets/not_logged_in_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class FreelancerPortfolioAddScreen extends StatefulWidget {
  const FreelancerPortfolioAddScreen({super.key});

  @override
  State<FreelancerPortfolioAddScreen> createState() =>
      _FreelancerPortfolioAddScreenState();
}

class _FreelancerPortfolioAddScreenState
    extends State<FreelancerPortfolioAddScreen> with TickerProviderStateMixin {
  File? file;
  final picker = ImagePicker();
  final GlobalKey<FormState> portfolioFormKey = GlobalKey<FormState>();

  void _choose() async {
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
        maxHeight: 500,
        maxWidth: 600);
    if (pickedFile != null) {
      setState(() {
        file = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (CustomAppBarWidget(
        titleColor: Colors.white,
        context: context,
        title: getTranslated('Add Portfolio Image', context),
      )) as PreferredSizeWidget?,
      body: Column(children: [
        Expanded(
            child: SizedBox(
                width: Dimensions.webScreenWidth,
                child: Form(
                  key: portfolioFormKey,
                  child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                              height: Dimensions.paddingSizeOverLarge),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              getTranslated('Upload Portfolio Image', context)!,
                              style: rubikSemiBold.copyWith(
                                  color: ColorResources.getGreyBunkerColor(
                                      context)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          file != null
                              ? Stack(
                                  children: [
                                    DottedBorder(
                                      dashPattern: const [4, 5],
                                      borderType: BorderType.RRect,
                                      color: Theme.of(context).hintColor,
                                      radius: const Radius.circular(15),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(
                                                  Dimensions.paddingSizeSmall)),
                                          child: Image.file(
                                            file!,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.3,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.3,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 5,
                                      right: 5,
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        onTap: _choose,
                                        child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Theme.of(context)
                                                          .hintColor,
                                                      blurRadius: 1,
                                                      spreadRadius: 1,
                                                      offset:
                                                          const Offset(0, 0))
                                                ],
                                                borderRadius: const BorderRadius
                                                    .all(
                                                    Radius.circular(Dimensions
                                                        .paddingSizeDefault))),
                                            child: const Padding(
                                              padding: EdgeInsets.all(4.0),
                                              child: Icon(
                                                Icons.edit_note_sharp,
                                                color: Colors.red,
                                                size: 25,
                                              ),
                                            )),
                                      ),
                                    ),
                                  ],
                                )
                              : InkWell(
                                  onTap: _choose,
                                  child: Stack(
                                    children: [
                                      DottedBorder(
                                        dashPattern: const [4, 5],
                                        borderType: BorderType.RRect,
                                        color: Theme.of(context).hintColor,
                                        radius: const Radius.circular(15),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.paddingSizeSmall),
                                          child: Image.asset(
                                              Images.placeholderImage,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.3,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.3,
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      const Positioned(
                                        bottom: 0,
                                        right: 0,
                                        top: 0,
                                        left: 0,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Icon(
                                            Icons.camera_alt,
                                            color: Colors.black,
                                            size: 40,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          const SizedBox(
                              height: Dimensions.paddingSizeOverLarge),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                CustomTextFieldWidget(
                                  hintText:
                                      getTranslated('Service Title', context),

                                  isShowBorder: true,
                                  isRequired: true,

                                  //    controller: _emailPhoneController,
                                  inputType: TextInputType.text,
                                ),
                                const SizedBox(
                                    height: Dimensions.paddingSizeLarge),
                                CustomTextFieldWidget(
                                  hintText: getTranslated(
                                      'Short Description', context),

                                  isShowBorder: true,
                                  isRequired: true,

                                  //    controller: _emailPhoneController,
                                  inputType: TextInputType.text,
                                ),
                                const SizedBox(
                                    height: Dimensions.paddingSizeLarge),
                                ChipTagsInput(),
                              ],
                            ),
                          ),
                        ]),
                  ),
                ))),
        Center(
          child: Consumer<FreelancerPortfolioProvider>(
            builder: (context, freelancerPortfolioProvider, child) {
              return Container(
                width: 700,
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                margin: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeSmall,
                    vertical: Dimensions.paddingSizeDefault),
                child: CustomButtonWidget(
                    isLoading: freelancerPortfolioProvider.isLoading,
                    btnTxt: getTranslated('Upload', context),
                    onTap: () async {
                      if (portfolioFormKey.currentState != null &&
                          portfolioFormKey.currentState!.validate()) {
                        if (file == null) {
                          showCustomSnackBarHelper(
                              getTranslated('select_city', context));
                        } else {
                          ResponseModel responseModel =
                              await freelancerPortfolioProvider
                                  .freelancerPortfolioAdd(
                            file,
                            Provider.of<AuthProvider>(context, listen: false)
                                .getUserToken(),
                          );

                          if (responseModel.isSuccess) {
                            if (context.mounted) {
                              setState(() {
                                file = null;
                              });
                              showCustomSnackBarHelper(
                                  getTranslated(
                                      'Uploaded Successfully !', context),
                                  isError: false);
                              Provider.of<FreelancerPortfolioProvider>(context,
                                      listen: false)
                                  .getFreelancerPortfolioList();
                            }
                          } else {
                            showCustomSnackBarHelper(responseModel.message);
                          }
                        }
                      }
                    }),
              );
            },
          ),
        )
      ]),
    );
  }
}

class ChipTagsInput extends StatefulWidget {
  const ChipTagsInput({Key? key}) : super(key: key);

  @override
  State<ChipTagsInput> createState() => _ChipTagsInputState();
}

class _ChipTagsInputState extends State<ChipTagsInput> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _tags = [];

  void _addTag(String value) {
    if (value.trim().isEmpty) return;
    setState(() {
      _tags.add(value.trim());
    });
    _controller.clear();
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border:
            Border.all(color: Theme.of(context).primaryColor.withOpacity(0.4)),
      ),
      child: Wrap(
        spacing: 4,
        runSpacing: 2,
        children: [
          ..._tags.map((tag) => Chip(
                side: BorderSide(
                    color: Theme.of(context).primaryColor.withOpacity(0.4)),
                label: Text(tag),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () => _removeTag(tag),
              )),
          SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: CustomTextFieldWidget(
              hintText: _tags.isEmpty ? "Enter tags" : "",
              prefixIconColor: Theme.of(context).primaryColor,
              isShowBorder: false,
              isRequired: true,
              controller: _controller,
              inputType: TextInputType.text,
              onSubmit: _addTag,
            ),
          ),
        ],
      ),
    );
  }
}
