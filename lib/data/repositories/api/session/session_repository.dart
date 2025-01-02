import 'package:movie_app/data/models/api/responses/cast/cast.dart';
import 'package:movie_app/data/models/api/responses/movie/movie.dart';
import 'package:movie_app/data/models/api/responses/trailer/trailer.dart';

abstract class SessionRepository {
  List<Movie> movieListDay();
  void saveMovieList(List<Movie> movieList);

  List<Movie> movieListWeek();
  void saveMovieListWeek(List<Movie> movieList);

  List<Movie> topRatedMovies();
  void saveTopRatedMovies(List<Movie> topRatedMovies);

  Movie? movieDetail(int movieId);
  void saveMovieDetail(Movie movie);

  List<Cast>? movieCredits(int movieId);
  void saveMovieCredits(int movieId, List<Cast> castList);

  List<Movie>? movieRecommendations(int movieId);
  void saveMovieRecommendations(int movieId, List<Movie> movieList);

  Trailer? movieTrailer(int movieId);
  void saveMovieTrailer(int movieId, Trailer trailer);
}

class SessionRepositoryImpl implements SessionRepository {
  List<Movie> _movieList = [];
  List<Movie> _movieListWeek = [];
  List<Movie> _topRatedMovies = [];
  final Map<int, Movie> _movieDetails = {};
  final Map<int, List<Cast>> _movieCredits = {};
  final Map<int, List<Movie>> _movieRecommendations = {};
  final Map<int, Trailer> _movieTrailers = {};

  @override
  List<Movie> movieListDay() {
    return _movieList;
  }

  @override
  void saveMovieList(List<Movie> movieList) {
    _movieList = movieList;
  }

  @override
  List<Movie> movieListWeek() {
    return _movieListWeek;
  }

  @override
  void saveMovieListWeek(List<Movie> movieListWeek) {
    _movieListWeek = movieListWeek;
  }

  @override
  Movie? movieDetail(int movieId) {
    return _movieDetails[movieId];
  }

  @override
  void saveMovieDetail(Movie movie) {
    _movieDetails[movie.id!] = movie;
  }

  @override
  List<Movie> topRatedMovies() {
    return _topRatedMovies;
  }

  @override
  void saveTopRatedMovies(List<Movie> topRatedMovies) {
    _topRatedMovies = topRatedMovies;
  }

  @override
  List<Cast>? movieCredits(int movieId) {
    return _movieCredits[movieId];
  }

  @override
  void saveMovieCredits(int moviedId, List<Cast> castList) {
    _movieCredits[moviedId] = castList;
  }

  @override
  List<Movie>? movieRecommendations(int movieId) {
    return _movieRecommendations[movieId];
  }

  @override
  void saveMovieRecommendations(int movieId, List<Movie> movieList) {
    _movieRecommendations[movieId] = movieList;
  }

  @override
  Trailer? movieTrailer(int movieId) {
    return _movieTrailers[movieId];
  }

  @override
  void saveMovieTrailer(int movieId, Trailer trailer) {
    _movieTrailers[movieId] = trailer;
  }
}
