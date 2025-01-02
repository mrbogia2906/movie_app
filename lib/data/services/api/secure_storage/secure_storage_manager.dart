import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageManager {
  SecureStorageManager(this._storage);

  final FlutterSecureStorage _storage;
  static const _userIdKey = 'userId';

  Future<String?> _read({
    required String key,
  }) async {
    return _storage.read(key: key);
  }

  Future<void> _delete({
    required String key,
  }) async {
    await _storage.delete(key: key);
  }

  Future<void> _write({
    required String key,
    required String? value,
  }) async {
    await _storage.write(
      key: key,
      value: value,
    );
  }

  Future<void> writeUserId(String? userId) async {
    try {
      await _write(
        key: _userIdKey,
        value: userId,
      );
      print('Saving user id to secure storage: $userId');
    } catch (e) {
      print('Error saving user id: $e');
    }
  }

  Future<String?> readUserId() async {
    try {
      final result = await _read(key: _userIdKey);
      print('Reading user id from secure storage: $result');
      return result;
    } catch (e) {
      print('Error reading user id: $e');
      return null;
    }
  }

  Future<void> deleteUserId() async {
    try {
      await _delete(key: _userIdKey);
      print('Deleting user id from secure storage');
    } catch (e) {
      print('Error deleting user id: $e');
    }
  }
}
