import 'dart:async';
import 'package:big_like/features/worker_times/bloc/work_times_cubit.dart';
import 'package:big_like/features/worker_times/domain/models/work_times_model.dart';
import 'package:big_like/features/worker_times/presentation/widgets/holly_days_card.dart';
import 'package:big_like/features/worker_times/presentation/widgets/schedule_day_card.dart';
import 'package:big_like/local_storage/secure_storage.dart';
import 'package:big_like/utils/helpers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../common_widgets/custom_filed_elevated_btn.dart';
import '../../../../common_widgets/shimmer_effect.dart';
import '../../../../constants/consts.dart';
import '../../../../local_storage/shared_preferences.dart';
import '../../../../utils/utils.dart';
import '../../bloc/hollydays_cubit.dart';
import '../../data/worker_schedule_api_controller.dart';
import '../../domain/models/order_api_model.dart';

class WorkerTimesScreen extends StatefulWidget {
  const WorkerTimesScreen({super.key});

  @override
  State<WorkerTimesScreen> createState() => _WorkerTimesScreenState();
}

class _WorkerTimesScreenState extends State<WorkerTimesScreen>
    with WidgetsBindingObserver, Helpers {
  late PageController _pageController;
  late Future<List<WorkDayModel>> _future;
  late Future<List<HollyDaysModel>> _futureHollyDays;
  final WorkerScheduleApiController _workerDaysApiController =
      WorkerScheduleApiController();

  List<WorkDayModel> workerScheduleList = [];
  List<HollyDaysModel> workerHollyDaysList = [
    // HollyDaysModel(date: DateTime.now())
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print('object================>clearOrders');

    WidgetsBinding.instance.addObserver(this);
    _pageController = PageController();
    _future = _workerDaysApiController.getWorkerDays();
    _futureHollyDays = _workerDaysApiController.getWorkerHollyDays();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);

    _pageController.dispose();
    super.dispose();
  }

  Future<void> _pullRefreshSchedule() async {
    workerScheduleList.clear();
    setState(() {
      _future = _workerDaysApiController.getWorkerDays();
    });
  }

  Future<void> _pullRefreshHollyDays() async {
    workerHollyDaysList.clear();
    setState(() {
      _futureHollyDays = _workerDaysApiController.getWorkerHollyDays();
    });
  }

  late List<ConnectivityResult> _connectivityResult;
  final _errorIndicator = GlobalKey<RefreshIndicatorState>();

  void _update() async {
    if (_errorIndicator.currentState != null) {
      _errorIndicator.currentState!.show();
    }
    // orderBloc.selectedOrdersPage = 0;
    setState(() {});
  }

  int selectedOrdersPage = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([
          _future,
          _futureHollyDays,
          (Connectivity().checkConnectivity()),
        ]),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            workerScheduleList = snapshot.data[0];
            final scheduleList = context.read<WorkTimesCubit>().getList();
            if (scheduleList.isEmpty) {
              for (var element in workerScheduleList) {
                for (var ele in element.times) {
                  context.read<WorkTimesCubit>().addWorkTime(ele);
                }
              }
            }
            workerHollyDaysList = snapshot.data[1];
            final list = context.read<HollyDaysCubit>().getList();
            if (list.isEmpty) {
              for (var element in workerHollyDaysList) {
                context.read<HollyDaysCubit>().addHollyDay(element);
              }
            }
            _connectivityResult = snapshot.data[2];
            if (!(_connectivityResult.contains(ConnectivityResult.mobile) ||
                _connectivityResult.contains(ConnectivityResult.wifi))) {
              Utils.checkNetwork(context: context, function: _update);
              return RefreshIndicator(
                  onRefresh: _pullRefreshSchedule,
                  key: _errorIndicator,
                  color: kPrimaryColor,
                  child: const Center(child: Icon(Icons.error_outline)));
            }
            return Stack(
              children: [
                Positioned.fill(
                    top: 60,
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (val) {
                        setState(() {
                          selectedOrdersPage = val;
                        });
                      },
                      children: [
                        RefreshIndicator(
                            onRefresh: _pullRefreshSchedule,
                            color: kPrimaryColor,
                            child: ListView(
                              padding: const EdgeInsets.only(
                                  right: 15, left: 15, top: 10, bottom: 20),
                              children: [
                                ListView.separated(
                                  // physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return ScheduleDayCard(
                                        workDayModel:
                                            workerScheduleList[index]);
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(
                                      height: 10,
                                    );
                                  },
                                  itemCount: workerScheduleList.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                CustomFiledElevatedBtn(
                                  function: updateWorkDays,
                                  text: 'حفظ',
                                ),
                              ],
                            )),
                        RefreshIndicator(
                          onRefresh: _pullRefreshHollyDays,
                          color: kPrimaryColor,
                          child: ListView(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 20.h),
                            children: [
                              const HollyDaysCard(),
                              SizedBox(
                                height: 20.h,
                              ),
                              CustomFiledElevatedBtn(
                                function: () {
                                  updateHollyDays();
                                },
                                text: 'حسناً',
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
                Positioned(
                    right: 0,
                    left: 0,
                    top: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 0),
                      color: Theme.of(context).scaffoldBackgroundColor,
                      height: 60,
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                setState(() {
                                  selectedOrdersPage = 0;
                                });
                                _pageController.jumpToPage(0);
                              },
                              child: Column(
                                children: [
                                  Text(
                                    'الدوام',
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                        color: selectedOrdersPage == 0
                                            ? kPrimaryColor
                                            : Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.color),
                                  ),
                                  SizedBox(
                                    height: 11.h,
                                  ),
                                  Container(
                                    height: 7,
                                    decoration: BoxDecoration(
                                        color: selectedOrdersPage == 0
                                            ? kPrimaryColor
                                            : Theme.of(context).cardColor,
                                        borderRadius: kBorderRadius),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 12.w,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                // context
                                //     .read<WorkerTimesCubit>()
                                //     .updateScreen(screenNum: 1);
                                setState(() {
                                  selectedOrdersPage = 1;
                                });
                                _pageController.jumpToPage(1);
                              },
                              child: Column(
                                children: [
                                  Text(
                                    'العطلات',
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                        color: selectedOrdersPage == 1
                                            ? kPrimaryColor
                                            : Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .color),
                                  ),
                                  SizedBox(
                                    height: 11.h,
                                  ),
                                  Container(
                                    height: 7,
                                    decoration: BoxDecoration(
                                        color: selectedOrdersPage == 1
                                            ? kPrimaryColor
                                            : Theme.of(context).cardColor,
                                        borderRadius: kBorderRadius),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))
              ],
            );
          } else if (snapshot.hasError) {
            return const Icon(Icons.error_outline);
          } else {
            return const ShimmerEffect(content: OrderScreenShimmer());
          }
        });
  }

  updateHollyDays() async {
    final list = context.read<HollyDaysCubit>().getList();

    if (list.any(
      (element) =>
          element.date.isAtSameMomentAs(DateTime.now()) ||
          element.date.isBefore(DateTime.now()),
    )) {
      showSnackBar(context, massage: 'must be a date after now', error: true);
      return;
    } else {
      onLoading(context, () {});

      bool status = await _workerDaysApiController.updateHollyDays(list);
      if (mounted) {
        Navigator.pop(context);
      }
      if (status) {
        showSnackBar(context, massage: 'تم التحديث بنجاح');
      } else {
        showSnackBar(context,
            massage: 'لم يتم التحديث, حاول مرة اخرى', error: true);
      }
    }
  }

  void updateWorkDays() async {
    final list = context.read<WorkTimesCubit>().getList();

    if (list.any(
      (element) => element.startTime == null || element.endTime == null,
    )) {
      showSnackBar(context,
          massage: 'تاكد من اضافة الاوقات بالشكل الصحيح', error: true);
      return;
    } else {
      onLoading(context, () {});

      bool status = await _workerDaysApiController.updateWorkDays(list);
      if (mounted) {
        Navigator.pop(context);
      }
      if (status) {
        showSnackBar(context, massage: 'تم التحديث بنجاح');
      } else {
        showSnackBar(context,
            massage: 'لم يتم التحديث, حاول مرة اخرى', error: true);
      }
    }
  }
}
