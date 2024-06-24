part of 'order_bloc.dart';

@immutable
sealed class OrderState {}

final class OrderInitial extends OrderState {}

final class OrderSuccess extends OrderState {
  // final List<OrderApiModel> ordersLis;
  //
  // OrderSuccess({required this.ordersLis});
}

final class OrderFailure extends OrderState {
  final String error;

  OrderFailure(this.error);
}

final class OrderLoading extends OrderState {}
