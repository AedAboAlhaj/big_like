import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../widgets/method_container.dart';
import 'package:big_like/common_widgets/custom_filed_elevated_btn.dart';
import 'package:big_like/utils/helpers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../../../local_storage/shared_preferences.dart';
import '../../../orders/domain/models/order_api_model.dart';
import '../../bloc/checkout_bloc.dart';
import '../../data/checkout_api_controller.dart';
import '../../domain/models/card_api_model.dart';
import '../screens/cards_screen.dart';
import '../screens/credit_payment_screen.dart';

class SelectPaymentMethod extends StatefulWidget {
  const SelectPaymentMethod({super.key, required this.isProducts});

  final bool isProducts;

  @override
  State<SelectPaymentMethod> createState() => _SelectPaymentMethodState();
}

class _SelectPaymentMethodState extends State<SelectPaymentMethod>
    with Helpers {
  String selectedPaymentMethod = 'cash';
  late final CheckoutBloc checkoutBloc;
  PaymentPortalInfo? _paymentPortalInfo;
  OrderResponse? orderResponse;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkoutBloc = BlocProvider.of<CheckoutBloc>(context);
  }

  num _getTotalPrice() {
    return checkoutBloc.sendOrderModel.options != null
        ? checkoutBloc.sendOrderModel.options!.cost
        : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        MethodContainer(
          title: 'كاش',
          iconUrl: 'assets/images/svgIcons/wallet_icon.svg',
          selected: selectedPaymentMethod == 'cash',
          fun: () {
            selectedPaymentMethod = 'cash';
            setState(() {});
          },
        ),
        SizedBox(
          height: 30.h,
        ),
        MethodContainer(
          title: 'بطاقة',
          iconUrl: 'assets/images/svgIcons/credit_card_icon.svg',
          selected: selectedPaymentMethod == 'visa',
          fun: () {
            selectedPaymentMethod = 'visa';
            setState(() {});
          },
        ),
        const Spacer(),
        Container(
          margin: EdgeInsets.only(bottom: 40.h),
          width: 1.sw,
          child: CustomFiledElevatedBtn(
            text: 'ارسل الطلب',
            function: () async {
              await sendOrder();
            },
          ),
        )
      ],
    );
  }

  final CheckoutApiController _checkoutApiController = CheckoutApiController();

  Future<void> sendOrder() async {
    onLoading(context, () {});
    if (AppSharedPref().orderId == '') {
      checkoutBloc.sendOrderModel.paymentMethod = selectedPaymentMethod;

      if (context.mounted) {
        orderResponse = await _checkoutApiController.sendUserOrders(
            order: checkoutBloc.sendOrderModel,
            isOrderService: !widget.isProducts);
      }

      // String message =
      //     orderId != null ? 'تم ارسال طلبك بنجاج' : 'خطأ, لم يتم ارسال طلبك';
      // if (!(orderId != null)) {
      //   showTopSnackBar(massage: message, error: !(orderId != null));
      // }

      if (orderResponse != null) {
        if (selectedPaymentMethod != 'cash') {
          AppSharedPref().saveOrderId(orderId: orderResponse!.orderId);
          AppSharedPref()
              .saveLastOrderTime(lastOrderTime: orderResponse!.orderTimeDown);
          List<CardApiModel> cards = await _checkoutApiController.getCards();
          if (cards.isEmpty) {
            String? signature = await _checkoutApiController.authCreditPayment(
                phoneNum: '123456',
                total: _getTotalPrice(),
                paymentPortalInfo: _paymentPortalInfo!);
            if (signature != null) {
              if (mounted) {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreditPaymentScreen(
                              signature: signature,
                              paymentPortalInfo: _paymentPortalInfo!,
                              orderResponse: orderResponse!,
                            )));
              }
            }
          } else {
            if (mounted) {
              Navigator.pop(context);
              showCupertinoModalBottomSheet(
                expand: true,
                bounce: false,
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => CardsScreen(
                  cardsList: cards,
                  paymentPortalInfo: _paymentPortalInfo!,
                  orderId: orderResponse!.orderId,
                  amount: _getTotalPrice(),
                ),
              );
            }
          }
        } else {
          if (mounted) {
            Navigator.pop(context);
            checkoutBloc.clearOrder();
            Navigator.pushNamedAndRemoveUntil(
                context, '/thank_you_screen', (route) => false);
          }
        }
      } else {
        if (mounted) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Navigator.pop(context);
            showSnackBar(context,
                massage: 'نأسف لا يمكن الحجز في هاذا الموعد!!', error: true);
          });
        }
      }
    } else {
      if (DateTime.now()
          .isAfter(DateTime.parse(AppSharedPref().lastOrderTime))) {
        _checkoutApiController.deleteOrder(AppSharedPref().orderId);
        AppSharedPref().saveOrderId(orderId: '');
        AppSharedPref().saveLastOrderTime(lastOrderTime: '');
      }
      List<CardApiModel> cards = await _checkoutApiController.getCards();
      if (cards.isEmpty) {
        String? signature = await _checkoutApiController.authCreditPayment(
            phoneNum: '123456',
            total: _getTotalPrice(),
            paymentPortalInfo: _paymentPortalInfo!);
        if (signature != null) {
          if (mounted) {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreditPaymentScreen(
                          signature: signature,
                          paymentPortalInfo: _paymentPortalInfo!,
                          orderResponse: OrderResponse(
                              orderId: AppSharedPref().orderId,
                              orderTimeDown: AppSharedPref().lastOrderTime),
                        )));
          }
        }
      } else {
        if (mounted) {
          Navigator.pop(context);
          showCupertinoModalBottomSheet(
            expand: true,
            bounce: false,
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => CardsScreen(
              cardsList: cards,
              paymentPortalInfo: _paymentPortalInfo!,
              orderId: AppSharedPref().orderId,
              amount: _getTotalPrice(),
            ),
          );
        }
      }
    }
  }
}
