import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_app/data/models/api/responses/movie/movie.dart';
import 'package:movie_app/data/repositories/api/movie/movie_repository.dart';

abstract class FavoriteRepository {
  Future<void> addFavorite(
    String userId,
    int movieId,
  );

  Stream<List<Movie>> getFavorites(String userId);

  Future<void> removeFavorite(String userId, int movieId);

  Future<bool> isFavorite(String userId, int movieId);
}

class FavoriteRepositoryImpl implements FavoriteRepository {
  FavoriteRepositoryImpl(this._movieRepository);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final MovieRepository _movieRepository;

  @override
  Future<void> addFavorite(
    String userId,
    int movieId,
  ) async {
    await _firestore
        .collection('user')
        .doc(userId)
        .collection('favorites')
        .doc(movieId.toString())
        .set({
      'id': movieId,
    });
  }

  @override
  Stream<List<Movie>> getFavorites(String userId) {
    return _firestore
        .collection('user')
        .doc(userId)
        .collection('favorites')
        .snapshots()
        .asyncMap((snapshot) async {
      var movies = <Movie>[];
      for (var doc in snapshot.docs) {
        int movieId = doc.data()['id'];
        var movie = await _movieRepository.getMovieDetails(movieId);
        movies.add(movie);
      }
      return movies;
    });
  }

  @override
  Future<void> removeFavorite(String userId, int movieId) async {
    QuerySnapshot query = await _firestore
        .collection('user')
        .doc(userId)
        .collection('favorites')
        .where('id', isEqualTo: movieId)
        .get();
    for (var doc in query.docs) {
      await doc.reference.delete();
    }
  }

  @override
  Future<bool> isFavorite(String userId, int movieId) async {
    QuerySnapshot query = await _firestore
        .collection('user')
        .doc(userId)
        .collection('favorites')
        .where('id', isEqualTo: movieId)
        .get();
    return query.docs.isNotEmpty;
  }
}
