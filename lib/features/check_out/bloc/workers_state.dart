part of 'workers_bloc.dart';

@immutable
sealed class WorkersState {}

final class WorkersInitial extends WorkersState {}

final class WorkersLoading extends WorkersState {}

final class WorkersSuccess extends WorkersState {
  final List<WorkerModel> workersList;

  WorkersSuccess({required this.workersList});
}

final class WorkersFailure extends WorkersState {
  final String error;

  WorkersFailure(this.error);
}
