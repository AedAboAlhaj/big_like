part of 'services_bloc.dart';

@immutable
sealed class ServicesEvent {}

final class ServicesFetched extends ServicesEvent {}

final class ServiceFetched extends ServicesEvent {
  final int serviceId;

  ServiceFetched(this.serviceId);
}
