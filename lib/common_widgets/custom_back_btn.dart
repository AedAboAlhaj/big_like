import 'package:big_like/constants/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBackBtn extends StatelessWidget {
  const CustomBackBtn({
    super.key,
    this.backFunction,
  });

  final VoidCallback? backFunction;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        if (backFunction != null) {
          backFunction!();
        }
      },
      child: Container(
        width: 39,
        height: 39,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          shape: BoxShape.circle,
        ),
        child: SizedBox(
          width: 10.w,
          child: const Icon(
            Icons.arrow_back_ios,
            size: 18,
            color: kBlackColor,
          ),
        ),
      ),
    );
  }
}
