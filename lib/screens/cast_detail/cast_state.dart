import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_app/data/models/api/responses/cast/cast.dart';

part 'cast_state.freezed.dart';

@freezed
class CastState with _$CastState {
  factory CastState({
    @Default(Cast()) Cast cast,
    @Default(false) bool isExpandedBio,
  }) = _CastState;

  const CastState._();
}
