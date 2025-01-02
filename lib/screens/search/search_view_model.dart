import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/components/base_view/base_view_model.dart';
import 'package:movie_app/data/repositories/api/movie/movie_repository.dart';
import 'package:movie_app/data/repositories/firebase/auth_repository.dart';
import 'package:movie_app/data/repositories/firebase/search_repository.dart';
import 'package:movie_app/screens/search/search_state.dart';

class SearchViewModel extends BaseViewModel<SearchState> {
  SearchViewModel({
    required this.ref,
    required this.movieRepository,
    required this.searchRepository,
    required this.authRepository,
  }) : super(SearchState());

  final Ref ref;

  final MovieRepository movieRepository;

  final AuthRepository authRepository;

  final SearchRepository searchRepository;

  Future<void> initData() async {
    await _getSearchHistory();
  }

  Future<void> _getSearchHistory() async {
    final searchHistory = await searchRepository
        .getSearchHistory(authRepository.getCurrentUserId());
    state = state.copyWith(searchQueryHistory: searchHistory);
  }

  Future<void> addSearchHistory(String query) async {
    await searchRepository.addSearchHistory(
      authRepository.getCurrentUserId(),
      query,
    );
    await _getSearchHistory();
  }

  Future<void> searchMovies(String query) async {
    final movies = await movieRepository.searchMovies(query);
    state = state.copyWith(searchResults: movies);
  }

  Future<void> deleteSearchHistory(String searchHistory) async {
    await searchRepository.deleteSearchHistory(
      authRepository.getCurrentUserId(),
      searchHistory,
    );
    await _getSearchHistory();
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setSearchResults() {
    state = state.copyWith(searchResults: []);
  }
}
