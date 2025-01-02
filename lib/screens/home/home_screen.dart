import 'dart:async';

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/components/base_view/base_view.dart';
import 'package:movie_app/components/loading/container_with_loading.dart';
import 'package:movie_app/data/providers/movie_repository_provider.dart';
import 'package:movie_app/data/providers/secure_storage_provider.dart';
import 'package:movie_app/data/providers/session_repository_provider.dart';
import 'package:movie_app/resources/app_text_styles.dart';
import 'package:movie_app/resources/gen/colors.gen.dart';
import 'package:movie_app/router/app_router.dart';
import 'package:movie_app/screens/home/components/movie_carousel_slider.dart';
import 'package:movie_app/screens/home/components/movie_item.dart';
import 'package:movie_app/screens/home/components/treding_section.dart';
import 'package:movie_app/screens/home/home_state.dart';
import 'package:movie_app/screens/home/home_view_model.dart';
import 'package:movie_app/utilities/constants/text_constants.dart';

final _provider = StateNotifierProvider.autoDispose<HomeViewModel, HomeState>(
  (ref) => HomeViewModel(
    ref: ref,
    movieRepository: ref.watch(movieRepositoryProvider),
    sessionRepository: ref.watch(sessionRepositoryProvider),
    secureStorageManager: ref.watch(secureStorageProvider),
  ),
);

@RoutePage()
class HomeScreen extends BaseView {
  const HomeScreen({super.key});

  @override
  BaseViewState<HomeScreen, HomeViewModel> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseViewState<HomeScreen, HomeViewModel>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  HomeState get state => ref.watch(_provider);

  @override
  Future<void> onInitState() async {
    super.onInitState();

    _tabController = TabController(length: 2, vsync: this);

    await Future.delayed(Duration.zero, () async {
      await _onInitData();
    });
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Widget buildBody(BuildContext context) {
    final trendingMovies = state.movieListTrending[TrendingType.day] ?? [];
    return ContainerWithLoading(
      child: RefreshIndicator(
        onRefresh: _refreshMovies,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: trendingMovies.isNotEmpty
                  ? MovieCarouselSlider(movies: trendingMovies)
                  : const SizedBox(
                      height: 250,
                    ),
            ),
            TrendingSection(
              tabController: _tabController,
              movieListTrending: state.movieListTrending,
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 0, 16),
                    child: Text(
                      TextConstants.topRated,
                      style: AppTextStyles.s24w700.copyWith(
                        color: ColorName.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 320,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.movieTopRated.length,
                      itemBuilder: (context, index) {
                        final movie = state.movieTopRated[index];
                        return MovieItem(movie: movie);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshMovies() async {
    await viewModel.initData();
  }

  @override
  bool get tapOutsideToDismissKeyBoard => true;

  @override
  String get screenName => HomeRoute.name;

  @override
  HomeViewModel get viewModel => ref.read(_provider.notifier);

  Future<void> _onInitData() async {
    await onLoading(viewModel.initData);
  }
}
