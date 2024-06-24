import 'package:big_like/common_widgets/custom_filed_elevated_btn.dart';
import 'package:big_like/constants/consts.dart';
import 'package:big_like/features/auth/presentation/screens/auth_model_screen.dart';
import 'package:big_like/features/auth/presentation/widgets/lang_tile.dart';
import 'package:big_like/local_storage/secure_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common_widgets/custom_loading_indicator.dart';
import '../../../../local_storage/shared_preferences.dart';
import '../../blocs/requirements_bloc.dart';

class LangScreen extends StatefulWidget {
  const LangScreen({super.key});

  @override
  State<LangScreen> createState() => _LangScreenState();
}

class _LangScreenState extends State<LangScreen> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    // final requirementsBloc = BlocProvider.of<RequirementsBloc>(context);
    final requirementsBloc = context.watch<RequirementsBloc>();

    return ModelScreen(
        screenTitle: 'select lang',
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
                  requirementsBloc.langList = state.langList;

                  return ListView.separated(
                    itemCount: requirementsBloc.langList.length,
                    padding:
                        EdgeInsets.only(bottom: 100.h, left: 15.w, right: 15.w),
                    itemBuilder: (BuildContext context, int index) {
                      return LangTile(
                        langModel: requirementsBloc.langList[index],
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
                        'إختيار اللغة',
                        style: TextStyle(
                            fontSize: 20.sp,
                            fontFamily: kFontFamilyName,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        'الرجاء اختيار لغة التطبيق',
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
                  function: requirementsBloc.selectedLang != null
                      ? () {
                          AppSharedPref().saveLanguageLocale(
                              languageLocale:
                                  requirementsBloc.selectedLang!.locale);

                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/',
                            (route) => false,
                          );
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
