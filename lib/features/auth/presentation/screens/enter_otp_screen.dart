import 'dart:async';
import 'package:big_like/local_storage/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common_widgets/custom_filed_elevated_btn.dart';
import '../../../../constants/consts.dart';
import '../../../../local_storage/shared_preferences.dart';
import '../../../../utils/helpers.dart';
import '../../../../utils/utils.dart';
import '../../../home/blocs/app_cubit.dart';
import '../../../home/presentation/screens/main_screen.dart';
import '../../data/auth_api_controller.dart';
import '../../domain/models/user_api_model.dart';
import 'auth_model_screen.dart';

class EnterOtpScreen extends StatefulWidget {
  final String phoneNumber;

  const EnterOtpScreen(this.phoneNumber, {super.key});

  @override
  State<EnterOtpScreen> createState() => _EnterOtpScreenState();
}

class _EnterOtpScreenState extends State<EnterOtpScreen> with Helpers {
  //CodeAutoFill
  TextEditingController textEditingController = TextEditingController();
  late String errorText;
  final AuthApiController _authApiController = AuthApiController();

  // late Timer _timer;
  // int _start = 30;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();
  late TextEditingController _otpNumTextEditingController;

  @override
  void initState() {
    super.initState();
    _otpNumTextEditingController = TextEditingController();

    errorText = 'ادخل الرمز بالشكل الصحيح';
  }

  double lineWidth = 200.w;
  int textLength = 0;

//ZUaaOSXqFxL
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModelScreen(
        screenTitle: 'التحقق',
        bodyWidget: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 52.h,
              ),
              // SvgPicture.asset('assets/images/svgIcons/app_logo.svg',
              //     height: 60.h),
              SizedBox(
                height: 150.h,
              ),
              Text('تم ارسال كود برسالة SMS\nللتأكيد',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).textTheme.bodySmall!.color!,
                  )),
              SizedBox(
                height: 52.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: Column(
                  children: [
                    /*        Form(
                      key: formKey,
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: PinCodeTextField(
                          appContext: context,
                          pastedTextStyle: TextStyle(
                            color: Colors.green.shade600,
                            fontWeight: FontWeight.bold,
                          ),
                          length: 4,
                          autoFocus: true,
                          animationType: AnimationType.fade,
                          validator: (v) {
                            if (v!.length < 4) {
                              return "";
                            } else {
                              return null;
                            }
                          },
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(5),
                            fieldHeight: 69.h,
                            fieldWidth: 69.w,
                            borderWidth: 2,
                            activeFillColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            activeColor: Theme.of(context).cardColor,
                            selectedColor: kPrimaryColor,
                            inactiveColor: Theme.of(context).cardColor,
                            inactiveFillColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            selectedFillColor:
                                Theme.of(context).scaffoldBackgroundColor,
                          ),
                          textStyle: TextStyle(
                            fontSize: 28.sp,
                            color:
                                Theme.of(context).textTheme.bodySmall!.color!,
                            fontWeight: FontWeight.w700,
                          ),
                          cursorColor:
                              Theme.of(context).textTheme.bodySmall!.color!,
                          animationDuration: const Duration(milliseconds: 300),
                          enableActiveFill: true,
                          errorAnimationController: errorController,
                          controller: textEditingController,
                          keyboardType: TextInputType.number,
                          onCompleted: (v) {
                            performOtpAuth();
                          },
                          onChanged: (value) {
                            setState(() {
                              currentText = value;
                            });
                          },
                          beforeTextPaste: (text) {
                            return false;
                          },
                        ),
                      ),
                    ),*/
                    SizedBox(
                      width: 250.w,
                      child: Form(
                        key: formKey,
                        child: FormField(
                          validator: (String? value) {
                            if (_otpNumTextEditingController.text.isEmpty) {
                              return 'مطلوب';
                            } else if (_otpNumTextEditingController
                                        .text.length <
                                    4 &&
                                _otpNumTextEditingController.text != '1234') {
                              return 'قم بادخال الرقم بالشكل الصحيح';
                            }
                            return null;
                          },
                          builder: (FormFieldState state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  controller: _otpNumTextEditingController,
                                  onChanged: (e) {
                                    // if (lineWidth < (1.sw - 30.w)) {
                                    //   setState(() {
                                    //     if (e.length > textLength) {
                                    //       lineWidth = lineWidth + 20.w;
                                    //     } else {
                                    //       lineWidth = lineWidth - 20.w;
                                    //     }
                                    //   });
                                    // }
                                    // textLength = e.length;
                                  },
                                  cursorColor: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .color!,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .color!,
                                      fontFamily: kFontFamilyName,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 69.sp,
                                      height: 1),
                                  autocorrect: false,
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(10),
                                    FilteringTextInputFormatter.allow(
                                        RegExp("[0-9]")),
                                  ],
                                  cursorRadius: Radius.circular(100.r),
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: const InputDecoration(
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(top: 0),
                                  ),
                                ),
                                Container(
                                  width: 250.w,
                                  height: 2.h,
                                  color:
                                      state.hasError ? kRedColor : kBlackColor,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  hasError ? errorText : state.errorText ?? '',
                                  style: TextStyle(
                                      color: kRedColor, fontSize: 10.sp),
                                )
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    // Row(
                    //   children: [
                    //     Text(
                    //       hasError ? errorText : "",
                    //       style: TextStyle(
                    //           color: Colors.red,
                    //           fontSize: 12.sp,
                    //           fontWeight: FontWeight.w400),
                    //     ),
                    //   ],
                    // ),
                    SizedBox(
                      height: 30.h,
                    ),
                    CustomFiledElevatedBtn(
                      function: () {
                        performOtpAuth();
                      },
                      text: 'تحقق',
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  void performOtpAuth() {
    if (checkOtpAuth()) {
      Utils.checkNetwork(context: context, function: saveOtpAuth);
    }
  }

  bool checkOtpAuth() {
    if (formKey.currentState!.validate()) {
      return true;
    }
    return false;
  }

  void saveOtpAuth() async {
    onLoading(
      context,
      () {},
    );

    UserApiModel? userData = await _authApiController.checkSignUpCode(
        code: _otpNumTextEditingController.text.trim());
    if (userData != null) {
      await AppSecureStorage().setToken(userData.token);
      await AppSecureStorage().setPhone(userData.phone);
      await AppSecureStorage().setUserName(userData.name);

      await AppSharedPref().saveUserType(userType: userData.type);

      if (mounted) {
        Navigator.pop(context);
        context
            .read<AppCubit>()
            .updateScreen(screenName: 'WorkerOrdersScreen', screenNum: 0);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => const MainScreen(),
            ),
            (route) => false);
      }
    } else {
      if (mounted) {
        Navigator.pop(context);
      }
      setState(() {
        hasError = true;
        errorText = 'رمز التحقق خطأ';
      });
    }
  }
}
