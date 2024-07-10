import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants/consts.dart';
import '../../domain/models/service_model.dart';

class ServiceOptionCard extends StatefulWidget {
  const ServiceOptionCard({
    super.key,
    required this.options,
    required this.function,
  });

  final Options options;
  final VoidCallback function;

  @override
  State<ServiceOptionCard> createState() => _SidesCardState();
}

class _SidesCardState extends State<ServiceOptionCard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _sizeAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);

    _sizeAnimation = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
          tween: Tween<double>(
            begin: 22.h,
            end: 30.h,
          ),
          weight: 50),
      TweenSequenceItem<double>(
          tween: Tween<double>(
            begin: 30.h,
            end: 22.h,
          ),
          weight: 50),
    ]).animate(_animationController);
    _animationController.addStatusListener((state) {
      if (state == AnimationStatus.completed) {
        setState(() {
          // selected = true;
        });
      } else if (state == AnimationStatus.dismissed) {
        setState(() {
          // selected = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, _) {
        return InkWell(
          onTap: () {
            widget.options.isSelected
                ? _animationController.reverse()
                : _animationController.forward();
            // setState(() {
            //   widget.options.isSelected = !widget.options.isSelected;
            // });
            widget.function();
          },
          splashColor: Colors.transparent,
          child: Row(
            children: [
              SizedBox(
                width: 40.h,
                child: Container(
                  height: _sizeAnimation.value,
                  width: _sizeAnimation.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        widget.options.isSelected ? kBlackColor : kWhiteColor,
                    border: Border.all(color: kBlackColor, width: 1.5.w),
                  ),
                  child: Theme(
                    data: ThemeData(unselectedWidgetColor: Colors.transparent),
                    child: Icon(
                      Icons.check,
                      color: kWhiteColor,
                      size: _sizeAnimation.value - 6.h,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.options.name,
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: kBlackColor,
                        fontWeight: FontWeight.w700,
                        fontFamily: kFontFamilyName,
                      ),
                    ),
                    Text(
                      widget.options.fullDesc,
                      maxLines: 3,
                      style: TextStyle(
                        fontSize: 10.sp,
                        letterSpacing: .2,
                        color: kGrayColor,
                        fontWeight: FontWeight.w500,
                        fontFamily: kFontFamilyName,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 20.w,
              ),
              Text(
                '₪${widget.options.cost}',
                style: TextStyle(
                  fontSize: 15.sp,
                  color: kBlackColor,
                  fontWeight: FontWeight.w500,
                  fontFamily: kFontFamilyName,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
