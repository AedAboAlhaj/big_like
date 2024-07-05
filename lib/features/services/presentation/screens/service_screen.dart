import 'dart:developer';

import 'package:big_like/common_widgets/custom_network_image.dart';
import 'package:big_like/features/services/bloc/services_bloc.dart';
import 'package:big_like/features/services/domain/models/service_model.dart';
import 'package:big_like/features/services/presentation/widgets/price_label_bottom_card.dart';
import 'package:big_like/features/services/presentation/widgets/service_option_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../common_widgets/custom_loading_indicator.dart';
import '../../../../constants/consts.dart';
import '../../../auth/blocs/requirements_bloc.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key, required this.serviceModel});

  final ServiceModel serviceModel;

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen>
    with SingleTickerProviderStateMixin {
  int _selectedImage = 0;

  Animation<double>? _animation; // Use `Animation` instead of `Animatable`
  late AnimationController _controller;
  late ServiceModel serviceModel;
  Options? selectedOption;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    context.read<ServicesBloc>().add(ServiceFetched(widget.serviceModel.id));
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = TweenSequence<double>(
      [
        TweenSequenceItem<double>(
          weight: 100,
          tween: Tween<double>(
            begin: 0,
            end: 1,
          ),
        ),
      ],
    ).animate(_controller);
    _controller.forward(); // he
    _controller.repeat(); // he
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  final _transformationController = TransformationController();

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapDetails = details;
  }

  late TapDownDetails _doubleTapDetails;

  void _handleDoubleTap() {
    if (_transformationController.value != Matrix4.identity()) {
      _transformationController.value = Matrix4.identity();
    } else {
      final position = _doubleTapDetails.localPosition;
      // For a 3x zoom
      _transformationController.value = Matrix4.identity()
        ..translate(-position.dx * 2, -position.dy * 2)
        ..scale(3.0);
      // Fox a 2x zoom
      // ..translate(-position.dx, -position.dy)
      // ..scale(2.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          top: false,
          child: BlocConsumer<ServicesBloc, ServicesState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              if (state is ShowServiceFailure) {
                return Center(
                  child: Text(state.error),
                );
              }
              if (state is! ShowServiceSuccess) {
                return const CustomLoadingIndicator();
              }
              serviceModel = state.serviceModel;
              if (!(serviceModel.options.any(
                    (element) => element.isSelected,
                  )) &&
                  serviceModel.options.isNotEmpty) {
                selectedOption = serviceModel.options.first;
                serviceModel.options.first.isSelected = true;
                selectedOption?.isSelected = true;
              }

              return Stack(
                children: [
                  Positioned.fill(
                    child: SingleChildScrollView(
                      controller: ModalScrollController.of(context),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 300.h,
                            child: PageView.builder(
                                scrollDirection: Axis.horizontal,
                                onPageChanged: (val) {
                                  setState(() {
                                    _selectedImage = val;
                                  });

                                  debugPrint(
                                      '---------------->$_selectedImage');
                                },
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTapDown: _handleDoubleTapDown,
                                    onTap: _handleDoubleTap,
                                    child: InteractiveViewer(
                                      transformationController:
                                          _transformationController,
                                      child: CustomNetworkImage(
                                        imageUrl: serviceModel.cover,
                                      ),
                                    ),
                                  );
                                },
                                itemCount: 1),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 18.h,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 130.w,
                                      child: Text(
                                        serviceModel.name,
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .color,
                                          fontFamily: kFontFamilyName,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '(تقييم 90)',
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        color: kOrangeColor,
                                        fontFamily: kFontFamilyName,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8.w,
                                    ),
                                    RatingBar(
                                      initialRating: 3.1,
                                      minRating: 1,
                                      itemSize: 20,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemPadding: const EdgeInsets.symmetric(
                                          horizontal: 1),
                                      ratingWidget: RatingWidget(
                                        full: SvgPicture.asset(
                                            'assets/images/svgIcons/star.svg'),
                                        half: SvgPicture.asset(
                                            'assets/images/svgIcons/star_half.svg'),
                                        empty: SvgPicture.asset(
                                            'assets/images/svgIcons/star_border.svg'),
                                      ),
                                      onRatingUpdate: (rating) {
                                        print(rating);
                                      },
                                    ),
                                    SizedBox(
                                      width: 8.w,
                                    ),
                                    Text(
                                      '4.5',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        color: kOrangeColor,
                                        fontFamily: kFontFamilyName,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 13.h,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                ),
                                child: Text(
                                  widget.serviceModel.description ?? "",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .color!,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: kFontFamilyName,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 34.h,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                ),
                                child: Text(
                                  'الخيارات المقترحة',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .color!,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: kFontFamilyName,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 17.h,
                              ),
                              ListView.separated(
                                itemCount: serviceModel.options.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.only(
                                  right: 15.w,
                                  left: 15.w,
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  return ServiceOptionCard(
                                    function: () {
                                      for (var element
                                          in serviceModel.options) {
                                        element.isSelected = false;
                                      }
                                      selectedOption =
                                          serviceModel.options[index];
                                      selectedOption?.isSelected = true;
                                      setState(() {});
                                    },
                                    options: serviceModel.options[index],
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return SizedBox(
                                    height: 18.h,
                                  );
                                },
                              ),
                              SizedBox(
                                height: 90.h,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      top: 45.h,
                      left: 20.w,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () =>
                                Navigator.of(context, rootNavigator: true)
                                    .pop(),
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .color!,
                                size: 25.w,
                              ),
                            ),
                          ),
                        ],
                      )),
                  selectedOption != null
                      ? PriceLabelBottomCard(
                          option: selectedOption,
                        )
                      : const SizedBox(),
                ],
              );
            },
          ),
        ));
  }
}
