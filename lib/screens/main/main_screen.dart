import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/components/base_view/base_view.dart';
import 'package:movie_app/router/app_router.dart';
import 'package:movie_app/screens/main/components/bottom_tab_bar.dart';
import 'package:movie_app/screens/main/main_view_model.dart';

final mainProvider =
    StateNotifierProvider.autoDispose((ref) => MainViewModel());

/// Screen code: A_02
@RoutePage()
class MainScreen extends BaseView {
  const MainScreen({
    super.key,
  });

  @override
  BaseViewState<MainScreen, MainViewModel> createState() => _MainViewState();
}

class _MainViewState extends BaseViewState<MainScreen, MainViewModel> {
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Widget buildBody(BuildContext context) {
    return AutoTabsScaffold(
      routes: const [
        HomeTabRoute(),
        FavoriteTabRoute(),
        SearchRoute(),
        SettingTabRoute(),
      ],
      resizeToAvoidBottomInset: true,
      bottomNavigationBuilder: (context, tabsRouter) {
        return BottomTabBar(tabsRouter: tabsRouter);
      },
    );
  }

  @override
  bool get ignoreSafeAreaBottom => true;

  @override
  String get screenName => MainRoute.name;

  @override
  MainViewModel get viewModel => ref.read(mainProvider.notifier);
}
