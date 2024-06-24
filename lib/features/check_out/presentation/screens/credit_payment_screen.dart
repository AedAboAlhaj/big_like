import 'dart:async';
import 'package:big_like/features/check_out/data/checkout_api_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import '../../../../constants/consts.dart';
import '../../../../local_storage/shared_preferences.dart';
import '../../../../utils/helpers.dart';
import '../../../orders/domain/models/order_api_model.dart';

class CreditPaymentScreen extends StatefulWidget {
  const CreditPaymentScreen({
    super.key,
    required this.signature,
    required this.orderResponse,
    required this.paymentPortalInfo,
  });

  final String signature;
  final OrderResponse orderResponse;
  final PaymentPortalInfo paymentPortalInfo;

  @override
  State<CreditPaymentScreen> createState() => _CreditPaymentScreenState();
}

class _CreditPaymentScreenState extends State<CreditPaymentScreen>
    with Helpers, WidgetsBindingObserver {
  late final WebViewController _controller;
  double progress = 0;
  late Timer _timer;
  late int _start;
  String _currentUrl = '';

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start <= 0) {
          timer.cancel();
          _ordersApiController.deleteOrder(AppSharedPref().orderId);
          AppSharedPref().saveOrderId(orderId: '');
          AppSharedPref().saveLastOrderTime(lastOrderTime: '');
          showSnackBar(context,
              massage: 'الوقت المتاح للدفع انتهى! حاول مرة اخرى!', error: true);
          Navigator.of(context).pop();
        } else {
          if (_currentUrl.contains('https://icom.yaad.net/p/')) {
            _controller.runJavaScript(
                'var x = document.getElementById("payments-container");  x.style.display = "none";');
          }

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

  int? transId;
  num? amount;
  int? cCode;
  String? token;
  String? idNumber;
  String? last4Numbers;
  String? year;
  String? month;

  // final List<AppLifecycleState> _stateHistoryList = <AppLifecycleState>[];

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) return;
    if (state == AppLifecycleState.detached) {
      _ordersApiController.deleteOrder(AppSharedPref().orderId);
      AppSharedPref().saveOrderId(orderId: '');
      AppSharedPref().saveLastOrderTime(lastOrderTime: '');
    }
    if (state == AppLifecycleState.resumed) {
      if (DateTime.now()
          .isAfter(DateTime.parse(AppSharedPref().lastOrderTime))) {
        _ordersApiController.deleteOrder(AppSharedPref().orderId);
        AppSharedPref().saveOrderId(orderId: '');
        AppSharedPref().saveLastOrderTime(lastOrderTime: '');
        Navigator.pop(context);
      } else {
        _start = DateTime.parse(widget.orderResponse.orderTimeDown)
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
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _start = DateTime.parse(widget.orderResponse.orderTimeDown)
        .difference(DateTime.now())
        .inSeconds;
    startTimer();

    AppSharedPref().saveOrderId(orderId: widget.orderResponse.orderId);
    AppSharedPref()
        .saveLastOrderTime(lastOrderTime: widget.orderResponse.orderTimeDown);
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
    final uri = Uri.parse('https://icom.yaad.net/p/?${widget.signature}');
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      // ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              this.progress = progress / 100;
            });
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
            _controller.runJavaScript(
                'var x = document.getElementById("payments-container");  x.style.display = "none";');
          },
          onNavigationRequest: (NavigationRequest request) async {
            _controller.runJavaScript(
                'var x = document.getElementById("payments-container");  x.style.display = "none";');
            _currentUrl = request.url;

            if (request.url.startsWith('https://www.tlbak.com/err/suc/') ||
                request.url.startsWith('https://www.tlbak.com/err/fail/')) {
              String params = request.url.split('?')[1];

              List<String> resParams = params.split('&');

              for (var element in resParams) {
                if (element.contains('UserId')) {
                  idNumber = element.split('=')[1];
                }
                if (element.contains('CCode')) {
                  cCode ??= int.parse(element.split('=')[1]);
                }
                if (element.contains('Amount')) {
                  amount = num.parse(element.split('=')[1]);
                }
                if (element.contains('Id')) {
                  transId ??= int.parse(element.split('=')[1]);
                }
                if (element.contains('UserId')) {
                  idNumber = element.split('=')[1];
                }
                if (element.contains('Tmonth')) {
                  month = element.split('=')[1];
                }
                if (element.contains('Tyear')) {
                  year = element.split('=')[1];
                }
                if (element.contains('L4digit')) {
                  last4Numbers = element.split('=')[1];
                }
              }

              await storePayment();
              debugPrint('blocking navigation to ${request.url}');
              return NavigationDecision.prevent;
            }
            //todo send date to the backend
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(uri);

    // #enddocregion platform_features

    _controller = controller;
  }

  final CheckoutApiController _ordersApiController = CheckoutApiController();

  Future<void> storePayment() async {
    // try {
    //   _ordersApiController.saveMobileLog(log: _currentUrl);
    // } catch (e) {}

    // onLoading(context, () {});
    if (cCode != null) {
      if (cCode == 0 && transId != null) {
        String? res = await _ordersApiController.getToken(
            transId: transId!, paymentPortalInfo: widget.paymentPortalInfo);
        if (res != null) {
          List<String> resParams = res.split('&');

          for (var element in resParams) {
            if (element.contains('Token')) {
              token = element.split('=')[1];
            }
          }
        }
      }
      SendPaymentApiModel newPayment = SendPaymentApiModel();

      newPayment.orderId = widget.orderResponse.orderId;
      newPayment.amount = amount;
      newPayment.transactionId = transId != null ? transId! : 0;
      newPayment.cCode = cCode != null ? cCode.toString() : '900';
      newPayment.month = month;
      newPayment.year = year;
      newPayment.last4Numbers = last4Numbers;
      newPayment.idNumber = idNumber;
      newPayment.field_1 = 'field_1';
      newPayment.field_2 = 'field_2';
      newPayment.field_3 = 'field_3';
      if (token != null) {
        newPayment.token = token;
      }

      // try {
      //   await _ordersApiController.saveMobileLog(
      //       log: newPayment.toJson().toString());
      // } catch (e) {}
      bool created =
          await _ordersApiController.storePayment(payment: newPayment);

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
        Navigator.pop(context);

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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _ordersApiController.deleteOrder(AppSharedPref().orderId);
        AppSharedPref().saveOrderId(orderId: '');
        AppSharedPref().saveLastOrderTime(lastOrderTime: '');
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                top: 60.h,
                child: Column(
                  children: [
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white,
                      color: kPrimaryColor,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: WebViewWidget(
                          controller: _controller,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      _ordersApiController.deleteOrder(AppSharedPref().orderId);
                      AppSharedPref().saveOrderId(orderId: '');
                      AppSharedPref().saveLastOrderTime(lastOrderTime: '');
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 39,
                      height: 39,
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          shape: BoxShape.circle),
                      child: const Icon(Icons.arrow_back_rounded),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
