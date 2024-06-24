import 'package:big_like/common_widgets/custom_filed_elevated_btn.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../../../constants/consts.dart';
import '../../../../local_storage/shared_preferences.dart';
import '../../../../utils/utils.dart';
import '../../domain/models/order_api_model.dart';

class OrderCard extends StatefulWidget {
  const OrderCard({super.key, required this.orderApiModel});

  final OrderApiModel orderApiModel;

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  late final Map status;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    status = {
      'pending': 'معلق',
      'preparation': 'قيد التحضير',
      'ready': 'جاهز للتوصيل',
      'in_progress_delivery': 'بالطريق',
      'canceled': 'تم الالغاء',
      'done': 'تم التسليم'
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 440,
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
          color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              SizedBox(
                height: 15.h,
              ),
              const Text(
                '13:30',
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.w900),
              ),
              Text(
                'يوم الاحد 05.06',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w900),
              ),
              Text(
                '3 ساعات',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w900),
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'رقم الطلب',
                        style: TextStyle(
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Text(
                        'طريقة الدفع',
                        style: TextStyle(
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Text(
                        'الاجمالي',
                        style: TextStyle(
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 40.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '#23233',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Text(
                        'فيزا',
                        style: TextStyle(
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      const Text(
                        '673',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
            ],
          ),
          EasyStepper(
            activeStep: 2,
            internalPadding: 0.w,
            showLoadingAnimation: false,
            stepRadius: 18.r,
            showStepBorder: true,
            defaultStepBorderType: BorderType.normal,
            unreachedStepBorderColor: Colors.black,
            activeStepBorderColor: kPrimaryColor,
            finishedStepBackgroundColor: kPrimaryColor,
            unreachedStepTextColor: Colors.white,
            lineStyle: LineStyle(
                lineLength: 60,
                lineType: LineType.normal,
                finishedLineColor: kPrimaryColor,
                defaultLineColor: Colors.black,
                lineThickness: 1.5.h),
            borderThickness: 4.w,
            steps: [
              EasyStep(
                customStep: Text(
                  '1',
                  style: TextStyle(
                      color: 2 < 0
                          ? Colors.black
                          : 2 == 0
                              ? kPrimaryColor
                              : Colors.white,
                      fontSize: 17.sp,
                      fontFamily: '',
                      fontWeight: FontWeight.w900),
                ),
                customTitle: const Column(
                  children: [
                    Text('بالانتظار',
                        style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w500)),
                    Text('15.03.24',
                        style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              EasyStep(
                  customStep: Text(
                    '2',
                    style: TextStyle(
                        color: 2 < 1
                            ? Colors.black
                            : 2 == 1
                                ? kPrimaryColor
                                : Colors.white,
                        fontSize: 17.sp,
                        fontFamily: '',
                        fontWeight: FontWeight.w900),
                  ),
                  customTitle: const Column(
                    children: [
                      Text(
                        'الموعد',
                        style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '16.03.24',
                        style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '11:00',
                        style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w500),
                      ),
                    ],
                  )),
              EasyStep(
                  customStep: Text(
                    '3',
                    style: TextStyle(
                        color: 2 < 2
                            ? Colors.black
                            : 2 == 2
                                ? kPrimaryColor
                                : Colors.white,
                        fontSize: 17.sp,
                        fontFamily: '',
                        fontWeight: FontWeight.w900),
                  ),
                  customTitle: const Center(
                    child: Text(
                      'انتهاء',
                      style:
                          TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                    ),
                  )),
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 25.w),
              width: double.infinity,
              child:
                  CustomFiledElevatedBtn(function: () {}, text: 'تفاصيل الطلب'))
        ],
      ),
    );
  }
}
