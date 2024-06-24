import 'package:big_like/common_widgets/custom_filed_elevated_btn.dart';
import 'package:big_like/common_widgets/custom_loading_indicator.dart';
import 'package:big_like/constants/consts.dart';
import 'package:big_like/features/auth/blocs/requirements_bloc.dart';
import 'package:big_like/features/auth/presentation/screens/auth_model_screen.dart';
import 'package:big_like/local_storage/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/country_tile.dart';

class CountryScreen extends StatefulWidget {
  const CountryScreen({super.key});

  @override
  State<CountryScreen> createState() => _CountryScreenState();
}

class _CountryScreenState extends State<CountryScreen> {
  int selected = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<RequirementsBloc>().add(RequirementsFetched());
  }

  @override
  Widget build(BuildContext context) {
    // final requirementsBloc = BlocProvider.of<RequirementsBloc>(context);
    final requirementsBloc = context.watch<RequirementsBloc>();

    return ModelScreen(
        screenTitle: '',
        showBackBtn: false,
        bodyWidget: Stack(
          children: [
            Positioned.fill(
              top: 80.h,
              child: BlocConsumer<RequirementsBloc, RequirementsState>(
                listener: (context, state) {
                  // TODO: implement listener
                },
                builder: (context, RequirementsState state) {
                  if (state is RequirementsFailure) {
                    return Center(
                      child: Text(state.error),
                    );
                  }
                  if (state is! RequirementsSuccess) {
                    return const CustomLoadingIndicator();
                  }
                  requirementsBloc.countriesList = state.countriesList;

                  return ListView.separated(
                    itemCount: requirementsBloc.countriesList.length,
                    padding:
                        EdgeInsets.only(left: 15.w, right: 15.w, bottom: 150.h),
                    itemBuilder: (BuildContext context, int index) {
                      return CountryTile(
                        countryModel: requirementsBloc.countriesList[index],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 10.h,
                      );
                    },
                  );
                },
              ),
            ),
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: const BoxDecoration(color: kWhiteColor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'إختيار الدولة',
                        style: TextStyle(
                            fontSize: 20.sp,
                            fontFamily: kFontFamilyName,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        'الرجاء اختيار بلد الإقامة',
                        style: TextStyle(
                            fontSize: 16.sp, fontFamily: kFontFamilyName),
                      ),
                    ],
                  ),
                )),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
                decoration: const BoxDecoration(
                  color: kWhiteColor,
                ),
                child: CustomFiledElevatedBtn(
                  function: requirementsBloc.selectedCountry != null
                      ? () {
                          AppSharedPref().saveCountryId(
                              countryId: requirementsBloc.selectedCountry!.id);
                          Navigator.pushNamed(context, '/lang_screen');
                        }
                      : null,
                  text: 'تم',
                ),
              ),
            )
          ],
        ));
  }
}
