import 'package:flutter/material.dart';
import 'package:movie_app/resources/app_text_styles.dart';
import 'package:movie_app/resources/gen/colors.gen.dart';
import 'package:movie_app/screens/home/models/trending_tab.dart';

class TrendingTabBar extends StatelessWidget {
  const TrendingTabBar({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 210,
      decoration: BoxDecoration(
        border: Border.all(color: ColorName.black),
        borderRadius: BorderRadius.circular(32),
      ),
      child: TabBar(
        splashFactory: NoSplash.splashFactory,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: ColorName.darkblue,
        ),
        labelStyle: AppTextStyles.s14w700.copyWith(
          color: ColorName.lightblue,
        ),
        labelColor: ColorName.lightblue,
        unselectedLabelStyle: AppTextStyles.s14w700.copyWith(
          color: ColorName.darkblue,
        ),
        indicatorColor: Colors.transparent,
        dividerHeight: 0,
        controller: controller,
        tabs: TrendingTab.values
            .map((tab) => Tab(text: tab.getLabel(context)))
            .toList(),
      ),
    );
  }
}
