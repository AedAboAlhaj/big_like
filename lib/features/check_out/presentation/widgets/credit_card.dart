import 'package:big_like/features/check_out/data/checkout_api_controller.dart';
import 'package:flutter/material.dart';
import '../../../../constants/consts.dart';
import '../../../../local_storage/shared_preferences.dart';
import '../../../../utils/helpers.dart';
import '../../../../utils/utils.dart';
import '../../../orders/domain/models/order_api_model.dart';
import '../../domain/models/card_api_model.dart';

class CreditCard extends StatefulWidget {
  const CreditCard(
      {super.key,
      required this.cardApiModel,
      required this.amount,
      required this.orderId,
      required this.paymentPortalInfo,
      required this.deleteFunction});

  final CardApiModel cardApiModel;
  final num amount;
  final String orderId;
  final PaymentPortalInfo paymentPortalInfo;
  final VoidCallback deleteFunction;

  @override
  State<CreditCard> createState() => _CreditCardState();
}

final CheckoutApiController _checkoutApiController = CheckoutApiController();

class _CreditCardState extends State<CreditCard> with Helpers {
  int? transId;
  int? cCode;
  num? amount;

  String displayIdNum(String id) {
    if (id.length >= 4) {
      return '${id[0]}${id[1]}*****${id[id.length - 1]}${id[id.length - 2]}';
    } else {
      return id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Helpers.showActionDialog(
            context: context,
            iconData: Icons.payment,
            title: 'تأكيد العملية',
            content:
                '${'هل انت متأكد من الدفع بالبطاقة التي تنتهي ب'}${widget.cardApiModel.last_4Numbers}',
            btnText: 'تأكيد العملية',
            function: () async {
              Utils.checkNetwork(
                context: context,
                function: () async {
                  onLoading(context, () {});
                  String? res = await _checkoutApiController.tokenPayment(
                      total: widget.amount,
                      paymentPortalInfo: widget.paymentPortalInfo,
                      cardApiModel: widget.cardApiModel);
                  if (res != null) {
                    List<String> resParams = res.split('&');

                    for (var element in resParams) {
                      if (element.contains('CCode')) {
                        cCode ??= int.parse(element.split('=')[1]);
                      }
                      if (element.contains('Amount')) {
                        amount = num.parse(element.split('=')[1]);
                      }
                      if (element.contains('Id')) {
                        transId ??= int.parse(element.split('=')[1]);
                      }
                    }

                    await storePayment();
                  } else {
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                    String message = 'خطأ, لم يتم ارسال طلبك';
                    showSnackBar(context, massage: message, error: true);
                  }
                },
              );
            });
      },
      child: Container(
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: kBorderRadius,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/images/chip.png',
                    height: 50,
                  ),
                ],
              ),
              const Text('Card Number'),
              Text(
                '.... .... ....${widget.cardApiModel.last_4Numbers}',
                style: const TextStyle(
                    color: kWhiteColor, fontSize: 40, height: 1),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text('Valid Thur'),
              const SizedBox(
                height: 5,
              ),
              Text(
                '${widget.cardApiModel.month}/${widget.cardApiModel.year}',
                style: const TextStyle(color: kWhiteColor),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Helpers.showActionDialog(
                          context: context,
                          iconData: Icons.delete,
                          title: 'حذف البطاقة',
                          content: 'هل انت متأكد من حذف البطاقة؟',
                          btnText: 'حذف',
                          function: widget.deleteFunction);
                    },
                    child: const SizedBox(
                        height: 40,
                        width: 40,
                        child: Icon(
                          Icons.delete,
                          size: 30,
                          color: kRedColor,
                        )),
                  ),
                  Text(
                    displayIdNum(widget.cardApiModel.idNumber),
                    style: const TextStyle(color: kWhiteColor),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> storePayment() async {
    // onLoading(context, () {});
    if (cCode != null) {
      SendPaymentApiModel newPayment = SendPaymentApiModel();
      newPayment.orderId = widget.orderId;
      newPayment.amount = amount;
      newPayment.transactionId = transId != null ? transId! : 0;
      newPayment.cCode = cCode != null ? cCode.toString() : '900';
      newPayment.month = widget.cardApiModel.month;
      newPayment.year = widget.cardApiModel.year;
      newPayment.last4Numbers = widget.cardApiModel.last_4Numbers;
      newPayment.idNumber = widget.cardApiModel.idNumber;
      newPayment.field_1 = 'field_1';
      newPayment.field_2 = 'field_2';
      newPayment.field_3 = 'field_3';
      newPayment.token = widget.cardApiModel.cardToken;
      // await _checkoutApiController.saveMobileLog(
      //     log: newPayment.toJson().toString());

      bool created =
          await _checkoutApiController.storePayment(payment: newPayment);

      if (created) {
        if (cCode != 0) {
          if (context.mounted) {
            Navigator.pop(context);
          }

          showSnackBar(context,
              massage: ' ${'خطئ في عملية التحويل'} $cCode', error: true);
        } else {
          AppSharedPref().saveOrderId(orderId: '');
          AppSharedPref().saveLastOrderTime(lastOrderTime: '');

          if (mounted) {
            // Navigator.pop(context);
            Navigator.pushNamedAndRemoveUntil(
                context, '/thank_you_screen', (route) => false);
          }
        }
      } else {
        if (context.mounted) {
          Navigator.pop(context);
        }
        String message = created
            ? 'تم ارسال طلبك بنجاج'
            : 'خطأ في السيرفر, لم يتم ارسال طلبك';
        showSnackBar(context, massage: message, error: !created);
      }
    } else {
      Navigator.pop(context);
      String message = 'خطأ, لم يتم ارسال طلبك';
      showSnackBar(context, massage: message, error: true);
    }
  }
}
