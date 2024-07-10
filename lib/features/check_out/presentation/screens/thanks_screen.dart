import 'package:big_like/common_widgets/custom_filed_elevated_btn.dart';
import 'package:big_like/constants/consts.dart';
import 'package:big_like/features/auth/presentation/screens/auth_model_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

import '../../../home/blocs/app_cubit.dart';
import '../../../home/presentation/screens/main_screen.dart';

class ThanksScreen extends StatelessWidget {
  const ThanksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appCubit = BlocProvider.of<AppCubit>(context);

    return ModelScreen(
      screenTitle: '',
      showBackBtn: false,
      bodyWidget: Padding(
        padding: EdgeInsets.symmetric(horizontal: 35.w),
        child: Column(
          children: [
            SizedBox(
              height: 50.h,
            ),
            SvgPicture.asset(
              'assets/images/svgIcons/success.svg',
              height: 200.h,
              width: double.infinity,
            ),
            SizedBox(
              height: 50.h,
            ),
            Text('شكرا',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 87.sp,
                    color: kPrimaryColor)),
            SizedBox(
              height: 21.h,
            ),
            Text(
                'لقد تم استقبال طلبك بنجاح\nسيتم خدمتكم بالوقت المطلوب وبكل حب',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 17.sp,
                ),
                textAlign: TextAlign.center),
            SizedBox(
              height: 70.h,
            ),
            SizedBox(
                width: double.infinity,
                child: CustomFiledElevatedBtn(
                  function: () {
                    context
                        .read<AppCubit>()
                        .updateScreen(screenName: 'OrdersScreen', screenNum: 1);

                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainScreen()),
                        (route) => false);
                  },
                  textColor: kBlackColor,
                  color: kLightPrimaryColor,
                  text: 'ملخص الطلب',
                )),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
                width: double.infinity,
                child: CustomFiledElevatedBtn(
                    function: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/', (route) => false);
                    },
                    text: 'الرئيسية')),
          ],
        ),
      ),
    );
  }
}
