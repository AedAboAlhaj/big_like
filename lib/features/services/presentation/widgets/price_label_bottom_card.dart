import 'package:big_like/features/check_out/bloc/checkout_bloc.dart';
import 'package:big_like/features/check_out/presentation/screens/service_date_and_time_screen.dart';
import 'package:big_like/features/services/domain/models/service_model.dart';
import 'package:big_like/local_storage/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../../../constants/consts.dart';
import '../../../orders/bloc/order_bloc.dart';

class PriceLabelBottomCard extends StatefulWidget {
  const PriceLabelBottomCard({
    super.key,
    required this.option,
  });

  final Options? option;

  @override
  State<PriceLabelBottomCard> createState() => _PriceLabelBottomCardState();
}

class _PriceLabelBottomCardState extends State<PriceLabelBottomCard> {
  late final CheckoutBloc checkoutBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkoutBloc = BlocProvider.of<CheckoutBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 15.h,
      left: 15.w,
      right: 15.w,
      child: InkWell(
        onTap: () async {
          final token = await AppSecureStorage().getToken();
          if (context.mounted) {
            if (token == null) {
              Navigator.pushNamed(context, '/auth_phone_screen');
            } else {
              checkoutBloc.sendOrderModel.options = widget.option;
              showCupertinoModalBottomSheet(
                expand: true,
                bounce: false,
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => const ServiceDateAndTimeScreen(),
              );
            }
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 34.w, vertical: 17.h),
          decoration: BoxDecoration(
              color: kDarkCyanColor, borderRadius: kBorderRadius5),
          child: Row(
            children: [
              Text(
                'التالي',
                style: TextStyle(
                    color: kWhiteColor,
                    fontFamily: kFontFamilyName,
                    fontWeight: FontWeight.bold,
                    fontSize: 17.sp),
              ),
              const Spacer(),
              Text(
                '₪${widget.option != null ? widget.option?.cost : 0}',
                style: TextStyle(
                    color: kWhiteColor,
                    height: 1,
                    fontFamily: kFontFamilyName,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
