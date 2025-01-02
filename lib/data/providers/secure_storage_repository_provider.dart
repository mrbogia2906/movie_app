import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:movie_app/data/repositories/api/secure_storage/secure_storage_repository.dart';

final secureStorageRepositoryProvider = Provider<SecureStorageRepository>(
  (ref) => SecureStorageRepositoryImpl(const FlutterSecureStorage()),
);
