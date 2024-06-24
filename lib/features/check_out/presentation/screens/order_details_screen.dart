import 'dart:ui';

import 'package:big_like/features/check_out/bloc/checkout_bloc.dart';
import 'package:big_like/features/check_out/presentation/screens/select_payment_method.dart';
import 'package:big_like/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common_widgets/custom_filed_elevated_btn.dart';
import '../../../../local_storage/shared_preferences.dart';
import '../../../auth/presentation/screens/auth_model_screen.dart';
import '../widgets/clicked_container.dart';
import 'package:intl/intl.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late final CheckoutBloc checkoutBloc;
  late final TextEditingController noteTextEditingController;
  late final TextEditingController addressTextEditingController;
  late final TextEditingController couponTextEditingController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkoutBloc = BlocProvider.of<CheckoutBloc>(context);

    noteTextEditingController =
        TextEditingController(text: checkoutBloc.sendOrderModel.note);
    addressTextEditingController =
        TextEditingController(text: checkoutBloc.sendOrderModel.address);
    couponTextEditingController =
        TextEditingController(text: checkoutBloc.sendOrderModel.coupon);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    noteTextEditingController.dispose();
    addressTextEditingController.dispose();
    couponTextEditingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModelScreen(
      bodyWidget: Stack(
        children: [
          Positioned.fill(
            left: 15.w,
            right: 15.w,
            child: Column(
              children: [
                SizedBox(
                  height: 30.h,
                ),
                Text(
                  'تفاصيل الطلب',
                  style:
                  TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 47.h,
                ),
                Text(
                  '${checkoutBloc.sendOrderModel.startTime} -> ${checkoutBloc
                      .sendOrderModel.endTime}',
                  style:
                  TextStyle(fontWeight: FontWeight.w900, fontSize: 30.sp),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                    'يوم ${DateFormat.EEEE(AppSharedPref().languageLocale)
                        .format(DateFormat("yyyy-MM-DD").parse(
                        checkoutBloc.sendOrderModel.date ?? ''))} ${checkoutBloc
                        .sendOrderModel.startTime}'),
                // Text('3 ساعات'),
                SizedBox(
                  height: 30.h,
                ),
                ClickedContainer(
                  fun: () {
                    Helpers.showCheckoutDialog(
                        context: context,
                        title: 'العنوان',
                        content: 'قم بادخال العنوان رجاءا',
                        hintText: 'العنوان..',
                        controller: addressTextEditingController,
                        function: () {
                          setState(() {
                            checkoutBloc.sendOrderModel.address =
                                addressTextEditingController.text.trim();
                          });
                        });
                  },
                  title: addressTextEditingController.text.isEmpty
                      ? 'قم بادخال العنوان رجاءا'
                      : 'عنوانك: ${addressTextEditingController.text}',
                  iconUrl: 'assets/images/svgIcons/location_pin.svg',
                ),
                SizedBox(
                  height: 14.h,
                ),
                ClickedContainer(
                  fun: () {
                    Helpers.showCheckoutDialog(
                        context: context,
                        title: 'ملاحظات',
                        content: 'قم بادخال ملاحظاتك رجاءا',
                        hintText: 'ملاحظات..',
                        controller: noteTextEditingController,
                        function: () {
                          setState(() {
                            checkoutBloc.sendOrderModel.note =
                                noteTextEditingController.text.trim();
                          });
                        });
                  },
                  title: noteTextEditingController.text.isEmpty
                      ? 'ملاحظات..'
                      : noteTextEditingController.text,
                  iconUrl: 'assets/images/svgIcons/note_icon.svg',
                ),
                SizedBox(
                  height: 14.h,
                ),
                ClickedContainer(
                  fun: () {
                    Helpers.showCheckoutDialog(
                        context: context,
                        title: 'كوبون الخصم',
                        content: 'هل لديك كوبون ؟!',
                        hintText: 'الكوبون',
                        controller: couponTextEditingController,
                        function: () {
                          setState(() {
                            checkoutBloc.sendOrderModel.coupon =
                                couponTextEditingController.text.trim();
                          });
                        });
                  },
                  title: 'هل لديك كوبون؟',
                  iconUrl: 'assets/images/svgIcons/coupon_icon.svg',
                ),
                SizedBox(
                  height: 52.h,
                ),
                Text(
                  'استعمالك للتطبيق يشترط موافقتك على',
                  style:
                  TextStyle(fontWeight: FontWeight.w500, fontSize: 10.sp),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Text(
                  'شروط الإستخدام',
                  style:
                  TextStyle(fontWeight: FontWeight.w700, fontSize: 11.sp),
                ),
              ],
            ),
          ),
          Positioned(
              bottom: 20.h,
              left: 15.w,
              right: 15.w,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 25.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          'إجمالي الدفع',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 17.sp),
                        ),
                        const Spacer(),
                        Text(
                          '₪${checkoutBloc.sendOrderModel.options?.cost}',
                          style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 22.h,
                    ),
                    CustomFiledElevatedBtn(
                        function: () =>
                            openConditionDialog(
                              context,
                                  () {},
                            ),
                        text: 'التالي'),
                  ],
                ),
              ))
        ],
      ),
      screenTitle: '',
    );
  }

  void openConditionDialog(BuildContext context, VoidCallback function) {
    showGeneralDialog(
        barrierColor: Colors.transparent,
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
              ])
                  .animate(a1)
                  .value,
              child: Opacity(
                opacity: a1.value,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: AlertDialog(
                    insetPadding: EdgeInsets.zero,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    content: StatefulBuilder(
                      builder: (context, setStateModelParent) {
                        return const SelectPaymentMethod();
                      },
                    ),
                  ),
                ),
              ));
        },
        transitionDuration: const Duration(milliseconds: 150),
        barrierDismissible: false,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return Container();
        });
  }
}
