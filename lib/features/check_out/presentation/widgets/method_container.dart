import 'package:big_like/constants/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MethodContainer extends StatelessWidget {
  const MethodContainer(
      {super.key,
      required this.title,
      required this.selected,
      required this.fun,
      required this.iconUrl});

  final String title;
  final String iconUrl;
  final bool selected;
  final void Function() fun;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: fun,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: selected ? kPrimaryColor : Colors.transparent, width: 2),
          borderRadius: BorderRadius.circular(6),
          color: kLightGrayColor,
        ),
        height: 190.w,
        width: 210.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(iconUrl),
            SizedBox(
              height: 22.h,
            ),
            Text(title,
                style: TextStyle(fontSize: 23.sp, fontWeight: FontWeight.w600))
          ],
        ),
      ),
    );
  }
}
