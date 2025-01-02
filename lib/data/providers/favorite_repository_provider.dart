import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/data/providers/movie_repository_provider.dart';
import 'package:movie_app/data/repositories/firebase/favorite_repository.dart';

final favoriteRepositoryProvider = Provider<FavoriteRepository>(
  (ref) => FavoriteRepositoryImpl(
    ref.watch(movieRepositoryProvider),
  ),
);
