part of 'requirements_bloc.dart';

@immutable
sealed class RequirementsState {}

final class RequirementsInitial extends RequirementsState {}

final class RequirementsSuccess extends RequirementsState {
  final List<SupportedCountryModel> countriesList;
  final List<SupportedLangModel> langList;

  RequirementsSuccess({required this.langList, required this.countriesList});
}

final class RequirementsFailure extends RequirementsState {
  final String error;

  RequirementsFailure(this.error);
}

final class RequirementsLoading extends RequirementsState {}
