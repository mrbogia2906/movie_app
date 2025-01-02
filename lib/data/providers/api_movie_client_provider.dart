import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/data/services/api/movie/api_movie_client.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final apiPostClientProvider = Provider<ApiMovieClient>(
  (ref) {
    final dio = Dio();

    /// Only show the API request log in debug mode
    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: true,
          error: true,
          compact: true,
          maxWidth: 99,
        ),
      );
    }

    return ApiMovieClient(dio);
  },
);
