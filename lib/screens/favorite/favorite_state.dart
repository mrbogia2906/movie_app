import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_app/data/models/api/responses/movie/movie.dart';

part 'favorite_state.freezed.dart';

@freezed
class FavoriteState with _$FavoriteState {
  factory FavoriteState({
    @Default([]) List<Movie> favoriteList,
  }) = _FavoriteState;

  const FavoriteState._();
}
