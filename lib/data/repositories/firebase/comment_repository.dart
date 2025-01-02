import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_app/data/models/api/responses/user_comment/user_comment.dart';
import 'package:movie_app/data/models/api/responses/user_like_comment/user_like_comment.dart';

abstract class CommentRepository {
  Future<void> addComment(
    String userId,
    int movieId,
    UserComment comment,
  );

  Stream<List<UserComment>> getComments(int movieId);

  Future<void> removeComment(String userId, int movieId, String comment);

  Future<void> updateComment(String userId, int movieId, UserComment comment);

  Future<void> likeComment(String userId, int movieId, UserComment comment);

  Future<List<UserComment>> getTopTwoCommentsWithMostLikes(int movieId);
}

class CommentRepositoryImpl implements CommentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> addComment(
    String userId,
    int movieId,
    UserComment comment,
  ) async {
    final newComment = comment.copyWith(
      userNameCommented: userId,
      createdAt: DateTime.now().toUtc().toIso8601String(),
      updatedAt: DateTime.now().toUtc().toIso8601String(),
    );

    await _firestore
        .collection('movie')
        .doc(movieId.toString())
        .collection('comments')
        .add(newComment.toJson());
  }

  @override
  Future<void> likeComment(
    String userId,
    int movieId,
    UserComment comment,
  ) async {
    QuerySnapshot query = await _firestore
        .collection('movie')
        .doc(movieId.toString())
        .collection('comments')
        .where('userNameCommented', isEqualTo: comment.userNameCommented)
        .where('createdAt', isEqualTo: comment.createdAt)
        .get();

    for (var doc in query.docs) {
      final userLikedComments = (doc['listUserLikedComment'] as List<dynamic>?)
              ?.map((e) => UserLikeComment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];

      final isLiked = comment.isLikedByUser(userId);

      if (isLiked) {
        userLikedComments
            .removeWhere((element) => element.userNameLiked == userId);
      } else {
        userLikedComments.add(
          UserLikeComment(
            userNameLiked: userId,
            createdAt: DateTime.now().toUtc().toIso8601String(),
            updatedAt: DateTime.now().toUtc().toIso8601String(),
          ),
        );
      }

      await doc.reference.update({
        'listUserLikedComment':
            userLikedComments.map((e) => e.toJson()).toList(),
      });
    }
  }

  @override
  Stream<List<UserComment>> getComments(int movieId) {
    return _firestore
        .collection('movie')
        .doc(movieId.toString())
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return UserComment.fromJson(doc.data());
      }).toList();
    });
  }

  @override
  Future<void> removeComment(String userId, int movieId, String comment) async {
    QuerySnapshot query = await _firestore
        .collection('movie')
        .doc(movieId.toString())
        .collection('comments')
        .where('userNameCommented', isEqualTo: userId)
        .where('comment', isEqualTo: comment)
        .get();

    for (var doc in query.docs) {
      await doc.reference.delete();
    }
  }

  @override
  Future<void> updateComment(
    String userId,
    int movieId,
    UserComment comment,
  ) async {
    QuerySnapshot query = await _firestore
        .collection('movie')
        .doc(movieId.toString())
        .collection('comments')
        .where('userNameCommented', isEqualTo: userId)
        .where('createdAt', isEqualTo: comment.createdAt)
        .get();

    for (var doc in query.docs) {
      await doc.reference.update({
        'comment': comment.comment,
        'updatedAt': DateTime.now().toUtc().toIso8601String(),
      });
    }
  }

  @override
  Future<List<UserComment>> getTopTwoCommentsWithMostLikes(int movieId) async {
    QuerySnapshot snapshot = await _firestore
        .collection('movie')
        .doc(movieId.toString())
        .collection('comments')
        .get();

    final comments = snapshot.docs.map((doc) {
      return UserComment.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();

    comments.sort((a, b) {
      final aLikes = a.listUserLikedComment?.length ?? 0;
      final bLikes = b.listUserLikedComment?.length ?? 0;
      return bLikes.compareTo(aLikes);
    });

    return comments.take(2).toList();
  }
}
