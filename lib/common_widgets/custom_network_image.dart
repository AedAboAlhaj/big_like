import 'package:big_like/common_widgets/shimmer_effect.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/consts.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage(
      {super.key, required this.imageUrl, this.imageHeight});

  final String? imageUrl;
  final int? imageHeight;

  @override
  Widget build(BuildContext context) {
    return imageUrl != null
        ? CachedNetworkImage(
            imageUrl: appUrl + imageUrl!,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) => Center(
              child: ShimmerImageEffect(
                  content: Container(
                decoration: BoxDecoration(
                    color: kWhiteColor, borderRadius: kBorderRadius5),
                height: double.infinity,
                width: double.infinity,
              )),
            ),
            errorWidget: (context, url, error) => Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset(
                'assets/images/no_pictures.png',
                fit: BoxFit.contain,
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.asset(
              'assets/images/no_pictures.png',
              fit: BoxFit.contain,
            ),
          );
  }
}
