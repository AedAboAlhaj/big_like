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
import '../../domain/models/user_api_model.dart';
import 'auth_model_screen.dart';
import 'enter_otp_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with Helpers {
  final _formKey = GlobalKey<FormState>();

  // late TextEditingController _phoneNumTextEditingController;
  late TextEditingController _nameTextEditingController;
  late TextEditingController _lastNameTextEditingController;
  late FocusNode _firstNameFocusNode;
  late FocusNode _lastNameFocusNode;

  // late TextEditingController _cityTextEditingController;

  final AuthApiController _authApiController = AuthApiController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameTextEditingController = TextEditingController();
    _lastNameTextEditingController = TextEditingController();
    _firstNameFocusNode = FocusNode();
    _lastNameFocusNode = FocusNode();
    // _phoneNumTextEditingController = TextEditingController();
    // _phoneNumTextEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return ModelScreen(
      screenTitle: 'التسجيل',
      bodyWidget: KeyboardActions(
        config: _buildConfig(context),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomInputTextFiled(
                        controller: _nameTextEditingController,
                        restrictSpecialCharacter: true,
                        focusNode: _firstNameFocusNode,
                        hintText: 'الاسم الاول'),
                    SizedBox(
                      height: 10.h,
                    ),
                    CustomInputTextFiled(
                        restrictSpecialCharacter: true,
                        controller: _lastNameTextEditingController,
                        focusNode: _lastNameFocusNode,
                        hintText: 'اسم العائلة'),
                    SizedBox(
                      height: 25.h,
                    ),
                    SizedBox(
                      child: CustomFiledElevatedBtn(
                        text: 'تحقق',
                        function: () {
                          createNewCustomerAccount();
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

  void createNewCustomerAccount() {
    if (checkUserPhoneNum()) {
      Utils.checkNetwork(context: context, function: saveUserPhoneNum);

      // } else {
      //   showTopSnackBar(massage: 'قم بادخال رقم الهاتف', error: true);
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
    UserApiModel newUser = UserApiModel();
    newUser.name =
        '${_nameTextEditingController.text} ${_lastNameTextEditingController.text}';
    newUser.phone = widget.phoneNumber;
    // newUser.birthdate = ;
    // newUser.city = _cityTextEditingController.text;
    int? code = await _authApiController.register(
      userApiModel: newUser,
    );
    // bool  = await _authApiController.sendOtp(
    //     phoneNumber: _phoneNumTextEditingController.text[0] == '0'
    //         ? _phoneNumTextEditingController.text
    //         : '${_phoneNumTextEditingController.text}');
    if (code != null) {
      if (mounted) {
        Navigator.pop(context);
        showCupertinoModalBottomSheet(
            expand: false,
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => EnterOtpScreen(widget.phoneNumber));

        // showCupertinoModalBottomSheet(
        //   expand: false,
        //   context: context,
        //   backgroundColor: Colors.transparent,
        //   builder: (context) =>
        //       EnterOtpScreen(_phoneNumTextEditingController.text, code: code),
        //   // builder: (context) => EnterOtpScreen(
        //   //     _phoneNumTextEditingController.text[0] == '0'
        //   //         ? _phoneNumTextEditingController.text
        //   //         : '${_phoneNumTextEditingController.text}'),
        // );
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => EnterOtpScreen(
        //             _phoneNumTextEditingController.text[0] == '0'
        //                 ? _phoneNumTextEditingController.text
        //                 : '${_phoneNumTextEditingController.text}')));
      }

      // showTopSnackBar(
      //   massage: 'success',
      // );
      // Get.to(EnterOtpScreen(_phoneNumTextEditingController.text[0] == '0'
      //     ? _phoneNumTextEditingController.text
      //     : '0' + _phoneNumTextEditingController.text));
    } else {
      if (mounted) {
        Navigator.pop(context);
      }
      //todo:: register screen
      // showTopSnackBar(
      //     massage: LocaleKeys.error_in_your_phone_num.tr(), error: true);
    }
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: false,
      actions: [
        KeyboardActionsItem(focusNode: _firstNameFocusNode, toolbarButtons: [
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
        KeyboardActionsItem(focusNode: _lastNameFocusNode, toolbarButtons: [
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
