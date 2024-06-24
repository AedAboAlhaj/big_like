import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/consts.dart';

class CustomFiledElevatedBtn extends StatelessWidget {
  const CustomFiledElevatedBtn(
      {super.key,
      required this.text,
      required this.function,
      this.color,
      this.textColor = kWhiteColor,
      this.height = 66,
      this.isIconVisible = false,
      this.fontSize = 18});
  final String text;
  final VoidCallback? function;
  final Color? color;
  final Color textColor;
  final int fontSize;
  final int height;
  final bool isIconVisible;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: function,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? kDarkCyanColor,
        elevation: 0,
        minimumSize: Size(200.w, height.h),
        disabledBackgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: kBorderRadius5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
              visible: isIconVisible,
              child: Row(
                children: [
                  Icon(
                    Icons.add_circle,
                    color: kWhiteColor,
                    size: 22.w,
                  ),
                  SizedBox(
                    width: 10.w,
                  )
                ],
              )),
          Text(
            text,
            style: TextStyle(
                color: textColor,
                fontFamily: kFontFamilyName,
                fontWeight: FontWeight.bold,
                fontSize: fontSize.sp),
          ),
        ],
      ),
    );
  }
}
