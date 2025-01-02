import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/components/base_view/base_view_model.dart';
import 'package:movie_app/data/repositories/firebase/auth_repository.dart';
import 'package:movie_app/data/repositories/firebase/favorite_repository.dart';
import 'package:movie_app/screens/favorite/favorite_state.dart';

import '../../data/models/api/responses/movie/movie.dart';

class FavoriteViewModel extends BaseViewModel<FavoriteState> {
  FavoriteViewModel({
    required this.ref,
    required this.favoriteRepository,
    required this.authRepository,
  }) : super(FavoriteState());

  Ref ref;

  FavoriteRepository favoriteRepository;

  AuthRepository authRepository;

  StreamSubscription<List<Movie>>? _favoritesSubscription;

  @override
  void dispose() {
    _favoritesSubscription?.cancel();
    super.dispose();
  }

  Future<void> initData() async {
    _listenAllFavoriteChanges();
  }

  void _listenAllFavoriteChanges() {
    final userId = authRepository.getCurrentUserId();
    _favoritesSubscription =
        favoriteRepository.getFavorites(userId).listen((movies) {
      state = state.copyWith(favoriteList: movies);
    }, onError: (error) {
      debugPrint('Error listening to favorites: $error');
      _favoritesSubscription?.cancel();
    });
  }

  Future<void> removeFavorite(int movieId) async {
    await favoriteRepository.removeFavorite(
      authRepository.getCurrentUserId(),
      movieId,
    );
  }
}
