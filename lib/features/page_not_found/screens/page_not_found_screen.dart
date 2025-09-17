import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';


class PageNotFoundScreen extends StatelessWidget {
  const PageNotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar:  null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(minHeight: !ResponsiveHelper.isDesktop(context) && height < 600 ? height : height - 400),
              child: Center(
                child: TweenAnimationBuilder(
                  curve: Curves.bounceOut,
                  duration: const Duration(seconds: 2),
                  tween: Tween<double>(begin: 12.0,end: 30.0),
                  builder: (BuildContext context, dynamic value, Widget? child){
                    return Text(getTranslated('page_not_found', context)!,style: TextStyle(fontWeight: FontWeight.bold,fontSize: value));
                  },

                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
