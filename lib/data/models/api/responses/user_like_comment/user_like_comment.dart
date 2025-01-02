import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_like_comment.freezed.dart';
part 'user_like_comment.g.dart';

@freezed
class UserLikeComment with _$UserLikeComment {
  const factory UserLikeComment({
    @JsonKey(name: 'userNameLiked') String? userNameLiked,
    @JsonKey(name: 'imageUrl') String? imageUrl,
    @JsonKey(name: 'status') String? status,
    @JsonKey(name: 'createdAt') String? createdAt,
    @JsonKey(name: 'updatedAt') String? updatedAt,
  }) = _UserLikeComment;

  factory UserLikeComment.fromJson(Map<String, dynamic> json) =>
      _$UserLikeCommentFromJson(json);
}
