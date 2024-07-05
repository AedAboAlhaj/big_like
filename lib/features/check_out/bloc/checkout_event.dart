part of 'checkout_bloc.dart';

@immutable
sealed class CheckoutEvent {}

final class ScheduleFetched extends CheckoutEvent {
  ScheduleFetched({required this.optionId});

  final int optionId;
}
