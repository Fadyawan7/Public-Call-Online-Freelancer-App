import 'package:flutter/material.dart';
import 'package:flutter_restaurant/features/freelancer/providers/freelancer_provider.dart';
import 'package:flutter_restaurant/features/freelancer/screens/freelancer_screen.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';

import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';

import 'package:provider/provider.dart';

class RequestSubmitedScreen extends StatefulWidget {
  final int status;
  final String? message;

  const RequestSubmitedScreen({super.key,required this.status, this.message});

  @override
  State<RequestSubmitedScreen> createState() => _RequestSubmitedScreenState();
}

class _RequestSubmitedScreenState extends State<RequestSubmitedScreen> {

  @override
  void initState() {
    ///delay for widget tree load and fix issue for notify controller
    Future.delayed(const Duration(milliseconds: 300)).then((_){
      FreelancerScreen.loadData(true);
    });    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: null,
      body: SafeArea(
        child: OrderSuccessfulWidget(widget: widget, success: true,message: widget.message!,)
      ),
    );
  }
}

class OrderSuccessfulWidget extends StatelessWidget {
  const OrderSuccessfulWidget({
    super.key,
    required this.widget,
    required this.success,
    required this.message,

  });

  final RequestSubmitedScreen widget;
  final bool success;
  final String message;


  @override
  Widget build(BuildContext context) {
    final FreelancerProvider freelancerProvider = Provider.of<FreelancerProvider>(context, listen:false);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Center(child: SizedBox(
          width: Dimensions.webScreenWidth,
          child: freelancerProvider.isLoading ? const CircularProgressIndicator() :  Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Container(
                height: 100, width: 100,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.status == 0 ? Icons.check_circle : widget.status == 1 ? Icons.sms_failed : widget.status == 2 ? Icons.question_mark : Icons.cancel,
                  color: Theme.of(context).primaryColor, size: 80,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),


              Text(widget.message!,
                style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),


              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                  child: CustomButtonWidget(
                    btnTxt: getTranslated('back_home', context),
                    onTap: ()=> RouterHelper.getDashboardRoute('home', action: RouteAction.pushNamedAndRemoveUntil),
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
