part of 'services_bloc.dart';

@immutable
sealed class ServicesState {}

final class ServicesInitial extends ServicesState {}

final class ServicesSuccess extends ServicesState {
  final List<ServiceModel> serviceList;

  ServicesSuccess({required this.serviceList});
}

final class ServicesFailure extends ServicesState {
  final String error;

  ServicesFailure(this.error);
}

final class ServicesLoading extends ServicesState {}

///
///
final class ShowServiceInitial extends ServicesState {}

final class ShowServiceLoading extends ServicesState {}

final class ShowServiceSuccess extends ServicesState {
  final ServiceModel serviceModel;

  ShowServiceSuccess({required this.serviceModel});
}

final class ShowServiceFailure extends ServicesState {
  final String error;

  ShowServiceFailure(this.error);
}
