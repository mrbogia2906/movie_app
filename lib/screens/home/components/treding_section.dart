import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_app/data/models/api/responses/movie/movie.dart';
import 'package:movie_app/resources/app_text_styles.dart';
import 'package:movie_app/resources/gen/assets.gen.dart';
import 'package:movie_app/resources/gen/colors.gen.dart';
import 'package:movie_app/screens/home/components/movie_item.dart';
import 'package:movie_app/screens/home/components/treding_tab_bar.dart';
import 'package:movie_app/screens/home/home_state.dart';
import 'package:movie_app/utilities/constants/text_constants.dart';

class TrendingSection extends StatelessWidget {
  const TrendingSection({
    Key? key,
    required this.tabController,
    required this.movieListTrending,
  }) : super(key: key);

  final TabController tabController;
  final Map<TrendingType, List<Movie>> movieListTrending;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
                child: Text(
                  TextConstants.trending,
                  style: AppTextStyles.s24w700.copyWith(
                    color: ColorName.black,
                  ),
                ),
              ),
              TrendingTabBar(controller: tabController),
            ],
          ),
          SizedBox(
            height: 300,
            child: Stack(
              children: [
                SvgPicture.asset(
                  Assets.images.backgroundSvg.path,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                TabBarView(
                  controller: tabController,
                  children:
                      TrendingType.values.map(_buildMovieTrending).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieTrending(
    TrendingType type,
  ) {
    final movies = movieListTrending[type] ?? [];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: SizedBox(
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: MovieItem(movie: movie),
            );
          },
        ),
      ),
    );
  }
}
