import 'package:big_like/features/check_out/data/checkout_api_controller.dart';
import 'package:big_like/features/check_out/domain/models/worker_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../orders/domain/models/send_order_model.dart';
import '../domain/models/date_model.dart';

part 'checkout_event.dart';

part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  CheckoutBloc(this.checkoutApiController) : super(CheckoutInitial()) {
    on<ScheduleFetched>(_getScheduleList);
    on<WorkersFetched>(_getWorkersList);
  }

  SendOrderModel sendOrderModel = SendOrderModel();
  CheckoutApiController checkoutApiController = CheckoutApiController();

  void _getScheduleList(
      ScheduleFetched event, Emitter<CheckoutState> emit) async {
    emit(ScheduleLoading());

    try {
      final datesList = await checkoutApiController.getSchedule();

      emit(ScheduleSuccess(datesList: datesList));
    } catch (e) {
      print(e);
      emit(ScheduleFailure(e.toString()));
    }
  }

  void _getWorkersList(
      WorkersFetched event, Emitter<CheckoutState> emit) async {
    emit(ScheduleLoading());

    try {
      final workersList = await checkoutApiController.getWorkers(
          date: event.date, startTime: event.startTime, endTime: event.endTime);

      emit(WorkersSuccess(workersList: workersList));
    } catch (e) {
      emit(WorkersFailure(e.toString()));
    }
  }
}
