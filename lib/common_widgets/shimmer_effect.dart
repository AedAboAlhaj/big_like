import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../constants/consts.dart';

class ProductOrderCardShimmer extends StatelessWidget {
  const ProductOrderCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 94.h,
          width: 100.w,
          decoration:
              BoxDecoration(borderRadius: kBorderRadius5, color: Colors.white),
        ),
        SizedBox(
          width: 28.w,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 10.h,
              width: 120.w,
              color: Colors.white,
            ),
            SizedBox(
              height: 4.h,
            ),
            Container(
              height: 10.h,
              width: 120.w,
              color: Colors.white,
            ),
            SizedBox(
              height: 4.h,
            ),
            Container(
              height: 10.h,
              width: 100.w,
              color: Colors.white,
            ),
            SizedBox(
              height: 4.h,
            ),
            Container(
              height: 10.h,
              width: 26.w,
              color: Colors.white,
            ),
          ],
        ),
      ],
    );
  }
}

class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 237.h,
      width: 120.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 155.h,
            decoration: BoxDecoration(
                borderRadius: kBorderRadius5, color: Colors.white),
            width: double.infinity,
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            height: 15.h,
            width: 120.w,
            color: Colors.white,
          ),
          SizedBox(
            height: 4.h,
          ),
          Container(
            height: 15.h,
            width: 100.w,
            color: Colors.white,
          ),
          SizedBox(
            height: 4.h,
          ),
          Container(
            height: 20.h,
            width: 26.w,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

class ShimmerEffect extends StatelessWidget {
  const ShimmerEffect({super.key, required this.content});
  final Widget content;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Shimmer.fromColors(
          period: const Duration(seconds: 1),
          baseColor:Colors.grey[300]!,
          highlightColor:
        Colors.grey[100]!,
          child: content),
    );
  }
}

class ShimmerImageEffect extends StatelessWidget {
  const ShimmerImageEffect({Key? key, required this.content}) : super(key: key);
  final Widget content;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Shimmer.fromColors(
          period: const Duration(seconds: 1),
          baseColor:  Colors.grey[200]!,
          highlightColor:
            Colors.grey[100]!,
          child: content),
    );
  }
}

class BannerShimmer extends StatelessWidget {
  const BannerShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        height: 141.h,
        width: 1.sw);
  }
}

class ComPageShimmerCard extends StatelessWidget {
  const ComPageShimmerCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      height: 60.h,
    );
  }
}

class MainCategoryShimmerCard extends StatelessWidget {
  const MainCategoryShimmerCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.h,
      width: 120.w,
      decoration:
          BoxDecoration(borderRadius: kBorderRadius5, color: Colors.white),
      clipBehavior: Clip.antiAlias,
    );
  }
}

class SearchBarShimmer extends StatelessWidget {
  const SearchBarShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55.h,
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      width: double.infinity,
      decoration:
          BoxDecoration(borderRadius: kBorderRadius5, color: Colors.white),
      clipBehavior: Clip.antiAlias,
    );
  }
}

class SubCategoryShimmerCard extends StatelessWidget {
  const SubCategoryShimmerCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42.h,
      width: 98.w,
      decoration:
          BoxDecoration(borderRadius: kBorderRadius5, color: Colors.white),
      clipBehavior: Clip.antiAlias,
    );
  }
}

class ProductListHShimmer extends StatelessWidget {
  const ProductListHShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 237.h,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) {
          return const ProductCardShimmer();
        },
        separatorBuilder: (context, index) {
          return SizedBox(
            width: 10.w,
          );
        },
      ),
    );
  }
}

class MainCategoriesListHShimmer extends StatelessWidget {
  const MainCategoriesListHShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150.h,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) {
          return const MainCategoryShimmerCard();
        },
        separatorBuilder: (context, index) {
          return SizedBox(
            width: 10.w,
          );
        },
      ),
    );
  }
}

class SubCategoriesListHShimmer extends StatelessWidget {
  const SubCategoriesListHShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42.h,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) {
          return const SubCategoryShimmerCard();
        },
        separatorBuilder: (context, index) {
          return SizedBox(
            width: 10.w,
          );
        },
      ),
    );
  }
}

class MainCategoriesListVerticalShimmer extends StatelessWidget {
  const MainCategoriesListVerticalShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        slivers: <Widget>[
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return const MainCategoryShimmerCard();
              },
              childCount: 12,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10.h,
              crossAxisSpacing: 10.w,
              childAspectRatio: 120.w / 150.h,
            ),
          ),
        ],
      ),
    );
  }
}

class ProductListVerticalShimmer extends StatelessWidget {
  const ProductListVerticalShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        slivers: <Widget>[
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return const ProductCardShimmer();
              },
              childCount: 12,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 18.h,
              crossAxisSpacing: 12.w,
              childAspectRatio: 120.w / 230.h,
            ),
          ),
        ],
      ),
    );
  }
}

class HomeScreenShimmer extends StatelessWidget {
  const HomeScreenShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          SizedBox(
            height: 12.h,
          ),
          SizedBox(
            height: 25.h,
            child: Padding(
              padding: EdgeInsets.only(right: 15.w, left: 28.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 20.h,
                    width: 68.w,
                    decoration: const BoxDecoration(color: Colors.white),
                  ),
                  Container(
                    height: 20.h,
                    width: 68.w,
                    decoration: const BoxDecoration(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 12.h,
          ),
          const MainCategoriesListHShimmer(),
          SizedBox(
            height: 22.h,
          ),
          const SearchBarShimmer(),
          SizedBox(
            height: 10.h,
          ),
          const BannerShimmer(),
          SizedBox(
            height: 15.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 20.h,
                  width: 100.w,
                  decoration: const BoxDecoration(color: Colors.white),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 12.h,
          ),
          const ProductListHShimmer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 20.h,
                  width: 100.w,
                  decoration: const BoxDecoration(color: Colors.white),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 12.h,
          ),
          const ProductListHShimmer(),
        ],
      ),
    );
  }
}

class MainCategoriesSimmerScreen extends StatelessWidget {
  const MainCategoriesSimmerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10.h,
        ),
        const MainCategoriesListVerticalShimmer()
      ],
    );
  }
}

class ComPageSimmerScreen extends StatelessWidget {
  const ComPageSimmerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10.h,
        ),
        const ComPageShimmerCard(),
        SizedBox(
          height: 10.h,
        ),
        const ComPageShimmerCard()
      ],
    );
  }
}

class CheckOutSimmerScreen extends StatelessWidget {
  const CheckOutSimmerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComPageShimmerCard(),
          SizedBox(
            height: 20.h,
          ),
          Row(
            children: [
              const Expanded(child: ComPageShimmerCard()),
              SizedBox(
                width: 10.h,
              ),
              const Expanded(child: ComPageShimmerCard()),
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          Row(
            children: [
              const Expanded(child: ComPageShimmerCard()),
              SizedBox(
                width: 10.h,
              ),
              const Expanded(child: ComPageShimmerCard()),
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          const ComPageShimmerCard(),
          SizedBox(
            height: 50.h,
          ),
          Container(
            height: 15.h,
            width: 268.w,
            decoration: const BoxDecoration(color: Colors.white),
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            height: 15.h,
            width: 268.w,
            decoration: const BoxDecoration(color: Colors.white),
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            height: 15.h,
            width: 150.w,
            decoration: const BoxDecoration(color: Colors.white),
          ),
          SizedBox(
            height: 50.h,
          ),
          Container(
            height: 15.h,
            width: 268.w,
            decoration: const BoxDecoration(color: Colors.white),
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            height: 15.h,
            width: 268.w,
            decoration: const BoxDecoration(color: Colors.white),
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            height: 15.h,
            width: 150.w,
            decoration: const BoxDecoration(color: Colors.white),
          ),
          SizedBox(
            height: 20.h,
          ),
          const ComPageShimmerCard(),
        ],
      ),
    );
  }
}

class MainCategorySimmerScreen extends StatelessWidget {
  const MainCategorySimmerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 30),
      child: ProductListVerticalShimmer(),
    );
  }
}

class ProductSimmerScreen extends StatelessWidget {
  const ProductSimmerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 330.h,
          width: double.infinity,
          decoration: const BoxDecoration(color: Colors.white),
        ),
        SizedBox(
          height: 44.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 20.h,
                width: 300.w,
                decoration: const BoxDecoration(color: Colors.white),
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                height: 20.h,
                width: 200.w,
                decoration: const BoxDecoration(color: Colors.white),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        Padding(
          padding: EdgeInsets.only(right: 15.w, left: 28.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 40.h,
                width: 100.w,
                decoration: const BoxDecoration(color: Colors.white),
              ),
              Container(
                height: 40.h,
                width: 100.w,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 15.h,
                width: 268.w,
                decoration: const BoxDecoration(color: Colors.white),
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                height: 15.h,
                width: 268.w,
                decoration: const BoxDecoration(color: Colors.white),
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                height: 15.h,
                width: 150.w,
                decoration: const BoxDecoration(color: Colors.white),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 30.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 20.h,
                width: 100.w,
                decoration: const BoxDecoration(color: Colors.white),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 12.h,
        ),
        const ProductListHShimmer(),
      ],
    );
  }
}

class RecipeSimmerScreen extends StatelessWidget {
  const RecipeSimmerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 330.h,
          width: double.infinity,
          decoration: const BoxDecoration(color: Colors.white),
        ),
        SizedBox(
          height: 44.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 20.h,
                width: 300.w,
                decoration: const BoxDecoration(color: Colors.white),
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                height: 20.h,
                width: 200.w,
                decoration: const BoxDecoration(color: Colors.white),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        Padding(
          padding: EdgeInsets.only(right: 15.w, left: 28.w),
          child: Row(
            children: [
              Container(
                height: 40.h,
                width: 100.w,
                decoration: const BoxDecoration(color: Colors.white),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 15.h,
                width: 268.w,
                decoration: const BoxDecoration(color: Colors.white),
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                height: 15.h,
                width: 268.w,
                decoration: const BoxDecoration(color: Colors.white),
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                height: 15.h,
                width: 150.w,
                decoration: const BoxDecoration(color: Colors.white),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 30.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 20.h,
                width: 100.w,
                decoration: const BoxDecoration(color: Colors.white),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 12.h,
        ),
        const ProductListHShimmer(),
      ],
    );
  }
}

class OrderCardShimmer extends StatelessWidget {
  const OrderCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).cardColor, width: 2)),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 15.h,
                    width: 100.w,
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Container(
                    height: 15.h,
                    width: 76.w,
                    color: Colors.white,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 15.h,
                    width: 100.w,
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Container(
                    height: 15.h,
                    width: 66.w,
                    color: Colors.white,
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 22.h,
          ),
          Container(
            height: 30.h,
            width: double.infinity,
            decoration: const BoxDecoration(color: Colors.white),
          ),
          SizedBox(
            height: 22.h,
          ),
          SizedBox(
            height: 220.h,
            child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return const ProductOrderCardShimmer();
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    color: kWhiteColor,
                  );
                },
                itemCount: 2),
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 15.h,
                width: 120.w,
                color: Colors.white,
              ),
              Container(
                height: 15.h,
                width: 60.w,
                color: Colors.white,
              ),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 15.h,
                width: 120.w,
                color: Colors.white,
              ),
              Container(
                height: 15.h,
                width: 60.w,
                color: Colors.white,
              ),
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          Container(
            height: 55.h,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: kBorderRadius5, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class OrderScreenShimmer extends StatelessWidget {
  const OrderScreenShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return const OrderCardShimmer();
        },
        separatorBuilder: (context, index) {
          return const Divider(
            color: kWhiteColor,
          );
        },
        itemCount: 3);
  }
}