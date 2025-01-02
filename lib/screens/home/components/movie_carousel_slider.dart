import 'package:auto_route/auto_route.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/components/images/profile_avatar.dart';
import 'package:movie_app/data/models/api/responses/movie/movie.dart';
import 'package:movie_app/resources/app_text_styles.dart';
import 'package:movie_app/resources/gen/colors.gen.dart';
import 'package:movie_app/router/app_router.dart';
import 'package:movie_app/utilities/constants/app_constants.dart';

class MovieCarouselSlider extends StatefulWidget {
  const MovieCarouselSlider({Key? key, required this.movies}) : super(key: key);

  final List<Movie> movies;

  @override
  State<MovieCarouselSlider> createState() => _MovieCarouselSliderState();
}

class _MovieCarouselSliderState extends State<MovieCarouselSlider> {
  int _currentPageIndex = 0;
  final maxPageIndex = 5;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.movies.length > maxPageIndex
              ? maxPageIndex
              : widget.movies.length,
          itemBuilder: (context, index, realIndex) {
            final movie = widget.movies[index];
            return _MovieCarouselItem(movie: movie);
          },
          options: CarouselOptions(
            height: 250,
            viewportFraction: 1,
            enlargeCenterPage: true,
            autoPlay: false,
            autoPlayInterval: const Duration(seconds: 5),
            onPageChanged: (index, reason) {
              setState(() {
                _currentPageIndex = index;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4.0, top: 8),
          child: Row(
            children: List.generate(
              widget.movies.length > maxPageIndex
                  ? maxPageIndex
                  : widget.movies.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _currentPageIndex == index ? 24 : 8,
                height: 6,
                decoration: BoxDecoration(
                  color: _currentPageIndex == index
                      ? ColorName.blueFF5FC1C7
                      : ColorName.grey,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MovieCarouselItem extends StatelessWidget {
  const _MovieCarouselItem({
    Key? key,
    required this.movie,
  }) : super(key: key);

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.router.push(MovieDetailRoute(movieId: movie.id!));
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          ProfileAvatar(
            imageUrl: '${AppConstants.imageW500}${movie.posterPath}',
            radius: 0,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, ColorName.black.withOpacity(0.8)],
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 24,
            child: Text(
              movie.title ?? '',
              style: AppTextStyles.s21w700.copyWith(color: ColorName.white),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
