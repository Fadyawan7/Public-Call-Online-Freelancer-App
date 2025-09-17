import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/features/address/providers/location_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/features/address/widgets/freelancer_search_dialog_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../widgets/permission_dialog_widget.dart';

class SelectLocationScreen extends StatefulWidget {
  final GoogleMapController? googleMapController;
  const SelectLocationScreen({super.key, this.googleMapController});

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  GoogleMapController? _controller;
  final TextEditingController _locationController = TextEditingController();
  CameraPosition? _cameraPosition;
  late LatLng _initialPosition;
  LatLng? _markerPosition;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();

    final LocationProvider locationProvider = Provider.of<LocationProvider>(context, listen: false);
    _initialPosition = (locationProvider.pickedAddressLatitude != null && locationProvider.pickedAddressLongitude != null)
        ? LatLng(double.parse(locationProvider.pickedAddressLatitude!), double.parse(locationProvider.pickedAddressLongitude!))
        : LatLng(locationProvider.position.latitude, locationProvider.position.longitude);

    _markerPosition = _initialPosition;
    _addMarker(_markerPosition!);
  }

  void _addMarker(LatLng position) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId('draggableMarker'),
          position: position,
          draggable: true,
          onDragEnd: (newPosition) {
            setState(() {
              _markerPosition = newPosition;
            });
            // Update the location provider with the new marker position
            Provider.of<LocationProvider>(context, listen: false).updatePosition(
              CameraPosition(target: newPosition, zoom: 16),
              false,
              null,
              context,
              false,
            );
          },
          icon: BitmapDescriptor.defaultMarker, // Use your custom marker image here
        ),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (Provider.of<LocationProvider>(context).address != null) {
      _locationController.text = Provider.of<LocationProvider>(context).address ?? '';
    }

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        centerTitle: true,
        title: Text(getTranslated('select_delivery_address', context)!),
      ),
      body: SingleChildScrollView(
        physics: ResponsiveHelper.isDesktop(context) ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeSmall : 0),
              child: Center(
                child: SizedBox(
                  width: Dimensions.webScreenWidth,
                  height: height * 0.9,
                  child: Consumer<LocationProvider>(
                    builder: (context, locationProvider, child) => Stack(
                      clipBehavior: Clip.none,
                      children: [
                        GoogleMap(
                          mapType: MapType.normal,
                          initialCameraPosition: CameraPosition(
                            target: _initialPosition,
                            zoom: 16,
                          ),
                          zoomControlsEnabled: false,
                          myLocationButtonEnabled: false,
                          minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                          compassEnabled: false,
                          indoorViewEnabled: true,
                          mapToolbarEnabled: true,
                          onCameraIdle: () {
                            locationProvider.updatePosition(_cameraPosition, false, null, context, false);
                          },
                          onCameraMove: (position) {
                            setState(() {
                              _markerPosition = position.target; // Update marker position based on camera movement
                              _cameraPosition = position;
                              _addMarker(_markerPosition!); // Update the marker's position
                            });
                          },
                          onMapCreated: (GoogleMapController controller) {
                            _controller = controller;
                            Future.delayed(const Duration(milliseconds: 500)).then((value) {
                              _controller!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                                target: _markerPosition ?? _initialPosition,
                                zoom: 15,
                              )));
                            });
                          },
                          markers: _markers,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          left: 0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () => _checkPermission(() {
                                  locationProvider.getCurrentLocation(context, true, mapController: _controller);
                                }, context),
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  margin: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                                    color: Colors.white,
                                  ),
                                  child: Icon(
                                    Icons.my_location,
                                    color: Theme.of(context).primaryColor,
                                    size: 35,
                                  ),
                                ),
                              ),
                              SafeArea(
                                child: Center(
                                  child: SizedBox(
                                    width: ResponsiveHelper.isDesktop(context) ? 450 : 1170,
                                    child: Padding(
                                      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                                      child: CustomButtonWidget(
                                        btnTxt: getTranslated('select_location', context),
                                        onTap: locationProvider.loading ? null : () {
                                          if (locationProvider.pickAddress != null) {
                                            locationProvider.setAddress = locationProvider.pickAddress ?? '';
                                          }
                                          locationProvider.setPickedAddressLatLon(
                                            locationProvider.pickPosition.latitude.toString(),
                                            locationProvider.pickPosition.longitude.toString(),
                                          );
                                          if (widget.googleMapController != null) {
                                            widget.googleMapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                                              target: LatLng(
                                                locationProvider.pickPosition.latitude,
                                                locationProvider.pickPosition.longitude,
                                              ),
                                              zoom: 16,
                                            )));
                                          }
                                          context.pop();
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        locationProvider.loading
                            ? Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                          ),
                        )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _checkPermission(Function callback, BuildContext context) async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    } else if (permission == LocationPermission.deniedForever) {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (context) => const PermissionDialogWidget(),
      );
    } else {
      callback();
    }
  }
}