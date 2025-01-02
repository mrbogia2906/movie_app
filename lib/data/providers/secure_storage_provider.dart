import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:movie_app/data/services/api/secure_storage/secure_storage_manager.dart';

final secureStorageProvider = Provider<SecureStorageManager>(
  (ref) => SecureStorageManager(const FlutterSecureStorage()),
);
