import 'package:big_like/constants/theme_provider.dart';
import 'package:big_like/features/auth/blocs/requirements_bloc.dart';
import 'package:big_like/features/auth/data/requirements_api_controller.dart';
import 'package:big_like/features/auth/presentation/screens/auth_phone_number_screen.dart';
import 'package:big_like/features/auth/presentation/screens/country_screen.dart';
import 'package:big_like/features/auth/presentation/screens/enter_otp_screen.dart';
import 'package:big_like/features/auth/presentation/screens/register_screen.dart';
import 'package:big_like/features/check_out/bloc/checkout_bloc.dart';
import 'package:big_like/features/check_out/data/checkout_api_controller.dart';
import 'package:big_like/features/check_out/presentation/screens/thanks_screen.dart';
import 'package:big_like/features/home/blocs/app_cubit.dart';
import 'package:big_like/features/orders/bloc/order_bloc.dart';
import 'package:big_like/features/orders/data/orders_api_controller.dart';
import 'package:big_like/features/services/data/services_api_controller.dart';
import 'package:big_like/local_storage/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'features/auth/presentation/screens/lang_screen.dart';
import 'features/home/presentation/screens/main_screen.dart';
import 'features/orders/bloc/order_cubit.dart';
import 'features/services/bloc/services_bloc.dart';
import 'local_storage/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSecureStorage().initSecureStorage();
  await AppSharedPref().initSharedPreferences();

/*
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FbNotifications.initNotifications();
  final RemoteMessage? message =
      await FbNotifications.firebaseMessaging.getInitialMessage();

  await DbProvider().initDatabase();*/
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<RequirementsApiController>(
            create: (context) => RequirementsApiController()),
        RepositoryProvider<ServicesApiController>(
            create: (context) => ServicesApiController()),
        RepositoryProvider<CheckoutApiController>(
            create: (context) => CheckoutApiController()),
        RepositoryProvider<OrdersApiController>(
            create: (context) => OrdersApiController()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<RequirementsBloc>(
              create: (context) =>
                  RequirementsBloc(context.read<RequirementsApiController>())),
          BlocProvider<ServicesBloc>(
              create: (context) =>
                  ServicesBloc(context.read<ServicesApiController>())),
          BlocProvider<OrderBloc>(
              create: (context) =>
                  OrderBloc(context.read<OrdersApiController>())),
          BlocProvider<CheckoutBloc>(
              create: (context) =>
                  CheckoutBloc(context.read<CheckoutApiController>())),
          BlocProvider(create: (_) => AppCubit()),
          BlocProvider(create: (_) => OrderCubit()),
        ],
        child: ScreenUtilInit(
            designSize: const Size(428, 926),
            builder: (context, child) {
              return MaterialApp(
                localizationsDelegates: const [
                  GlobalCupertinoLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                debugShowCheckedModeBanner: false,
                themeMode: ThemeMode.system,
                theme: MyThemes.lightTheme,
                // supportedLocales: [
                //   Locale(AppSharedPref().languageLocale ?? 'ar'),
                //   // OR Locale('ar', 'AE') OR Other RTL locales
                // ],

                locale: Locale(AppSharedPref().languageLocale ?? 'ar'),
                initialRoute: AppSharedPref().countryId != null &&
                        AppSharedPref().languageLocale != null
                    ? '/'
                    : '/country_screen',
                onGenerateRoute: (RouteSettings settings) {
                  switch (Uri.parse(settings.name ?? "").path) {
                    case '/':
                      return MaterialWithModalsPageRoute(
                          builder: (_) {
                            return const MainScreen();
                          },
                          settings: settings);
                    case '/thank_you_screen':
                      return MaterialWithModalsPageRoute(
                          builder: (_) => const ThanksScreen(),
                          settings: settings);
                    case '/lang_screen':
                      return MaterialWithModalsPageRoute(
                          builder: (_) => const LangScreen(),
                          settings: settings);
                    case '/country_screen':
                      return MaterialWithModalsPageRoute(
                          builder: (_) => const CountryScreen(),
                          settings: settings);
                    case '/auth_phone_screen':
                      return MaterialWithModalsPageRoute(
                          builder: (_) => const AuthPhoneNumScreen(),
                          settings: settings);

                    /*     case '/':
                  return MaterialWithModalsPageRoute(
                      builder: (_) => const LunchScreen(), settings: settings);
            */
                  }
                  return null;
                },
                // routerConfig: AppRouter.router,
              );
            }),
      ),
    );
  }
}
