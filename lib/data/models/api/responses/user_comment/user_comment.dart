import 'package:freezed_annotation/freezed_annotation.dart';

import '../user_like_comment/user_like_comment.dart';

part 'user_comment.freezed.dart';
part 'user_comment.g.dart';

@freezed
class UserComment with _$UserComment {
  const factory UserComment({
    @JsonKey(name: 'userNameCommented') String? userNameCommented,
    @JsonKey(name: 'imageUrl') String? imageUrl,
    @JsonKey(name: 'comment') String? comment,
    @JsonKey(name: 'createdAt') String? createdAt,
    @JsonKey(name: 'updatedAt') String? updatedAt,
    @JsonKey(name: 'listUserLikedComment')
    List<UserLikeComment>? listUserLikedComment,
  }) = _UserComment;

  factory UserComment.fromJson(Map<String, dynamic> json) =>
      _$UserCommentFromJson(json);
}

extension UserCommentExtension on UserComment {
  bool isLikedByUser(String currentUserId) {
    return listUserLikedComment?.any(
          (like) => like.userNameLiked == currentUserId,
        ) ??
        false;
  }
}
