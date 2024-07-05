import 'package:big_like/common_widgets/custom_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../constants/consts.dart';
import '../../../products/domain/models/products_api_model.dart';

class OrderProductCard extends StatefulWidget {
  const OrderProductCard({
    super.key,
    required this.product,
  });

  final ProductApiModel product;

  @override
  State<OrderProductCard> createState() => _OrderProductCardState();
}

class _OrderProductCardState extends State<OrderProductCard> {
  num _getProductPrice() {
    var total = 0.0;

    total += widget.product.quantity * (widget.product.price);

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration:
          BoxDecoration(borderRadius: kBorderRadius5, color: kLightWhiteColor),
      child: Row(
        children: [
          SizedBox(
            // clipBehavior: Clip.antiAlias,
            // padding: EdgeInsets.symmetric(vertical: 10.h),
            // decoration: BoxDecoration(
            //     borderRadius: kBorderRadius5,
            //     color: Theme.of(context).cardColor),
            height: 94.h,
            width: 100.w,
            child: CustomNetworkImage(
              imageUrl: widget.product.image,
            ),
          ),
          VerticalDivider(
            color: kBlackColor,
            width: 28.w,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    '${widget.product.price} ₪',
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: kFontFamilyName,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodySmall!.color!),
                  ),
                ],
              ),
              SizedBox(
                height: 3.h,
              ),
              SizedBox(
                width: 170.w,
                child: Text(
                  widget.product.name,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Theme.of(context).textTheme.bodySmall!.color!,
                    fontFamily: kFontFamilyName,
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Row(
                children: [
                  // Text(
                  //   '${product.weightDescriotion.weightDesc}${product.weightDescriotion.weightDescUnit}/${weightDescriptionPrice()}₪',
                  //   style: TextStyle(
                  //     fontSize: 10.sp,
                  //     color: kPrimaryColor,
                  //     // fontWeight: FontWeight.w700,
                  //     fontFamily: kFontFamilyName,
                  //   ),
                  // ),
                  // const SizedBox(
                  //   width: 5,
                  // ),
                  Text(
                    'الاجمالي: ',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: kGrayColor,
                      fontFamily: kFontFamilyName,
                    ),
                  ),
                  Text('₪${_getProductPrice()}',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: kGrayColor,
                        fontFamily: kFontFamilyName,
                      )),
                ],
              ),
            ],
          ),
          const Spacer(),
          Text(
            widget.product.quantity.toString(),
            style: TextStyle(
              fontSize: 19.sp,
              color: kPrimaryColor,
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
    );
  }
}
