import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/data/providers/secure_storage_repository_provider.dart';
import 'package:movie_app/data/repositories/firebase/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
      secureStorageRepository: ref.watch(secureStorageRepositoryProvider)),
);
