import 'dart:async';
import 'dart:io';
import 'package:big_like/features/achievements/presentation/screens/achievements_screen.dart';
import 'package:big_like/features/home/blocs/app_cubit.dart';
import 'package:big_like/features/worker_times/presentation/screens/worker_times_screen.dart';
import 'package:big_like/local_storage/secure_storage.dart';
import 'package:big_like/local_storage/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../constants/consts.dart';
import '../../../../utils/utils.dart';
import '../../../auth/presentation/screens/auth_phone_number_screen.dart';
import '../../../orders/presentation/screens/orders_screen.dart';
import '../../../settings/presentation/screens/settings_screen.dart';
import '../../../worker_orders/presentation/screens/worker_orders_screen.dart';
import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  static late List<Widget> _widgetOptions;
  late final AppCubit appCubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appCubit = BlocProvider.of<AppCubit>(context);
    if (AppSharedPref().userType != 'worker') {
      _widgetOptions = const <Widget>[
        HomeScreen(),
        OrdersScreen(),
        AchievementsScreen(),
        SettingsScreen()
      ];
    } else {
      _widgetOptions = const <Widget>[
        WorkerOrdersScreen(),
        WorkerTimesScreen(),
        SettingsScreen()
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(0, 60.h),
          child: Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w),
              child: AppBar(
                // elevation: 0,
                iconTheme: IconThemeData(
                    color: Theme.of(context).appBarTheme.backgroundColor,
                    size: 35.h),
                backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                leadingWidth: 0,
                titleSpacing: 0,
                centerTitle: true,
                title: SizedBox(
                  width: 80,
                  child: SvgPicture.asset(
                    'assets/images/app_logo.svg',
                    fit: BoxFit.contain,
                    colorFilter: Utils.svgColor(kPrimaryColor),
                  ),
                ),
              ))),
      body: CupertinoPageScaffold(
        child: BlocBuilder<AppCubit, int>(builder: (context, screenIndex) {
          return _widgetOptions[screenIndex];
        }),
      ),
      bottomNavigationBar: Container(
        height: 105.h,
        clipBehavior: Clip.antiAlias,
        alignment: Alignment.topCenter,
        padding: EdgeInsets.only(top: 9.h),
        decoration: BoxDecoration(
          color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          boxShadow: [
            BoxShadow(
                color:
                    Theme.of(context).textTheme.bodySmall!.color!.withAlpha(10),
                spreadRadius: 4,
                blurRadius: 4)
          ],
        ),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: AppSharedPref().userType != 'worker'
                ? customerNavigationBarIcons(context)
                : workersNavigationBarIcons(context)),
      ),
    );
  }

  List<Widget> workersNavigationBarIcons(BuildContext context) {
    return [
      BottomNavigationBarIcon(
        title: 'طلباتي',
        imageUrl: 'assets/images/svgIcons/orders_icon.svg',
        pageNumber: 0,
        function: () async {
          context
              .read<AppCubit>()
              .updateScreen(screenName: 'WorkerOrdersScreen', screenNum: 0);
        },
        screenText: 'HomeScreen',
      ),
      BottomNavigationBarIcon(
        title: 'دوامي',
        imageUrl: 'assets/images/svgIcons/note_icon.svg',
        pageNumber: 1,
        function: () {
          context
              .read<AppCubit>()
              .updateScreen(screenName: 'WorkerTimesScreen', screenNum: 1);
        },
        screenText: 'OrdersScreen',
      ),
      BottomNavigationBarIcon(
        title: 'الإعدادات',
        imageUrl: 'assets/images/svgIcons/settings_icon.svg',
        pageNumber: 2,
        function: () {
          context
              .read<AppCubit>()
              .updateScreen(screenName: 'SettingsScreen', screenNum: 2);
        },
        screenText: 'SettingsScreen',
      ),
    ];
  }

  List<Widget> customerNavigationBarIcons(BuildContext context) {
    return [
      BottomNavigationBarIcon(
        title: 'الرئيسية',
        imageUrl: 'assets/images/svgIcons/home_icon.svg',
        pageNumber: 0,
        function: () async {
          context
              .read<AppCubit>()
              .updateScreen(screenName: 'HomeScreen', screenNum: 0);
        },
        screenText: 'HomeScreen',
      ),
      BottomNavigationBarIcon(
        title: 'الطلبات',
        imageUrl: 'assets/images/svgIcons/orders_icon.svg',
        pageNumber: 1,
        function: () async {
          final token = await AppSecureStorage().getToken();
          if (context.mounted) {
            if (token == null) {
              showCupertinoModalBottomSheet(
                expand: false,
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => const AuthPhoneNumScreen(),
              );
            } else {
              context
                  .read<AppCubit>()
                  .updateScreen(screenName: 'OrdersScreen', screenNum: 1);
            }
          }
        },
        screenText: 'OrdersScreen',
      ),
      BottomNavigationBarIcon(
        title: 'بروفايل',
        imageUrl: 'assets/images/svgIcons/profile.svg',
        pageNumber: 2,
        screenText: 'AchievementsScreen',
        function: () {
          context
              .read<AppCubit>()
              .updateScreen(screenName: 'AchievementsScreen', screenNum: 2);
        },
      ),
      BottomNavigationBarIcon(
        title: 'الإعدادات',
        imageUrl: 'assets/images/svgIcons/settings_icon.svg',
        pageNumber: 3,
        function: () {
          context
              .read<AppCubit>()
              .updateScreen(screenName: 'SettingsScreen', screenNum: 3);
        },
        screenText: 'SettingsScreen',
      ),
    ];
  }
}

class BottomNavigationBarIcon extends StatefulWidget {
  const BottomNavigationBarIcon(
      {super.key,
      required this.imageUrl,
      required this.title,
      required this.pageNumber,
      required this.screenText,
      required this.function,
      this.animationController});

  final String imageUrl;
  final String title;
  final String screenText;
  final int pageNumber;
  final VoidCallback function;
  final AnimationController? animationController;

  @override
  State<BottomNavigationBarIcon> createState() =>
      _BottomNavigationBarIconState();
}

class _BottomNavigationBarIconState extends State<BottomNavigationBarIcon> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.animationController != null) {
      widget.animationController!.addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.forward) {
          setState(() {
            _isAnimating = true;
          });
        } else {
          setState(() {
            _isAnimating = false;
          });
        }
      });
    }
  }

  bool _isAnimating = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, int>(
      builder: (context, screenIndex) {
        return InkWell(
          onTap: widget.function,
          child: Container(
            height: 78.h,
            width: 73.w,
            decoration: BoxDecoration(
              color: screenIndex == widget.pageNumber
                  ? Theme.of(context).cardColor
                  : null,
              shape: BoxShape.circle,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.animationController != null
                    ? Visibility(
                        visible: !_isAnimating,
                        replacement: RotationTransition(
                          turns: Tween(begin: 0.0, end: 1.0)
                              .animate(widget.animationController!),
                          child: Icon(
                            Icons.refresh,
                            color: kPrimaryColor,
                          ),
                        ),
                        child: SvgPicture.asset(widget.imageUrl,
                            height: 16.h,
                            colorFilter: Utils.svgColor(
                                screenIndex == widget.pageNumber
                                    ? kDarkCyanColor
                                    : Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .color ??
                                        kBlackColor)),
                      )
                    : SvgPicture.asset(
                        widget.imageUrl,
                        height: 16.h,
                        colorFilter: Utils.svgColor(screenIndex ==
                                widget.pageNumber
                            ? kDarkCyanColor
                            : Theme.of(context).textTheme.bodySmall!.color!),
                      ),
                SizedBox(
                  height: 4.h,
                ),
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: screenIndex == widget.pageNumber
                        ? kDarkCyanColor
                        : Theme.of(context).textTheme.bodySmall!.color!,
                    fontWeight: FontWeight.bold,
                    fontFamily: kFontFamilyName,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
