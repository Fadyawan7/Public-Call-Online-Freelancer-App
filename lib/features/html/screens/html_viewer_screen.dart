import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/enums/html_type_enum.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/common/widgets/custom_app_bar_widget.dart';

import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_selectable_text/fwfh_selectable_text.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';


class HtmlViewerScreen extends StatelessWidget {
  final HtmlType htmlType;
  const HtmlViewerScreen({super.key, required this.htmlType});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final policyModel = Provider.of<SplashProvider>(context, listen: false).policyModel;

    String data = 'no_data_found';
    String appBarText = '';

    switch (htmlType) {
      case HtmlType.termsAndCondition :
        data = policyModel?.termsAndCondition ?? '';
        appBarText = 'terms_and_condition';
        break;
      case HtmlType.aboutUs :
        data = policyModel?.aboutUs ?? '';
        appBarText = 'about_us';
        break;
      case HtmlType.privacyPolicy :
        data = policyModel?.privacyPolicy ?? '';
        appBarText = 'privacy_policy';
        break;
    }

    if(data.isNotEmpty) {
      data = data.replaceAll('href=', 'target="_blank" href=');
    }

    return Scaffold(
      appBar: ( CustomAppBarWidget(
        titleColor: Colors.white,
        title: getTranslated(appBarText, context),
        context: context,
      )) as PreferredSizeWidget?,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: SizedBox(
                width: 1170,
                child:  ResponsiveHelper.isDesktop(context) ? Column(
                  children: [
                    Container(
                      height: 100, alignment: Alignment.center,
                      child: SelectableText(getTranslated(appBarText, context)!,
                        style: rubikBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).textTheme.bodyLarge?.color),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ConstrainedBox(
                      constraints: BoxConstraints(minHeight:  height < 600 ? height : height - 400),
                      child: HtmlWidget(data,
                        factoryBuilder: () => MyWidgetFactory(),
                        key: Key(htmlType.toString()),
                        onTapUrl: (String url) {
                          return launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                        },),
                    ),
                    const SizedBox(height: 30),
                  ],
                ) : SingleChildScrollView(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  physics: const BouncingScrollPhysics(),
                  child: HtmlWidget(
                    data,
                    key: Key(htmlType.toString()),
                    onTapUrl: (String url) {
                      return launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                    },
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );


  }
}

class MyWidgetFactory extends WidgetFactory with SelectableTextFactory {

  @override
  SelectionChangedCallback  get selectableTextOnChanged => (selection, cause) {};


}