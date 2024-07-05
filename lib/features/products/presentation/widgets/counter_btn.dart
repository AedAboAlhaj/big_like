import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../constants/consts.dart';

class CounterBtn extends StatelessWidget {
  final VoidCallback function;
  final IconData iconData;
  final double iconSize;
  final Color iconColor;
  final Color? btnColor;

  const CounterBtn({
    super.key,
    required this.function,
    required this.iconData,
    required this.iconSize,
    this.iconColor = kWhiteColor,
    this.btnColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 8.5.w, vertical: 4.h),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.0.w, vertical: 4.h),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
            decoration: BoxDecoration(
                color: btnColor ?? kPrimaryColor,
                borderRadius: BorderRadius.circular(1000)),
            child: Icon(
              iconData,
              size: iconSize,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}
