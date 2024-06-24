import 'package:big_like/features/auth/presentation/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../../../common_widgets/custom_filed_elevated_btn.dart';
import '../../../../common_widgets/custom_text_btn.dart';
import '../../../../common_widgets/custom_text_editing_field.dart';
import '../../../../constants/consts.dart';
import '../../../../utils/helpers.dart';
import '../../../../utils/utils.dart';
import '../../data/auth_api_controller.dart';
import 'auth_model_screen.dart';
import 'enter_otp_screen.dart';

class AuthPhoneNumScreen extends StatefulWidget {
  const AuthPhoneNumScreen({super.key});

  @override
  State<AuthPhoneNumScreen> createState() => _AuthPhoneNumScreenState();
}

class _AuthPhoneNumScreenState extends State<AuthPhoneNumScreen> with Helpers {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _phoneNumTextEditingController;
  final AuthApiController _authApiController = AuthApiController();
  late FocusNode _phoneNumFocusNode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _phoneNumTextEditingController = TextEditingController();
    _phoneNumFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _phoneNumFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModelScreen(
      screenTitle: 'تسجيل الدخول',
      bodyWidget: KeyboardActions(
        config: _buildConfig(context),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 230.h,
              ),
              Text(
                'مرحباََ',
                style: TextStyle(
                  fontSize: 22.sp,
                  color: Theme.of(context).textTheme.bodySmall!.color!,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                'قم بتسجيل الدخول باستخدام رقم الهاتف',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Theme.of(context).textTheme.bodySmall!.color!,
                ),
              ),
              SizedBox(
                height: 25.h,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomInputTextFiled(
                        textInputType: TextInputType.phone,
                        restrictSpecialCharacter: true,
                        focusNode: _phoneNumFocusNode,
                        controller: _phoneNumTextEditingController,
                        hintText: 'قم بادخال رقم الهاتف'),
                    SizedBox(
                      height: 25.h,
                    ),
                    SizedBox(
                      child: CustomFiledElevatedBtn(
                        text: 'تسجيل الدخول',
                        function: () {
                          performSaveUserPhoneNum();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void performSaveUserPhoneNum() {
    if (checkUserPhoneNum()) {
      Utils.checkNetwork(context: context, function: saveUserPhoneNum);
    }
  }

  bool checkUserPhoneNum() {
    if (_formKey.currentState!.validate()) {
      return true;
    }
    return false;
  }

  void saveUserPhoneNum() async {
    onLoading(
      context,
      () {},
    );
    String? code = await _authApiController.sendOtp(
        phoneNumber: _phoneNumTextEditingController.text);
    if (mounted) {
      Navigator.pop(context);
      if (code != null) {
        showCupertinoModalBottomSheet(
          expand: false,
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) =>
              EnterOtpScreen(_phoneNumTextEditingController.text),
        );
      } else {
        showCupertinoModalBottomSheet(
          expand: false,
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) => RegisterScreen(
            phoneNumber: _phoneNumTextEditingController.text,
          ),
        );
      }
    }
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: false,
      actions: [
        KeyboardActionsItem(focusNode: _phoneNumFocusNode, toolbarButtons: [
          (node) {
            return SizedBox(
              height: 50.h,
              width: 1.sw,
              child: CustomTextBtn(
                // isBR: false,
                function: () {
                  node.unfocus();
                },
                text: 'تم',
                textColor: kWhiteColor,
                btnColor: kPrimaryColor,
                isRounded: false,
                /* titleSize: 14.sp,
                  buttonColor: kGrayColor*/
              ),
            );
          }
        ]),
      ],
    );
  }
}
