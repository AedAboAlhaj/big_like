import 'dart:async';
import 'package:big_like/features/orders/bloc/order_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../common_widgets/shimmer_effect.dart';
import '../../../../constants/consts.dart';
import '../../../../local_storage/shared_preferences.dart';
import '../../../../utils/utils.dart';
import '../../data/worker_orders_api_controller.dart';
import '../../domain/models/order_api_model.dart';
import '../widgets/worker_order_card.dart';

class WorkerOrdersScreen extends StatefulWidget {
  const WorkerOrdersScreen({super.key});

  @override
  State<WorkerOrdersScreen> createState() => _WorkerOrdersScreenState();
}

class _WorkerOrdersScreenState extends State<WorkerOrdersScreen>
    with WidgetsBindingObserver {
  late PageController _pageController;
  late Future<List<WorkerOrderApiModel>> _future;
  final WorkerOrdersApiController _workerOrdersApiController =
      WorkerOrdersApiController();

  List<WorkerOrderApiModel> workerOrdersList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print('object================>clearOrders');
    WidgetsBinding.instance.addObserver(this);
    _pageController = PageController();
    _future = _workerOrdersApiController.getWorkerOrders();
    timer =
        Timer.periodic(const Duration(minutes: 1), (Timer t) => _pullRefresh());
  }

  Timer? timer;

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);

    _pageController.dispose();
    timer?.cancel();
    super.dispose();
  }

  Future<void> _pullRefresh() async {
    workerOrdersList.clear();
    _future = _workerOrdersApiController.getWorkerOrders();
    setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // --
        _pullRefresh();
        break;
      case AppLifecycleState.inactive:
        // --
        debugPrint('Inactive');
        break;
      case AppLifecycleState.paused:
        // --
        debugPrint('Paused');
        break;
      case AppLifecycleState.detached:
        // --
        debugPrint('Detached');
        break;
      case AppLifecycleState.hidden:
      // TODO: Handle this case.
    }
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
            if (workerOrdersList.isEmpty) {
              workerOrdersList = snapshot.data[0];
            }

            _connectivityResult = snapshot.data[1];
            if (!(_connectivityResult.contains(ConnectivityResult.mobile) ||
                _connectivityResult.contains(ConnectivityResult.wifi))) {
              Utils.checkNetwork(context: context, function: _update);
              return RefreshIndicator(
                  onRefresh: _pullRefresh,
                  key: _errorIndicator,
                  color: kPrimaryColor,
                  child: const Center(child: Icon(Icons.error_outline)));
            }
            return Stack(
              children: [
                Positioned.fill(
                    top: 95.h,
                    child: workerOrdersList
                            .where((element) =>
                                element.status != 2 && element.status != 3)
                            .toList()
                            .isNotEmpty
                        ? RefreshIndicator(
                            onRefresh: _pullRefresh,
                            color: kPrimaryColor,
                            child: ListView.separated(
                                padding: const EdgeInsets.only(
                                    right: 15, left: 15, top: 10, bottom: 100),
                                // physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return WorkerOrderCard(
                                    workerOrderApiModel: workerOrdersList
                                        .where((element) =>
                                            element.status != 2 &&
                                            element.status != 3)
                                        .toList()[index],
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return const SizedBox(
                                    height: 10,
                                  );
                                },
                                itemCount: workerOrdersList
                                    .where((element) =>
                                        element.status != 2 &&
                                        element.status != 3)
                                    .toList()
                                    .length),
                          )
                        : const Center(
                            child: Text('لا يوجد لديك طلبات جديدة'))),
                Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
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
                          height: 80.h,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            physics: const BouncingScrollPhysics(),
                            itemCount: 30,
                            separatorBuilder: (context, index) => SizedBox(
                              width: 10.w,
                            ),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  index;
                                  setState(() {});
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      DateFormat.E(
                                              AppSharedPref().languageLocale)
                                          .format(DateFormat("yyyy-MM-DD")
                                              .parse('2024-03-12')),
                                      style: TextStyle(
                                          color: kDarkGrayColor,
                                          height: 2,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    CircleAvatar(
                                        radius: 24.h,
                                        backgroundColor: 1 == index
                                            ? kPrimaryColor
                                            : Colors.transparent,
                                        child: Text(
                                          index.toString(),
                                          style: TextStyle(
                                              fontSize: 18.sp,
                                              color: 1 == index
                                                  ? kWhiteColor
                                                  : kBlackColor,
                                              height: 1,
                                              fontWeight: 1 == index
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
                      ],
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
}
