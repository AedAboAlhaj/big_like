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
    // orderBloc.ordersList.clear();
    // orderBloc.ordersList = await _ordersApiController.getUserOrders();
    // setState(() {});
    orderBloc.add(OrdersFetched());
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
                            context
                                .read<OrderCubit>()
                                .updateScreen(screenNum: val);
                          },
                          children: [
                            orderBloc.ordersList
                                    .where((element) =>
                                        element.status != 'done' &&
                                        element.status != 'canceled')
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
                                                    element.status != 'done' &&
                                                    element.status !=
                                                        'canceled')
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
                                                element.status != 'done' &&
                                                element.status != 'canceled')
                                            .toList()
                                            .length),
                                  )
                                : const Center(
                                    child: Text('لا يوجد لديك طلبات جديدة')),
                            orderBloc.ordersList
                                    .where((element) =>
                                        element.status == 'done' ||
                                        element.status == 'canceled')
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
                                                    element.status == 'done' ||
                                                    element.status ==
                                                        'canceled')
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
                                                element.status == 'done' ||
                                                element.status == 'canceled')
                                            .toList()
                                            .toList()
                                            .length),
                                  )
                                : const Center(
                                    child: Text('لا يوجد لديك طلبات سابقة')),
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
                                                : Theme.of(context).cardColor),
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
