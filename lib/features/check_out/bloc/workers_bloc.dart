import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../data/checkout_api_controller.dart';
import '../domain/models/worker_model.dart';

part 'workers_event.dart';

part 'workers_state.dart';

class WorkersBloc extends Bloc<WorkersEvent, WorkersState> {
  WorkersBloc(this.checkoutApiController) : super(WorkersInitial()) {
    on<WorkersFetched>(_getWorkersList);
  }

  CheckoutApiController checkoutApiController = CheckoutApiController();

  void _getWorkersList(WorkersFetched event, Emitter<WorkersState> emit) async {
    emit(WorkersLoading());

    try {
      final workersList = await checkoutApiController.getWorkers(
          date: event.date, startTime: event.time, optionId: event.optionId);

      emit(WorkersSuccess(workersList: workersList));
    } catch (e) {
      emit(WorkersFailure(e.toString()));
    }
  }
}
