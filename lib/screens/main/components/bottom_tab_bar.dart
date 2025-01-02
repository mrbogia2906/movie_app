import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:movie_app/resources/gen/colors.gen.dart';
import 'package:movie_app/screens/main/components/tab_item.dart';
import 'package:movie_app/screens/main/models/main_tab.dart';

class BottomTabBar extends StatelessWidget {
  const BottomTabBar({
    required this.tabsRouter,
    super.key,
  });

  final TabsRouter tabsRouter;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: ColorName.grayFFFAFAFA,
      child: Row(
        children: [
          MainTab.home,
          MainTab.favorite,
          MainTab.search,
          MainTab.setting,
        ].map((tab) {
          return Flexible(
            child: TabItem(
              mainTab: tab,
              isActive: tab.index == tabsRouter.activeIndex,
              onTap: () => tabsRouter.setActiveIndex(tab.index),
            ),
          );
        }).toList(),
      ),
    );
  }
}
