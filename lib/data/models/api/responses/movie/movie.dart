import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_app/data/models/api/responses/user_comment/user_comment.dart';

part 'movie.g.dart';
part 'movie.freezed.dart';

@freezed
class MovieResponse with _$MovieResponse {
  const factory MovieResponse({
    @JsonKey(name: 'page') required int page,
    @JsonKey(name: 'results') required List<Movie> results,
    @JsonKey(name: 'total_pages') required int totalPages,
    @JsonKey(name: 'total_results') required int totalResults,
  }) = _MovieResponse;

  factory MovieResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieResponseFromJson(json);
}

@freezed
class Movie with _$Movie {
  const factory Movie({
    @JsonKey(name: 'adult') bool? adult,
    @JsonKey(name: 'backdrop_path') String? backdropPath,
    @JsonKey(name: 'belongs_to_collection') dynamic belongsToCollection,
    @JsonKey(name: 'budget') int? budget,
    @JsonKey(name: 'genres') List<Genre>? genres,
    @JsonKey(name: 'homepage') String? homepage,
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'imdb_id') String? imdbId,
    @JsonKey(name: 'original_language') String? originalLanguage,
    @JsonKey(name: 'original_title') String? originalTitle,
    @JsonKey(name: 'overview') String? overview,
    @JsonKey(name: 'popularity') double? popularity,
    @JsonKey(name: 'poster_path') String? posterPath,
    @JsonKey(name: 'release_date') String? releaseDate,
    @JsonKey(name: 'revenue') int? revenue,
    @JsonKey(name: 'runtime') int? runtime,
    @JsonKey(name: 'spoken_languages') List<SpokenLanguage>? spokenLanguages,
    @JsonKey(name: 'status') String? status,
    @JsonKey(name: 'tagline') String? tagline,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'video') bool? video,
    @JsonKey(name: 'vote_average') double? voteAverage,
    @JsonKey(name: 'vote_count') int? voteCount,
    @JsonKey(name: 'listUserCommented') List<UserComment>? listUserCommented,
  }) = _Movie;

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
}

@freezed
class Genre with _$Genre {
  const factory Genre({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'name') required String name,
  }) = _Genre;

  factory Genre.fromJson(Map<String, dynamic> json) => _$GenreFromJson(json);
}

@freezed
class SpokenLanguage with _$SpokenLanguage {
  const factory SpokenLanguage({
    @JsonKey(name: 'english_name') required String englishName,
    @JsonKey(name: 'iso_639_1') required String iso6391,
    @JsonKey(name: 'name') required String name,
  }) = _SpokenLanguage;

  factory SpokenLanguage.fromJson(Map<String, dynamic> json) =>
      _$SpokenLanguageFromJson(json);
}
