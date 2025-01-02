import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_app/data/models/api/responses/movie/movie.dart';

part 'search_state.freezed.dart';

@freezed
class SearchState with _$SearchState {
  factory SearchState({
    @Default([]) List<Movie> topRatedMovies,
    @Default([]) List<Movie> searchResults,
    @Default('') String searchQuery,
    @Default([]) List<String> searchQueryHistory,
    @Default([]) List<Genre> genres,
  }) = _SearchState;

  const SearchState._();
}
