import 'dart:async';
import 'dart:math';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../common_widgets/shimmer_effect.dart';
import '../../../../constants/consts.dart';
import '../../../../utils/helpers.dart';
import '../../bloc/cart_cubit.dart';
import '../../domain/models/products_api_model.dart';
import 'counter_btn.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    super.key,
    required this.productApiModel,
  });

  final ProductApiModel productApiModel;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

// 1. custom Curve subclass
class SineCurve extends Curve {
  const SineCurve({this.count = 3});

  final double count;

  // 2. override transformInternal() method
  @override
  double transformInternal(double t) {
    return sin(count * 2 * pi * t);
  }
}

abstract class AnimationControllerState<T extends StatefulWidget>
    extends State<T> with SingleTickerProviderStateMixin {
  AnimationControllerState(this.animationDuration);

  final Duration animationDuration;
  late final animationController =
      AnimationController(vsync: this, duration: animationDuration);

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

class ShakeWidget extends StatefulWidget {
  const ShakeWidget({
    Key? key,
    required this.child,
    required this.shakeOffset,
    this.shakeCount = 3,
    this.shakeDuration = const Duration(milliseconds: 500),
  }) : super(key: key);

  // 1. pass a child widget
  final Widget child;

  // 2. configurable properties
  final double shakeOffset;
  final int shakeCount;
  final Duration shakeDuration;

  // 3. pass the shakeDuration as an argument to ShakeWidgetState. See below.
  @override
  ShakeWidgetState createState() => ShakeWidgetState(shakeDuration);
}

class ShakeWidgetState extends AnimationControllerState<ShakeWidget> {
  ShakeWidgetState(super.duration);

  // 1. create a Tween
  late final Animation<double> _sineAnimation = Tween(
    begin: 0.0,
    end: 1.0,
    // 2. animate it with a CurvedAnimation
  ).animate(CurvedAnimation(
    parent: animationController,
    // 3. use our SineCurve
    curve: SineCurve(count: widget.shakeCount.toDouble()),
  ));

  @override
  void initState() {
    super.initState();
    // 1. register a status listener
    animationController.addStatusListener(_updateStatus);
  }

  @override
  void dispose() {
    // 2. dispose it when done
    animationController.removeStatusListener(_updateStatus);
    super.dispose();
  }

  void _updateStatus(AnimationStatus status) {
    // 3. reset animationController when the animation is complete
    if (status == AnimationStatus.completed) {
      animationController.reset();
    }
  }

  void shake() {
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    // 1. return an AnimatedBuilder
    return AnimatedBuilder(
      // 2. pass our custom animation as an argument
      animation: _sineAnimation,
      // 3. optimization: pass the given child as an argument
      child: widget.child,
      builder: (context, child) {
        return Transform.translate(
          // 4. apply a translation as a function of the animation value
          offset: Offset(_sineAnimation.value * widget.shakeOffset, 0),
          // 5. use the child widget
          child: child,
        );
      },
    );
  }
}

class _ProductCardState extends State<ProductCard>
    with TickerProviderStateMixin, Helpers {
  // int _counter = 0;
  // final CartsApiGetXController _cartsApiGetXController =
  //     Get.put(CartsApiGetXController());

  late AnimationController _controller;
  final _shakeKey = GlobalKey<ShakeWidgetState>();
  bool isMaxQuantity = false;

  @override
  void dispose() {
    colorController.dispose();
    _controller.dispose();
    super.dispose();
  }

  late AnimationController colorController;
  late Animation _colorAnim;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    colorController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _colorAnim = ColorTween(begin: kPrimaryColor, end: kRedColor)
        .animate(colorController);
  }

  @override
  Widget build(BuildContext context) {
    // print(
    //     ' "https://app.tlbak.com/images/${widget.productDisplayApiModel.img}?w=200&h=200"');
    return GestureDetector(
      onTap: () {
        // showCupertinoModalBottomSheet(
        //   expand: true,
        //   bounce: false,
        //   context: context,
        //   backgroundColor: Colors.transparent,
        //   builder: (context) => ProductScreen(
        //       product: widget.productApiModel,
        //       sectionId: widget.sectionId),
        // );
        // Utils.productScreenBottomSheet(context: context);
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => const ProductScreen()));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 155.h,
            decoration: BoxDecoration(
                borderRadius: kBorderRadius5,
                color: Theme.of(context).cardColor),
            clipBehavior: Clip.antiAlias,
            child: BlocBuilder<CartCubit, List<ProductApiModel>>(
              builder: (context, cart) {
                return Stack(
                  children: [
                    Positioned.fill(
                      left: 5.w,
                      right: 5.w,
                      top: 10.h,
                      bottom: 20.h,
                      child: Opacity(
                        opacity: widget.productApiModel.quantity > 0 ? 1 : .5,
                        child: CachedNetworkImage(
                          imageUrl:
                              "$appUrl${widget.productApiModel.image}?w=200&h=200",
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Center(
                            child: ShimmerImageEffect(
                                content: Container(
                              decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  borderRadius: kBorderRadius5),
                              height: 155.h,
                            )),
                          ),
                          errorWidget: (context, url, error) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'assets/images/no_pictures.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                        width: cart.any((element) =>
                                element.id == widget.productApiModel.id)
                            ? cart
                                        .firstWhere((element) =>
                                            element.id ==
                                            widget.productApiModel.id)
                                        .userSelectedQuantity >
                                    0
                                ? 135.w
                                : 0.0
                            : 0.0,
                        height: 25.w,
                        bottom: 12.h,
                        // bottom: 6.h,
                        // right: _counter > 0 ? 22.w : null,
                        left: 19.2.w,
                        curve: Curves.fastOutSlowIn,
                        duration: const Duration(milliseconds: 650),
                        child: IgnorePointer(
                          ignoring: !(widget.productApiModel.quantity > 0),
                          child: Visibility(
                            visible: widget.productApiModel.quantity > 0,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .scaffoldBackgroundColor
                                    .withOpacity(.9),
                              ),
                              child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: ShakeWidget(
                                  // 4. pass the GlobalKey as an argument
                                  key: _shakeKey,
                                  // 5. configure the animation parameters
                                  shakeCount: 3,
                                  shakeOffset: 5,
                                  shakeDuration:
                                      const Duration(milliseconds: 400),
                                  // 6. Add the child widget that will be animated
                                  child: Visibility(
                                    visible: cart.any((element) =>
                                        element.id ==
                                        widget.productApiModel.id),
                                    child: AnimatedFlipCounter(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      value: cart.any((element) =>
                                              element.id ==
                                              widget.productApiModel.id)
                                          ? cart
                                              .firstWhere((element) =>
                                                  element.id ==
                                                  widget.productApiModel.id)
                                              .userSelectedQuantity
                                          : 0,
                                      padding: EdgeInsets.zero,
                                      textStyle: TextStyle(
                                          fontSize: 14.sp,
                                          fontFamily: kFontFamilyName,
                                          fontWeight: FontWeight.bold,
                                          color: _colorAnim.value),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )),
                    AnimatedPositioned(
                        bottom: 4.h,
                        // right: _counter > 0 ? 12.w : null,
                        curve: Curves.fastOutSlowIn,
                        left: cart.any((element) =>
                                element.id == widget.productApiModel.id)
                            ? cart
                                        .firstWhere((element) =>
                                            element.id ==
                                            widget.productApiModel.id)
                                        .userSelectedQuantity >
                                    0
                                ? 134.w
                                : 0.w
                            : 0,
                        duration: const Duration(milliseconds: 650),
                        child: IgnorePointer(
                          ignoring: !((widget.productApiModel.quantity > 0)),
                          child: Visibility(
                            visible: (widget.productApiModel.quantity > 0),
                            child: AnimatedRotation(
                              duration: const Duration(milliseconds: 500),

                              turns: cart.any((element) =>
                                      element.id == widget.productApiModel.id)
                                  ? cart
                                              .firstWhere((element) =>
                                                  element.id ==
                                                  widget.productApiModel.id)
                                              .userSelectedQuantity >
                                          0
                                      ? 0
                                      : .2
                                  : .2,
                              curve: Curves.fastOutSlowIn,

                              // angle:,
                              child: CounterBtn(
                                iconSize: 25.w,
                                function: () async {
                                  colorController.reset();
                                  if (cart.any((element) =>
                                      element.id ==
                                      widget.productApiModel.id)) {
                                    if (cart
                                            .firstWhere((element) =>
                                                element.id ==
                                                widget.productApiModel.id)
                                            .userSelectedQuantity >
                                        0) {
                                      // --cart
                                      //     .firstWhere((element) =>
                                      //         element.id ==
                                      //         widget.productApiModel.id)
                                      //     .userSelectedQuantity;
                                      context
                                          .read<CartCubit>()
                                          .decreaseQuantity(
                                              widget.productApiModel);

                                      // _cartsGetXController.updateCart(
                                      //     cartUpdated,
                                      //     key: _cartsGetXController
                                      //         .shakeProductCartKey);

                                      if (cart
                                              .firstWhere((element) =>
                                                  element.id ==
                                                  widget.productApiModel.id)
                                              .userSelectedQuantity ==
                                          0) {
                                        context
                                            .read<CartCubit>()
                                            .deleteFromCart(
                                                widget.productApiModel);
                                      }
                                    }
                                  }
                                },
                                iconData: Icons.remove,
                              ),
                            ),
                          ),
                        )),
                    Positioned(
                        bottom: 4.h,
                        left: 0.w,
                        child: IgnorePointer(
                          ignoring: !((widget.productApiModel.quantity > 0)),
                          child: Visibility(
                            visible: (widget.productApiModel.quantity > 0),
                            child: CounterBtn(
                              iconSize: 25.w,
                              function: () async {
                                if (cart.any((element) =>
                                    element.id == widget.productApiModel.id)) {
                                  // ++cart
                                  //     .firstWhere((element) =>
                                  //         element.id ==
                                  //         widget.productApiModel.id)
                                  //     .userSelectedQuantity;
                                  context
                                      .read<CartCubit>()
                                      .increaseQuantity(widget.productApiModel);
                                } else {
                                  await addToCart();
                                }
                              },
                              iconData: Icons.add,
                            ),
                          ),
                        )),
                  ],
                );
              },
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            '₪${widget.productApiModel.price}',
            // '${widget.product.price} ₪',
            style: TextStyle(
                fontSize: 12.sp,
                fontFamily: kFontFamilyName,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor),
          ),

          Text(
            widget.productApiModel.name,
            maxLines: 2,
            style: TextStyle(
                fontSize: 11.sp,
                overflow: TextOverflow.ellipsis,
                fontFamily: kFontFamilyName,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.bodySmall!.color!),
          ),

          // Text(
          //   '${widget.productDisplayApiModel.weight.weight} ${widget.productDisplayApiModel.weight.unit}',
          //   maxLines: 1,
          //   style: TextStyle(
          //       fontSize: 8.sp,
          //       fontFamily: kFontFamilyName,
          //       overflow: TextOverflow.ellipsis,
          //       color: kGrayColor),
          // ),
        ],
      ),
    );
  }

  Future<void> addToCart() async {
    widget.productApiModel.userSelectedQuantity = 1;
    bool created = context.read<CartCubit>().addToCart(widget.productApiModel);
    String message = created ? 'تم اضافة المنتج الى السلة' : 'خطئ';
    showSnackBar(context, massage: message, error: !created);
  }
}
