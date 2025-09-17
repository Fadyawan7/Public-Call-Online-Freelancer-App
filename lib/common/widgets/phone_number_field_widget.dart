import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/code_picker_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';

class PhoneNumberFieldView extends StatelessWidget {
  const PhoneNumberFieldView({
    super.key,
    required this.onValueChange,
    required this.countryCode,
    required this.phoneNumberTextController,
    required this.phoneFocusNode,
  });

  final Function(String value) onValueChange;
  final String? countryCode;
  final TextEditingController phoneNumberTextController;
  final FocusNode phoneFocusNode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(

          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.2))
      ),
      child: Row(children: [
        CodePickerWidget(
          onChanged: ( value)=> onValueChange(value.code!),
          initialSelection: countryCode,
          favorite: [countryCode ?? ''],
          showDropDownButton: true,
          padding: EdgeInsets.zero,
          showFlagMain: true,
          textStyle: TextStyle(color: Theme.of(context).textTheme.displayLarge!.color),

        ),
        Expanded(child: CustomTextFieldWidget(
          controller: phoneNumberTextController,
          focusNode: phoneFocusNode,
          inputType: TextInputType.phone,
          hintText: getTranslated('number_hint', context),

        )),
      ]),
    );
  }
}