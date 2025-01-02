import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/screens/cast_detail/cast_screen.dart';
import 'package:movie_app/screens/favorite/favorite_screen.dart';
import 'package:movie_app/screens/home/home_screen.dart';
import 'package:movie_app/screens/login/login_screen.dart';
import 'package:movie_app/screens/main/main_screen.dart';
import 'package:movie_app/screens/movie_detail/movie_detail_screen.dart';
import 'package:movie_app/screens/register/register_screen.dart';
import 'package:movie_app/screens/search/search_screen.dart';
import 'package:movie_app/screens/setting/setting_screen.dart';
import 'package:movie_app/screens/splash/splash_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: SplashRoute.page,
          path: '/',
        ),
        AutoRoute(
          page: LoginRoute.page,
          path: '/login',
        ),
        AutoRoute(
          page: RegisterRoute.page,
          path: '/register',
        ),
        AutoRoute(
          page: MainRoute.page,
          path: '/main',
          children: [
            AutoRoute(
              page: HomeTabRoute.page,
              path: 'homeTab',
              children: [
                AutoRoute(
                  page: HomeRoute.page,
                  path: '',
                ),
              ],
            ),
            AutoRoute(
              page: FavoriteTabRoute.page,
              path: 'favoriteTab',
              children: [
                AutoRoute(
                  page: FavoriteRoute.page,
                  path: '',
                ),
              ],
            ),
            AutoRoute(
              page: SearchTabRoute.page,
              path: 'searchTab',
              children: [
                AutoRoute(
                  page: SearchRoute.page,
                  path: '',
                ),
              ],
            ),
            AutoRoute(
              page: SettingTabRoute.page,
              path: 'settingTab',
              children: [
                AutoRoute(
                  page: SettingRoute.page,
                  path: '',
                ),
              ],
            ),
          ],
        ),
        AutoRoute(
          page: MovieDetailRoute.page,
          path: '/movieDetail',
        ),
        AutoRoute(
          page: CastRoute.page,
          path: '/cast/:castId',
        ),
      ];
}

@RoutePage(name: 'HomeTabRoute')
class HomeTabPage extends AutoRouter {
  const HomeTabPage({super.key});
}

@RoutePage(name: 'FavoriteTabRoute')
class FavoriteTabPage extends AutoRouter {
  const FavoriteTabPage({super.key});
}

@RoutePage(name: 'SettingTabRoute')
class SettingTabPage extends AutoRouter {
  const SettingTabPage({super.key});
}

@RoutePage(name: 'SearchTabRoute')
class SearchTabPage extends AutoRouter {
  const SearchTabPage({super.key});
}
