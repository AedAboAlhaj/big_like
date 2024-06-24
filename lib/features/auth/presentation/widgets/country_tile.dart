import 'package:big_like/common_widgets/custom_network_image.dart';
import 'package:big_like/constants/consts.dart';
import 'package:big_like/features/auth/domain/models/suported_country_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../blocs/requirements_bloc.dart';

class CountryTile extends StatefulWidget {
  const CountryTile({super.key, required this.countryModel});

  final SupportedCountryModel countryModel;

  @override
  State<CountryTile> createState() => _CountryTileState();
}

class _CountryTileState extends State<CountryTile>
    with TickerProviderStateMixin {
  late Animation<double> _sizeAnimation;
  late AnimationController _animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _animationController = AnimationController(
        duration: const Duration(milliseconds: 150), vsync: this);
    _sizeAnimation = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
          tween: Tween<double>(
            begin: 25.h,
            end: 35.h,
          ),
          weight: 50),
      TweenSequenceItem<double>(
          tween: Tween<double>(
            begin: 35.h,
            end: 25.h,
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
            _animationController.reset();
            _animationController.forward();
            context.read<RequirementsBloc>().add(
                CountryListUpdated(supportedCountryModel: widget.countryModel));
          },
          splashColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
            height: 60.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    width: 1.5,
                    color: widget.countryModel.isSelected
                        ? kPrimaryColor
                        : kBlackColor)),
            child: Row(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  height: 30.h,
                  width: 30.w,
                  clipBehavior: Clip.antiAlias,
                  child: CustomNetworkImage(
                    imageUrl: widget.countryModel.image ?? '',
                  ),
                ),
                SizedBox(
                  width: 12.w,
                ),
                Text(
                  widget.countryModel.name,
                  style:
                      TextStyle(fontSize: 16.sp, fontFamily: kFontFamilyName),
                ),
                const Spacer(),
                SizedBox(
                  width: 40.h,
                  child: Container(
                    height: _sizeAnimation.value,
                    width: _sizeAnimation.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.countryModel.isSelected
                          ? kPrimaryColor
                          : kWhiteColor,
                      border: Border.all(
                          color: widget.countryModel.isSelected
                              ? Colors.transparent
                              : kBlackColor),
                    ),
                    child: Theme(
                      data:
                          ThemeData(unselectedWidgetColor: Colors.transparent),
                      child: Icon(
                        Icons.check,
                        color: kWhiteColor,
                        size: _sizeAnimation.value - 6.h,
                      ),
                    ),
                  ),
                ),
                /*     Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.selected ? kPrimaryColor : kWhiteColor,
                  border: Border.all(
                      color: widget.selected ? Colors.transparent :kBlackColor)),
              height: 23.w,
              width: 23.w,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(2),
              child: widget.selected
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    )
                  : null,
            )*/
              ],
            ),
          ),
        );
      },
    );
  }
}
