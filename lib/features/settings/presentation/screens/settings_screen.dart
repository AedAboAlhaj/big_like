import 'dart:io';

import 'package:big_like/local_storage/secure_storage.dart';
import 'package:big_like/local_storage/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../common_widgets/shimmer_effect.dart';
import '../../../../constants/consts.dart';
import '../../../../utils/helpers.dart';
import '../../../../utils/utils.dart';
import '../../../auth/presentation/screens/auth_phone_number_screen.dart';
import '../../../home/presentation/screens/main_screen.dart';
import '../../data/settings_api_controller.dart';
import '../../domain/models/company_profile_page_api_model.dart';
import '../widgets/settings_title_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Future<List<CompanyProfilePageApiModel>> _future;
  List<CompanyProfilePageApiModel> _pagesList = [];
  final SettingsApiController _settingsApiController = SettingsApiController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    login();
    _future = _settingsApiController.getCompanyProfilePages();
  }

  late List<ConnectivityResult> _connectivityResult;
  final _errorIndicator = GlobalKey<RefreshIndicatorState>();

  // void _update() async {
  //   if (_errorIndicator.currentState != null) {
  //     _errorIndicator.currentState!.show();
  //   }
  // }

  Future<void> _pullRefresh() async {
    _pagesList = await _settingsApiController.getCompanyProfilePages();
    setState(() {});
  }

  bool _isAuthenticated = false;

  Future<void> login() async {
    AppSecureStorage().getToken().then((value) {
      if (value == null) {
        setState(() {
          _isAuthenticated = false;
        });
      } else {
        setState(() {
          _isAuthenticated = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _pagesList.isEmpty
              ? FutureBuilder(
                  future: Future.wait([
                    _future,
                    (Connectivity().checkConnectivity()),
                    AppSecureStorage().getToken()
                  ]),
                  builder: (context, AsyncSnapshot snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.active:
                      case ConnectionState.waiting:
                        return const ShimmerEffect(
                            content: ComPageSimmerScreen());
                      case ConnectionState.done:
                        if (snapshot.hasData) {
                          _pagesList = snapshot.data[0];

                          _connectivityResult = snapshot.data[1];
                          if (_connectivityResult
                                  .contains(ConnectivityResult.mobile) ||
                              _connectivityResult
                                  .contains(ConnectivityResult.wifi)) {
                            // Utils.checkNetwork(
                            //     context: context, function: _update);
                            return RefreshIndicator(
                                onRefresh: _pullRefresh,
                                key: _errorIndicator,
                                color: kPrimaryColor,
                                child: Container());
                          }
                          return ListView.separated(
                            scrollDirection: Axis.vertical,
                            itemCount: _pagesList.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return CamPagesTitleCard(
                                comProfilePagesModel: _pagesList[index],
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: 10.h,
                              );
                            },
                          );
                        }
                    }
                    return Container();
                  })
              : ListView.separated(
                  scrollDirection: Axis.vertical,
                  itemCount: _pagesList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return CamPagesTitleCard(
                      comProfilePagesModel: _pagesList[index],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 10.h,
                    );
                  },
                ),
          SizedBox(
            height: 10.h,
          ),
          Text('الإعدادات',
              style: TextStyle(
                fontSize: 17.sp,
                color: Theme.of(context).textTheme.bodySmall!.color!,
                fontWeight: FontWeight.w700,
              )),
          SizedBox(
            height: 10.h,
          ),
          /*  Container(
            color: Theme.of(context).cardColor,
            child: ListTile(
              onTap: () {
                Get.changeThemeMode(
                  Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
                );
                AppSharedPref().saveThemeMode(
                  theme: !Get.isDarkMode ? 'lightTheme' : 'darkTheme',
                );
              },
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 32.w, vertical: 0),
              horizontalTitleGap: 0,
              minVerticalPadding: 0,
              tileColor: Theme.of(context).cardColor,
              trailing: Directionality(
                textDirection: TextDirection.ltr,
                child: YakoThemeSwitch(
                  enabled: !Get.isDarkMode,
                  disabledToggleColor: Theme.of(context).primaryColor,
                  enabledBackgroundColor: kWhiteColor,
                  disabledBackgroundColor: kBlackColor,
                  // enabledToggleColor: Theme.of(context).textTheme.bodySmall!.color!,
                  // disabledToggleColor: Theme.of(context).textTheme.bodySmall!.color!,
                  width: 50.w,
                  onChanged: ({bool? changed}) async {
                    Get.changeThemeMode(
                      changed! ? ThemeMode.light : ThemeMode.dark,
                    );
                    AppSharedPref().saveThemeMode(
                      theme: changed ? 'lightTheme' : 'darkTheme',
                    );
                    // Get.changeThemeMode(
                    //     Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
                    // await Get.forceAppUpdate();
                    // Get.changeTheme(
                    //   changed ?? true
                    //       ? MyThemes.lightTheme
                    //       : MyThemes.darkTheme,
                    // );
                  },
                ),
              ),
              leading: Icon(Icons.autorenew_rounded,
                  color: Theme.of(context).textTheme.bodySmall!.color),
              title: Text(
                  Get.isDarkMode
                      ? _translationGetXController.trans['light_mode'] ??
                          'الوضع النهاري'
                      : _translationGetXController.trans['night_mode'] ??
                          'الوضع الليلي',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.bodySmall!.color!,
                  )),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),*/
          Container(
            color: Theme.of(context).cardColor,
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 32.w, vertical: 0),
              horizontalTitleGap: 0,
              minVerticalPadding: 0,
              tileColor: Colors.grey.shade100.withOpacity(.6),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 15,
                color: Theme.of(context).textTheme.bodySmall!.color!,
              ),
              leading: Icon(Icons.language,
                  color: Theme.of(context).textTheme.bodySmall!.color),
              title: Text('اللغة',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  )),
              onTap: () async {
                showLangAlert();
              },
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            color: Theme.of(context).cardColor,
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 32.w, vertical: 0),
              horizontalTitleGap: 0,
              minVerticalPadding: 0,
              tileColor: Colors.grey.shade100.withOpacity(.6),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 15,
                color: Theme.of(context).textTheme.bodySmall!.color!,
              ),
              leading: Icon(Icons.stars,
                  color: Theme.of(context).textTheme.bodySmall!.color),
              title: Text('تقيم التطبيق',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  )),
              onTap: () async {
                // inAppReview.openStoreListing(
                //   appStoreId: '6446030945',
                // );
              },
            ),
          ),
          /*      SizedBox(
            height: 10.h,
          ),
          Visibility(
            visible: _appGetXController.settingsApiModel!.phone != null,
            child: Container(
              color: Theme
                  .of(context)
                  .cardColor,
              child: ListTile(
                contentPadding:
                EdgeInsets.symmetric(horizontal: 32.w, vertical: 0),
                horizontalTitleGap: 0,
                minVerticalPadding: 0,
                tileColor: Colors.grey.shade100.withOpacity(.6),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                  color: Theme
                      .of(context)
                      .textTheme
                      .bodySmall!
                      .color!,
                ),
                leading:
                SvgPicture.asset('assets/images/svgIcons/whatsapp_icon.svg',
                    colorFilter: Utils.svgColor(
                      Theme
                          .of(context)
                          .textTheme
                          .bodySmall!
                          .color!,
                    ),
                    width: 23),
                title: Text(
                    _translationGetXController.trans['whatsapp'] ?? 'واتساب',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    )),
                onTap: () async {
                  Uri url() {
                    if (Platform.isAndroid) {
                      // add the [https]
                      return Uri.parse(
                          "whatsapp://send?phone=${_appGetXController
                              .settingsApiModel!.whatsapp}"); // new line
                    } else {
                      // add the [https]
                      // return Uri.parse(
                      //     "api.whatsapp.com/send?phone=${_appGetXController.settingsApiModel!.whatsapp}"); // new line
                      return Uri.parse(
                          "whatsapp://wa.me/${_appGetXController
                              .settingsApiModel!.whatsapp}/");
                    }
                  }

                  // if (!await canLaunchUrl(url())) {
                  //   showTopSnackBar(
                  //       massage: 'حدث خطأ أثناء فتح تطبيق الواتساب',
                  //       error: true);
                  // } else {
                  try {
                    if (!await launchUrl(url())) {
                      throw 'Could not launch${url().path}';
                    }
                  } catch (e) {
                    showTopSnackBar(
                        massage: _translationGetXController.trans[
                        'can_not_find_whatsapp_app_installed_in_you'] ??
                            'لم يتم عالعثور على تطبيق واتساب لديك',
                        error: true);
                  }

                  // }
                },
              ),
            ),
          ),*/
          Visibility(
            visible: _isAuthenticated,
            child: SizedBox(
              height: 10.h,
            ),
          ),
          Container(
            color: Theme.of(context).cardColor,
            child: Visibility(
              visible: _isAuthenticated,
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 32.w, vertical: 0),
                horizontalTitleGap: 0,
                minVerticalPadding: 0,
                tileColor: Theme.of(context).cardColor,
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                  color: Theme.of(context).textTheme.bodySmall!.color,
                ),
                leading: Icon(Icons.delete,
                    color: Theme.of(context).textTheme.bodySmall!.color),
                title: Text('حذف الحساب',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall!.color!,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    )),
                onTap: () => Helpers.showActionDialog(
                    iconData: Icons.logout_outlined,
                    context: context,
                    btnText: 'حذف الحساب',
                    title: 'حذف الحساب',
                    content: 'هل أنت متاكد من حذف الحساب ؟؟',
                    function: () {
                      AppSecureStorage().deleteToken();

                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MainScreen()),
                          (route) => false);
                    }),
              ),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            color: Theme.of(context).cardColor,
            child: Visibility(
                visible: _isAuthenticated,
                replacement: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 32.w, vertical: 0),
                  horizontalTitleGap: 0,
                  minVerticalPadding: 0,
                  tileColor: Theme.of(context).cardColor,
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                    color: Theme.of(context).textTheme.bodySmall!.color,
                  ),
                  leading: Icon(Icons.login,
                      color: Theme.of(context).textTheme.bodySmall!.color),
                  title: Text(
                    'تسجيل الدخول',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.bodySmall!.color!,
                    ),
                  ),
                  onTap: () {
                    showCupertinoModalBottomSheet(
                      expand: false,
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const AuthPhoneNumScreen(),
                    );
                  },
                ),
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 32.w, vertical: 0),
                  horizontalTitleGap: 0,
                  minVerticalPadding: 0,
                  tileColor: Theme.of(context).cardColor,
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                    color: Theme.of(context).textTheme.bodySmall!.color,
                  ),
                  leading: Icon(Icons.logout,
                      color: Theme.of(context).textTheme.bodySmall!.color),
                  title: Text(
                    'تسجيل الخروج',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall!.color!,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () => Helpers.showActionDialog(
                      iconData: Icons.logout_outlined,
                      context: context,
                      btnText: 'تسجيل الخروج',
                      title: ' تسجيل الخروج',
                      content: 'هل انت متاكد انك تريد تسجيل الخروج؟',
                      function: () {
                        AppSecureStorage().clean();
                        AppSharedPref().clear();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainScreen()),
                            (route) => false);
                      }),
                )),
          ),
        ],
      ),
    );
  }

  void showLangAlert() {
    // _language = Get.locale?.languageCode ?? 'ar';
    showModalBottomSheet(
        context: context,
        clipBehavior: Clip.antiAlias,
        useRootNavigator: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r)),
        ),
        builder: (context) {
          return BottomSheet(
              onClosing: () {},
              enableDrag: false,
              builder: (context) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    return Container(
                      height: 400.h,
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: Column(
                        children: [
                          Text(
                            'اللغة',
                            style: TextStyle(
                              fontSize: 18.sp,
                              color:
                                  Theme.of(context).textTheme.bodySmall?.color,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          ListView.separated(
                            itemCount: 1,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 0),
                                horizontalTitleGap: 0,
                                minVerticalPadding: 0,
                                tileColor: Theme.of(context).cardColor,
                                /*   title: RadioListTile(
                                  title: Text(
                                      AppSharedPref().localeList[index] == 'ar'
                                          ? "العربية"
                                          : AppSharedPref().localeList[index] ==
                                          'en'
                                          ? 'English'
                                          : 'עברית',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.color,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  value: AppSharedPref().localeList[index],
                                  groupValue: _language,
                                  onChanged: (String? value) async {
                                    if (value != null) {
                                      setState(() {
                                        _language = value;

                                        // changeLanguageCodeSettings(context, _language);
                                      });
                                      // await context.setLocale(Locale(_language));
                                      _translationGetXController.trans.clear();
                                      Get.updateLocale(Locale(_language));
                                      AppSharedPref()
                                          .saveAppLocale(appLocale: _language);
                                      Navigator.pushNamedAndRemoveUntil(
                                          context, '/', (route) => false);
                                      // Navigator.pushAndRemoveUntil(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => const MainScreen()),
                                      //     (route) => false);
                                    }
                                  },
                                  activeColor: Theme.of(context).primaryColor,
                                ),*/
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(
                                height: 20.h,
                              );
                            },
                          ),
                          /*      ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 0),
                            horizontalTitleGap: 0,
                            minVerticalPadding: 0,
                            tileColor: Theme.of(context).cardColor,
                            title: RadioListTile(
                              title: Text('English',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                  )),
                              value: 'en',
                              groupValue: _language,
                              onChanged: (String? value) async {
                                if (value != null) {
                                  setState(() {
                                    _language = value;

                                    // changeLanguageCodeSettings(context, _language);
                                  });
                                  // await context.setLocale(Locale(_language));
                                  _translationGetXController.trans.clear();
                                  Get.updateLocale(Locale(_language));
                                  AppSharedPref()
                                      .saveAppLocale(appLocale: _language);
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, '/', (route) => false);
                                  // Navigator.pushAndRemoveUntil(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => const MainScreen()),
                                  //     (route) => false);
                                }
                              },
                              activeColor: Theme.of(context).primaryColor,
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 0),
                            horizontalTitleGap: 0,
                            minVerticalPadding: 0,
                            tileColor: Theme.of(context).cardColor,
                            title: RadioListTile(
                              title: Text('עִברִית',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                  )),
                              value: 'he',
                              groupValue: _language,
                              onChanged: (String? value) async {
                                if (value != null) {
                                  setState(() {
                                    _language = value;

                                    // changeLanguageCodeSettings(context, _language);
                                  });
                                  // await context.setLocale(Locale(_language));
                                  _translationGetXController.trans.clear();
                                  Get.updateLocale(Locale(_language));

                                  AppSharedPref()
                                      .saveAppLocale(appLocale: _language);
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, '/', (route) => false);
                                  // Navigator.pushAndRemoveUntil(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => const MainScreen()),
                                  //     (route) => false);
                                }
                              },
                              activeColor: Theme.of(context).primaryColor,
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 0),
                            horizontalTitleGap: 0,
                            minVerticalPadding: 0,
                            tileColor: Theme.of(context).cardColor,
                            title: RadioListTile(
                              title: Text(
                                'العربية',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              value: 'ar',
                              groupValue: _language,
                              activeColor: Theme.of(context).primaryColor,
                              onChanged: (String? value) async {
                                if (value != null) {
                                  setState(() {
                                    _language = value;

                                    // changeLanguageCodeSettings(context, _language);
                                  });
                                  _translationGetXController.trans.clear();
                                  Get.updateLocale(Locale(_language));
                                  AppSharedPref()
                                      .saveAppLocale(appLocale: _language);
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, '/', (route) => false);
                                  // Navigator.pushAndRemoveUntil(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => const MainScreen()),
                                  //     (route) => false);
                                }
                              },
                            ),
                          ),*/
                          const Spacer()
                        ],
                      ),
                    );
                  },
                );
              });
        });
  }
}
