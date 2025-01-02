import 'package:flutter/material.dart';
import 'package:movie_app/data/models/api/responses/user_comment/user_comment.dart';
import 'package:movie_app/resources/app_text_styles.dart';
import 'package:movie_app/resources/gen/assets.gen.dart';
import 'package:movie_app/resources/gen/colors.gen.dart';
import 'package:movie_app/utilities/constants/text_constants.dart';

class CommentItem extends StatelessWidget {
  const CommentItem({
    super.key,
    required this.comment,
    required this.onLikeTap,
    required this.currentUserId,
    this.setModalState,
  });

  final UserComment comment;
  final Future<void> Function() onLikeTap;
  final String currentUserId;
  final StateSetter? setModalState;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(Assets.images.avatarDefault.path),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        comment.userNameCommented ?? '',
                        style: AppTextStyles.s16w700,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: Text(
                        _getTimeDifference(DateTime.parse(comment.createdAt!)),
                        style: AppTextStyles.s12w400.copyWith(
                          color: ColorName.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment.comment ?? '',
                  style: AppTextStyles.s14w400,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (!context.mounted) return;
                        await onLikeTap();
                        if (!context.mounted) return;
                        setModalState?.call(() {});
                      },
                      child: Icon(
                        comment.isLikedByUser(
                          currentUserId,
                        )
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: comment.isLikedByUser(
                          currentUserId,
                        )
                            ? Colors.red
                            : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      comment.listUserLikedComment?.length.toString() ?? '',
                      style: AppTextStyles.s12w400,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _getTimeDifference(DateTime createdAt) {
  final now = DateTime.now();
  final difference = now.difference(createdAt);

  if (difference.inDays > 0) {
    return '${difference.inDays} ${TextConstants.dayAgo}';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} ${TextConstants.hourAgo}';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} ${TextConstants.minuteAgo}';
  } else {
    return '${TextConstants.justNow}';
  }
}
