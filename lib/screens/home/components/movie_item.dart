import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movie_app/components/images/profile_avatar.dart';
import 'package:movie_app/data/models/api/responses/movie/movie.dart';
import 'package:movie_app/resources/app_text_styles.dart';
import 'package:movie_app/resources/gen/colors.gen.dart';
import 'package:movie_app/router/app_router.dart';
import 'package:movie_app/utilities/constants/app_constants.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MovieItem extends StatelessWidget {
  const MovieItem({
    required this.movie,
    super.key,
  });

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    double percent;
    return GestureDetector(
      onTap: () {
        context.router.push(MovieDetailRoute(movieId: movie.id!));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SizedBox(
          width: 150,
          height: 120,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    child: ProfileAvatar(
                      imageUrl:
                          '${AppConstants.imageW600AndH900}${movie.posterPath}',
                      width: double.infinity,
                      height: 200,
                      radius: 12,
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, 170),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(32)),
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: CircularPercentIndicator(
                            fillColor: ColorName.black,
                            radius: 18.0,
                            lineWidth: 3.0,
                            percent: percent = movie.voteAverage! / 10,
                            center: Text(
                              '${(movie.voteAverage! * 10).round()}%',
                              style: AppTextStyles.s12w700.copyWith(
                                color: ColorName.white,
                              ),
                            ),
                            progressColor: getProgressColor(percent),
                            backgroundColor: ColorName.grey.withOpacity(0.6),
                            circularStrokeCap: CircularStrokeCap.round,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 0),
                child: Text(
                  movie.title ?? '',
                  style: AppTextStyles.s16w700,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  DateFormat(AppConstants.dateFormatMDY)
                      .format(DateTime.parse(movie.releaseDate.toString())),
                  style: AppTextStyles.s14w400.copyWith(
                    color: ColorName.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color getProgressColor(double percent) {
    if (percent >= 0.7) {
      return ColorName.green.withOpacity(0.9);
    } else if (percent >= 0.4) {
      return ColorName.yellow.withOpacity(0.7);
    } else {
      return ColorName.red;
    }
  }
}
