import 'package:big_like/features/home/presentation/widgets/banner_card.dart';
import 'package:big_like/features/services/bloc/services_bloc.dart';
import 'package:big_like/features/services/presentation/widgets/service_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common_widgets/custom_loading_indicator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final servicesBloc = BlocProvider.of<ServicesBloc>(context);
    context.read<ServicesBloc>().add(ServicesFetched());

    return BlocConsumer<ServicesBloc, ServicesState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, ServicesState state) {
        if (state is ServicesFailure) {
          return Center(
            child: Text(state.error),
          );
        }
        if (state is! ServicesSuccess) {
          return const CustomLoadingIndicator();
        }
        final servicesList = state.serviceList;

        return ListView(
          children: [
            const BannerCard(),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding:
                  EdgeInsets.only(bottom: 90, top: 10, left: 20.w, right: 20.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 17.h,
                crossAxisSpacing: 17.w,
                childAspectRatio: 177.w / 203.h,
              ),
              shrinkWrap: true,
              itemCount: servicesList.length,
              itemBuilder: (context, index) {
                return ServiceCard(
                  serviceModel: servicesList[index],
                );
              },
            ),
          ],
        );
      },
    );
  }
}
