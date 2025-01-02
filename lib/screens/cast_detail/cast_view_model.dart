import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/components/base_view/base_view_model.dart';
import 'package:movie_app/data/repositories/api/movie/movie_repository.dart';
import 'package:movie_app/screens/cast_detail/cast_state.dart';

class CastViewModel extends BaseViewModel<CastState> {
  CastViewModel({
    required this.ref,
    required this.movieRepository,
  }) : super(CastState());

  final Ref ref;

  final MovieRepository movieRepository;

  Future<void> initData(int castId) async {
    await _getCastDetail(castId);
  }

  Future<void> _getCastDetail(int castId) async {
    final castDetail = await movieRepository.getCastDetails(castId);
    state = state.copyWith(cast: castDetail);
  }

  void toggleExpandedBio() {
    state = state.copyWith(isExpandedBio: !state.isExpandedBio);
  }
}
