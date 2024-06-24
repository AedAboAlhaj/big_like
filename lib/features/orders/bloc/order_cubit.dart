import 'package:flutter_bloc/flutter_bloc.dart';

class OrderCubit extends Cubit<int> {
  OrderCubit() : super(0);

  int selectedOrdersPage = 0;

  void updateScreen({required int screenNum}) {
    selectedOrdersPage = screenNum;
    emit(selectedOrdersPage);
  }
}
