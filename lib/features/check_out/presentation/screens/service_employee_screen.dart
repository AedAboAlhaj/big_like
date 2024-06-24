import 'package:big_like/features/check_out/bloc/checkout_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../../../common_widgets/custom_filed_elevated_btn.dart';
import '../../../../common_widgets/custom_loading_indicator.dart';
import '../../../../common_widgets/custom_network_image.dart';
import '../../../../constants/consts.dart';
import '../../../auth/presentation/screens/auth_model_screen.dart';
import '../../../orders/bloc/order_bloc.dart';
import 'order_details_screen.dart';

class ServiceEmployeeScreen extends StatefulWidget {
  const ServiceEmployeeScreen({super.key});

  @override
  State<ServiceEmployeeScreen> createState() => _ServiceEmployeeScreenState();
}

class _ServiceEmployeeScreenState extends State<ServiceEmployeeScreen> {
  int selectedEmployee = 0;
  late final CheckoutBloc checkoutBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkoutBloc = BlocProvider.of<CheckoutBloc>(context);
    context.read<CheckoutBloc>().add(WorkersFetched(
        date: checkoutBloc.sendOrderModel.date ?? "",
        endTime: checkoutBloc.sendOrderModel.endTime ?? "",
        startTime: checkoutBloc.sendOrderModel.startTime ?? ""));
  }

  @override
  Widget build(BuildContext context) {
    return ModelScreen(
        screenTitle: '',
        bodyWidget: BlocConsumer<CheckoutBloc, CheckoutState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, CheckoutState state) {
            if (state is WorkersFailure) {
              return Center(
                child: Text(state.error),
              );
            }
            if (state is! WorkersSuccess) {
              return const CustomLoadingIndicator();
            }

            return BlocConsumer<CheckoutBloc, CheckoutState>(
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, CheckoutState state) {
                if (state is WorkersFailure) {
                  return Center(
                    child: Text(state.error),
                  );
                }
                if (state is! WorkersSuccess) {
                  return const CustomLoadingIndicator();
                }
                final workersList = state.workersList;
                if (workersList.isEmpty) {
                  return const Center(
                    child: Text('لا يوجد عاملين حاليا'),
                  );
                }
                return Stack(
                  children: [
                    Positioned.fill(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30.h,
                          ),
                          Text(
                            'اختيار اشخص الملائم',
                            style: TextStyle(
                                fontSize: 18.sp, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 51.h,
                          ),
                          Expanded(
                              child: ListView.separated(
                                  padding: EdgeInsets.only(bottom: 100.h),
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    Color textColor = selectedEmployee == index
                                        ? Colors.white
                                        : Colors.black;
                                    return GestureDetector(
                                      onTap: () {
                                        selectedEmployee = index;
                                        setState(() {});
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6.r),
                                              color: selectedEmployee == index
                                                  ? const Color(0xffc43359)
                                                  : Colors.grey.shade200),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 23.w, vertical: 14.h),
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 15.w,
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                  height: 58.h,
                                                  width: 58.h,
                                                  decoration:
                                                      const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle),
                                                  clipBehavior: Clip.antiAlias,
                                                  child: CustomNetworkImage(
                                                      imageUrl:
                                                          workersList[index]
                                                              .photo)),
                                              SizedBox(
                                                width: 15.w,
                                              ),
                                              Text(
                                                workersList[index].name,
                                                style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w700,
                                                    color: selectedEmployee ==
                                                            index
                                                        ? kWhiteColor
                                                        : kBlackColor),
                                              ),
                                              // const Spacer(),
                                              // Text(
                                              //   '5/',
                                              //   style: TextStyle(
                                              //       fontSize: 20.sp,
                                              //       color: selectedEmployee ==
                                              //               index
                                              //           ? kWhiteColor
                                              //           : kBlackColor),
                                              // ),
                                              // Text(
                                              //   ' 4.5',
                                              //   style: TextStyle(
                                              //       fontSize: 20.sp,
                                              //       color: textColor,
                                              //       fontWeight:
                                              //           FontWeight.w700),
                                              // ),
                                            ],
                                          )),
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                  itemCount: workersList.length))
                        ],
                      ),
                    ),
                    Positioned(
                        bottom: 20.h,
                        left: 15.w,
                        right: 15.w,
                        child: CustomFiledElevatedBtn(
                          function: () {
                            checkoutBloc.sendOrderModel.workerId =
                                workersList[selectedEmployee].id;
                            showCupertinoModalBottomSheet(
                              expand: true,
                              bounce: false,
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) => const OrderDetailsScreen(),
                            );
                          },
                          text: 'التالي',
                        ))
                  ],
                );
              },
            );
          },
        ));
  }
}
