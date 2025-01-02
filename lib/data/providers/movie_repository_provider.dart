import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/data/providers/api_movie_client_provider.dart';
import 'package:movie_app/data/providers/session_repository_provider.dart';
import 'package:movie_app/data/repositories/api/movie/movie_repository.dart';

final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  return MovieRepositoryImpl(
    ref.watch(apiPostClientProvider),
    ref.watch(sessionRepositoryProvider),
  );
});
