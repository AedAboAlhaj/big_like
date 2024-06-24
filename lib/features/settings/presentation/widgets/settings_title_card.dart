import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/models/company_profile_page_api_model.dart';
import '../screens/com_profile_screen_model.dart';

class CamPagesTitleCard extends StatelessWidget {
  final CompanyProfilePageApiModel comProfilePagesModel;

  const CamPagesTitleCard({
    super.key,
    required this.comProfilePagesModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(bottom: 10.h),
      color: Theme.of(context).cardColor,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 0),
        horizontalTitleGap: 0,
        minVerticalPadding: 0,
        tileColor: Theme.of(context).cardColor,
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 15,
          color: Theme.of(context).textTheme.bodySmall!.color,
        ),
        title: Text(
          comProfilePagesModel.defaultTitle,
          style: TextStyle(
            fontSize: 15.sp,
            color: Theme.of(context).textTheme.bodySmall!.color,
            fontWeight: FontWeight.w600,
          ),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CamProfilePageModel(
                        comProfilePagesModel: comProfilePagesModel,
                      )));
        },
      ),
    );
  }
}
