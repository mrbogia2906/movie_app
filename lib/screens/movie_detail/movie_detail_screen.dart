import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/components/base_view/base_view.dart';
import 'package:movie_app/components/loading/container_with_loading.dart';
import 'package:movie_app/components/loading/loading_state.dart';
import 'package:movie_app/data/providers/auth_repository_provider.dart';
import 'package:movie_app/data/providers/comment_repository_provider.dart';
import 'package:movie_app/data/providers/favorite_repository_provider.dart';
import 'package:movie_app/data/providers/movie_repository_provider.dart';
import 'package:movie_app/data/providers/secure_storage_provider.dart';
import 'package:movie_app/data/providers/session_repository_provider.dart';
import 'package:movie_app/data/providers/trailer_download_provider.dart';
import 'package:movie_app/resources/app_text_styles.dart';
import 'package:movie_app/resources/gen/colors.gen.dart';
import 'package:movie_app/router/app_router.dart';
import 'package:movie_app/screens/movie_detail/components/comment_item.dart';
import 'package:movie_app/screens/movie_detail/components/keep_alive_youtube_player.dart';
import 'package:movie_app/screens/movie_detail/components/movie_cast_list.dart';
import 'package:movie_app/screens/movie_detail/components/movie_detail_info.dart';
import 'package:movie_app/screens/movie_detail/components/movie_recommend_list.dart';
import 'package:movie_app/screens/movie_detail/components/movie_top_comment.dart';
import 'package:movie_app/screens/movie_detail/movie_detail_state.dart';
import 'package:movie_app/screens/movie_detail/movie_detail_view_model.dart';
import 'package:movie_app/utilities/constants/text_constants.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../components/loading/loading_view_model.dart';

final _movieDetailProvider = StateNotifierProvider.autoDispose
    .family<MovieDetailViewModel, MovieDetailState, int>(
  (ref, movieId) {
    return MovieDetailViewModel(
      ref: ref,
      movieId: movieId,
      movieRepository: ref.watch(movieRepositoryProvider),
      sessionRepository: ref.watch(sessionRepositoryProvider),
      secureStorageManager: ref.watch(secureStorageProvider),
      favoriteRepository: ref.watch(favoriteRepositoryProvider),
      authRepository: ref.watch(authRepositoryProvider),
      trailerDownloadManager: ref.watch(trailerDownloadProvider),
      commentRepository: ref.watch(commentRepositoryProvider),
    );
  },
);

@RoutePage()
class MovieDetailScreen extends BaseView {
  const MovieDetailScreen({
    Key? key,
    required this.movieId,
  }) : super(key: key);

  final int movieId;

  @override
  BaseViewState<MovieDetailScreen, MovieDetailViewModel> createState() =>
      _MovieDetailScreenState();
}

class _MovieDetailScreenState
    extends BaseViewState<MovieDetailScreen, MovieDetailViewModel> {
  late YoutubePlayerController _youtubeController;
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  MovieDetailState get state => ref.watch(_movieDetailProvider(widget.movieId));

  LoadingState get loadingState => ref.watch(loadingStateProvider);

  @override
  Future<void> onInitState() async {
    super.onInitState();
    // WidgetsBinding.instance.addObserver(this);

    _youtubeController = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        mute: true,
        showFullscreenButton: true,
        loop: false,
      ),
    );

    _youtubeController.setFullScreenListener((isFullScreen) {
      if (!mounted) return;
      if (state.isLandScape != isFullScreen) {
        viewModel.setLandscape(isLandScape: isFullScreen);
      }
    });

    Future.delayed(Duration.zero, () async {
      await _onInitData();
    });
  }

  @override
  void dispose() {
    // WidgetsBinding.instance.removeObserver(this);
    _youtubeController.close();
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  // @override
  // void didChangeMetrics() {
  //   final orientation = MediaQuery.of(context).orientation;
  //   bool isLandscape = orientation == Orientation.landscape;

  //   if (state.isLandScape != isLandscape) {
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       if (mounted) {
  //         viewModel.setLandscape(isLandScape: isLandscape);
  //       }
  //     });
  //   }
  // }

  Future<void> _initializePlayer() async {
    if (state.cachedVideoPath != null) {
      _videoPlayerController =
          VideoPlayerController.file(File(state.cachedVideoPath!));
      try {
        await _videoPlayerController?.initialize();
        setState(() {});

        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController!,
          autoPlay: false,
          looping: true,
          showControls: true,
          materialProgressColors: ChewieProgressColors(
            playedColor: ColorName.blue,
            handleColor: ColorName.blue,
            backgroundColor: Colors.transparent,
            bufferedColor: ColorName.black,
          ),
          placeholder: Container(
            color: Colors.transparent,
          ),
        );
      } catch (e) {
        debugPrint('Error initializing video player: $e');
        _videoPlayerController?.dispose();
      }
    } else {
      await _youtubeController
          .cueVideoById(videoId: state.trailer.key!)
          .catchError((e) {
        debugPrint('Error loading YouTube video: $e');
      });
    }
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return orientation == Orientation.landscape && _chewieController == null
        ? null
        : AppBar(
            title: Text(
              state.movie.title ?? '',
              style: AppTextStyles.s18w700,
            ),
            centerTitle: true,
            backgroundColor: ColorName.white,
            elevation: 0,
            foregroundColor: ColorName.black,
          );
  }

  @override
  Widget buildBody(BuildContext context) {
    print(
        'state.isLandScape: ${state.isLandScape}, loading: ${loadingState.isLoading}');
    return OrientationBuilder(
      builder: (context, orientation) {
        bool isLandscape = orientation == Orientation.landscape;
        return ContainerWithLoading(
          child: isLandscape && _chewieController == null
              ? KeepAliveYoutubePlayer(controller: _youtubeController)
              : ListView(
                  children: [
                    if (state.cachedVideoPath != null &&
                        _chewieController != null)
                      SizedBox(
                        height: 250,
                        child: Chewie(controller: _chewieController!),
                      )
                    else
                      KeepAliveYoutubePlayer(controller: _youtubeController),
                    loadingState.isLoading == false
                        ? _buildDetailsBody(context)
                        : const SizedBox.shrink(),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildDetailsBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MovieDetailInfo(
          movie: state.movie,
          movieId: widget.movieId,
          isFavorite: state.isFavorite,
          onFavoriteTap: () => viewModel.toggleFavorite(widget.movieId),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 4.0,
            horizontal: 16.0,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    TextConstants.comment,
                    style: AppTextStyles.s18w700,
                  ),
                  GestureDetector(
                    onTap: () {
                      _showModal(context);
                    },
                    child: Text(
                      TextConstants.showAll,
                      style: AppTextStyles.s12w700.copyWith(
                        color: ColorName.blue,
                      ),
                    ),
                  ),
                ],
              ),
              MovieTopComment(
                topTwoComments: state.topTwoComments,
                currentUserId: viewModel.authRepository.getCurrentUserId(),
              ),
            ],
          ),
        ),
        MovieCastList(castList: state.castList),
        MovieRecommendList(
          recommendations: state.recommendations,
          controller: _youtubeController,
        ),
      ],
    );
  }

  void _showModal(BuildContext context) {
    final _commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext modalContext) {
        return DraggableScrollableSheet(
          expand: false,
          snap: true,
          initialChildSize: 0.8,
          maxChildSize: 0.8,
          minChildSize: 0.6,
          snapSizes: const [0.8],
          builder: (BuildContext sheetContext, scrollController) {
            return StatefulBuilder(
              builder: (
                BuildContext statefulContext,
                StateSetter setModalState,
              ) {
                final bottomInset =
                    MediaQuery.of(statefulContext).viewInsets.bottom;

                return Padding(
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                state.commentList.isNotEmpty
                                    ? '${TextConstants.comment} (${state.commentList.length})'
                                    : '${TextConstants.comment}',
                                style: AppTextStyles.s18w700,
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => Navigator.pop(sheetContext),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Scrollbar(
                            child: ListView.builder(
                              controller: scrollController,
                              itemCount: state.commentList.length,
                              itemBuilder: (context, index) => CommentItem(
                                comment: state.commentList[index],
                                onLikeTap: () async {
                                  if (!mounted) return;
                                  await viewModel.likeComment(
                                    comment: state.commentList[index],
                                    movieId: widget.movieId,
                                  );
                                },
                                currentUserId:
                                    viewModel.authRepository.getCurrentUserId(),
                                setModalState: setModalState,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 8,
                            right: 8,
                            top: 8,
                            bottom: bottomInset > 0 ? 8 : 54,
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _commentController,
                                  decoration: InputDecoration(
                                    hintText: TextConstants.addComment,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                  ),
                                  onSubmitted: (value) {
                                    if (value.trim().isNotEmpty) {
                                      if (!context.mounted) return;
                                      viewModel.addComment(
                                        movieId: widget.movieId,
                                        comment: value,
                                      );
                                      _commentController.clear();
                                      if (!mounted) return;
                                      setModalState(() {});
                                    }
                                  },
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  if (_commentController.text
                                      .trim()
                                      .isNotEmpty) {
                                    if (!context.mounted) return;
                                    viewModel.addComment(
                                      movieId: widget.movieId,
                                      comment: _commentController.text,
                                    );
                                    _commentController.clear();
                                    if (!mounted) return;
                                    setModalState(() {});
                                    FocusScope.of(statefulContext).unfocus();
                                  }
                                },
                                icon: const Icon(Icons.send),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  String get screenName => MovieDetailRoute.name;

  @override
  bool get tapOutsideToDismissKeyBoard => true;

  @override
  MovieDetailViewModel get viewModel =>
      ref.read(_movieDetailProvider(widget.movieId).notifier);

  Future<void> _onInitData() async {
    Object? error;

    await onLoading(() async {
      try {
        await viewModel.initData(movieId: widget.movieId);

        if (!mounted) return;
        await viewModel.checkAndDownloadVideo(
          state.trailer.key!,
          state.movie.title!,
        );

        if (!mounted) return;
        await _initializePlayer();
      } catch (e) {
        error = e;
      }
    });

    if (error != null) {
      handleError(error!);
    }
  }
}
