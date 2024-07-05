import 'package:big_like/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../constants/consts.dart';

class OrderIconButton extends StatelessWidget {
  final VoidCallback? function;
  final String imgUrl;
  final Color buttonColor;
  final Color iconColor;

  const OrderIconButton(
      {super.key,
      required this.function,
      this.buttonColor = kBlackColor,
      required this.imgUrl,
      required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: function,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 2),
          fixedSize: Size(double.infinity, 66.h),
          minimumSize: Size(double.infinity, 66.h),
          maximumSize: Size(double.infinity, 66.h),
          backgroundColor: buttonColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: kBorderRadius3,
          ),
        ),
        child: SvgPicture.asset(
          imgUrl,
          colorFilter: Utils.svgColor(iconColor),
        ),
      ),
    );
  }
}
