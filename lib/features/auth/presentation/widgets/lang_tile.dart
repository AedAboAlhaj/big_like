import 'package:big_like/features/auth/blocs/requirements_bloc.dart';
import 'package:big_like/features/auth/domain/models/suported_lang_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../constants/consts.dart';

class LangTile extends StatefulWidget {
  const LangTile({super.key, required this.langModel});

  final SupportedLangModel langModel;

  @override
  State<LangTile> createState() => _LangTileState();
}

class _LangTileState extends State<LangTile> with TickerProviderStateMixin {
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
            context
                .read<RequirementsBloc>()
                .add(LangListUpdated(supportedLangModel: widget.langModel));
          },
          splashColor: Colors.transparent,
          child: Container(
            height: 60.h,
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    width: 1.5,
                    color: widget.langModel.isSelected
                        ? kPrimaryColor
                        : Colors.black26)),
            child: Row(
              children: [
                Text(
                  widget.langModel.name,
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
                      color: widget.langModel.isSelected
                          ? kPrimaryColor
                          : kWhiteColor,
                      border: Border.all(
                          color: widget.langModel.isSelected
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
              ],
            ),
          ),
        );
      },
    );
  }
}
