import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/data/repositories/firebase/comment_repository.dart';

final commentRepositoryProvider = Provider<CommentRepository>((ref) {
  return CommentRepositoryImpl();
});
