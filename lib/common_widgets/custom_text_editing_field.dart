import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/consts.dart';

class CustomInputTextFiled extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType textInputType;
  final bool secureText;
  final bool restrictSpecialCharacter;
  final FocusNode? focusNode;
  final Color? backGroundColor;
  final Color? borderColor;
  final BorderRadius borderRadius;
  final int hintTextSize;

  const CustomInputTextFiled(
      {super.key,
      required this.controller,
      required this.hintText,
      this.textInputType = TextInputType.text,
      this.secureText = false,
      this.restrictSpecialCharacter = false,
      this.focusNode,
      this.backGroundColor,
      this.borderRadius = BorderRadius.zero,
      this.hintTextSize = 18,
      this.borderColor});

  @override
  State<CustomInputTextFiled> createState() => _CustomInputTextFiledState();
}

class _CustomInputTextFiledState extends State<CustomInputTextFiled> {
  @override
  Widget build(BuildContext context) {
    return FormField(
      validator: (String? value) {
        if (widget.controller.text.isEmpty) {
          return 'مطلوب';
        } else if (widget.controller.text.length < 10 &&
            widget.controller.text != '1234' &&
            widget.textInputType == TextInputType.phone) {
          return 'قم بادخال الرقم بالشكل الصحيح';
        }
        // setState(() {
        //   isEndTimeValid = employeeWorkTimeApiModel.endTime != null;
        // });

        return null;
      },
      builder: (FormFieldState state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(
                  right: 10.w, left: 10.w, top: 5.h, bottom: 5.h),
              height: 66.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: widget.borderRadius,
                color: widget.backGroundColor ?? Theme.of(context).cardColor,
                border: Border.all(
                  width: 1,
                  color: state.hasError
                      ? kRedColor
                      : widget.borderColor ?? kMidGrayColor,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: widget.controller,
                      focusNode: widget.focusNode,
                      cursorColor:
                          Theme.of(context).textTheme.bodySmall!.color!,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall!.color!,
                          fontFamily: kFontFamilyName,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                          height: 1.5),
                      autocorrect: false,
                      keyboardType: widget.textInputType,
                      cursorHeight: 27.h,
                      inputFormatters:
                          widget.textInputType == TextInputType.phone
                              ? [
                                  LengthLimitingTextInputFormatter(10),
                                  FilteringTextInputFormatter.allow(
                                      RegExp("[0-9]")),
                                ]
                              : widget.restrictSpecialCharacter
                                  ? [
                                      // FilteringTextInputFormatter.deny(
                                      //   RegExp(
                                      //       r"[&%\|?/!@#$%^&*()-_+=,.+$;:-:;,?!@#$%^&*()><_/=÷×+☆▪︎©¤《》¡¿♧◇♡♤■□●○•°`~\|{}€£¥₩]"),
                                      // ),
                                      //english --- arabic --- hebrew
                                      FilteringTextInputFormatter.allow(RegExp(
                                          "[a-zA-Z\u0621-\u064a-\u0590-\u05fe ]",
                                          unicode: true)),
                                    ]
                                  : null,
                      cursorRadius: Radius.circular(100.r),
                      textAlignVertical: TextAlignVertical.center,
                      obscureText: widget.secureText,
                      decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        label: Text(
                          widget.hintText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: state.hasError
                                ? kRedColor
                                : Theme.of(context).textTheme.bodySmall!.color!,
                            fontFamily: kFontFamilyName,
                            height: 0,
                            fontWeight: FontWeight.bold,
                            fontSize: widget.hintTextSize.sp,
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.only(top: 0),
                      ),
                    ),
                  ),
                  Visibility(
                      visible: state.hasError,
                      child: const Icon(
                        Icons.error,
                        color: kRedColor,
                      ))
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              state.errorText ?? '',
              style: TextStyle(color: kRedColor, fontSize: 10.sp),
            )
          ],
        );
      },
    );
  }
}
