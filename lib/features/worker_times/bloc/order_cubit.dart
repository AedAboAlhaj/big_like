import 'package:flutter_bloc/flutter_bloc.dart';

class WorkerTimesCubit extends Cubit<int> {
  WorkerTimesCubit() : super(0);

  int selectedOrdersPage = 0;

  void updateScreen({required int screenNum}) {
    selectedOrdersPage = screenNum;
    emit(selectedOrdersPage);
  }
}
