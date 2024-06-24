import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_state.dart';

class AppCubit extends Cubit<int> {
  AppCubit() : super(0);

  // String screenText = 'HomeScreen';
  int screenIndex = 0;

  void updateScreen({required String screenName, required int screenNum}) {
    screenIndex = screenNum;
    emit(screenIndex);
  }
}
