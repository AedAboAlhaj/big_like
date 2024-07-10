import 'package:big_like/common_widgets/custom_filed_elevated_btn.dart';
import 'package:big_like/features/worker_times/bloc/work_times_cubit.dart';
import 'package:big_like/features/worker_times/presentation/widgets/time_input_field.dart';
import 'package:big_like/utils/helpers.dart';
import 'package:big_like/utils/utils.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants/consts.dart';
import '../../domain/models/work_times_model.dart';

class ScheduleDayCard extends StatefulWidget {
  const ScheduleDayCard({
    super.key,
    required this.workDayModel,
  });

  final WorkDayModel workDayModel;

  @override
  State<ScheduleDayCard> createState() => _ScheduleDayCardState();
}

class _ScheduleDayCardState extends State<ScheduleDayCard> with Helpers {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: isExpanded
            ? TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                curve: Curves.ease,
                duration: const Duration(milliseconds: 500),
                builder: (BuildContext context, double opacity, Widget? child) {
                  return Opacity(
                      opacity: opacity, child: buildTableRowExpanded());
                })
            : buildTableRowCollapsed(),
      ),
    );
  }

  Widget buildTableRowCollapsed() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      // decoration: BoxDecoration(
      //     border: Border(
      //         top: BorderSide.none,
      //         bottom: BorderSide(width: 1, color: kGrayColor))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            widget.workDayModel.day,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.sp,
              color: kBlackColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Icon(Icons.keyboard_arrow_up_rounded)
        ],
      ),
    );
  }

  Widget buildTableRowExpanded() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                widget.workDayModel.day,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.sp,
                  color: kBlackColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Icon(Icons.keyboard_arrow_down_rounded)
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                BlocBuilder<WorkTimesCubit, List<WorkTimesModel>>(
                  builder: (context, state) {
                    return ListView.builder(
                      itemCount: state.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        // final list = context
                        //     .read<WorkTimesCubit>()
                        //     .getTimesList(widget.workDayModel.dayNum);

                        return widget.workDayModel.dayNum == state[index].dayNum
                            ? workTimeCostRow(state[index], index)
                            : const SizedBox();
                      },
                    );
                  },
                ),
                SizedBox(
                  height: 10.h,
                ),
                CustomFiledElevatedBtn(
                    function: () {
                      /*   setState(() {
                        widget.workDayModel.times.add();
                      });*/
                      context.read<WorkTimesCubit>().addWorkTime(WorkTimesModel(
                          startTime: null,
                          endTime: null,
                          id: widget.workDayModel.id,
                          dayNum: widget.workDayModel.dayNum));
                    },
                    text: '+ إضافة وقت جديد',
                    textColor: kBlackColor,
                    color: kLightGrayColor,
                    height: 50),
              ],
            ),
          )
        ],
      ),
    );
  }

  Column workTimeCostRow(WorkTimesModel workTimeModel, int index) {
    TimeOfDay? startTime = workTimeModel.startTime;
    TimeOfDay? endTime = workTimeModel.endTime;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: FormField(
                validator: (value) {
                  if (startTime == null) {
                    return 'مطلوب';
                  }

                  return null;
                },
                builder: (FormFieldState state) {
                  return InkWell(
                      onTap: () {
                        DatePicker.showTimePicker(
                          context,
                          showTitleActions: true,
                          theme: DatePickerTheme(
                            doneStyle: TextStyle(
                              color: kPrimaryColor,
                              fontFamily: kFontFamilyName,
                            ),
                          ),
                          showSecondsColumn: false,
                          onChanged: (date) {},
                          locale: LocaleType.ar,
                          onConfirm: (date) {
                            if (endTime != null) {
                              if (isTimeAfter(
                                  endTime!,
                                  TimeOfDay(
                                      hour: date.hour, minute: date.minute))) {
                                setState(() {
                                  startTime = TimeOfDay(
                                      hour: date.hour, minute: date.minute);
                                });
                                context
                                    .read<WorkTimesCubit>()
                                    .updateStartTime(index, startTime!);
                              } else {
                                showSnackBar(context,
                                    massage:
                                        'وقت بداية الدوام يجب ان يكون قبل وقت النهاية',
                                    error: true);
                              }
                            } else {
                              setState(() {
                                startTime = TimeOfDay(
                                    hour: date.hour, minute: date.minute);
                              });
                              context
                                  .read<WorkTimesCubit>()
                                  .updateStartTime(index, startTime!);
                            }
                          },
                          currentTime: DateTime.now(),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('من',
                                style: TextStyle(
                                    fontSize: 10.sp, color: kBlackColor)),
                            Text(
                              workTimeModel.startTime != null
                                  ? Utils.getTimeText(workTimeModel.startTime!)
                                  : '00:00',
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700,
                                  color: workTimeModel.startTime != null
                                      ? kBlackColor
                                      : Colors.black38),
                            ),
                            Visibility(
                              visible: state.hasError,
                              child: Text('مطلوب',
                                  style: TextStyle(
                                      fontSize: 10.sp, color: kRedColor)),
                            ),
                          ],
                        ),
                      ));
                },
              ),
            ),
            Expanded(
              child: FormField(
                validator: (value) {
                  if (startTime == null) {
                    return 'مطلوب';
                  }

                  return null;
                },
                builder: (FormFieldState state) {
                  return InkWell(
                      onTap: () {
                        DatePicker.showTimePicker(
                          context,
                          showTitleActions: true,
                          theme: DatePickerTheme(
                            doneStyle: TextStyle(
                              color: kPrimaryColor,
                              fontFamily: kFontFamilyName,
                            ),
                          ),
                          showSecondsColumn: false,
                          onChanged: (date) {},
                          locale: LocaleType.ar,
                          onConfirm: (date) {
                            if (startTime != null) {
                              if (isTimeAfter(
                                  TimeOfDay(
                                      hour: date.hour, minute: date.minute),
                                  startTime!)) {
                                setState(() {
                                  endTime = TimeOfDay(
                                      hour: date.hour, minute: date.minute);
                                });
                                context
                                    .read<WorkTimesCubit>()
                                    .updateEndTime(index, endTime!);
                              } else {
                                showSnackBar(context,
                                    massage:
                                        'وقت بداية الدوام يجب ان يكون قبل وقت النهاية',
                                    error: true);
                              }
                            } else {
                              setState(() {
                                endTime = TimeOfDay(
                                    hour: date.hour, minute: date.minute);
                              });

                              context
                                  .read<WorkTimesCubit>()
                                  .updateEndTime(index, endTime!);
                            }
                          },
                          currentTime: DateTime.now(),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('الى',
                                style: TextStyle(
                                    fontSize: 10.sp, color: kBlackColor)),
                            Text(
                              workTimeModel.endTime != null
                                  ? Utils.getTimeText(workTimeModel.endTime!)
                                  : '00:00',
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700,
                                  color: workTimeModel.endTime != null
                                      ? kBlackColor
                                      : Colors.black38),
                            ),
                            Visibility(
                              visible: state.hasError,
                              child: Text('مطلوب',
                                  style: TextStyle(
                                      fontSize: 10.sp, color: kRedColor)),
                            ),
                          ],
                        ),
                      ));
                },
              ),
            ),
            /*  Expanded(
              child: TimeInputField(
                hintText: 'الى',
                controller: toTextEditingController,
                onChanged: (val) {
                  times
                      .where((element) => element == workTimeModel)
                      .first
                      .endTime = val;
                },
              ),
            ),*/
            InkWell(
              onTap: () {
                // setState(() {
                //   widget.workDayModel.times.remove(workTimeModel);
                // });
                context.read<WorkTimesCubit>().removeWorkTime(workTimeModel);
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: kBorderRadius5,

                  // Optional: adds rounded corners
                  color: kRedColor.withOpacity(.1), // Background color
                ),
                child: const Icon(
                  Icons.close,
                  size: 30,
                  color: kRedColor,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10.h,
        )
      ],
    );
  }
}
