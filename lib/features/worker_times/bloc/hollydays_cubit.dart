import 'package:big_like/features/worker_times/domain/models/work_times_model.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HollyDaysCubit extends Cubit<List<HollyDaysModel>> {
  HollyDaysCubit() : super([]);

  void addHollyDay(HollyDaysModel hollyDayModel) {
    emit([...state, hollyDayModel]);
  }

  void removeHollyDay(HollyDaysModel hollyDayModel) {
    state.remove(hollyDayModel);
    emit(List.from(state)); // Emit a new state with updated list
  }

  List<HollyDaysModel> getList() {
    return List.from(state); // Return a copy of the list
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    // TODO: implement onError
    super.onError(error, stackTrace);
    debugPrint(error.toString());
  }
}
