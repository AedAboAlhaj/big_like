import 'package:big_like/features/worker_times/domain/models/work_times_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkTimesCubit extends Cubit<List<WorkTimesModel>> {
  WorkTimesCubit() : super([]);

  void addWorkTime(WorkTimesModel workTime) {
    emit([...state, workTime]);
  }

  void removeWorkTime(WorkTimesModel workTime) {
    state.remove(workTime);
    emit(List.from(state)); // Emit a new state with updated list
  }

  List<WorkTimesModel> getList() {
    return List.from(state); // Return a copy of the list
  }

  List<WorkTimesModel> getTimesList(int dayNum) {
    List<WorkTimesModel> list = state
        .where(
          (element) => element.dayNum == dayNum,
        )
        .toList();

    return list; // Return a copy of the list
  }

  void updateStartTime(int index, TimeOfDay startTime) {
    state[index].startTime = startTime;
    emit(List.from(state)); // Emit a new state with updated list
  }

  void updateEndTime(int index, TimeOfDay endTime) {
    state[index].endTime = endTime;
    emit(List.from(state)); // Emit a new state with updated list
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    // TODO: implement onError
    super.onError(error, stackTrace);
    debugPrint(error.toString());
  }
}
