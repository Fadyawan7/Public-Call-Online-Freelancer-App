// country_dropdown_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/country_model.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:provider/provider.dart';

class CountryDropdownWidget extends StatelessWidget {
  final TextEditingController searchController;

  const CountryDropdownWidget({
    super.key,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);

    String? selectedCountryId;
    if (profileProvider.userInfoModel!.countryId == -1) {
      // Find selected country if available
      try {
        selectedCountryId = profileProvider.countryList
            ?.firstWhere((country) => country.id == profileProvider.selectedCountryID)
            .id
            .toString();
      } catch (e) {
        selectedCountryId = null; // No matching country found
      }
    } else if (profileProvider.userInfoModel?.countryId != -1) {
      // Use the user's countryId if set
      selectedCountryId = profileProvider.userInfoModel?.countryId.toString();
    }


    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        autofocus: true,
        iconStyleData: IconStyleData(
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color:Theme.of(context).hintColor,
          ),
        ),
        isExpanded: true,
        hint: Text(
          getTranslated('select_country', context)!,
          style: rubikRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault,
            color: Theme.of(context).hintColor,
          ),
        ),
        selectedItemBuilder: (BuildContext context) {
          return profileProvider.countryList?.map((CountryModel country) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  country.countryName ?? "",
                  style: rubikRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color:  Theme.of(context).textTheme.bodyMedium?.color
                  ),
                ),
                Text(
                  country.countryFlag ?? "",
                  style: rubikRegular.copyWith(
                    fontSize: Dimensions.fontSizeOverLarge,
                    color:Theme.of(context).textTheme.bodyMedium?.color
                  ),
                ),
              ],
            );
          }).toList() ?? [];
        },
        items: profileProvider.countryList?.map((CountryModel country) {
          return DropdownMenuItem<String>(
            value: country.id.toString(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  country.countryFlag ?? "",
                  style: rubikRegular.copyWith(
                    fontSize: Dimensions.fontSizeExtraLarge,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                Text(
                  country.countryName ?? "",
                  style: rubikRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        value: selectedCountryId,
        onChanged: (String? value) async {
          if (value != null) {
            final selectedCountry = profileProvider.countryList!
                .firstWhere((country) => country.id == int.parse(value));
            final parsedNumber = selectedCountry.countryCode!.startsWith('+')
                ? selectedCountry.countryCode
                : '+${selectedCountry.countryCode!}';
            profileProvider.setCountryID(
              countryID: int.parse(value),
              selectedCountryCode: parsedNumber,
            );
            profileProvider.getCityList(int.parse(value));
          }
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
                hintText: getTranslated('select_country', context)!,
                hintStyle: const TextStyle(fontSize: Dimensions.fontSizeSmall),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
              ),
            ),
          ),
          searchMatchFn: (item, searchValue) {
            final country = profileProvider.countryList
                ?.firstWhere((element) => element.id.toString() == item.value);
            return country?.countryName?.toLowerCase().contains(searchValue.toLowerCase()) ?? false;
          },
        ),
        buttonStyleData: ButtonStyleData(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).hintColor,
            ),
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          ),
          padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
        ),
      ),
    );
  }
}