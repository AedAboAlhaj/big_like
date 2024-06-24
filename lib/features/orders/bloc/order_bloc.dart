import 'package:big_like/features/orders/data/orders_api_controller.dart';
import 'package:big_like/features/orders/domain/models/order_api_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'order_event.dart';

part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrdersApiController ordersApiController;

  OrderBloc(this.ordersApiController) : super(OrderInitial()) {
    on<OrdersFetched>(_getOrdersList);
    // on<OrdersUpdated>(_ordersUpdated);
  }

  // final OrdersApiController _ordersApiController = OrdersApiController();
  List<OrderApiModel> ordersList = [];

  void _getOrdersList(OrdersFetched event, Emitter<OrderState> emit) async {
    emit(OrderLoading());

    try {
      ordersList = await ordersApiController.getUserOrders();

      emit(OrderSuccess());
    } catch (e) {
      emit(OrderFailure(e.toString()));
    }
  }

// void _ordersUpdated(OrdersUpdated event, Emitter<OrderState> emit) async {
//   // emit(OrderLoading());
//   //
//   // try {
//   //   ordersList = await ordersApiController.getUserOrders();
//   //
//   //   emit(OrderSuccess());
//   // } catch (e) {
//   //   emit(OrderFailure(e.toString()));
//   // }
// }
}
