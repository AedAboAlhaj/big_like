part of 'checkout_bloc.dart';

@immutable
sealed class CheckoutEvent {}

final class ScheduleFetched extends CheckoutEvent {}

final class WorkersFetched extends CheckoutEvent {
  WorkersFetched(
      {required this.date, required this.startTime, required this.endTime});

  final String date;
  final String startTime;
  final String endTime;
}
