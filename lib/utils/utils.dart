import 'dart:io';
import 'package:big_like/constants/consts.dart';
import 'package:big_like/features/check_out/domain/models/date_model.dart';
import 'package:big_like/local_storage/shared_preferences.dart';
import 'package:big_like/utils/helpers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class Utils {
  static ColorFilter svgColor(Color color) {
    return ColorFilter.mode(color, BlendMode.srcIn);
  }

  static TimeOfDay stringToTimeOfDay(String time) {
    // Parse the time from the string
    DateFormat format = DateFormat.Hm(); // for 24 hour format
    // DateFormat format = DateFormat('h:mm a'); // for 12 hour format
    DateTime dateTime = format.parse(time);

    // Convert it to TimeOfDay
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }

  static String formatDateString(String dateString) {
    // Parse the string date
    DateTime dateTime = DateTime.parse(dateString);

    // Format the date to 'EEEE, MMMM d, yyyy' format
    DateFormat formatter =
        DateFormat('EEEE, MMMM d', AppSharedPref().languageLocale ?? 'en');
    return formatter.format(dateTime);
  }

  static String formatDateTime(DateTime? dt) {
    // Format the DateTime object into MM.DD.YY format
    return dt != null ? DateFormat('MM.dd.yy\nhh:mm').format(dt) : '';
  }

  static Future<void> checkNetwork(
      {required BuildContext context, required VoidCallback function}) async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      try {
        InternetAddress.lookup(appUrl);
        // if (connectivityResult.isNotEmpty && connectivityResult[0].rawAddress.isNotEmpty) {
        //   print('connected');
        // }
      } on SocketException catch (_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            behavior: SnackBarBehavior.fixed,
            duration: const Duration(seconds: 1),
            content: Row(
              children: [
                Text(
                  'تحقق من الاتصال بالانترنت',
                  style: TextStyle(
                      color: kWhiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp),
                ),
                const Spacer(),
                const Icon(
                  Icons.cancel_outlined,
                  color: Colors.white,
                  size: 30,
                )
              ],
            ),
            backgroundColor: kBlackColor,
          ));
        }
      }
      function();
    } else if (connectivityResult.contains(ConnectivityResult.none)) {
      if (context.mounted) {
        Helpers.showActionDialog(
            context: context,
            iconData: Icons.wifi_off_sharp,
            title: 'لا يوجد اتصال بالانترنت',
            content: 'راجاءا تحقق من الاتصال بالانترنت ثم اعد المحاولة',
            btnText: 'فحص الاتصال',
            barrierDismissible: false,
            function: () async {
              var connectivityResult =
                  await (Connectivity().checkConnectivity());

              if (connectivityResult.contains(ConnectivityResult.mobile) ||
                  connectivityResult.contains(ConnectivityResult.wifi)) {
                if (context.mounted) {
                  Navigator.pop(context);
                }
                function();
              } else if (connectivityResult
                  .contains(ConnectivityResult.none)) {}
            });
      }
    }
  }
}
