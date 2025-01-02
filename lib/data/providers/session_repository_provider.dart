import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:movie_app/data/repositories/api/session/session_repository.dart';

final sessionRepositoryProvider = Provider<SessionRepository>(
  (ref) => SessionRepositoryImpl(),
);
