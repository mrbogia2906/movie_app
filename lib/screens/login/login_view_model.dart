import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/components/base_view/base_view_model.dart';
import 'package:movie_app/data/repositories/firebase/auth_repository.dart';
import 'package:movie_app/screens/login/login_state.dart';

class LoginViewModel extends BaseViewModel<LoginState> {
  LoginViewModel({
    required this.ref,
    required this.authRepository,
  }) : super(LoginState());

  final Ref ref;

  final AuthRepository authRepository;

  void setEmail(String email) {
    state = state.copyWith(email: email.trim());
  }

  void setPassword(String password) {
    state = state.copyWith(password: password.trim());
  }

  Future<UserCredential?> loginWithEmailAndPassword() async {
    final userCredential = await authRepository.loginWithEmailAndPassword(
      email: state.email.trim(),
      password: state.password.trim(),
    );
    return userCredential;
  }
}
