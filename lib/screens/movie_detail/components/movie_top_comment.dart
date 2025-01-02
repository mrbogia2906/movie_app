import 'package:flutter/material.dart';
import 'package:movie_app/data/models/api/responses/user_comment/user_comment.dart';
import 'package:movie_app/screens/movie_detail/components/comment_item.dart';
import 'package:movie_app/utilities/constants/text_constants.dart';

class MovieTopComment extends StatelessWidget {
  const MovieTopComment({
    Key? key,
    required this.topTwoComments,
    required this.currentUserId,
  }) : super(key: key);

  final List<UserComment> topTwoComments;

  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    return topTwoComments.isNotEmpty
        ? Column(
            children: topTwoComments.map((comment) {
              return CommentItem(
                comment: comment,
                onLikeTap: () async {
                  return;
                },
                currentUserId: currentUserId,
              );
            }).toList(),
          )
        : const SizedBox(
            height: 100,
            child: Center(
              child: Text(TextConstants.noComment),
            ),
          );
  }
}
