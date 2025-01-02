import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/components/base_view/base_view_model.dart';
import 'package:movie_app/data/repositories/api/movie/movie_repository.dart';
import 'package:movie_app/data/repositories/api/session/session_repository.dart';
import 'package:movie_app/data/services/api/secure_storage/secure_storage_manager.dart';
import 'package:movie_app/screens/home/home_state.dart';

class HomeViewModel extends BaseViewModel<HomeState> {
  HomeViewModel({
    required this.ref,
    required this.movieRepository,
    required this.sessionRepository,
    required this.secureStorageManager,
  }) : super(const HomeState());

  final Ref ref;

  final MovieRepository movieRepository;

  final SessionRepository sessionRepository;

  final SecureStorageManager secureStorageManager;

  Future<void> initData() async {
    await Future.wait([
      _getTrendingMovies(),
      _getTopRatedMovies(),
    ]);
  }

  Future<void> _getTrendingMovies() async {
    final hasCachedMovies = await _getCachedMovies();
    if (hasCachedMovies) {
      unawaited(_getTrendingMoviesRespone());
    } else {
      await _getTrendingMoviesRespone();
    }
  }

  Future<bool> _getCachedMovies() async {
    var movieListDay = sessionRepository.movieListDay();
    var movieListWeek = sessionRepository.movieListWeek();

    state = state.copyWith(
      movieListTrending: {
        TrendingType.day: movieListDay,
        TrendingType.week: movieListWeek,
      },
    );

    return movieListDay.isEmpty && movieListWeek.isEmpty;
  }

  Future<void> _getTrendingMoviesRespone() async {
    final movieListDay = await movieRepository.getTrendingMoviesDay();
    final movieListWeek = await movieRepository.getTrendingMoviesWeek();

    state = state.copyWith(
      movieListTrending: {
        TrendingType.day: movieListDay,
        TrendingType.week: movieListWeek,
      },
    );
  }

  Future<void> _getTopRatedMovies() async {
    final movieTopRated = await movieRepository.getTopRatedMovies();

    state = state.copyWith(movieTopRated: movieTopRated);
  }
}
