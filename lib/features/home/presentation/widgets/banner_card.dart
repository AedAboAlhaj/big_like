import 'package:big_like/common_widgets/custom_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants/consts.dart';

class BannerCard extends StatelessWidget {
/*
  final BannerApiModel bannerModel;
  final List<CategoryApiModel> list;
*/

  const BannerCard({
    super.key,
    /*required this.bannerModel, required this.list*/
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        /*
        switch (bannerModel.type) {
          case "category":
            {
              if (bannerModel.value != null) {
                if (bannerModel.parentSection == null) {
                  CategoryApiModel category = list.firstWhere(
                          (element) => element.id == bannerModel.value,
                      orElse: () => CategoryApiModel(
                          createdAt: '',
                          id: -1,
                          name: Name(ar: '', he: ''),
                          defaultName: '',
                          sort: -1,
                          status: false,
                          image: null));
                  if (category.id != -1) {
                    Navigator.push(
                        context,
                        MaterialWithModalsPageRoute(
                          builder: (_) =>
                              MainCategoryScreen(mainCategoryId: category.id),
                        ));
                  }
                } else {
                  CategoryApiModel category = list.firstWhere(
                          (element) => element.id == bannerModel.parentSection,
                      orElse: () => CategoryApiModel(
                          createdAt: '',
                          id: -1,
                          name: Name(ar: '', he: ''),
                          defaultName: '',
                          sort: -1,
                          status: false,
                          image: null));
                  if (category.id != -1) {
                    Navigator.push(
                        context,
                        MaterialWithModalsPageRoute(
                          builder: (_) => MainCategoryScreen(
                              subCategoryId: bannerModel.value,
                              // subCategoryRank: bannerModel.sectionRank,
                              mainCategoryId: category.id),
                        ));
                  }
                }
              }
            }
            break;

          case "product":
            {
              if (bannerModel.value != null) {
                AddressesGetXController addressesGetXController =
                Get.put(AddressesGetXController());
                showCupertinoModalBottomSheet(
                  expand: true,
                  bounce: false,
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => ProductScreen(
                    product: ProductDisplayApiModel(
                        status: true,
                        weight: Weight(unit: '', weight: 0),
                        weightDescriotion: WeightDescriotion(
                            weightDesc: 0, weightDescUnit: ''),
                        name: Name(ar: '', he: ''),
                        id: bannerModel.value!,
                        img: '',
                        storage: Storage(
                          id: addressesGetXController.locationDataApiModel !=
                              null
                              ? addressesGetXController
                              .locationDataApiModel!.storageApiModel!.id
                              : 4,
                          status: 0,
                          price: 0,
                          quantity: 0,
                        )),
                  ),
                );
              }
            }
            break;
          case "group":
            {
              if (bannerModel.value != null) {
                showCupertinoModalBottomSheet(
                  expand: true,
                  bounce: false,
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => GroupViewScreenModel(
                    groupId: bannerModel.value!,
                    groupImg: bannerModel.groupImg,
                  ),
                );
              }
            }
            break;
          case "block":
            {
              if (bannerModel.value != null) {
                showCupertinoModalBottomSheet(
                  expand: true,
                  bounce: false,
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => BlockViewScreenModel(
                    blockId: bannerModel.value!,
                  ),
                );
              }
            }
            break;
          case "url":
            {
              if (bannerModel.value != null) {
                // Utils.openLink(url: bannerModel.value!);
              }
            }
            break;
          default:
            {
              debugPrint('default banner');
            }
            break;
        }
      */
      },
      child: Container(
        height: 180.h,
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          borderRadius: kBorderRadius,
        ),
        clipBehavior: Clip.antiAlias,
        width: double.infinity,
        child: const CustomNetworkImage(
          imageUrl: 'uploads/services/66549c62048c2.jpg',
        ),
      ),
    );
  }
}
