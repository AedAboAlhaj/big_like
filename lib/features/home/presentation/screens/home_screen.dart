import 'package:big_like/common_widgets/shimmer_effect.dart';
import 'package:big_like/constants/consts.dart';
import 'package:big_like/features/home/domain/models/banner_api_model.dart';
import 'package:big_like/features/home/presentation/widgets/banner_card.dart';
import 'package:big_like/features/services/bloc/services_bloc.dart';
import 'package:big_like/features/services/data/services_api_controller.dart';
import 'package:big_like/features/services/domain/models/service_model.dart';
import 'package:big_like/features/services/presentation/widgets/service_card.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../common_widgets/custom_loading_indicator.dart';
import '../../../../local_storage/secure_storage.dart';
import '../../../products/presentation/screens/products_screen.dart';
import '../../data/home_api_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<ServiceModel>> _future;
  late Future<List<BannerApiModel>> _futureBanners;
  List<ServiceModel> _servicesList = [];
  final ServicesApiController _servicesApiController = ServicesApiController();
  final HomeApiController _homeApiController = HomeApiController();
  late PageController _pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(initialPage: 0);

    _future = _servicesApiController.getServices();
    _futureBanners = _homeApiController.getBanners();
  }

  late List<ConnectivityResult> _connectivityResult;
  late List<BannerApiModel> _bannersList;
  final _errorIndicator = GlobalKey<RefreshIndicatorState>();

  // void _update() async {
  //   if (_errorIndicator.currentState != null) {
  //     _errorIndicator.currentState!.show();
  //   }
  // }

  Future<void> _pullRefresh() async {
    _servicesList = await _servicesApiController.getServices();
    _bannersList = await _homeApiController.getBanners();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // final servicesBloc = BlocProvider.of<ServicesBloc>(context);

    return FutureBuilder(
        future: Future.wait([
          _future,
          _futureBanners,
          (Connectivity().checkConnectivity()),
        ]),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            _servicesList = snapshot.data[0];
            _bannersList = snapshot.data[1];
            _connectivityResult = snapshot.data[2];
            if (!(_connectivityResult.contains(ConnectivityResult.mobile) ||
                _connectivityResult.contains(ConnectivityResult.wifi))) {
              // Utils.checkNetwork(
              //     context: context, function: _update);
              return RefreshIndicator(
                  onRefresh: _pullRefresh,
                  key: _errorIndicator,
                  color: kPrimaryColor,
                  child: Container());
            }
            return RefreshIndicator(
                onRefresh: _pullRefresh,
                key: _errorIndicator,
                color: kPrimaryColor,
                child: ListView(
                  children: [
                    Visibility(
                      visible: _bannersList.isNotEmpty,
                      child: SizedBox(
                          height: 180.h,
                          child: PageView.builder(
                            itemBuilder: (context, index) {
                              return BannerCard(
                                  bannerModel: _bannersList[index]);
                            },
                            itemCount: _bannersList.length,
                            controller: _pageController,
                          )),
                    ),
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(
                          bottom: 15.h, top: 15.h, left: 15.w, right: 15.w),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 15.h,
                        crossAxisSpacing: 15.w,
                        childAspectRatio: 177.w / 203.h,
                      ),
                      shrinkWrap: true,
                      itemCount: _servicesList.length,
                      itemBuilder: (context, index) {
                        return ServiceCard(
                          serviceModel: _servicesList[index],
                        );
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        showCupertinoModalBottomSheet(
                          expand: true,
                          bounce: false,
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (context) => const ProductsScreen(),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 15.w),
                        height: 170.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: kBorderRadius10),
                        alignment: Alignment.center,
                        child: Text(
                          'المنتجات',
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 30.sp,
                              color: kWhiteColor),
                        ),
                      ),
                    )
                  ],
                ));
          } else if (snapshot.hasError) {
            return const Center(child: Icon(Icons.error_outline));
          } else {
            return const ShimmerEffect(content: HomeScreenShimmer());
          }
        });
  }
}
