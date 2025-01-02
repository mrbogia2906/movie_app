import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/data/repositories/firebase/search_repository.dart';

final searchHistoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepositoryImpl();
});
