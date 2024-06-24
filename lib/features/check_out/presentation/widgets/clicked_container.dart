import 'package:big_like/constants/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ClickedContainer extends StatelessWidget {
  const ClickedContainer(
      {super.key,
      required this.fun,
      required this.title,
      required this.iconUrl});

  final void Function() fun;
  final String title;
  final String iconUrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: fun,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(6.r),
            color: Colors.white),
        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
        child: Row(
          children: [
            SvgPicture.asset(iconUrl),
            SizedBox(
              width: 20.w,
            ),
            SizedBox(
                width: 200.w,
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 15, overflow: TextOverflow.ellipsis),
                )),
            const Spacer(),
            CircleAvatar(
              backgroundColor: kLightGrayColor,
              radius: 14.sp,
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 12,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}
