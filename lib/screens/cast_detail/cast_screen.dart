import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/components/base_view/base_view.dart';
import 'package:movie_app/components/images/profile_avatar.dart';
import 'package:movie_app/components/loading/container_with_loading.dart';
import 'package:movie_app/data/providers/movie_repository_provider.dart';
import 'package:movie_app/resources/app_text_styles.dart';
import 'package:movie_app/router/app_router.dart';
import 'package:movie_app/screens/cast_detail/cast_state.dart';
import 'package:movie_app/screens/cast_detail/cast_view_model.dart';
import 'package:movie_app/utilities/constants/app_constants.dart';
import 'package:movie_app/utilities/constants/text_constants.dart';

final _provider = StateNotifierProvider.autoDispose<CastViewModel, CastState>(
  (ref) => CastViewModel(
    ref: ref,
    movieRepository: ref.watch(movieRepositoryProvider),
  ),
);

@RoutePage()
class CastScreen extends BaseView {
  const CastScreen({
    Key? key,
    required this.castId,
  }) : super(key: key);

  final int castId;

  @override
  BaseViewState<CastScreen, CastViewModel> createState() => _CastScreenState();
}

class _CastScreenState extends BaseViewState<CastScreen, CastViewModel> {
  CastState get state => ref.watch(_provider);

  @override
  Future<void> onInitState() async {
    super.onInitState();
    await Future.delayed(Duration.zero, () async {
      await _onInitData(widget.castId);
    });
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => AppBar(
        centerTitle: true,
        title: Text(
          '${state.cast.name ?? ''}',
          style: AppTextStyles.s20w700,
        ),
      );

  @override
  Widget buildBody(BuildContext context) {
    print('castId: ${widget.castId}, ${state.isExpandedBio}');
    return ContainerWithLoading(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileImage(),
                _buildPersonalInfo(),
                _buildBiography(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(8),
        height: 200,
        width: 200,
        child: ProfileAvatar(
          imageUrl: state.cast.profilePath != null
              ? '${AppConstants.imageW235AndH235Face}${state.cast.profilePath}'
              : '',
          radius: 12,
        ),
      ),
    );
  }

  Widget _buildPersonalInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            TextConstants.personalInfo,
            style: AppTextStyles.s18w700,
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            TextConstants.knowFor,
            state.cast.knownForDepartment ?? '',
          ),
          _buildInfoRow(
            TextConstants.gender,
            state.cast.gender == 2 ? TextConstants.male : TextConstants.female,
          ),
          _buildInfoRow(TextConstants.birthday, state.cast.birthday ?? ''),
          _buildInfoRow(
            TextConstants.placeOfBirth,
            state.cast.placeOfBirth ?? '',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: AppTextStyles.s14w700,
          ),
          Text(
            value,
            style: AppTextStyles.s14w400,
          ),
        ],
      ),
    );
  }

  Widget _buildBiography() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            TextConstants.biography,
            style: AppTextStyles.s18w700,
          ),
          const SizedBox(height: 8),
          _buildExpandableBiography(),
        ],
      ),
    );
  }

  Widget _buildExpandableBiography() {
    final fullBio = state.cast.biography ?? '';
    const maxLines = 3;

    return LayoutBuilder(
      builder: (context, constraints) {
        final textPainter = TextPainter(
          text: TextSpan(text: fullBio, style: AppTextStyles.s14w400),
          maxLines: maxLines,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        final isOverflowing = textPainter.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fullBio,
              style: AppTextStyles.s14w400,
              maxLines: state.isExpandedBio ? null : maxLines,
              overflow: state.isExpandedBio
                  ? TextOverflow.visible
                  : TextOverflow.ellipsis,
            ),
            if (isOverflowing)
              GestureDetector(
                onTap: () {
                  viewModel.toggleExpandedBio();
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    state.isExpandedBio
                        ? TextConstants.readLess
                        : TextConstants.readMore,
                    style: AppTextStyles.s14w700.copyWith(color: Colors.blue),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  String get screenName => CastRoute.name;

  @override
  CastViewModel get viewModel => ref.read(_provider.notifier);

  Future<void> _onInitData(int castId) async {
    await onLoading(() => viewModel.initData(castId));
  }
}
