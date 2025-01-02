import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_information.freezed.dart';
part 'user_information.g.dart';

@freezed
class UserInformation with _$UserInformation {
  const factory UserInformation({
    @JsonKey(name: 'uid') String? uid,
    @JsonKey(name: 'email') String? email,
    @JsonKey(name: 'displayName') String? displayName,
  }) = _UserInformation;

  factory UserInformation.fromJson(Map<String, dynamic> json) =>
      _$UserInformationFromJson(json);
}
