import 'dart:ui';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../common_widgets/custom_filed_elevated_btn.dart';
import '../constants/consts.dart';

mixin Helpers {
  static void showActionDialog(
      {required BuildContext context,
      required IconData iconData,
      required String title,
      required String content,
      required String btnText,
      bool showConfirmBtn = true,
      bool showCancelBtn = false,
      required VoidCallback function,
      bool barrierDismissible = true}) {
    showGeneralDialog(
      context: context,
      useRootNavigator: false,
      barrierColor: kLightCyanColor.withOpacity(.1),
      barrierDismissible: barrierDismissible,
      barrierLabel: 'true',
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return const Text('PAGE BUILDER');
      },
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: TweenSequence(<TweenSequenceItem<double>>[
            TweenSequenceItem<double>(
                tween: Tween<double>(
                  begin: 0,
                  end: 1.2,
                ),
                weight: 70),
            TweenSequenceItem<double>(
                tween: Tween<double>(
                  begin: 1.1,
                  end: 1,
                ),
                weight: 15),
            // TweenSequenceItem<double>(
            //     tween: Tween<double>(
            //       begin: 1.15,
            //       end: 1,
            //     ),
            //     weight: 15),
          ]).animate(a1).value,
          child: Opacity(
            opacity: a1.value,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: AlertDialog(
                insetPadding:
                    EdgeInsets.only(left: 20.w, right: 20.w, top: 10.h),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: kBorderRadius,
                    side: BorderSide(
                        color: Theme.of(context).cardColor, width: 1)),
                // shape: RoundedRectangleBorder(
                //   borderRadius: BorderRadius.circular(5),
                // ),

                content: StatefulBuilder(
                  builder: (context, setStateModelParent) {
                    return SizedBox(
                      width: 1.sw,
                      height: showCancelBtn ? 1.sh / 2 + 20 : 1.sh / 2 - 30,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context).cardColor,
                                  ),
                                  padding: const EdgeInsets.all(45),
                                  child: Icon(
                                    iconData,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .color!,
                                    size: 75,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  title,
                                  style: TextStyle(
                                    height: 2,
                                    fontSize: 20.sp,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .color!,
                                    fontFamily: kFontFamilyName,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Text(
                                  content,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    height: 2,
                                    fontSize: 18.sp,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .color!,
                                    fontFamily: kFontFamilyName,
                                  ),
                                ),
                                const Spacer(),
                                Visibility(
                                  visible: showConfirmBtn,
                                  child: SizedBox(
                                    width: 1.sw,
                                    child: CustomFiledElevatedBtn(
                                      text: btnText,
                                      color: kLightPrimaryColor,
                                      textColor: Theme.of(context).primaryColor,
                                      function: function,
                                      height: 50,
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: showCancelBtn,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      SizedBox(
                                        width: 1.sw,
                                        child: CustomFiledElevatedBtn(
                                          text: 'إغلاق',
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .color!
                                              .withOpacity(.15),
                                          textColor: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .color!,
                                          function: () {
                                            Navigator.pop(context);
                                          },
                                          height: 50,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Positioned(
                            left: 0,
                            child: Visibility(
                              visible: barrierDismissible,
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  padding: EdgeInsets.zero,
                                  icon: Icon(
                                    Icons.cancel,
                                    size: 40,
                                    color: kPrimaryColor,
                                  )),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  bool isTimeAfter(TimeOfDay time1, TimeOfDay time2) {
    if (time1.hour > time2.hour) {
      return true;
    } else if (time1.hour == time2.hour && time1.minute > time2.minute) {
      return true;
    } else {
      return false;
    }
  }

/*
  static void showCheckoutDialog(
      {required BuildContext context,
      required String title,
      required String content,
      required String hintText,
      required String iconUrl,
      required TextEditingController controller,
      bool largeTextField = true,
      required VoidCallback function,
      bool barrierDismissible = true}) {
    showGeneralDialog(
      context: context,
      useRootNavigator: false,
      barrierColor: kLightCyanColor.withOpacity(.1),
      barrierDismissible: barrierDismissible,
      barrierLabel: 'true',
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return const Text('PAGE BUILDER');
      },
      transitionBuilder: (context, a1, a2, widget) {
        final formKey = GlobalKey<FormState>();

        return Transform.scale(
          scale: TweenSequence(<TweenSequenceItem<double>>[
            TweenSequenceItem<double>(
                tween: Tween<double>(
                  begin: 0,
                  end: 1.2,
                ),
                weight: 70),
            TweenSequenceItem<double>(
                tween: Tween<double>(
                  begin: 1.1,
                  end: 1,
                ),
                weight: 15),
          ]).animate(a1).value,
          child: Opacity(
            opacity: a1.value,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: AlertDialog(
                insetPadding:
                    EdgeInsets.only(left: 20.w, right: 20.w, top: 10.h),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: kBorderRadius,
                    side: BorderSide(
                        color: Theme.of(context).cardColor, width: 1)),
                // shape: RoundedRectangleBorder(
                //   borderRadius: BorderRadius.circular(5),
                // ),

                content: StatefulBuilder(
                  builder: (context, setStateModelParent) {
                    return Form(
                        key: formKey,
                        child: SizedBox(
                          width: 1.sw,
                          height: 1.sh / 2 - 100,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      title,
                                      style: TextStyle(
                                        height: 2,
                                        fontSize: 20.sp,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .color!,
                                        fontFamily: kFontFamilyName,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      content,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        height: 2,
                                        fontSize: 18.sp,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .color!,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: kFontFamilyName,
                                      ),
                                    ),
                                    const Spacer(),
                                    FormField(
                                      validator: (String? value) {
                                        if (controller.text.isEmpty) {
                                          return 'مطلوب';
                                        }
                                        return null;
                                      },
                                      builder: (FormFieldState state) {
                                        return Column(
                                          children: [
                                            Row(
                                              children: [
                                                SvgPicture.asset(iconUrl),
                                                SizedBox(
                                                  width: 10.w,
                                                ),
                                                Expanded(
                                                  child: TextField(
                                                    controller: controller,
                                                    cursorColor:
                                                        Theme.of(context)
                                                            .textTheme
                                                            .bodySmall!
                                                            .color!,
                                                    textAlign: TextAlign.start,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall!
                                                            .color!,
                                                        fontFamily:
                                                            kFontFamilyName,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18.sp,
                                                        height: 1.5),
                                                    autocorrect: false,
                                                    cursorHeight: 27.h,
                                                    cursorRadius:
                                                        Radius.circular(100.r),
                                                    textAlignVertical:
                                                        TextAlignVertical
                                                            .center,
                                                    decoration: InputDecoration(
                                                      // enabledBorder: InputBorder.none,
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                      color:
                                                                          kPrimaryColor)),
                                                      label: Text(
                                                        hintText,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: state.hasError
                                                              ? kRedColor
                                                              : Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodySmall!
                                                                  .color!,
                                                          fontFamily:
                                                              kFontFamilyName,
                                                          height: 0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12.sp,
                                                        ),
                                                      ),
                                                      border: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color:
                                                                  kPrimaryColor)),
                                                      contentPadding:
                                                          const EdgeInsets.only(
                                                              top: 0),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              state.errorText ?? '',
                                              style: TextStyle(
                                                  color: kRedColor,
                                                  fontSize: 10.sp),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                    const Spacer(),
                                    SizedBox(
                                      width: 1.sw,
                                      child: CustomFiledElevatedBtn(
                                        text: 'تم',
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(.15),
                                        textColor:
                                            Theme.of(context).primaryColor,
                                        function: () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            function();
                                          }
                                        },
                                        height: 50,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                left: 0,
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    padding: EdgeInsets.zero,
                                    icon: Icon(
                                      Icons.cancel,
                                      size: 40,
                                      color: kPrimaryColor,
                                    )),
                              )
                            ],
                          ),
                        ));
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
*/
  static void showCheckoutBottomSheet(
      {required BuildContext context,
      required String title,
      required String content,
      required String hintText,
      required String iconUrl,
      required TextEditingController controller,
      bool largeTextField = true,
      required VoidCallback function,
      bool barrierDismissible = true}) {
    final formKey = GlobalKey<FormState>();

    showCupertinoModalBottomSheet(
      expand: true,
      bounce: false,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Scaffold(
        body: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            function();
                          }
                        },
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        child: Text(
                          'تم',
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold),
                        )),
                    Text(
                      title,
                      style: TextStyle(
                        height: 2.2,
                        fontSize: 18.sp,
                        color: Theme.of(context).textTheme.bodySmall!.color!,
                        fontFamily: kFontFamilyName,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.close,
                          size: 25,
                          color: kPrimaryColor,
                        )),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FormField(
                          validator: (String? value) {
                            if (controller.text.isEmpty) {
                              return 'مطلوب';
                            }
                            return null;
                          },
                          builder: (FormFieldState state) {
                            return Column(
                              children: [
                                TextField(
                                  controller: controller,
                                  cursorColor: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .color!,
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .color!,
                                      fontFamily: kFontFamilyName,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.sp,
                                      height: 1.5),
                                  autocorrect: false,
                                  cursorHeight: 27.h,
                                  cursorRadius: Radius.circular(100.r),
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: InputDecoration(
                                    enabledBorder: const UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: kGrayColor)),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: kPrimaryColor)),
                                    label: Text(
                                      hintText,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: state.hasError
                                            ? kRedColor
                                            : kGrayColor,
                                        fontFamily: kFontFamilyName,
                                        height: 0,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                    border: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: kPrimaryColor)),
                                    contentPadding:
                                        const EdgeInsets.only(top: 0),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  state.errorText ?? '',
                                  style: TextStyle(
                                      color: kRedColor, fontSize: 10.sp),
                                ),
                              ],
                            );
                          },
                        ),
                        Text(
                          content,
                          style: TextStyle(
                            height: 1,
                            fontSize: 13.sp,
                            color: kLightBlackColor,
                            fontFamily: kFontFamilyName,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                /*     const Spacer(),
                      SizedBox(
                        width: 1.sw,
                        child: CustomFiledElevatedBtn(
                          text: 'تم',
                          color:
                              Theme.of(context).primaryColor.withOpacity(.15),
                          textColor: Theme.of(context).primaryColor,
                          function: () {
                            if (formKey.currentState!.validate()) {
                              function();
                            }
                          },
                          height: 50,
                        ),
                      ),*/
              ],
            )),
      ),
    );
  }

  void onLoading(BuildContext context, VoidCallback function) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: kGrayColor.withOpacity(.5),
      useSafeArea: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 120.w, vertical: 350.h),
          child: Dialog(
            backgroundColor: Colors.transparent,

            elevation: 0,
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.circular(10.r),
            // ),
            child: Center(
              child: Container(
                height: 100.h,
                width: 100.w,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(5.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 23.w, vertical: 22.h),
                child: CircularProgressIndicator(
                  backgroundColor: kPrimaryColor.withOpacity(.3),
                  color: kPrimaryColor,
                  strokeWidth: 7.w,
                ),
              ),
            ),
          ),
        );
      },
    );
    function();
  }

  void showSnackBar(BuildContext context,
      {required String massage, bool error = false}) {
    Flushbar(
      message: massage,
      icon: Icon(
        !error ? Icons.check_circle_outline : Icons.info_outline,
        size: 30.0,
        color: kWhiteColor,
      ),
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      borderRadius: kBorderRadius5,
      margin: const EdgeInsets.all(5),
      duration: const Duration(seconds: 2),
      backgroundColor: error ? kRedColor : kPrimaryColor,
      // leftBarIndicatorColor: Colors.blue[300],
    ).show(context);

    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //   behavior: SnackBarBehavior.floating,
    //   duration: const Duration(seconds: 2),
    //   content: Row(
    //     children: [
    //       Text(
    //         massage,
    //         style: TextStyle(
    //             color: Colors.white,
    //             fontWeight: FontWeight.bold,
    //             fontSize: 18.sp),
    //       ),
    //       const Spacer(),
    //       Icon(
    //         !error ? Icons.check_circle_outline : Icons.cancel_outlined,
    //         color: Colors.white,
    //         size: 30,
    //       )
    //     ],
    //   ),
    //   backgroundColor: error ? kRedColor : kPrimaryColor,
    // ));
  }

/*  void showSnackBar(BuildContext context,
      {required String massage, bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
      content: Row(
        children: [
          Text(
            massage,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18.sp),
          ),
          const Spacer(),
          Icon(
            !error ? Icons.check_circle_outline : Icons.cancel_outlined,
            color: Colors.white,
            size: 30,
          )
        ],
      ),
      backgroundColor: error ? kRedColor : kPrimaryColor,
    ));
  }*/
}
