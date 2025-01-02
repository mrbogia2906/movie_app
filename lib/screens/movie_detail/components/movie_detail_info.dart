import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:movie_app/components/divider/divider_horizontal.dart';
import 'package:movie_app/data/models/api/responses/movie/movie.dart';
import 'package:movie_app/resources/app_text_styles.dart';
import 'package:movie_app/resources/gen/colors.gen.dart';
import 'package:movie_app/utilities/constants/app_constants.dart';
import 'package:movie_app/utilities/constants/text_constants.dart';

class MovieDetailInfo extends ConsumerWidget {
  const MovieDetailInfo({
    Key? key,
    required this.movie,
    required this.movieId,
    required this.isFavorite,
    required this.onFavoriteTap,
  }) : super(key: key);

  final Movie movie;

  final int movieId;

  final bool isFavorite;

  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: _buildMovieTitle(movie.title),
              ),
              IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: isFavorite ? ColorName.red : ColorName.grey,
                  size: 24,
                ),
                onPressed: onFavoriteTap,
              ),
            ],
          ),
          _buildMovieRating(movie.voteAverage),
          const SizedBox(height: 8),
          _buildMovieGenres(movie.genres),
          const SizedBox(height: 8),
          const DividerHorizontal(height: 2),
          const SizedBox(height: 8),
          _buildMovieMetadata(movie),
          const SizedBox(height: 8),
          const DividerHorizontal(height: 2),
          const SizedBox(height: 8),
          _buildMovieDescription(movie),
        ],
      ),
    );
  }
}

Widget _buildMovieTitle(String? title) {
  return Text(
    title ?? '',
    style: AppTextStyles.s21w700,
  );
}

Widget _buildMovieRating(double? rating) {
  return Row(
    children: [
      const Icon(Icons.star, color: ColorName.yellow),
      const SizedBox(width: 4),
      Text(
        '${rating?.toStringAsFixed(1) ?? ''} (IMDb)',
        style: AppTextStyles.s16w700,
      ),
    ],
  );
}

Widget _buildMovieGenres(List<Genre>? genres) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Wrap(
      alignment: WrapAlignment.start,
      runSpacing: 8,
      spacing: 8,
      children: genres?.map(_buildGenreTag).toList() ?? [],
    ),
  );
}

Widget _buildGenreTag(Genre genre) {
  return Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: ColorName.tagcolor,
      borderRadius: BorderRadius.circular(32),
    ),
    child: Text(
      genre.name,
      style: AppTextStyles.s12w700.copyWith(
        color: ColorName.deepblue,
      ),
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
  );
}

Widget _buildMovieMetadata(Movie movie) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      _buildMovieDetailInfo(
        TextConstants.duration,
        _convertToHoursAndMinutes(movie.runtime ?? 0),
      ),
      _buildMovieDetailInfo(
        TextConstants.language,
        movie.originalLanguage?.toUpperCase() ?? '',
      ),
      _buildMovieDetailInfo(
        TextConstants.releaseDate,
        _formatReleaseDate(movie.releaseDate),
      ),
    ],
  );
}

Widget _buildMovieDetailInfo(String label, String value) {
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: AppTextStyles.s14w400.copyWith(
            color: ColorName.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.s16w700,
        ),
      ],
    ),
  );
}

Widget _buildMovieDescription(Movie movie) {
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          TextConstants.description,
          style: AppTextStyles.s18w700,
        ),
        const SizedBox(height: 4),
        Text(
          movie.tagline ?? '',
          style: AppTextStyles.tagLine.copyWith(
            color: ColorName.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          movie.overview ?? '',
          style: AppTextStyles.overView.copyWith(
            color: ColorName.black.withOpacity(0.8),
          ),
        ),
      ],
    ),
  );
}

String _convertToHoursAndMinutes(int runtime) {
  final hours = runtime ~/ 60;
  final minutes = runtime % 60;
  return '${hours}h ${minutes}m';
}

String _formatReleaseDate(String? releaseDate) {
  if (releaseDate == null) return '';
  final parsedDate = DateTime.parse(releaseDate);
  final formattedDate =
      DateFormat(AppConstants.dateFormatDMY).format(parsedDate);
  return formattedDate;
}
