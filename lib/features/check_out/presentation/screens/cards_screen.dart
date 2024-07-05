import 'dart:async';
import 'package:big_like/features/check_out/data/checkout_api_controller.dart';
import 'package:big_like/local_storage/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../common_widgets/custom_filed_elevated_btn.dart';
import '../../../../local_storage/shared_preferences.dart';
import '../../../../utils/helpers.dart';
import '../../../auth/presentation/screens/auth_model_screen.dart';
import '../../../orders/domain/models/order_api_model.dart';
import '../../domain/models/card_api_model.dart';
import '../widgets/credit_card.dart';
import 'credit_payment_screen.dart';

class CardsScreen extends StatefulWidget {
  const CardsScreen(
      {super.key,
      required this.cardsList,
      required this.amount,
      required this.orderId,
      required this.paymentPortalInfo});

  final List<CardApiModel> cardsList;
  final num amount;
  final String orderId;
  final PaymentPortalInfo paymentPortalInfo;

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen>
    with Helpers, WidgetsBindingObserver {
  late Timer _timer;
  late int _start;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start <= 0) {
          timer.cancel();
          _checkoutApiController.deleteOrder(AppSharedPref().orderId);
          AppSharedPref().saveOrderId(orderId: '');
          AppSharedPref().saveLastOrderTime(lastOrderTime: '');
          showSnackBar(context,
              massage: 'انتهى وقت الجلسة!, تم الغاء الطلب', error: true);
          Navigator.of(context).pop();
        } else {
          // setState(() {
          _start--;
          // });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) return;
    if (state == AppLifecycleState.detached) {
      _checkoutApiController.deleteOrder(AppSharedPref().orderId);
      AppSharedPref().saveOrderId(orderId: '');
      AppSharedPref().saveLastOrderTime(lastOrderTime: '');
    }
    if (state == AppLifecycleState.resumed) {
      if (DateTime.now()
          .isAfter(DateTime.parse(AppSharedPref().lastOrderTime))) {
        _checkoutApiController.deleteOrder(AppSharedPref().orderId);
        AppSharedPref().saveOrderId(orderId: '');
        AppSharedPref().saveLastOrderTime(lastOrderTime: '');
        Navigator.pop(context);
      } else {
        _start = DateTime.parse(AppSharedPref().lastOrderTime)
            .difference(DateTime.now())
            .inSeconds;
        startTimer();
      }
    }

    // setState(() {
    //   _stateHistoryList.add(state);
    // });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    try {
      _start = DateTime.parse(AppSharedPref().lastOrderTime)
          .difference(DateTime.now())
          .inSeconds;
    } catch (e) {
      _start = 0;
    }

    startTimer();
  }

  final CheckoutApiController _checkoutApiController = CheckoutApiController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _checkoutApiController.deleteOrder(AppSharedPref().orderId);
        AppSharedPref().saveOrderId(orderId: '');
        AppSharedPref().saveLastOrderTime(lastOrderTime: '');
        return true;
      },
      child: ModelScreen(
        screenTitle: 'البطاقات',
        backFunction: () {
          _checkoutApiController.deleteOrder(AppSharedPref().orderId);
          AppSharedPref().saveOrderId(orderId: '');
          AppSharedPref().saveLastOrderTime(lastOrderTime: '');
        },
        bodyWidget: Column(
          children: [
            Text('اختر البطاقة الملائمة او اضف بطاقة جديدة للدفع',
                style: TextStyle(fontSize: 16.sp)),
            Expanded(
              child: ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                itemBuilder: (context, index) {
                  return CreditCard(
                    cardApiModel: widget.cardsList[index],
                    orderId: widget.orderId,
                    amount: widget.amount,
                    paymentPortalInfo: widget.paymentPortalInfo,
                    deleteFunction: () {
                      _checkoutApiController
                          .deleteCard(widget.cardsList[index].id.toString());
                      widget.cardsList.removeAt(index);
                      setState(() {
                        widget.cardsList;
                      });
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 15,
                  );
                },
                itemCount: widget.cardsList.length,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: SizedBox(
                  width: double.infinity,
                  child: CustomFiledElevatedBtn(
                      text: 'الدفع ببطاقة جديدة',
                      function: () async {
                        onLoading(context, () {});
                        final phone = await AppSecureStorage().getPhone();
                        String? signature =
                            await _checkoutApiController.authCreditPayment(
                                phoneNum: phone,
                                total: widget.amount,
                                paymentPortalInfo: widget.paymentPortalInfo);
                        if (signature != null) {
                          if (context.mounted) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CreditPaymentScreen(
                                          signature: signature,
                                          paymentPortalInfo:
                                              widget.paymentPortalInfo,
                                          orderResponse: OrderResponse(
                                              orderId: AppSharedPref().orderId,
                                              orderTimeDown: AppSharedPref()
                                                  .lastOrderTime),
                                        )));
                          }
                        }
                      })),
            ),
          ],
        ),
      ),
    );
  }
}
