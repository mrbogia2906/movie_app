import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/components/base_view/base_view.dart';
import 'package:movie_app/components/images/profile_avatar.dart';
import 'package:movie_app/components/loading/container_with_loading.dart';
import 'package:movie_app/data/providers/auth_repository_provider.dart';
import 'package:movie_app/data/providers/favorite_repository_provider.dart';
import 'package:movie_app/resources/app_text_styles.dart';
import 'package:movie_app/resources/gen/colors.gen.dart';
import 'package:movie_app/router/app_router.dart';
import 'package:movie_app/screens/favorite/favorite_state.dart';
import 'package:movie_app/screens/favorite/favorite_view_model.dart';
import 'package:movie_app/utilities/constants/app_constants.dart';
import 'package:movie_app/utilities/constants/text_constants.dart';

final _provider =
    StateNotifierProvider.autoDispose<FavoriteViewModel, FavoriteState>(
  (ref) => FavoriteViewModel(
    ref: ref,
    favoriteRepository: ref.watch(favoriteRepositoryProvider),
    authRepository: ref.watch(authRepositoryProvider),
  ),
);

@RoutePage()
class FavoriteScreen extends BaseView {
  const FavoriteScreen({super.key});

  @override
  BaseViewState<FavoriteScreen, FavoriteViewModel> createState() =>
      _FavoriteScreenState();
}

class _FavoriteScreenState
    extends BaseViewState<FavoriteScreen, FavoriteViewModel> {
  FavoriteState get state => ref.watch(_provider);

  @override
  Future<void> onInitState() async {
    super.onInitState();
    await Future.delayed(Duration.zero, () async {
      await _onInitData();
    });
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => AppBar(
        title: Text(
          TextConstants.favorite,
          style: AppTextStyles.s22w700,
        ),
        centerTitle: true,
        backgroundColor: ColorName.white,
      );

  @override
  Widget buildBody(BuildContext context) {
    return ContainerWithLoading(
      child: GridView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: state.favoriteList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
          final movie = state.favoriteList[index];
          return Stack(
            children: [
              GestureDetector(
                onTap: () {
                  context.router.push(
                    MovieDetailRoute(movieId: movie.id!),
                  );
                },
                child: ProfileAvatar(
                  imageUrl:
                      '${AppConstants.imageW600AndH900}${movie.posterPath}',
                  width: double.infinity,
                  height: 250,
                  radius: 12,
                ),
              ),
              GestureDetector(
                onTap: () {
                  viewModel.removeFavorite(movie.id!);
                },
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.5),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  String get screenName => FavoriteRoute.name;

  @override
  FavoriteViewModel get viewModel => ref.read(_provider.notifier);

  Future<void> _onInitData() async {
    await onLoading(viewModel.initData);
  }
}
