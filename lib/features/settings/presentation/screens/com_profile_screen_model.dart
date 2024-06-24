import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../constants/consts.dart';
import '../../../auth/presentation/screens/auth_model_screen.dart';
import '../../domain/models/company_profile_page_api_model.dart';
import 'package:html/dom.dart' as dom;

class CamProfilePageModel extends StatelessWidget {
  const CamProfilePageModel({super.key, required this.comProfilePagesModel});

  final CompanyProfilePageApiModel comProfilePagesModel;

  void launchTextUrl(String? textUrl) async {
    var url = Uri.parse(textUrl ?? "");
    var fallbackUrl = Uri.parse(textUrl ?? "");
    try {
      bool launched = await launchUrl(url);
      if (!launched) {
        await launchUrl(fallbackUrl);
      }
    } catch (e) {
      await launchUrl(fallbackUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModelScreen(
        screenTitle: comProfilePagesModel.defaultTitle,
        bodyWidget: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          scrollDirection: Axis.vertical,
          child: Html(
              shrinkWrap: true,
              data: comProfilePagesModel.defaultDescription,
              style: {
                "p": Style(fontFamily: kFontFamilyName),
              },
              onLinkTap: (String? url, Map<String, String> attributes,
                  dom.Element? element) {
                launchTextUrl(url);
              }
              // onLinkTap: (String? url) async {
              //   // if (await canLaunch(url)) {
              //   //   await launch(
              //   //     url,
              //   //   );
              //   // } else {
              //   //   throw 'Could not launch $url';
              //   // }
              // }
              ),
        ));
  }
}
