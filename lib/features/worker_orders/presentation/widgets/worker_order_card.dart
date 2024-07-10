import 'dart:io';

import 'package:big_like/common_widgets/custom_filed_elevated_btn.dart';
import 'package:big_like/features/orders/presentation/widgets/order_product_card.dart';
import 'package:big_like/features/services/domain/models/service_model.dart';
import 'package:big_like/features/services/domain/models/service_order_model.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../constants/consts.dart';
import '../../../../local_storage/shared_preferences.dart';
import '../../../../utils/utils.dart';
import '../../domain/models/worker_order_model.dart';
import 'contacts_order_btn.dart';

class WorkerOrderCard extends StatefulWidget {
  const WorkerOrderCard(
      {super.key, required this.workerOrderModel, required this.function});

  final WorkerOrderModel workerOrderModel;
  final VoidCallback function;

  @override
  State<WorkerOrderCard> createState() => _WorkerOrderCardState();
}

class _WorkerOrderCardState extends State<WorkerOrderCard> {
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

  num getTotalOrderPrice() {
    return widget.workerOrderModel.cost;
  }

  void launchWhatsApp() async {
    String url() {
      if (Platform.isIOS) {
        // add the [https]
        return "whatsapp://wa.me/${widget.workerOrderModel.customerInfo.phone.characters.first == '0' ? widget.workerOrderModel.customerInfo.phone.replaceFirst('0', '+972') : '+972${widget.workerOrderModel.customerInfo.phone}'}"; // new line
      } else {
        // add the [https]
        return "whatsapp://send?phone=${widget.workerOrderModel.customerInfo.phone.characters.first == '0' ? widget.toString().replaceFirst('0', '+972') : '+972${widget.workerOrderModel.customerInfo.phone.toString()}'}"; // new line
      }
    }

    String fallbackUrl() {
      if (Platform.isIOS) {
        // add the [https]
        return "https://api.whatsapp.com/send?phone=${widget.workerOrderModel.customerInfo.phone.characters.first == '0' ? widget.workerOrderModel.customerInfo.phone.replaceFirst('0', '+972') : '+972${widget.workerOrderModel.customerInfo.phone.toString()}'}"; // new line
      } else {
        // add the [https]
        return "https://wa.me/${widget.workerOrderModel.customerInfo.phone.characters.first == '0' ? widget.workerOrderModel.customerInfo.phone.replaceFirst('0', '+972') : '+972${widget.workerOrderModel.customerInfo.phone.toString()}'}"; // new line
      }
    }

    try {
      bool launched = await launchUrl(Uri.parse(url()));
      if (!launched) {
        await launchUrl(Uri.parse(fallbackUrl()));
      }
    } catch (e) {
      await launchUrl(Uri.parse(fallbackUrl()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 440,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
      decoration: BoxDecoration(
          color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Column(
                children: [
                  Text(
                    Utils.stringToTimeOfDay(widget.workerOrderModel.startTime)
                        .format(context),
                    style: const TextStyle(
                        fontSize: 35, fontWeight: FontWeight.w900),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Text(
                    Utils.formatDateString(widget.workerOrderModel.date),
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w900),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Text(
                    widget.workerOrderModel.option,
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              SizedBox(
                height: 22.h,
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
                            fontSize: 16.sp, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 13.h,
                      ),
                      Text(
                        'طريقة الدفع',
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 13.h,
                      ),
                      Text(
                        'إجمالي الدفع',
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 40.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '#${widget.workerOrderModel.id}',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16.sp),
                      ),
                      SizedBox(
                        height: 13.h,
                      ),
                      Text(
                        widget.workerOrderModel.paymentMethod,
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16.sp),
                      ),
                      SizedBox(
                        height: 13.h,
                      ),
                      Text(
                        '${getTotalOrderPrice()} ₪',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16.sp),
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
          SizedBox(
            height: 20.h,
          ),
          CustomFiledElevatedBtn(
              function: () {},
              color: const Color(0xffF5EFD9),
              textColor: Theme.of(context).textTheme.bodySmall!.color!,
              text: widget.workerOrderModel.customerInfo.address.toString()),
          SizedBox(
            height: 12.h,
          ),
          Row(
            children: [
              OrderIconButton(
                function: () async {
                  if (!await launchUrl(Uri.parse(
                      "tel://${widget.workerOrderModel.customerInfo.phone}"))) {
                    throw Exception(
                        'Could not launch ${"tel://${widget.workerOrderModel.customerInfo.phone}"}');
                  }
                },
                iconColor: kPrimaryColor,
                imgUrl: 'assets/images/svgIcons/call_icon.svg',
                buttonColor: kLightPrimaryColor,
              ),
              SizedBox(
                width: 10.h,
              ),
              OrderIconButton(
                function: () => launchWhatsApp(),
                iconColor: const Color(0xff51A865),
                imgUrl: 'assets/images/svgIcons/whatsapp_icon.svg',
                buttonColor: const Color(0xff51A865).withOpacity(.1),
              ),
            ],
          ),
          SizedBox(
            height: 12.h,
          ),
          CustomFiledElevatedBtn(
            function: widget.function,
            text: widget.workerOrderModel.status == 0
                ? 'اضغط هنا للذهاب'
                : 'تم تنفيذ الخدمة',
            color: widget.workerOrderModel.status == 0 ? null : kBlackColor,
          )
        ],
      ),
    );
  }
}
