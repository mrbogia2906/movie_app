import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_app/data/models/api/responses/cast/cast.dart';
import 'package:movie_app/data/models/api/responses/movie/movie.dart';
import 'package:movie_app/data/models/api/responses/trailer/trailer.dart';
import 'package:movie_app/data/models/api/responses/user_comment/user_comment.dart';

part 'movie_detail_state.freezed.dart';

@freezed
class MovieDetailState with _$MovieDetailState {
  const factory MovieDetailState({
    @Default(Movie()) Movie movie,
    @Default([]) List<Cast> castList,
    @Default(Trailer()) Trailer trailer,
    @Default(true) bool isShowTitle,
    @Default([]) List<Movie> recommendations,
    @Default(false) bool isFavorite,
    String? cachedVideoPath,
    @Default(false) bool isShowComment,
    @Default([]) List<UserComment> commentList,
    @Default([]) List<UserComment> topTwoComments,
    @Default(false) bool isLandScape,
  }) = _MovieDetailState;

  const MovieDetailState._();
}
