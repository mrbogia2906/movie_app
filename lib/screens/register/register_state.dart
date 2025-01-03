import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_state.freezed.dart';

@freezed
class RegisterState with _$RegisterState {
  factory RegisterState({
    @Default(false) bool authenticated,
    @Default(true) bool passwordVisible,
    @Default(true) bool confirmPasswordVisible,
    @Default('') String email,
    @Default('') String password,
  }) = _RegisterState;

  const RegisterState._();
}
