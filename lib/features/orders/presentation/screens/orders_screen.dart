import 'dart:async';
import 'package:big_like/features/orders/bloc/order_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../common_widgets/shimmer_effect.dart';
import '../../../../constants/consts.dart';
import '../../../../utils/utils.dart';
import '../../bloc/order_cubit.dart';
import '../../data/orders_api_controller.dart';
import '../../domain/models/order_api_model.dart';
import '../widgets/order_card.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with WidgetsBindingObserver {
  late PageController _pageController;
  late Future<List<OrderApiModel>> _future;
  final OrdersApiController _ordersApiController = OrdersApiController();

  late final OrderBloc orderBloc;
  int _selectedPage = 0;
  double _right = 1;
  double _left = (1.sw / 2) - 20.w;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print('object================>clearOrders');
    WidgetsBinding.instance.addObserver(this);
    orderBloc = BlocProvider.of<OrderBloc>(context);
    // orderBloc.selectedOrdersPage = 0;
    orderBloc.ordersList.clear();
    _pageController = PageController();
    _future = _ordersApiController.getUserOrders();
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
    orderBloc.ordersList.clear();
    orderBloc.ordersList = await _ordersApiController.getUserOrders();

    if (mounted) {
      context.read<OrderCubit>().updateScreen(screenNum: _selectedPage);
    }
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
            if (orderBloc.ordersList.isEmpty) {
              orderBloc.ordersList = snapshot.data[0];
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
            return BlocConsumer<OrderCubit, int>(
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
                            _selectedPage = val;
                            if (val == 0) {
                              _left = (1.sw / 2) - 20.w;
                              _right = 1;
                              context
                                  .read<OrderCubit>()
                                  .updateScreen(screenNum: _selectedPage);
                            } else {
                              _left = 1;
                              _right = (1.sw / 2) - 20.w;
                              context
                                  .read<OrderCubit>()
                                  .updateScreen(screenNum: _selectedPage);
                            }

                            // _pullRefresh();
                          },
                          children: [
                            orderBloc.ordersList
                                    .where((element) =>
                                        element.status != 2 &&
                                        element.status != 3)
                                    .toList()
                                    .isNotEmpty
                                ? RefreshIndicator(
                                    onRefresh: _pullRefresh,
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
                                          return OrderCard(
                                            orderApiModel: orderBloc.ordersList
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
                                        itemCount: orderBloc.ordersList
                                            .where((element) =>
                                                element.status != 2 &&
                                                element.status != 3)
                                            .toList()
                                            .length),
                                  )
                                : RefreshIndicator(
                                    onRefresh: _pullRefresh,
                                    color: kPrimaryColor,
                                    child: ListView(
                                      children: [
                                        Container(
                                            alignment: Alignment.center,
                                            height: 1.sh / 2,
                                            width: 1.sw,
                                            child: const Text(
                                                'لا يوجد لديك طلبات جديدة')),
                                      ],
                                    ),
                                  ),
                            orderBloc.ordersList
                                    .where((element) =>
                                        element.status == 2 ||
                                        element.status == 3)
                                    .toList()
                                    .isNotEmpty
                                ? RefreshIndicator(
                                    onRefresh: _pullRefresh,
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
                                          return OrderCard(
                                            orderApiModel: orderBloc.ordersList
                                                .where((element) =>
                                                    element.status == 2 ||
                                                    element.status == 3)
                                                .toList()
                                                .toList()[index],
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return const SizedBox(
                                            height: 10,
                                          );
                                        },
                                        itemCount: orderBloc.ordersList
                                            .where((element) =>
                                                element.status == 2 ||
                                                element.status == 3)
                                            .toList()
                                            .toList()
                                            .length),
                                  )
                                : RefreshIndicator(
                                    onRefresh: _pullRefresh,
                                    color: kPrimaryColor,
                                    child: ListView(
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          height: 1.sh / 2,
                                          width: 1.sw,
                                          child: const Center(
                                              child: Text(
                                                  'لا يوجد لديك طلبات سابقة')),
                                        )
                                      ],
                                    ),
                                  ),
                          ],
                        )),
                    Positioned(
                      right: 15,
                      left: 15,
                      top: 10,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: kBorderRadius5,
                        ),
                        clipBehavior: Clip.antiAlias,
                        alignment: Alignment.center,
                        height: 43.h,
                        // padding: const EdgeInsets.all(2),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            AnimatedPositioned(
                                right: _right,
                                left: _left,
                                curve: Curves.easeInOut,
                                duration: const Duration(milliseconds: 100),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: kBorderRadius5,
                                  ),
                                  width: (1.sw / 2) - 20.w,
                                  height: 50.h,
                                  // padding: EdgeInsets.symmetric(
                                  //     vertical: 12.h, horizontal: 31.w),
                                )),
                            Positioned.fill(
                                child: Row(
                              children: [
                                Expanded(
                                    child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedPage = 0;
                                      _left = (1.sw / 2) - 20.w;
                                      _right = 1;
                                    });
                                    _pageController.animateTo(0,
                                        duration:
                                            const Duration(milliseconds: 190),
                                        curve: Curves.easeInOut);
                                  },
                                  child: Text(
                                    'طلبات مفتوحة',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: _selectedPage == 0
                                            ? kWhiteColor
                                            : kBlackColor,
                                        fontWeight: _selectedPage == 0
                                            ? FontWeight.w800
                                            : FontWeight.bold,
                                        fontSize: 17.sp),
                                  ),
                                )),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Expanded(
                                    child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedPage = 1;
                                      _left = 1;
                                      _right = (1.sw / 2) - 20.w;
                                    });
                                    _pageController.animateToPage(1,
                                        duration:
                                            const Duration(milliseconds: 190),
                                        curve: Curves.easeInOut);
                                  },
                                  child: Text(
                                    'طلبات سابقة',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: _selectedPage == 1
                                            ? kWhiteColor
                                            : kBlackColor,
                                        fontWeight: _selectedPage == 0
                                            ? FontWeight.w800
                                            : FontWeight.bold,
                                        fontSize: 17.sp),
                                  ),
                                )),
                              ],
                            ))
                          ],
                        ),
                      ),
                    )
                    /*   Positioned(
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
                                        .read<OrderCubit>()
                                        .updateScreen(screenNum: 0);
                                    _pageController.jumpToPage(0);
                                  },
                                  child: Column(
                                    children: [
                                      Text(
                                        'طلبات حالية',
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
                                        .read<OrderCubit>()
                                        .updateScreen(screenNum: 1);
                                    _pageController.jumpToPage(1);
                                  },
                                  child: Column(
                                    children: [
                                      Text(
                                        'طلبات سابقة',
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
                        ))*/
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
