import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:movie_app/router/app_router.dart';

final appRouterProvider = Provider<AppRouter>(
  (ref) => AppRouter(),
);
