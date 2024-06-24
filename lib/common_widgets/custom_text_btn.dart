import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import '../constants/consts.dart';

class CustomTextBtn extends StatefulWidget {
  const CustomTextBtn({
    Key? key,
    this.text,
    this.function,
    this.textColor,
    this.btnColor,
    this.isRounded = true,
  }) : super(key: key);
  final String? text;
  final Color? textColor;
  final Color? btnColor;
  final bool isRounded;
  final VoidCallback? function;

  @override
  State<CustomTextBtn> createState() => _CustomTextBtnState();
}

class _CustomTextBtnState extends State<CustomTextBtn> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.function,
      style: TextButton.styleFrom(
          maximumSize: Size(89.w, 24.h),
          minimumSize: Size(89.w, 24.h),
          padding: EdgeInsets.zero,
          shape: widget.isRounded
              ? null
              : const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          backgroundColor: widget.btnColor ?? kLightWhiteColor),
      child: Text(
        widget.text ?? 'افتحلي الكل',
        style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            fontFamily: kFontFamilyName,
            color: widget.textColor ?? kLightBlackColor),
      ),
    );
  }
}
