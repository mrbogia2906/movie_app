import 'package:flutter/foundation.dart';
import 'package:movie_app/api_key.dart';
import 'package:movie_app/data/models/api/responses/cast/cast.dart';
import 'package:movie_app/data/models/api/responses/movie/movie.dart';
import 'package:movie_app/data/models/api/responses/trailer/trailer.dart';
import 'package:movie_app/data/repositories/api/session/session_repository.dart';
import 'package:movie_app/data/services/api/movie/api_movie_client.dart';

abstract class MovieRepository {
  Future<List<Movie>> getTrendingMoviesDay();
  Future<List<Movie>> getTrendingMoviesWeek();
  Future<Movie> getMovieDetails(int movieId);
  Future<List<Cast>> getMovieCredits(int movieId);
  Future<Trailer> getMovieTrailer(int movieId);
  Future<List<Movie>> getRecommendations(int movieId);
  Future<List<Movie>> searchMovies(String query);
  Future<List<Movie>> getTopRatedMovies();
  Future<Cast> getCastDetails(int personId);
}

class MovieRepositoryImpl implements MovieRepository {
  MovieRepositoryImpl(
    this._apiMovieClient,
    this._sessionRepository,
  );

  final ApiMovieClient _apiMovieClient;
  final SessionRepository _sessionRepository;

  @override
  Future<List<Movie>> getTrendingMoviesDay() async {
    try {
      final movieResponse = await _apiMovieClient.getTrendingMovies(
        'day',
        tmdbApiKey,
      );

      final movieList = movieResponse.results;

      return movieList;
    } catch (e) {
      debugPrint('Error getting trending movies: $e');
      rethrow;
    }
  }

  @override
  Future<List<Movie>> getTrendingMoviesWeek() async {
    try {
      final movieResponseWeek = await _apiMovieClient.getTrendingMovies(
        'week',
        tmdbApiKey,
      );
      final movieListWeek = movieResponseWeek.results;

      return movieListWeek;
    } catch (e) {
      debugPrint('Error getting trending movies: $e');
      rethrow;
    }
  }

  @override
  Future<Movie> getMovieDetails(int movieId) async {
    final sessionMovie = _sessionRepository.movieDetail(movieId);
    if (sessionMovie != null) {
      return sessionMovie;
    }
    try {
      final movie = await _apiMovieClient.getMovieDetails(
        movieId,
        tmdbApiKey,
      );

      _sessionRepository.saveMovieDetail(movie);
      return movie;
    } catch (e) {
      debugPrint('Error getting movie details: $e');
      rethrow;
    }
  }

  @override
  Future<List<Cast>> getMovieCredits(int movieId) async {
    final sessionCredits = _sessionRepository.movieCredits(movieId);
    if (sessionCredits != null) {
      return sessionCredits;
    }
    try {
      final credits = await _apiMovieClient.getMovieCredits(
        movieId,
        tmdbApiKey,
      );

      final castList = credits.cast;

      _sessionRepository.saveMovieCredits(movieId, castList);

      return castList;
    } catch (e) {
      debugPrint('Error getting movie credits: $e');
      rethrow;
    }
  }

  @override
  Future<Trailer> getMovieTrailer(int movieId) async {
    final sessionTrailer = _sessionRepository.movieTrailer(movieId);
    if (sessionTrailer != null) {
      return sessionTrailer;
    }
    try {
      final trailerRespone = await _apiMovieClient.getMovieVideos(
        movieId,
        tmdbApiKey,
      );

      final trailer = trailerRespone.results.lastWhere(
        (element) => element.type == 'Trailer',
        orElse: () => throw Exception('Trailer not found'),
      );

      _sessionRepository.saveMovieTrailer(movieId, trailer);

      return trailer;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting movie trailer: $e');
      }
      rethrow;
    }
  }

  @override
  Future<List<Movie>> getRecommendations(int movieId) async {
    final sessionRecommendations =
        _sessionRepository.movieRecommendations(movieId);
    if (sessionRecommendations != null) {
      return sessionRecommendations;
    }
    try {
      final recommendations = await _apiMovieClient.getRecommendations(
        movieId,
        tmdbApiKey,
      );

      final movieList = recommendations.results;

      _sessionRepository.saveMovieRecommendations(movieId, movieList);

      return movieList;
    } catch (e) {
      debugPrint('Error getting recommendations: $e');
      rethrow;
    }
  }

  @override
  Future<List<Movie>> searchMovies(String query) async {
    try {
      final searchResponse = await _apiMovieClient.searchMovies(
        query,
        tmdbApiKey,
      );

      final movieList = searchResponse.results;

      return movieList;
    } catch (e) {
      debugPrint('Error searching movies: $e');
      rethrow;
    }
  }

  @override
  Future<List<Movie>> getTopRatedMovies() async {
    try {
      final topRatedMovies = await _apiMovieClient.getTopRatedMovies(
        tmdbApiKey,
      );

      final movieList = topRatedMovies.results;

      _sessionRepository.saveTopRatedMovies(movieList);

      return movieList;
    } catch (e) {
      debugPrint('Error getting top rated movies: $e');
      rethrow;
    }
  }

  @override
  Future<Cast> getCastDetails(int personId) async {
    try {
      final person = await _apiMovieClient.getPersonDetails(
        personId,
        tmdbApiKey,
      );

      return person;
    } catch (e) {
      debugPrint('Error getting person details: $e');
      rethrow;
    }
  }
}
