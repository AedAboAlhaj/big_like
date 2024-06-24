import 'package:big_like/features/auth/data/requirements_api_controller.dart';
import 'package:big_like/features/auth/domain/models/suported_country_model.dart';
import 'package:big_like/features/auth/domain/models/suported_lang_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'requirements_event.dart';

part 'requirements_state.dart';

class RequirementsBloc extends Bloc<RequirementsEvent, RequirementsState> {
  RequirementsBloc(this.requirementsApiController)
      : super(RequirementsInitial()) {
    on<RequirementsFetched>(_getCountriesList);
    on<CountryListUpdated>(_getUpdateCountriesList);
    on<LangListUpdated>(_getUpdateLangList);
  }

  final RequirementsApiController requirementsApiController;
  late List<SupportedCountryModel> countriesList;
  late List<SupportedLangModel> langList;
  SupportedCountryModel? selectedCountry;
  SupportedLangModel? selectedLang;

  void _getUpdateCountriesList(
      CountryListUpdated event, Emitter<RequirementsState> emit) async {
    for (var element in countriesList) {
      element.isSelected = false;
    }
    event.supportedCountryModel.isSelected =
        !event.supportedCountryModel.isSelected;
    selectedCountry = event.supportedCountryModel.isSelected
        ? event.supportedCountryModel
        : null;
    emit(RequirementsSuccess(countriesList: countriesList, langList: langList));
  }

  void _getUpdateLangList(
      LangListUpdated event, Emitter<RequirementsState> emit) async {
    for (var element in langList) {
      element.isSelected = false;
    }
    event.supportedLangModel.isSelected = !event.supportedLangModel.isSelected;
    selectedLang =
        event.supportedLangModel.isSelected ? event.supportedLangModel : null;
    emit(RequirementsSuccess(countriesList: countriesList, langList: langList));
  }

  void _getCountriesList(
      RequirementsFetched event, Emitter<RequirementsState> emit) async {
    emit(RequirementsLoading());
    try {
      langList = await requirementsApiController.getSupportedLang();
      countriesList = await requirementsApiController.getSupportedCountries();
      emit(RequirementsSuccess(
          countriesList: countriesList, langList: langList));
    } catch (e) {
      emit(RequirementsFailure(e.toString()));
    }
  }
}
