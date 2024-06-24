import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/consts.dart';
import '../utils/utils.dart';
import 'custom_back_btn.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {super.key,
      required this.title,
      this.showBackBtn = true,
      this.backFunction});

  final String title;
  final bool showBackBtn;
  final VoidCallback? backFunction;

  @override
  Size get preferredSize => Size(0, 75.h);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 10.h),
        child: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          iconTheme: IconThemeData(color: kPrimaryColor, size: 35.h),
          leadingWidth: 39,
          titleSpacing: 0,
          leading: Visibility(
              visible: showBackBtn,
              child: CustomBackBtn(
                backFunction: backFunction,
              )),
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: InkWell(
            onTap: () {},
            child: SizedBox(
              width: 80,
              child: SvgPicture.network(
                appLogoUrl,
                fit: BoxFit.contain,
                /* colorFilter: Utils.svgColor(Theme.of(context)
                          .primaryColor)*/
              ), /*Image.network(
                    appLogoUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return Text(
                        appName,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontFamily: kFontFamilyName,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp),
                      );
                    },
                  )*/
            ),
          ) /*Row(
            children: [
              const Spacer(
                flex: 1,
              ),
              Text(
                // title,
                '',
                style: TextStyle(
                    color: kPrimaryColor,
                    fontFamily: kFontFamilyName,
                    fontWeight: FontWeight.bold,
                    fontSize: 17.sp),
              ),
              const Spacer(),
              InkWell(
                onTap: () {},
                child: SizedBox(
                  width: 50,
                  child: SvgPicture.network(appLogoUrl,
                      fit: BoxFit.contain,
                     */ /* colorFilter: Utils.svgColor(Theme.of(context)
                          .primaryColor)*/ /*), */ /*Image.network(
                    appLogoUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return Text(
                        appName,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontFamily: kFontFamilyName,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp),
                      );
                    },
                  )*/ /*
                ),
              ),
            ],
          )*/
          ,
        ));
  }
}
