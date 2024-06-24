import 'package:big_like/features/check_out/presentation/screens/service_employee_screen.dart';
import 'package:big_like/local_storage/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../../../common_widgets/custom_filed_elevated_btn.dart';
import '../../../../common_widgets/custom_loading_indicator.dart';
import '../../../../constants/consts.dart';
import '../../../auth/presentation/screens/auth_model_screen.dart';
import '../../bloc/checkout_bloc.dart';
import 'package:intl/intl.dart';

class ServiceDateAndTimeScreen extends StatefulWidget {
  const ServiceDateAndTimeScreen({super.key});

  @override
  State<ServiceDateAndTimeScreen> createState() =>
      _ServiceDateAndTimeScreenState();
}

class _ServiceDateAndTimeScreenState extends State<ServiceDateAndTimeScreen> {
  int selectedDay = 0;
  int selectedTime = 0;
  late final CheckoutBloc checkoutBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkoutBloc = BlocProvider.of<CheckoutBloc>(context);
    context.read<CheckoutBloc>().add(ScheduleFetched());
  }

  @override
  Widget build(BuildContext context) {
    return ModelScreen(
      bodyWidget: BlocConsumer<CheckoutBloc, CheckoutState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, CheckoutState state) {
          if (state is ScheduleFailure) {
            return Center(
              child: Text(state.error),
            );
          }
          if (state is! ScheduleSuccess) {
            return const CustomLoadingIndicator();
          }

          return BlocConsumer<CheckoutBloc, CheckoutState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, CheckoutState state) {
              if (state is ScheduleFailure) {
                return Center(
                  child: Text(state.error),
                );
              }
              if (state is! ScheduleSuccess) {
                return const CustomLoadingIndicator();
              }
              final datesList = state.datesList;
              if (datesList.isEmpty) {
                return const Center(
                  child: Text('لا يوحد اوقات متاحة حاليا'),
                );
              }
              return Stack(
                children: [
                  Positioned.fill(
                    child: Column(
                      children: [
                        const Divider(
                          height: 1,
                          color: kLightGrayColor,
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        SizedBox(
                          height: 70.h,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            physics: const BouncingScrollPhysics(),
                            itemCount: datesList.length,
                            separatorBuilder: (context, index) => SizedBox(
                              width: 10.w,
                            ),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  selectedDay = index;
                                  setState(() {});
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      datesList[index].day,
                                      style: const TextStyle(
                                          color: kDarkGrayColor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    CircleAvatar(
                                        radius: 20.h,
                                        backgroundColor: selectedDay == index
                                            ? kPrimaryColor
                                            : Colors.transparent,
                                        child: Text(
                                          DateFormat.E(AppSharedPref()
                                                  .languageLocale)
                                              .format(DateFormat("yyyy-MM-DD")
                                                  .parse(
                                                      datesList[index].date)),
                                          style: TextStyle(
                                              fontSize: 10.sp,
                                              color: selectedDay == index
                                                  ? Colors.white
                                                  : kDarkGrayColor,
                                              height: 1,
                                              fontWeight: selectedDay == index
                                                  ? FontWeight.w700
                                                  : FontWeight.w600),
                                        ))
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Divider(
                          height: 3.h,
                          color: kLightGrayColor,
                        ),
                        Expanded(
                            child: ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                padding: EdgeInsets.only(bottom: 100.h),
                                itemBuilder: (context, index) {
                                  return SizedBox(
                                    height: 40,
                                    child: ListTile(
                                      onTap: () {
                                        selectedTime = index;
                                        setState(() {});
                                      },
                                      title: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 20,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border:
                                                        selectedTime == index
                                                            ? null
                                                            : Border.all(
                                                                color: Colors
                                                                    .black26)),
                                                alignment: Alignment.center,
                                                child: selectedTime == index
                                                    ? CircleAvatar(
                                                        backgroundColor:
                                                            kPrimaryColor,
                                                        child: const Icon(
                                                            Icons.check,
                                                            color: Colors.white,
                                                            size: 15),
                                                      )
                                                    : null,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                '${datesList[selectedDay].times[index].startTime} -> ${datesList[selectedDay].times[index].endTime}',
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black54,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              const Spacer(),
                                              Text(
                                                '₪${checkoutBloc.sendOrderModel.options?.cost}',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: kPrimaryColor,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (_, index) => const Divider(
                                      height: 4,
                                      endIndent: 25,
                                      indent: 25,
                                      color: kLightGrayColor,
                                    ),
                                itemCount:
                                    datesList[selectedDay].times.length)),
                      ],
                    ),
                  ),
                  Positioned(
                      bottom: 20.h,
                      left: 15.w,
                      right: 15.w,
                      child: CustomFiledElevatedBtn(
                        function: () {
                          checkoutBloc.sendOrderModel.date =
                              datesList[selectedDay].date;
                          checkoutBloc.sendOrderModel.startTime =
                              datesList[selectedDay]
                                  .times[selectedTime]
                                  .startTime;
                          checkoutBloc.sendOrderModel.endTime =
                              datesList[selectedDay]
                                  .times[selectedTime]
                                  .endTime;
                          showCupertinoModalBottomSheet(
                            expand: true,
                            bounce: false,
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (context) => const ServiceEmployeeScreen(),
                          );
                        },
                        text: 'التالي',
                      ))
                ],
              );
            },
          );
        },
      ),
      screenTitle: 'title',
    );
  }
}
