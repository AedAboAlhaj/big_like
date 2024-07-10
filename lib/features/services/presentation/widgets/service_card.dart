import 'package:big_like/common_widgets/custom_network_image.dart';
import 'package:big_like/constants/consts.dart';
import 'package:big_like/features/services/domain/models/service_model.dart';
import 'package:big_like/features/services/presentation/screens/service_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({super.key, required this.serviceModel});

  final ServiceModel serviceModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showCupertinoModalBottomSheet(
        expand: true,
        bounce: false,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => ServiceScreen(
          serviceModel: serviceModel,
        ),
      ),
      child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: kBorderRadius,
          ),
          child: CustomNetworkImage(
            imageUrl: serviceModel.image,
            imageHeight: 203,
          )),
    );
  }
}
