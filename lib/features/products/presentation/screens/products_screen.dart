import 'package:big_like/features/products/bloc/cart_cubit.dart';
import 'package:big_like/features/products/domain/models/products_api_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

import '../../../../common_widgets/custom_filed_elevated_btn.dart';
import '../../../../common_widgets/shimmer_effect.dart';
import '../../../../constants/consts.dart';
import '../../../../utils/helpers.dart';
import '../../../auth/presentation/screens/auth_model_screen.dart';
import '../../../check_out/bloc/checkout_bloc.dart';
import '../../../check_out/presentation/screens/order_details_screen.dart';
import '../../data/products_api_controller.dart';
import '../widgets/product_card.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key, this.query = '', this.barcode = false});

  final String query;
  final bool barcode;

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> with Helpers {
  late TextEditingController _searchEditingController;
  String query = '';
  List<ProductApiModel> resultsProducts = [];
  late Future<List<ProductApiModel>> _futureResultsProducts;
  late final CartCubit cartCubit;

  @override
  void initState() {
    // TODO: implement initState
    query = widget.query;
    super.initState();
    checkoutBloc = BlocProvider.of<CheckoutBloc>(context);
    cartCubit = BlocProvider.of<CartCubit>(context);

    _searchEditingController = TextEditingController(text: query);
    _futureResultsProducts = _productsApiController.getProducts();
  }

  final ProductsApiController _productsApiController = ProductsApiController();
  late final CheckoutBloc checkoutBloc;

  @override
  void dispose() {
    // TODO: implement dispose
    _searchEditingController.dispose();
    super.dispose();
  }

  Future searchProduct(String query) async {
    Future.delayed(const Duration(seconds: 1), () async {
      setState(() {
        this.query = query;
        // resultsProducts = products;
      });
    });
  }

  ///bar code///

  String _scanBarcode = '';

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'الغاء',
        true,
        ScanMode.BARCODE,
      );
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
      showSnackBar(context,
          massage: 'تاكد من قراءة الكود بطريقة صحيحة', error: true);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    // setState(() {
    _scanBarcode = barcodeScanRes;
    // });

    if (_scanBarcode != '-1') {
      search(_scanBarcode);
    }
  }

  Future<void> search(String code) async {
    onLoading(context, () {});
    List<ProductApiModel> list = [];

    list = await _productsApiController.getProducts();

    if (context.mounted) {
      Navigator.pop(context);
    }
    if (list.isEmpty) {
      showSnackBar(context, massage: 'لم يتم التعرف على المنتج', error: true);
    } else {
      if (context.mounted) {
        // showCupertinoModalBottomSheet(
        //   expand: true,
        //   bounce: false,
        //   context: context,
        //   backgroundColor: Colors.transparent,
        //   builder: (context) => ProductScreen(
        //       product: list.first,
        //       sectionId: list.first.sectionsIds.isNotEmpty
        //           ? list.first.sectionsIds.first
        //           : -1),
        // );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // if (query.isNotEmpty) {
    //   _futureResultsProducts = _productsApiController.getProducts();
    // }

    return ModelScreen(
        screenTitle: 'البحث',
        bodyWidget: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            Positioned(
              right: 0,
              left: 0,
              top: 0,
              child: Hero(
                transitionOnUserGestures: true,
                tag: 'search_bar',
                child: Material(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Stack(
                      children: [
                        InkWell(
                          onTap: () => scanBarcodeNormal(),
                          child: Container(
                            height: 55.h,
                            padding: EdgeInsets.symmetric(horizontal: 21.w),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: kBorderRadius5,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/svgIcons/qrScan_icon.svg',
                                  height: 22.h,
                                ),
                                SvgPicture.asset(
                                  'assets/images/svgIcons/qrScan_icon.svg',
                                  height: 22.h,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 55.h,
                          width: 328.w,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 25.w, left: 15.w),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: kBorderRadius5,
                          ),
                          child: TextField(
                            cursorColor:
                                Theme.of(context).textTheme.bodySmall!.color!,
                            cursorWidth: 1.3,
                            autofocus: true,
                            controller: _searchEditingController,
                            onChanged: searchProduct,
                            decoration: InputDecoration(
                              suffixIconConstraints:
                                  const BoxConstraints.tightFor(),
                              suffixIcon: Visibility(
                                visible: query != '',
                                child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        query = '';
                                      });
                                      _searchEditingController.text = '';
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: const BoxDecoration(
                                        color: kWhiteColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.clear_rounded,
                                        color: kBlackColor,
                                        size: 20,
                                      ),
                                    )),
                              ),
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                  fontSize: 17.sp,
                                  fontFamily: kFontFamilyName,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .color!),
                              hintText: '${'أبحث عن'}',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 60,
              right: 0,
              left: 0,
              bottom: 0,
              child: FutureBuilder<List<ProductApiModel>>(
                  future: _futureResultsProducts,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const ShimmerEffect(
                        content: ProductListVerticalShimmer(),
                      );
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      resultsProducts = snapshot.data!;

                      return GridView.builder(
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 10),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 27.h,
                          crossAxisSpacing: 30.w,
                          childAspectRatio: 176.w / 227.h,
                        ),
                        itemCount: resultsProducts.length,
                        itemBuilder: (context, index) {
                          return ProductCard(
                            productApiModel: resultsProducts[index],
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: Text('لايوجد نتائج بحث مشابة',
                            style: TextStyle(
                              fontSize: 15.sp,
                              color:
                                  Theme.of(context).textTheme.bodySmall?.color,
                              fontWeight: FontWeight.w700,
                            )),
                      );
                    }
                  }),
            ),
            Positioned(
                bottom: 20.h,
                left: 15.w,
                right: 15.w,
                child: BlocBuilder<CartCubit, List<ProductApiModel>>(
                  builder: (context, state) {
                    return Visibility(
                      visible: state.isNotEmpty,
                      child: CustomFiledElevatedBtn(
                        function: () {
                          checkoutBloc.sendOrderModel.products.clear();
                          checkoutBloc.sendOrderModel.products.addAll(state);
                          showCupertinoModalBottomSheet(
                            expand: true,
                            bounce: false,
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (context) => const OrderDetailsScreen(
                              isProducts: true,
                            ),
                          );
                        },
                        text: 'التالي',
                      ),
                    );
                  },
                ))
          ],
        ));
  }
}
