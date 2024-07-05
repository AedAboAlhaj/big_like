import 'dart:async';
import 'package:big_like/features/worker_times/domain/models/work_times_model.dart';
import 'package:big_like/features/worker_times/presentation/widgets/holly_days_card.dart';
import 'package:big_like/features/worker_times/presentation/widgets/schedule_day_card.dart';
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
import '../../bloc/order_cubit.dart';
import '../../data/worker_orders_api_controller.dart';
import '../../domain/models/order_api_model.dart';

class WorkerTimesScreen extends StatefulWidget {
  const WorkerTimesScreen({super.key});

  @override
  State<WorkerTimesScreen> createState() => _WorkerTimesScreenState();
}

class _WorkerTimesScreenState extends State<WorkerTimesScreen>
    with WidgetsBindingObserver {
  late PageController _pageController;
  late Future<List<WorkerOrderApiModel>> _future;
  final WorkerOrdersApiController _workerOrdersApiController =
      WorkerOrdersApiController();

  List workerScheduleList = [];
  List<HollyDaysModel> workerHollyDaysList = [
    HollyDaysModel(date: DateTime.now())
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print('object================>clearOrders');
    WidgetsBinding.instance.addObserver(this);
    _pageController = PageController();
    _future = _workerOrdersApiController.getWorkerOrders();
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
    _future = _workerOrdersApiController.getWorkerOrders();
    setState(() {});
  }

  Future<void> _pullRefreshHollyDays() async {
    workerHollyDaysList.clear();
    _future = _workerOrdersApiController.getWorkerOrders();
    setState(() {});
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

  List<String> daysOfWeek = [
    DateFormat.EEEE(AppSharedPref().languageLocale ?? 'en')
        .format(DateTime.utc(2023, 7, 2)), // Monday
    DateFormat.EEEE(AppSharedPref().languageLocale ?? 'en')
        .format(DateTime.utc(2023, 7, 3)), // Tuesday
    DateFormat.EEEE(AppSharedPref().languageLocale ?? 'en')
        .format(DateTime.utc(2023, 7, 4)), // Wednesday
    DateFormat.EEEE(AppSharedPref().languageLocale ?? 'en')
        .format(DateTime.utc(2023, 7, 5)), // Thursday
    DateFormat.EEEE(AppSharedPref().languageLocale ?? 'en')
        .format(DateTime.utc(2023, 7, 6)), // Friday
    DateFormat.EEEE(AppSharedPref().languageLocale ?? 'en')
        .format(DateTime.utc(2023, 7, 7)), // Saturday
    DateFormat.EEEE(AppSharedPref().languageLocale ?? 'en')
        .format(DateTime.utc(2023, 7, 8)), // Sunday
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([
          _future,
          (Connectivity().checkConnectivity()),
        ]),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print(snapshot);
          if (snapshot.hasData) {
            _connectivityResult = snapshot.data[1];
            if (!(_connectivityResult.contains(ConnectivityResult.mobile) ||
                _connectivityResult.contains(ConnectivityResult.wifi))) {
              Utils.checkNetwork(context: context, function: _update);
              return RefreshIndicator(
                  onRefresh: _pullRefreshSchedule,
                  key: _errorIndicator,
                  color: kPrimaryColor,
                  child: const Center(child: Icon(Icons.error_outline)));
            }
            return BlocConsumer<WorkerTimesCubit, int>(
              listener: (context, selectedOrdersPage) {
                // TODO: implement listener
              },
              builder: (context, selectedOrdersPage) {
                return Stack(
                  children: [
                    Positioned.fill(
                        top: 75,
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (val) {
                            context
                                .read<WorkerTimesCubit>()
                                .updateScreen(screenNum: val);
                          },
                          children: [
                            RefreshIndicator(
                                onRefresh: _pullRefreshSchedule,
                                color: kPrimaryColor,
                                child: ListView.separated(
                                  padding: const EdgeInsets.only(
                                      right: 15,
                                      left: 15,
                                      top: 10,
                                      bottom: 100),
                                  // physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return ScheduleDayCard(
                                        day: daysOfWeek[index]);
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(
                                      height: 10,
                                    );
                                  },
                                  itemCount: daysOfWeek.length,
                                )),
                            workerHollyDaysList.isNotEmpty
                                ? RefreshIndicator(
                                    onRefresh: _pullRefreshHollyDays,
                                    color: kPrimaryColor,
                                    child: ListView(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w, vertical: 20.h),
                                      children: [
                                        HollyDaysCard(
                                          workerHollyDaysList:
                                              workerHollyDaysList,
                                        ),
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        CustomFiledElevatedBtn(
                                          function: () {},
                                          text: 'حسناً',
                                        ),
                                      ],
                                    ),
                                  )
                                : const Center(
                                    child: Text('لا يوجد لديك اي عطلات')),
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
                                  onTap: () {
                                    context
                                        .read<WorkerTimesCubit>()
                                        .updateScreen(screenNum: 0);
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
                                    context
                                        .read<WorkerTimesCubit>()
                                        .updateScreen(screenNum: 1);
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
              },
            );
          } else if (snapshot.hasError) {
            return const Icon(Icons.error_outline);
          } else {
            return const ShimmerEffect(content: OrderScreenShimmer());
          }
        });
  }
}
