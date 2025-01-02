import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import '../../../models/api/responses/user_information/user_information.dart';

abstract class SecureStorageRepository {
  Future<void> saveUserInformation({
    required UserInformation userInformation,
  });
}

class SecureStorageRepositoryImpl extends SecureStorageRepository {
  SecureStorageRepositoryImpl(this._storage);

  final FlutterSecureStorage _storage;
  static const _userInformation = 'userInformation';

  @override
  Future<void> saveUserInformation({
    required UserInformation userInformation,
  }) async {
    try {
      await _storage.write(
        key: _userInformation,
        value: jsonEncode(userInformation.toJson()),
      );
      debugPrint('Saving user information to secure storage: $userInformation');
    } on Exception catch (e) {
      debugPrint('Error saving user information: $e');
    }
  }
}
