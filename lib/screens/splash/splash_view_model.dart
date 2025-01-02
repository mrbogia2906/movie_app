import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/components/base_view/base_view_model.dart';
import 'package:movie_app/data/repositories/firebase/auth_repository.dart';
import 'package:movie_app/data/services/api/secure_storage/secure_storage_manager.dart';

class SplashViewModel extends BaseViewModel<void> {
  SplashViewModel({
    required this.ref,
    required this.secureStorageManager,
    required this.authRepository,
  }) : super(null);

  Ref ref;

  final SecureStorageManager secureStorageManager;

  final AuthRepository authRepository;

  Future<void> saveUserIdToSecureStorage() async {
    var userId = authRepository.getCurrentUserId();

    await secureStorageManager.writeUserId(userId);
  }
}
