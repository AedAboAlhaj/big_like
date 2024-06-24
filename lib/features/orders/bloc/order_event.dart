part of 'order_bloc.dart';

@immutable
sealed class OrderEvent {}

final class OrdersFetched extends OrderEvent {}

// final class OrdersUpdated extends OrderEvent {
//   final int selectedOrdersPage;
//   OrdersUpdated(this.selectedOrdersPage);
// }
