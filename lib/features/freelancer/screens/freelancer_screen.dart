import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_dialog_widget.dart';
import 'package:flutter_restaurant/common/widgets/filter_button_widget.dart';
import 'package:flutter_restaurant/features/address/widgets/freelancer_search_dialog_widget.dart';
import 'package:flutter_restaurant/features/freelancer/providers/freelancer_provider.dart';
import 'package:flutter_restaurant/features/freelancer/widgets/category_filter.dart';
import 'package:flutter_restaurant/features/freelancer/widgets/freelancer_detail_dialog_widget.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class FreelancerScreen extends StatefulWidget {
  const FreelancerScreen({super.key});

  @override
  State<FreelancerScreen> createState() => _FreelancerScreenState();
  static Future<void> loadData(bool reload, {bool isFcmUpdate = false}) async {}
}

class _FreelancerScreenState extends State<FreelancerScreen>
    with TickerProviderStateMixin {
  LatLng bahrainCountryLatLong = const LatLng(26.201000, 50.606998);
  final FreelancerProvider freelancerProvider =
      Provider.of<FreelancerProvider>(Get.context!, listen: false);

  final ProfileProvider profileProvider =
  Provider.of<ProfileProvider>(Get.context!, listen: false);
  final List<String> categories = [
    'Technology',
    'Design',
    'Marketing',
    'Finance',
    'Health'
  ];
  List<Marker> freelancerMarker = [];
  GoogleMapController? googleMapController;
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  BitmapDescriptor availableIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor busyIcon = BitmapDescriptor.defaultMarker;

  BitmapDescriptor selectedIcon = BitmapDescriptor.defaultMarker;

  void freelancerAvailableMarker() {
    BitmapDescriptor.asset(ImageConfiguration(), "assets/icon/darkgreen.png")
        .then((icon) {
      setState(() {
        availableIcon = icon;
      });
    });
  }

  void freelancerBusyMarker() {
    BitmapDescriptor.asset(ImageConfiguration(), "assets/icon/reddot.png")
        .then((icon) {
      setState(() {
        busyIcon = icon;
      });
    });
  }

  void selectedMarker() {
    BitmapDescriptor.asset(
            ImageConfiguration(
              size: const Size(20, 30),
            ),
            "assets/icon/marker.png")
        .then((icon) {
      setState(() {
        selectedIcon = icon;
      });
    });
  }

  @override
  void initState() {

    freelancerProvider.getFreelancerList();
    profileProvider.getUserInfo(true);

    freelancerAvailableMarker();
    freelancerBusyMarker();

    selectedMarker();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    googleMapController!.dispose();

  }
  void _openSearchDialog(BuildContext context, GoogleMapController? mapController) async {
    showDialog(context: context, builder: (context) => FreelancerSearchDialogWidget(mapController: mapController));
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:  CustomAppBarWidget(
        isBackButtonExist: false,
        titleColor: Colors.white,
        context: context,
        title: getTranslated('Worker', context),
        actionView: IconButton(
          icon: const Icon(Iconsax.add_circle, color: Colors.white,size: Dimensions.fontSizeDefault * 2,),
          onPressed: () => {
            profileProvider.isFreelancer! ?   RouterHelper.getFreelancerPortfolioListRoute(): RouterHelper.getApplyFreelancerRoute()
          },
        ),
      ),
      body: Stack(
        children: [
          Consumer<FreelancerProvider>(
            builder: (context, freelancerProvider, child) {
              final freelancerMarker =
                  freelancerProvider.freelancerList?.map((freelancer) {
                        final markerIcon = freelancer.status == 'available'
                                    ? availableIcon
                                : busyIcon;

                        return Marker(
                          icon: markerIcon,
                          markerId: MarkerId(freelancer.id.toString()),
                          position: LatLng(
                            double.parse(freelancer.latitude.toString()),
                            double.parse(freelancer.longitude.toString()),
                          ),
                          onTap: () async {
                            freelancerProvider.setSelectedFreelancer(
                                freelancer: freelancer);
                            await showModalBottomSheet(
                              backgroundColor: Theme.of(context).canvasColor,
                              context: context,
                              isScrollControlled: true,
                              isDismissible: true,
                              showDragHandle: true,
                              useSafeArea: true,
                              builder: (BuildContext context) {
                                return FreelancerDetailsBottomSheet(
                                  freelancer: freelancer,
                                );
                              },
                            );
                          },
                        );
                      }).toList() ??
                      <Marker>[];
              return GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: bahrainCountryLatLong,
                  zoom: 11,
                ),
                markers: freelancerMarker.toSet(),
                onMapCreated: (GoogleMapController c) {
                  googleMapController = c;
                  _customInfoWindowController.googleMapController = c;
                },
                myLocationEnabled: false,
                zoomControlsEnabled: false,
                compassEnabled: false,
                myLocationButtonEnabled: false,
                onTap: (v) {
                  _customInfoWindowController.hideInfoWindow?.call();
                },
                onCameraMove: (v) {
                  _customInfoWindowController.onCameraMove?.call();
                },
              );
            },
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 100,
            width: 250,
            offset: 16,
          ),
          InkWell(
            onTap: () => _openSearchDialog(context, googleMapController),
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: 18.0),
              margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: 23.0),
              decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
              child: Builder(
                  builder: (context) {

                    return  Row(children: [
                      Expanded(child: Text(
                           'search worker...'
                          , maxLines: 1, overflow: TextOverflow.ellipsis,style: rubikRegular.copyWith(
                        fontSize:
                        Dimensions.paddingSizeDefault,
                      ),)),
                       const Icon(Icons.search, size: 25),
                       const SizedBox(width: Dimensions.paddingSizeSmall,),
                      FilterButton(
                        categories: categories,
                        initiallySelected: ['Tech', 'Design'],
                        onFilterApplied: (selected) {
                          // Handle selected categories
                        },
                      )
                       // GestureDetector(
                       //   onTap: () async {
                       //
                       //   },
                       //     child: const Icon(Icons.filter_alt_outlined, size: 25)),
                    ]);
                  }
              ),
            ),
          )
        ],
      ),
    );
  }
}
