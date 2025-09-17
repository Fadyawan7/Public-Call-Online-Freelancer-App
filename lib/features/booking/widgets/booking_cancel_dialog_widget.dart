import 'package:flutter/material.dart';
import 'package:flutter_restaurant/features/booking/providers/booking_provider.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class BookingCancelDialogWidget extends StatelessWidget {
  final String bookingID;
  final Function callback;
  final String? popUpTxt;
  final String? status;

  const BookingCancelDialogWidget({super.key, required this.bookingID, required this.callback, this.popUpTxt, this.status});

  @override
  Widget build(BuildContext context) {
    return Dialog(

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        width: 300,
        child: Consumer<BookingProvider>(builder: (context, booking, child) {
          return Column(mainAxisSize: MainAxisSize.min, children: [

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: 50),
              child: Text(getTranslated('$popUpTxt', context)!, style: rubikBold, textAlign: TextAlign.center),
            ),

            Divider(
              indent: Dimensions.paddingSizeDefault,
              color: Theme.of(context).hintColor.withOpacity(0.1),
            ),
            !booking.isLoading ? Row(children: [

              Expanded(child: InkWell(
                onTap: () {
                  Provider.of<BookingProvider>(context, listen: false).updateBookingStatus( bookingID, status, (String message, bool isSuccess, String bookingID) {
                    context.pop();
                    callback(message, isSuccess, bookingID);
                  });

                },
                child: Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10))),
                  child: Text(getTranslated('yes', context)!, style: rubikBold.copyWith(color: Theme.of(context).primaryColor)),
                ),
              )),

              Expanded(child: InkWell(
                onTap: () => context.pop(),
                child: Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: const BorderRadius.only(bottomRight: Radius.circular(10))),
                  child: Text(getTranslated('no', context)!, style: rubikBold.copyWith(color: Colors.white)),
                ),
              )),

            ]) : Center(child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
            )),
          ]);
        },
        ),
      ),
    );
  }
}
