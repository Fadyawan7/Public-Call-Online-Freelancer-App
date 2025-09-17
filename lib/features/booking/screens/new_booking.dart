import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_outlined_button_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_pop_scope_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:flutter_restaurant/features/address/domain/models/address_model.dart';
import 'package:flutter_restaurant/features/address/providers/location_provider.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/booking/domain/models/place_booking_model.dart';
import 'package:flutter_restaurant/features/booking/providers/booking_provider.dart';
import 'package:flutter_restaurant/features/booking/widgets/booking_date_slot_widget.dart';
import 'package:flutter_restaurant/features/booking/widgets/booking_time_slot_widget.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/app_localization.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class BookingDateSlotScreen extends StatefulWidget {
  final String? freelancerId;
  const BookingDateSlotScreen({super.key, this.freelancerId});

  @override
  State<BookingDateSlotScreen> createState() => _BookingDateSlotScreenState();
}

class _BookingDateSlotScreenState extends State<BookingDateSlotScreen>
    with TickerProviderStateMixin {
  int hours = 0;
  final now = DateTime.now();
  FocusNode? _descriptionFocus;
  TextEditingController? _descriptionController;

  final GlobalKey<FormState> placeBookingFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    Provider.of<BookingProvider>(context, listen: false).checkAvailableDates();
    Provider.of<LocationProvider>(context, listen: false).initAddressList();

    Provider.of<BookingProvider>(context, listen: false)
        .checkAvailableTimes(now.toString());
    Provider.of<BookingProvider>(context, listen: false).updateDateSlot(
        0,
        Provider.of<BookingProvider>(context, listen: false)
            .days[0]
            .date
            .toString());
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _descriptionController?.dispose(); // Dispose to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return CustomPopScopeWidget(
      child: Scaffold(
        appBar: CustomAppBarWidget(
          title: getTranslated('booking_detail', context),
          titleColor: Colors.white,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BookingDateSlotWidget(),
                  const BookingTimeSlotWidget(),

                  // GoogleMap Address
                  const SizedBox(height: Dimensions.paddingSizeLarge),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeDefault),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          getTranslated('address', context)!,
                          style: rubikSemiBold.copyWith(
                              color: ColorResources.getGreyBunkerColor(context)),
                          overflow: TextOverflow.ellipsis,
                        ),
                        InkWell(
                          onTap: () => RouterHelper.getAddressRoute(),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Iconsax.add,
                                  size: 18,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  getTranslated('New', context)!,
                                  style: rubikSemiBold.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Consumer<LocationProvider>(
                    builder: (context, locationProvider, child) {
                      return locationProvider.addressList == null
                          ? _AddressShimmerWidget(
                              isEnabled: locationProvider.addressList == null)
                          : locationProvider.addressList!.isNotEmpty
                              ? SizedBox(
                                  height: 120, // Set a fixed height
                                  child: ListView.builder(
                                    padding: const EdgeInsets.all(
                                        Dimensions.paddingSizeDefault),
                                    itemCount:
                                        locationProvider.addressList?.length ??
                                            0,
                                    physics: const BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) => Consumer<BookingProvider>(
                                      builder: (context,bookingProvider,child){
                                        return GestureDetector(
                                          onTap: ()=> bookingProvider.updateSelectedAddress(index,locationProvider
                                              .addressList![
                                          index].id!),
                                          child: SizedBox(
                                            width:
                                            width*2/3, // Set a fixed width for each item
                                            child: Padding(
                                              padding: const EdgeInsets.only(right:  Dimensions.paddingSizeSmall
                                              ),
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(
                                                    vertical:
                                                    Dimensions.paddingSizeDefault,
                                                    horizontal:
                                                    Dimensions.paddingSizeSmall),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context).cardColor,
                                                border: Border.all(
                                                color: bookingProvider.selectAddressIndex == index
                                                ? Theme.of(context).primaryColor // Border color when selected
                                                    : Colors.transparent, // Transparent border when not selected
                                                width: 1, ),
                                                  borderRadius: BorderRadius.circular(
                                                      Dimensions.radiusDefault),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Theme.of(context)
                                                          .shadowColor
                                                          .withOpacity(0.5),
                                                      blurRadius:
                                                      Dimensions.radiusDefault,
                                                      spreadRadius:
                                                      Dimensions.radiusSmall,
                                                    )
                                                  ],
                                                ),
                                                child: Stack(
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      children: [
                                                        Icon(
                                                          locationProvider
                                                              .addressList![
                                                          index]
                                                              .addressType!
                                                              .toLowerCase() ==
                                                              "home"
                                                              ? Icons.home_filled
                                                              : locationProvider
                                                              .addressList![
                                                          index]
                                                              .addressType!
                                                              .toLowerCase() ==
                                                              "workplace"
                                                              ? Icons.work_outline
                                                              : Icons
                                                              .list_alt_outlined,
                                                          color: Theme.of(context)
                                                              .primaryColor
                                                              .withOpacity(0.8),
                                                          size: Dimensions
                                                              .paddingSizeLarge,
                                                        ),
                                                        const SizedBox(
                                                            width: Dimensions
                                                                .paddingSizeDefault),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              Text(
                                                                  locationProvider
                                                                      .addressList![
                                                                  index]
                                                                      .addressType!.toCapitalized(),
                                                                  style:
                                                                  rubikSemiBold),
                                                              const SizedBox(
                                                                  height: Dimensions
                                                                      .paddingSizeDefault),
                                                              Text(
                                                                locationProvider
                                                                    .addressList![
                                                                index]
                                                                    .address!,
                                                                maxLines: 1,
                                                                overflow: TextOverflow
                                                                    .ellipsis,
                                                                style: rubikRegular.copyWith(
                                                                    color: Theme.of(
                                                                        context)
                                                                        .hintColor,
                                                                    fontSize: Dimensions
                                                                        .fontSizeSmall),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                )
                              : Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                                    Text(
                                      getTranslated( 'no_saved_address_found',  context,
                                      )!,
                                      style: rubikSemiBold.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeDefault,fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: Dimensions.paddingSizeSmall),
                                    CustomOutlinedButton(
                                      label: "Add New",
                                      icon:Iconsax.add ,
                                      onPressed:()=>{
                                        RouterHelper.getAddAddressRoute(
                                            'address', 'add', AddressModel()),
                                      } ,

                                    ),


                                  ]),
                                ),
                              );
                    },
                  ),

                  //Describe Issue
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeDefault),
                    child: Text(
                      getTranslated('describe_the_issue', context)!,
                      style: rubikSemiBold.copyWith(
                          color: ColorResources.getGreyBunkerColor(context)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeDefault),
                    child: Form(
                      key: placeBookingFormKey,
                      child: CustomTextFieldWidget(
                        controller: _descriptionController,
                        maxLines: 5,
                        focusNode: _descriptionFocus,
                        capitalization: TextCapitalization.sentences,
                        hintText: getTranslated('explain_the_issue', context),
                        fillColor: Theme.of(context).cardColor,
                        isShowBorder: true,
                        borderColor:
                            Theme.of(context).hintColor.withOpacity(0.5),
                      ),
                    ),
                  ),

                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Consumer<BookingProvider>(
                    builder: (context, bookingProvider, child) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeDefault),
                        child: Form(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                getTranslated('provide_image', context)!,
                                style: rubikSemiBold.copyWith(
                                    color: ColorResources.getGreyBunkerColor(
                                        context)),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeSmall),
                              GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 1,
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                  ),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:bookingProvider.listImagePath!.length+1 ,
                                  itemBuilder: (BuildContext context, index) {
                                    return index ==
                                            bookingProvider
                                                .listImagePath!.length
                                        ? GestureDetector(
                                            onTap: () =>
                                                bookingProvider.pickImage(),
                                            child: Stack(
                                              children: [
                                                DottedBorder(
                                                  dashPattern: const [4, 5],
                                                  borderType: BorderType.RRect,
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                  radius:
                                                      const Radius.circular(15),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius
                                                        .circular(Dimensions
                                                            .paddingSizeSmall),
                                                    child: Image.asset(
                                                        Images.placeholderImage,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2.3,
                                                        width: MediaQuery.of(
                                                                    context)
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
                                          )
                                        : Stack(
                                            children: [
                                              DottedBorder(
                                                dashPattern: const [4, 5],
                                                borderType: BorderType.RRect,
                                                color:
                                                    Theme.of(context).hintColor,
                                                radius:
                                                    const Radius.circular(15),
                                                child: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20)),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius: const BorderRadius
                                                        .all(
                                                        Radius.circular(Dimensions
                                                            .paddingSizeSmall)),
                                                    child: Image.file(
                                                      File(bookingProvider
                                                          .images![index].path),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2.3,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2.3,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 5,
                                                right: 5,
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  onTap: () => bookingProvider
                                                      .removeImage(
                                                          index, false),
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Theme.of(
                                                                        context)
                                                                    .hintColor,
                                                                blurRadius: 1,
                                                                spreadRadius: 1,
                                                                offset:
                                                                    const Offset(
                                                                        0, 0))
                                                          ],
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                                  Radius.circular(
                                                                      Dimensions
                                                                          .paddingSizeDefault))),
                                                      child: const Padding(
                                                        padding:
                                                            EdgeInsets.all(4.0),
                                                        child: Icon(
                                                          Icons
                                                              .delete_forever_rounded,
                                                          color: Colors.red,
                                                          size: 25,
                                                        ),
                                                      )),
                                                ),
                                              ),
                                            ],
                                          );
                                  }),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  Container(
                    width: width,
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    margin: EdgeInsets.zero,
                    child: Consumer<BookingProvider>(
                      builder: (context, bookingProvider, child) {
                        return CustomButtonWidget(
                            isLoading: bookingProvider.isLoading,
                            btnTxt: getTranslated('apply', context),
                            onTap: () async {
                              String? description =
                                  _descriptionController!.text.trim();
                              if (placeBookingFormKey.currentState != null &&
                                  placeBookingFormKey.currentState!
                                      .validate()) {
                                if (bookingProvider.date!.isEmpty) {
                                  showCustomSnackBarHelper(getTranslated(
                                      'choose_your_date', context));
                                } else if (bookingProvider.timeSlot!.isEmpty) {
                                  showCustomSnackBarHelper(getTranslated(
                                      'choose_your_time', context));
                                } else if (bookingProvider.selectAddressIndex == -1) {
                                  showCustomSnackBarHelper(getTranslated(
                                      'select_address_list', context));
                                } else if (description.isEmpty) {
                                  showCustomSnackBarHelper(
                                      getTranslated('explain_issue', context));
                                } else {
                                  String? date = bookingProvider.date!;
                                  String? time = bookingProvider.timeSlot!;

                                  PlaceBookingBody placeBookingBody =
                                      PlaceBookingBody(
                                    freelancerId:
                                        int.parse(widget.freelancerId!),
                                    date: date,
                                    time: time,
                                    description: description,
                                        addressId: bookingProvider.selectAddressId
                                  );
                                  print("======BOOKINGDATA====${placeBookingBody.toJson()}");

                                  bookingProvider.placeBooking(
                                      placeBookingBody,
                                      bookingProvider.listImagePath!,
                                      _callback,
                                      Provider.of<AuthProvider>(context,
                                              listen: false)
                                          .getUserToken());
                                }
                              }
                            });
                      },
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

  void _callback(bool isSuccess, String message) async {
    if (isSuccess) {
      print('=====BOOKING===${isSuccess}');

      Provider.of<BookingProvider>(context, listen: false).resetSlots();
      RouterHelper.getOrderSuccessScreen('success', message);
    } else {
      print('=====BOOKING===${message}');
      showCustomSnackBarHelper(message);
    }
  }
}

class _AddressShimmerWidget extends StatelessWidget {
  const _AddressShimmerWidget({required this.isEnabled});
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
      itemCount: 1,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          color: Theme.of(context).hintColor.withOpacity(0.1),
        ),
        margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
        clipBehavior: Clip.hardEdge,
        child: Shimmer(
            enabled: isEnabled,
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Row(children: [
                Container(
                    width: 20,
                    height: 20,
                    color: Theme.of(context).hintColor.withOpacity(0.2)),
                const SizedBox(width: Dimensions.paddingSizeDefault),
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(
                          Dimensions.paddingSizeExtraSmall),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                              width: 150,
                              height: 20,
                              color:
                                  Theme.of(context).hintColor.withOpacity(0.2)),
                          const SizedBox(height: Dimensions.paddingSizeDefault),
                          Container(
                              width: 200,
                              height: 20,
                              color:
                                  Theme.of(context).hintColor.withOpacity(0.2)),
                        ],
                      )),
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),
                Container(
                    width: 20,
                    height: 20,
                    color: Theme.of(context).hintColor.withOpacity(0.2)),
              ]),
            )),
      ),
    );
  }
}
