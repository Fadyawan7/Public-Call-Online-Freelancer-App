// city_dropdown_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/city_model.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:provider/provider.dart';

class CityDropdownWidget extends StatelessWidget {
  final TextEditingController searchController;

  const CityDropdownWidget({
    super.key,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);

    String? selectedCityId;
      if(profileProvider.selectedCityID != -1){
        selectedCityId = profileProvider.cityList
            ?.firstWhere((city) => city.id == profileProvider.selectedCityID)
            .id
            .toString();
      }


    return  DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        iconStyleData: IconStyleData(
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Theme.of(context).hintColor,
          ),
        ),
        isExpanded: true,
        hint: Text(
          getTranslated('select_city', context)!,
          style: rubikRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault,
            color: Theme.of(context).hintColor,
          ),
        ),
        selectedItemBuilder: (BuildContext context) {
          return profileProvider.cityList?.map((CityModel city) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  city.cityName ?? "",
                  style: rubikRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color:Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            );
          }).toList() ?? [];
        },
        items: profileProvider.cityList?.map((CityModel city) {
          return DropdownMenuItem<String>(
            value: city.id.toString(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  city.cityName ?? "",
                  style: rubikRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: Theme.of(context).textTheme.bodyMedium?.color
                        ,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        value: selectedCityId,
        onChanged:(String? value) {
          if (value != null) {
            profileProvider.setCityID(cityID: int.parse(value));
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
                hintText: getTranslated('select_city', context)!,
                hintStyle: const TextStyle(fontSize: Dimensions.fontSizeSmall),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
              ),
            ),
          ),
          searchMatchFn: (item, searchValue) {
            final city = profileProvider.cityList
                ?.firstWhere((element) => element.id.toString() == item.value);
            return city?.cityName?.toLowerCase().contains(searchValue.toLowerCase()) ?? false;
          },
        ),
        buttonStyleData: ButtonStyleData(
          decoration: BoxDecoration(
            border: Border.all(
              color:  Theme.of(context).hintColor ,
            ),
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          ),
          padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
        ),
      ),
    );
  }
}