import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/components/base_view/base_view.dart';
import 'package:movie_app/components/images/profile_avatar.dart';
import 'package:movie_app/components/loading/container_with_loading.dart';
import 'package:movie_app/data/models/api/responses/movie/movie.dart';
import 'package:movie_app/data/providers/auth_repository_provider.dart';
import 'package:movie_app/data/providers/movie_repository_provider.dart';
import 'package:movie_app/data/providers/search_repository_provider.dart';
import 'package:movie_app/resources/app_text_styles.dart';
import 'package:movie_app/router/app_router.dart';
import 'package:movie_app/screens/search/search_state.dart';
import 'package:movie_app/screens/search/search_view_model.dart';
import 'package:movie_app/utilities/constants/app_constants.dart';
import 'package:movie_app/utilities/constants/text_constants.dart';

final _provider =
    StateNotifierProvider.autoDispose<SearchViewModel, SearchState>(
  (ref) => SearchViewModel(
    ref: ref,
    movieRepository: ref.watch(movieRepositoryProvider),
    searchRepository: ref.watch(searchHistoryProvider),
    authRepository: ref.watch(authRepositoryProvider),
  ),
);

@RoutePage()
class SearchScreen extends BaseView {
  const SearchScreen({super.key});

  @override
  BaseViewState<SearchScreen, SearchViewModel> createState() =>
      _SearchScreenState();
}

class _SearchScreenState extends BaseViewState<SearchScreen, SearchViewModel> {
  final _searchController = TextEditingController();

  SearchState get state => ref.watch(_provider);

  @override
  Future<void> onInitState() async {
    super.onInitState();
    await Future.delayed(Duration.zero, _onInitData);
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Widget buildBody(BuildContext context) {
    return ContainerWithLoading(
      child: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: state.searchQuery.isEmpty
                ? _buildSearchHistory(context)
                : _buildMovieList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: TextConstants.search,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: state.searchQuery.isEmpty
              ? const SizedBox.shrink()
              : IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    viewModel.setSearchQuery('');
                    viewModel.setSearchResults();
                  },
                ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        onChanged: (value) {
          viewModel.setSearchQuery(value);
          viewModel.searchMovies(value);
        },
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        onSubmitted: (value) {
          viewModel.addSearchHistory(value);
          viewModel.searchMovies(value);
        },
      ),
    );
  }

  Widget _buildSearchHistory(BuildContext context) {
    return ListView.builder(
      itemCount: state.searchQueryHistory.length,
      itemBuilder: (context, index) {
        final searchHistory = state.searchQueryHistory[index];
        return Dismissible(
          key: Key(searchHistory),
          direction: DismissDirection.endToStart,
          dismissThresholds: const {DismissDirection.endToStart: 0.3},
          onDismissed: (direction) {
            viewModel.deleteSearchHistory(searchHistory);
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20.0),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          child: ListTile(
            title: Text(searchHistory),
            leading: const Icon(Icons.history, color: Colors.black),
            onTap: () async {
              _searchController.text = searchHistory;
              viewModel.setSearchQuery(searchHistory);
              await loading.whileLoading(
                context,
                () async {
                  await Future.delayed(const Duration(milliseconds: 500));
                  await viewModel.searchMovies(searchHistory);
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildMovieList() {
    if (state.searchResults.isEmpty) {
      if (state.searchQuery.isNotEmpty) {
        return const SizedBox.shrink();
      } else {
        return Center(
          child: Text(
            TextConstants.noFound,
            style: AppTextStyles.s18w700,
          ),
        );
      }
    }
    return ListView.builder(
      itemCount: state.searchResults.length,
      itemBuilder: (context, index) {
        final movie = state.searchResults[index];
        return _buildMovieCard(movie);
      },
    );
  }

  Widget _buildMovieCard(Movie movie) {
    return GestureDetector(
      onTap: () => context.router.push(MovieDetailRoute(movieId: movie.id!)),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ProfileAvatar(
                imageUrl: movie.posterPath != null
                    ? '${AppConstants.imageW600AndH900}${movie.posterPath}'
                    : '',
                width: 100,
                height: 150,
                radius: 0,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title ?? '',
                      style: AppTextStyles.s18w700,
                    ),
                    const Text(TextConstants.sampleYear),
                    const Text(TextConstants.sampleDuration),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                TextConstants.sampleScore,
                style: AppTextStyles.s18w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get tapOutsideToDismissKeyBoard => true;

  @override
  String get screenName => SearchRoute.name;

  @override
  SearchViewModel get viewModel => ref.read(_provider.notifier);

  Future<void> _onInitData() async {
    await onLoading(viewModel.initData);
  }
}
