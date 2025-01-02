import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/components/images/profile_avatar.dart';
import 'package:movie_app/data/models/api/responses/movie/movie.dart';
import 'package:movie_app/resources/app_text_styles.dart';
import 'package:movie_app/router/app_router.dart';
import 'package:movie_app/utilities/constants/app_constants.dart';
import 'package:movie_app/utilities/constants/text_constants.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class MovieRecommendList extends StatelessWidget {
  const MovieRecommendList({
    Key? key,
    required this.recommendations,
    required this.controller,
  }) : super(key: key);

  final List<Movie> recommendations;

  final YoutubePlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 4),
          child: Text(
            TextConstants.recommended,
            style: AppTextStyles.s18w700,
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recommendations.length,
            itemBuilder: (context, index) {
              final movie = recommendations[index];
              return GestureDetector(
                onTap: () {
                  controller.pauseVideo();
                  context.router.push(MovieDetailRoute(movieId: movie.id!));
                },
                child: SizedBox(
                  width: 250,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ProfileAvatar(
                          imageUrl:
                              '${AppConstants.imageW200}${movie.backdropPath}',
                          width: 250,
                          height: 150,
                          radius: 12,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          movie.title ?? '',
                          style: AppTextStyles.s14w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
