part of 'checkout_bloc.dart';

@immutable
sealed class CheckoutState {}

final class CheckoutInitial extends CheckoutState {}

///
///
final class ScheduleInitial extends CheckoutState {}

final class ScheduleLoading extends CheckoutState {}

final class ScheduleSuccess extends CheckoutState {
  final List<DateModel> datesList;

  ScheduleSuccess({required this.datesList});
}

final class ScheduleFailure extends CheckoutState {
  final String error;

  ScheduleFailure(this.error);
}

///
///
