import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/api/responses/user_information/user_information.dart';
import '../api/secure_storage/secure_storage_repository.dart';

abstract class AuthRepository {
  Stream<User?> get user;
  String getCurrentUserId();
  Future<UserCredential?> loginWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<UserCredential?> registerWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<void> logOut();
}

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.secureStorageRepository,
  });

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final SecureStorageRepository secureStorageRepository;

  @override
  Stream<User?> get user => _firebaseAuth.authStateChanges();

  @override
  String getCurrentUserId() {
    return _firebaseAuth.currentUser!.uid;
  }

  @override
  Future<UserCredential?> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    debugPrint('------------------------------------------------------------');
    debugPrint(
        ':fire::fire::fire: [Post] Login With Email And Password :fire::fire::fire:');
    debugPrint('------------------------------------------------------------');
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    /// Save user information to cache
    final userInformation = UserInformation(
      uid: userCredential.user?.uid,
      email: userCredential.user?.email,
      displayName: userCredential.user?.displayName,
    );
    await secureStorageRepository.saveUserInformation(
      userInformation: userInformation,
    );
    return userCredential;
  }

  @override
  Future<UserCredential?> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    debugPrint('------------------------------------------------------------');
    debugPrint(
        ':fire::fire::fire: [Post] Register With Email And Password :fire::fire::fire:');
    debugPrint('------------------------------------------------------------');
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    /// Save user information to cache
    final userInformation = UserInformation(
      uid: userCredential.user?.uid,
      email: userCredential.user?.email,
      displayName: userCredential.user?.displayName,
    );
    await secureStorageRepository.saveUserInformation(
      userInformation: userInformation,
    );
    return userCredential;
  }

  @override
  Future<void> logOut() async {
    debugPrint('------------------------------------------------------------');
    debugPrint(':fire::fire::fire: Logout :fire::fire::fire:');
    debugPrint('------------------------------------------------------------');
    await FirebaseAuth.instance.signOut();
  }
}
