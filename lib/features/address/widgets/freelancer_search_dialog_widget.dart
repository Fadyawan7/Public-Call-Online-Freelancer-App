import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_loader_widget.dart';
import 'package:flutter_restaurant/features/address/domain/models/prediction_model.dart';
import 'package:flutter_restaurant/features/address/providers/location_provider.dart';
import 'package:flutter_restaurant/features/address/widgets/search_item_widget.dart';
import 'package:flutter_restaurant/features/freelancer/domain/models/freelancer_model.dart';
import 'package:flutter_restaurant/features/freelancer/providers/freelancer_provider.dart';
import 'package:flutter_restaurant/features/freelancer/widgets/freelancer_detail_dialog_widget.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class FreelancerSearchDialogWidget extends StatefulWidget {
  final GoogleMapController? mapController;
  final EdgeInsets? margin;
  const FreelancerSearchDialogWidget({super.key, required this.mapController, this.margin});


  @override
  State<FreelancerSearchDialogWidget> createState() => _FreelancerSearchDialogWidgetState();
}

class _FreelancerSearchDialogWidgetState extends State<FreelancerSearchDialogWidget> {
  @override
  Widget build(BuildContext context) {
    final FreelancerProvider freelancerProvider = Provider.of<FreelancerProvider>(context, listen: false);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      ),
      margin: widget.margin ?? const EdgeInsets.only(
        top: 75,
        right: Dimensions.paddingSizeSmall,
        left: Dimensions.paddingSizeSmall,
      ),
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: 650,
        child: GestureDetector(
          // Close the dialog when tapping outside
          onTap: () {
            FocusScope.of(context).unfocus(); // Close the keyboard
            Navigator.pop(context); // Close the dialog
          },
          behavior: HitTestBehavior.opaque, // Ensure the GestureDetector captures taps
          child: TypeAheadField<FreelancerModel>(
            suggestionsCallback: (pattern) async => await freelancerProvider.searchFreelancer(context, pattern),
            builder: (context, controller, focusNode) => TextField(
              controller: controller,
              focusNode: focusNode,
              textInputAction: TextInputAction.search,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                hintText: getTranslated('search_freelancer', context),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(style: BorderStyle.none, width: 0),
                ),
                hintStyle: Theme.of(context).textTheme.displayMedium!.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: Theme.of(context).disabledColor,
                ),
                filled: true,
                fillColor: Theme.of(context).cardColor,
              ),
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: Theme.of(context).textTheme.bodyLarge!.color,
                fontSize: Dimensions.fontSizeLarge,
              ),
            ),
            itemBuilder: (context, suggestion) => SearchItemWidget(suggestion: suggestion),
            onSelected: (FreelancerModel suggestion) async {
              freelancerProvider.setSelectedFreelancer(freelancer: suggestion);
              await showModalBottomSheet(
                backgroundColor: Theme.of(context).canvasColor,
                context: context,
                isScrollControlled: true,
                isDismissible: true, // Allow dismissing the bottom sheet by tapping outside
                showDragHandle: true,
                useSafeArea: true,
                builder: (BuildContext context) {
                  return FreelancerDetailsBottomSheet(freelancer: suggestion);
                },
              );
              Navigator.pop(context); // Close the search dialog after selecting a freelancer
            },
            loadingBuilder: (context) => CustomLoaderWidget(color: Theme.of(context).primaryColor),
            errorBuilder: (context, error) => const SearchItemWidget(),
            emptyBuilder: (context) => const SearchItemWidget(),
          ),
        ),
      ),
    );
  }
}
