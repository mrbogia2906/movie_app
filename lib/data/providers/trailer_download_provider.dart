import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/data/services/api/trailer/trailer_download_manager.dart';

final trailerDownloadProvider = Provider<TrailerDownloadManager>((ref) {
  return TrailerDownloadManager();
});
