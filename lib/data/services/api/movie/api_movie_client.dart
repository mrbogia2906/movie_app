import 'package:dio/dio.dart';
import 'package:movie_app/data/models/api/responses/cast/cast.dart';
import 'package:movie_app/data/models/api/responses/movie/movie.dart';
import 'package:movie_app/data/models/api/responses/trailer/trailer.dart';
import 'package:retrofit/retrofit.dart';

part 'api_movie_client.g.dart';

@RestApi(baseUrl: 'https://api.themoviedb.org/3/')
abstract class ApiMovieClient {
  factory ApiMovieClient(Dio dio, {String baseUrl}) = _ApiMovieClient;

  @GET('movie/{movie_id}')
  Future<Movie> getMovieDetails(
    @Path('movie_id') int movieId,
    @Query('api_key') String apiKey,
  );

  @GET('movie/{movie_id}/videos')
  Future<TrailerRespone> getMovieVideos(
    @Path('movie_id') int movieId,
    @Query('api_key') String apiKey,
  );

  @GET('movie/{movie_id}/credits')
  Future<CastRespone> getMovieCredits(
    @Path('movie_id') int movieId,
    @Query('api_key') String apiKey,
  );

  @GET('trending/movie/{time_window}')
  Future<MovieResponse> getTrendingMovies(
    @Path('time_window') String timeWindow,
    @Query('api_key') String apiKey,
  );

  @GET('person/{person_id}')
  Future<Cast> getPersonDetails(
    @Path('person_id') int personId,
    @Query('api_key') String apiKey,
  );

  @GET('movie/{movie_id}/recommendations')
  Future<MovieResponse> getRecommendations(
    @Path('movie_id') int movieId,
    @Query('api_key') String apiKey,
  );

  @GET('search/movie')
  Future<MovieResponse> searchMovies(
    @Query('query') String query,
    @Query('api_key') String apiKey,
  );

  @GET('movie/top_rated')
  Future<MovieResponse> getTopRatedMovies(
    @Query('api_key') String apiKey,
  );

  @GET('movie/{movie_id}')
  Future<Movie> getMovieDetail(
    @Path('movie_id') int movieId,
    @Query('api_key') String apiKey,
    @Query('append_to_response') String appendToResponse,
  );

  @GET('/person/{person_id}')
  Future<Cast> getPersonDetail(
    @Path('person_id') int personId,
    @Query('api_key') String apiKey,
  );
}
