import 'package:big_like/features/check_out/domain/models/date_model.dart';
import 'package:big_like/features/services/data/services_api_controller.dart';
import 'package:big_like/features/services/domain/models/service_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'services_event.dart';

part 'services_state.dart';

class ServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  final ServicesApiController servicesApiController;

  ServicesBloc(this.servicesApiController) : super(ServicesInitial()) {
    on<ServicesEvent>((event, emit) {});
    on<ServicesFetched>(_getServicesList);
    on<ServiceFetched>(_getServiceDetails);
  }

  // final ServicesApiController _servicesApiController = ServicesApiController();

  void _getServicesList(
      ServicesFetched event, Emitter<ServicesState> emit) async {
    emit(ServicesLoading());

    try {
      final servicesList = await servicesApiController.getServices();

      emit(ServicesSuccess(serviceList: servicesList));
    } catch (e) {
      emit(ServicesFailure(e.toString()));
    }
  }

  void _getServiceDetails(
      ServiceFetched event, Emitter<ServicesState> emit) async {
    emit(ShowServiceLoading());

    try {
      final serviceModel =
          await servicesApiController.showService(id: event.serviceId);
      if (serviceModel != null) {
        emit(ShowServiceSuccess(serviceModel: serviceModel));
      } else {
        emit(ShowServiceFailure('server error'));
      }
    } catch (e) {
      emit(ShowServiceFailure(e.toString()));
    }
  }
}
