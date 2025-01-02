import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_app/components/images/profile_avatar.dart';
import 'package:movie_app/resources/app_text_styles.dart';
import 'package:movie_app/resources/gen/colors.gen.dart';
import 'package:movie_app/utilities/constants/app_constants.dart';
import 'package:movie_app/utilities/constants/text_constants.dart';

class MovieDetailHeader extends StatelessWidget {
  const MovieDetailHeader({
    Key? key,
    required this.isShowTilte,
    required this.backdropPath,
    required this.title,
    required this.onPlayTrailer,
  }) : super(key: key);

  final bool isShowTilte;
  final String backdropPath;
  final String title;
  final VoidCallback onPlayTrailer;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leading: BackButton(
        onPressed: () {
          if (MediaQuery.of(context).orientation == Orientation.landscape) {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitUp,
              DeviceOrientation.portraitDown,
            ]);
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

            return;
          }
          context.router.pop();
        },
      ),
      iconTheme:
          IconThemeData(color: isShowTilte ? ColorName.black : ColorName.white),
      scrolledUnderElevation: 0,
      elevation: 0,
      expandedHeight: 300,
      pinned: true,
      floating: false,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: isShowTilte
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36.0),
                child: Text(
                  title,
                  style: AppTextStyles.s20w700,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            : null,
        background: Stack(
          children: [
            ProfileAvatar(
              imageUrl: backdropPath.isNotEmpty
                  ? '${AppConstants.imageW1000AndH450}$backdropPath'
                  : '',
              width: double.infinity,
              height: double.infinity,
              radius: 0,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildPlayTrailerButton(onPlayTrailer),
                  Text(
                    TextConstants.playTrailer,
                    style: AppTextStyles.s16w700.copyWith(
                      color: ColorName.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildPlayTrailerButton(VoidCallback onPlayTrailer) {
  return Container(
    width: 60,
    height: 60,
    decoration: BoxDecoration(
      color: ColorName.white.withOpacity(0.8),
      shape: BoxShape.circle,
    ),
    child: IconButton(
      onPressed: onPlayTrailer,
      icon: const Icon(
        Icons.play_arrow,
        color: ColorName.black,
        size: 30,
      ),
    ),
  );
}
