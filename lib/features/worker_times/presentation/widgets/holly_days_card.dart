import 'dart:ui';

import 'package:big_like/common_widgets/custom_filed_elevated_btn.dart';
import 'package:big_like/features/worker_times/presentation/widgets/time_input_field.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../constants/consts.dart';
import '../../domain/models/work_times_model.dart';

class HollyDaysCard extends StatefulWidget {
  const HollyDaysCard({
    super.key,
    required this.workerHollyDaysList,
  });

  final List<HollyDaysModel> workerHollyDaysList;

  @override
  State<HollyDaysCard> createState() => _HollyDaysCardState();
}

class _HollyDaysCardState extends State<HollyDaysCard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    times = widget.workerHollyDaysList;
  }

  List<HollyDaysModel> times = [];

  @override
  Widget build(BuildContext context) {
    return buildTableRowExpanded();
  }

  Widget buildTableRowExpanded() {
    return Container(
      child: Column(
        children: [
          /*  Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                _dateFormatterDisPlay(date),
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
          ),*/
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
                        times.add(HollyDaysModel(
                          date: DateTime.now(),
                        ));
                      });
                    },
                    text: '+ إضافة تاريخ جديد',
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

  Column workTimeCostRow(HollyDaysModel hollyDaysModel) {
    return Column(
      children: [
        SizedBox(
          height: 65.h,
          child: Row(
            children: [
              Expanded(
                flex: 6,
                child: InkWell(
                  onTap: () {
                    showDateTimeDialog(hollyDaysModel);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: kRedColor.withOpacity(.1)),
                      borderRadius: kBorderRadius5,
                    ),
                    child: Text(
                      _dateFormatterDisPlay(hollyDaysModel.date),
                      style: TextStyle(
                        fontSize: 25.sp,
                        color: kBlackColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                flex: 2,
                child: Container(
                  height: 65.h,
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
                        times.remove(hollyDaysModel);
                      });
                    },
                    icon: const Icon(
                      Icons.delete,
                      size: 28,
                    ),
                    color: kRedColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10.h,
        )
      ],
    );
  }

  DateTime _selectedDate = DateTime.now();

  void showDateTimeDialog(HollyDaysModel hollyDaysModel) async {
    hollyDaysModel.date = _selectedDate;
    showDialog(
        context: context,
        useRootNavigator: false,
        barrierDismissible: true,
        barrierColor: kWhiteColor.withOpacity(.5),
        builder: (context) {
          return StatefulBuilder(builder: (context, setStateModelParent) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Dialog(
                insetPadding: EdgeInsets.symmetric(horizontal: 26.w),
                elevation: 2,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                    side: BorderSide(color: kWhiteColor, width: 1)),
                child: SizedBox(
                  height: 1.sh / 2 + 30.h,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 15.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Theme(
                          data: ThemeData(
                            fontFamily: kFontFamilyName,
                            primaryColor: kPrimaryColor,
                          ),
                          child: SfDateRangePicker(
                            // startRangeSelectionColor: kDarkBlueColor,
                            // endRangeSelectionColor: kDarkBlueColor,
                            // rangeSelectionColor: kDarkBlueColor.withOpacity(.1),
                            selectionColor: kPrimaryColor,
                            // initialDisplayDate: _selectedDate,
                            initialSelectedDate: _selectedDate,
                            monthViewSettings: DateRangePickerMonthViewSettings(
                                viewHeaderStyle: DateRangePickerViewHeaderStyle(
                                    textStyle: TextStyle(
                                        fontFamily: kFontFamilyName,
                                        fontSize: 12.sp,
                                        color: kBlackColor))),
                            monthCellStyle: DateRangePickerMonthCellStyle(
                              specialDatesTextStyle: const TextStyle(
                                  fontFamily: kFontFamilyName,
                                  color: kBlackColor,
                                  fontWeight: FontWeight.w500),
                              blackoutDateTextStyle: const TextStyle(
                                  fontFamily: kFontFamilyName,
                                  color: kBlackColor,
                                  fontWeight: FontWeight.w500),
                              weekendTextStyle: const TextStyle(
                                  fontFamily: kFontFamilyName,
                                  color: kBlackColor,
                                  fontWeight: FontWeight.w500),
                              leadingDatesTextStyle: const TextStyle(
                                  fontFamily: kFontFamilyName,
                                  color: kBlackColor,
                                  fontWeight: FontWeight.w500),
                              trailingDatesTextStyle: const TextStyle(
                                  fontFamily: kFontFamilyName,
                                  color: kBlackColor,
                                  fontWeight: FontWeight.w500),
                              todayTextStyle: TextStyle(
                                  fontFamily: kFontFamilyName,
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w500),
                              todayCellDecoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: kPrimaryColor),
                              ),
                              textStyle: const TextStyle(
                                  fontFamily: kFontFamilyName,
                                  color: kBlackColor,
                                  fontWeight: FontWeight.w500),
                              // cellDecoration: BoxDecoration(
                              //   border: Border.all(color: kPurpleColor),
                              // ),
                            ),
                            headerStyle: const DateRangePickerHeaderStyle(
                                textStyle: TextStyle(
                                    fontFamily: kFontFamilyName,
                                    color: kBlackColor,
                                    fontWeight: FontWeight.w500)),
                            rangeTextStyle: const TextStyle(
                              fontFamily: kFontFamilyName,
                              color: kBlackColor,
                            ),
                            onSelectionChanged: (val) {
                              setState(() {
                                hollyDaysModel.date = val.value;
                              });
                            },
                            selectionMode: DateRangePickerSelectionMode.single,
                          ),
                        ),
                        CustomFiledElevatedBtn(
                          function: () {
                            setState(() {
                              _selectedDate = hollyDaysModel.date;
                            });
                            Navigator.pop(context);
                          },
                          text: 'حسناً',
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        });
  }

  String _dateFormatterDisPlay(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
}
