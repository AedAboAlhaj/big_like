import 'package:big_like/common_widgets/custom_filed_elevated_btn.dart';
import 'package:big_like/features/orders/presentation/widgets/order_product_card.dart';
import 'package:big_like/features/services/domain/models/service_model.dart';
import 'package:big_like/features/services/domain/models/service_order_model.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../../../constants/consts.dart';
import '../../../../local_storage/shared_preferences.dart';
import '../../../../utils/utils.dart';
import '../../domain/models/order_api_model.dart';

class WorkerOrderCard extends StatefulWidget {
  const WorkerOrderCard({super.key, required this.workerOrderApiModel});

  final WorkerOrderApiModel workerOrderApiModel;

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
    if (widget.workerOrderApiModel.productsInfo != null) {
      return (widget.workerOrderApiModel.productsInfo?.deliveryCost ?? 0) +
          widget.workerOrderApiModel.total;
    } else {
      return widget.workerOrderApiModel.total;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 440,
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(20.h),
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
              widget.workerOrderApiModel.service != null
                  ? ServiceInfo(
                      serviceOrderModel: widget.workerOrderApiModel.service!)
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return OrderProductCard(
                          product: widget.workerOrderApiModel.products[index],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider(
                          color: kDarkGrayColor,
                        );
                      },
                      itemCount: widget.workerOrderApiModel.products.length),
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
                      Visibility(
                        visible:
                            widget.workerOrderApiModel.productsInfo != null,
                        child: Column(
                          children: [
                            Text(
                              'تكلفة التوصيل',
                              style: TextStyle(
                                  fontSize: 16.sp, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 13.h,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'الاجمالي',
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
                        '#${widget.workerOrderApiModel.id}',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16.sp),
                      ),
                      SizedBox(
                        height: 13.h,
                      ),
                      Text(
                        widget.workerOrderApiModel.paymentMethod,
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16.sp),
                      ),
                      SizedBox(
                        height: 13.h,
                      ),
                      Visibility(
                        visible:
                            widget.workerOrderApiModel.productsInfo != null,
                        child: Column(
                          children: [
                            Text(
                              '${widget.workerOrderApiModel.productsInfo?.deliveryCost} ₪',
                              style: TextStyle(
                                  fontSize: 16.sp, fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              height: 13.h,
                            ),
                          ],
                        ),
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

class ServiceInfo extends StatelessWidget {
  const ServiceInfo({
    super.key,
    required this.serviceOrderModel,
  });

  final ServiceOrderModel serviceOrderModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          Utils.stringToTimeOfDay(serviceOrderModel.startTime).format(context),
          style: const TextStyle(fontSize: 35, fontWeight: FontWeight.w900),
        ),
        SizedBox(
          height: 3.h,
        ),
        Text(
          Utils.formatDateString(serviceOrderModel.date),
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w900),
        ),
        SizedBox(
          height: 3.h,
        ),
        Text(
          serviceOrderModel.option,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w900),
        ),
      ],
    );
  }
}
