import 'package:big_like/constants/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TimeInputField extends StatelessWidget {
  const TimeInputField({
    super.key,
    required this.controller,
    required this.hintText,
    this.enable = true,
    this.showBorder = true,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final bool enable;
  final bool showBorder;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: 4, vertical: showBorder ? 0 : 4),
      child: TextFormField(
        cursorWidth: 1,
        enabled: enable,
        // validator: (value) => enable && value!.isEmpty ? "مطلوب" : null,
        validator: (value) {
          if (value == null || (enable && value.isEmpty)) {
            return 'مطلوب';
          }
          return null;
        },
        style: const TextStyle(
            fontSize: 25, fontWeight: FontWeight.w700, color: kBlackColor),
        onChanged: onChanged,
        // readOnly: true,
        cursorColor: kPrimaryColor,
        textAlign: TextAlign.center,
        controller: controller,
        keyboardType: TextInputType.datetime,
        maxLength: 5,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.deny(RegExp('[,-]')),
          FilteringTextInputFormatter.deny(' ')
          // FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
            errorStyle: TextStyle(
              fontSize: 10.sp,
              height: 1,
            ),
            counterText: '',
            disabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: kRedColor.withOpacity(.1), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: kRedColor.withOpacity(.1), width: 1),
            ),
            border: OutlineInputBorder(
              borderSide:
                  BorderSide(color: kRedColor.withOpacity(.1), width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: kRedColor.withOpacity(.1), width: 1),
            ),
            labelText: hintText,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            labelStyle: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w700, color: kBlackColor)),
      ),
    );
  }
}
