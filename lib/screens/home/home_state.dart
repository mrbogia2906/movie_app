import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_app/data/models/api/responses/movie/movie.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default([]) List<Movie> movieTopRated,
    @Default({}) Map<TrendingType, List<Movie>> movieListTrending,
  }) = _HomeState;

  const HomeState._();
}

enum TrendingType {
  day,
  week,
}
