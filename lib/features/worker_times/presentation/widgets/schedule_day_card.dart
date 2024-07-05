import 'package:big_like/common_widgets/custom_filed_elevated_btn.dart';
import 'package:big_like/features/worker_times/presentation/widgets/time_input_field.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants/consts.dart';
import '../../domain/models/work_times_model.dart';

class ScheduleDayCard extends StatefulWidget {
  const ScheduleDayCard({
    super.key,
    required this.day,
  });

  final String day;

  @override
  State<ScheduleDayCard> createState() => _ScheduleDayCardState();
}

class _ScheduleDayCardState extends State<ScheduleDayCard> {
  bool isExpanded = false;
  List<WorkTimesModel> times = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
            widget.day,
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
                widget.day,
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
                ...times.map((e) => workTimeCostRow(
                      e,
                    )),
                SizedBox(
                  height: 10.h,
                ),
                CustomFiledElevatedBtn(
                    function: () {
                      setState(() {
                        times.add(WorkTimesModel(
                          startTime: '',
                          endTime: '',
                        ));
                      });
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

  Column workTimeCostRow(WorkTimesModel workTimeModel) {
    TextEditingController fromTextEditingController =
        TextEditingController(text: workTimeModel.startTime);
    TextEditingController toTextEditingController =
        TextEditingController(text: workTimeModel.endTime);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TimeInputField(
                hintText: 'من',
                controller: fromTextEditingController,
                onChanged: (val) {
                  times
                      .where((element) => element == workTimeModel)
                      .first
                      .startTime = val;
                },
              ),
            ),
            Expanded(
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
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: kBorderRadius5,
                // Optional: adds rounded corners
                color: kRedColor.withOpacity(.1), // Background color
              ),
              child: IconButton(
                onPressed: () {
                  // if (specialTime.id != null) {
                  //   authApiController.deleteWorkCostEmployee(
                  //       id: specialTime.id!);
                  // }
                  setState(() {
                    times.remove(workTimeModel);
                  });
                },
                icon: const Icon(
                  Icons.delete,
                  size: 28,
                ),
                color: kRedColor,
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
