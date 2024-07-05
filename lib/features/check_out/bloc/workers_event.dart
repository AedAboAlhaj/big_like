part of 'workers_bloc.dart';

@immutable
sealed class WorkersEvent {}

final class WorkersFetched extends WorkersEvent {
  WorkersFetched({
    required this.date,
    required this.time,
    required this.optionId,
  });

  final String date;
  final String time;
  final int optionId;
}
