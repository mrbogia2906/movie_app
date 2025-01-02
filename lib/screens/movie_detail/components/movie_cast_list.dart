import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/components/images/profile_avatar.dart';
import 'package:movie_app/data/models/api/responses/cast/cast.dart';
import 'package:movie_app/resources/app_text_styles.dart';
import 'package:movie_app/resources/gen/colors.gen.dart';
import 'package:movie_app/router/app_router.dart';
import 'package:movie_app/utilities/constants/app_constants.dart';
import 'package:movie_app/utilities/constants/text_constants.dart';

class MovieCastList extends StatelessWidget {
  const MovieCastList({
    Key? key,
    required this.castList,
  }) : super(key: key);

  final List<Cast> castList;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(TextConstants.cast, style: AppTextStyles.s18w700),
          const SizedBox(height: 8),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: castList.length > 10 ? 10 : castList.length,
              itemBuilder: (context, index) =>
                  _buildCastItem(context, castList[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCastItem(BuildContext context, Cast cast) {
    return GestureDetector(
      onTap: () {
        context.router.push(CastRoute(castId: cast.id!));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SizedBox(
          width: 100,
          child: Column(
            children: [
              ProfileAvatar(
                imageUrl: '${AppConstants.imageW185}${cast.profilePath}',
                width: 60,
                height: 60,
                radius: 30,
              ),
              const SizedBox(height: 4),
              Text(
                cast.name ?? '',
                style: AppTextStyles.s12w700,
                textAlign: TextAlign.center,
              ),
              Expanded(
                child: Text(
                  cast.character ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.s12w400.copyWith(
                    color: ColorName.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
