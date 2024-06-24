part of 'requirements_bloc.dart';

@immutable
sealed class RequirementsEvent {}

class RequirementsFetched extends RequirementsEvent {}

class CountryListUpdated extends RequirementsEvent {
  late final SupportedCountryModel supportedCountryModel;

  CountryListUpdated({required this.supportedCountryModel});
}

class LangListUpdated extends RequirementsEvent {
  late final SupportedLangModel supportedLangModel;

  LangListUpdated({required this.supportedLangModel});
}
