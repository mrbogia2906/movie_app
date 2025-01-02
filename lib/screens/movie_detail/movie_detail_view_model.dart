import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/components/base_view/base_view_model.dart';
import 'package:movie_app/data/models/api/responses/user_comment/user_comment.dart';
import 'package:movie_app/data/providers/trailer_download_provider.dart';
import 'package:movie_app/data/repositories/api/movie/movie_repository.dart';
import 'package:movie_app/data/repositories/api/session/session_repository.dart';
import 'package:movie_app/data/repositories/firebase/auth_repository.dart';
import 'package:movie_app/data/repositories/firebase/comment_repository.dart';
import 'package:movie_app/data/repositories/firebase/favorite_repository.dart';
import 'package:movie_app/data/services/api/secure_storage/secure_storage_manager.dart';
import 'package:movie_app/data/services/api/trailer/trailer_download_manager.dart';
import 'package:movie_app/screens/movie_detail/movie_detail_state.dart';
import 'package:path_provider/path_provider.dart';

class MovieDetailViewModel extends BaseViewModel<MovieDetailState> {
  MovieDetailViewModel({
    required this.ref,
    required this.movieId,
    required this.movieRepository,
    required this.sessionRepository,
    required this.secureStorageManager,
    required this.favoriteRepository,
    required this.authRepository,
    required this.trailerDownloadManager,
    required this.commentRepository,
  }) : super(const MovieDetailState());

  final Ref ref;

  final int movieId;

  final MovieRepository movieRepository;

  final SessionRepository sessionRepository;

  final SecureStorageManager secureStorageManager;

  final FavoriteRepository favoriteRepository;

  final AuthRepository authRepository;

  final TrailerDownloadManager trailerDownloadManager;

  final CommentRepository commentRepository;

  StreamSubscription<List<UserComment>>? _commentsSubscription;

  @override
  void dispose() {
    print('MovieDetailViewModel of ${movieId} dispose called');
    if (_commentsSubscription != null) {
      _commentsSubscription?.cancel();
      _commentsSubscription = null;
      print('Comments stream disposed');
    }
    super.dispose();
  }

  Future<void> initData({
    required int movieId,
  }) async {
    await Future.wait([
      _getMovieDetailResponse(movieId),
      _getMovieCredits(movieId),
      _getMovieTrailer(movieId),
      _getMovieRecommendations(movieId),
      _checkFavorite(movieId),
      _getTopTwoCommentsWithMostLikes(movieId),
    ]);

    _initializeCommentsStream(movieId);
  }

  void _initializeCommentsStream(int movieId) {
    _commentsSubscription?.cancel();

    final commentsStream = commentRepository.getComments(movieId);
    _commentsSubscription = commentsStream.listen(
      (comments) {
        if (mounted) {
          state = state.copyWith(commentList: comments);
        }
      },
      onError: (error) {
        debugPrint('Error in comments stream: $error');
        _commentsSubscription?.cancel();
        _commentsSubscription = null;
      },
    );
  }

  Future<void> _getMovieDetailResponse(int movieId) async {
    try {
      final movieDetail = await movieRepository.getMovieDetails(movieId);
      state = state.copyWith(movie: movieDetail);
    } catch (e) {
      if (kDebugMode) {
        print('Error getting movie detail: $e');
      }
    }
  }

  Future<void> _getMovieCredits(int movieId) async {
    try {
      final movieCredits = await movieRepository.getMovieCredits(movieId);
      state = state.copyWith(castList: movieCredits);
    } catch (e) {
      if (kDebugMode) {
        print('Error getting movie credits: $e');
      }
    }
  }

  Future<void> _getMovieTrailer(int movieId) async {
    try {
      final movieTrailer = await movieRepository.getMovieTrailer(movieId);
      state = state.copyWith(trailer: movieTrailer);
    } catch (e) {
      if (kDebugMode) {
        print('Error getting movie trailer: $e');
      }
    }
  }

  Future<void> _getMovieRecommendations(int movieId) async {
    try {
      final recommendations = await movieRepository.getRecommendations(movieId);
      state = state.copyWith(recommendations: recommendations);
    } catch (e) {
      if (kDebugMode) {
        print('Error getting movie recommendations: $e');
      }
    }
  }

  Future<void> toggleFavorite(int movieId) async {
    final userId = authRepository.getCurrentUserId();
    if (state.isFavorite) {
      state = state.copyWith(isFavorite: false);
      await favoriteRepository.removeFavorite(userId, movieId);
    } else {
      state = state.copyWith(isFavorite: true);
      await favoriteRepository.addFavorite(userId, movieId);
    }
  }

  Future<void> _checkFavorite(int movieId) async {
    final userId = authRepository.getCurrentUserId();
    final isFavorite = await favoriteRepository.isFavorite(userId, movieId);
    state = state.copyWith(isFavorite: isFavorite);
  }

  Future<void> checkAndDownloadVideo(String key, String videoTitle) async {
    final cacheDir = await getTemporaryDirectory();
    final savePath = '${cacheDir.path}/$videoTitle.mp4';

    final file = File(savePath);
    if (!await file.exists()) {
      final trailerDownloadManager = ref.watch(trailerDownloadProvider);
      await trailerDownloadManager.downloadVideoInBackground(key, videoTitle);
    } else {
      state = state.copyWith(cachedVideoPath: savePath);
    }
  }

  Future<void> addComment({
    required int movieId,
    required String comment,
  }) async {
    final userId = authRepository.getCurrentUserId();
    final userComment = UserComment(
      comment: comment,
      userNameCommented: userId,
      createdAt: DateTime.now().toUtc().toIso8601String(),
      updatedAt: DateTime.now().toUtc().toIso8601String(),
    );

    await commentRepository.addComment(userId, movieId, userComment);
  }

  Future<void> likeComment({
    required UserComment comment,
    required int movieId,
  }) async {
    if (!mounted) return;
    final userId = authRepository.getCurrentUserId();
    await commentRepository.likeComment(userId, movieId, comment);
  }

  Future<void> _getTopTwoCommentsWithMostLikes(int movieId) async {
    final comments =
        await commentRepository.getTopTwoCommentsWithMostLikes(movieId);

    state = state.copyWith(topTwoComments: comments);
  }

  void setLandscape({required bool isLandScape}) {
    if (state.isLandScape != isLandScape) {
      state = state.copyWith(isLandScape: isLandScape);
    }
  }
}
