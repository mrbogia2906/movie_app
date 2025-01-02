import 'package:freezed_annotation/freezed_annotation.dart';

part 'trailer.freezed.dart';
part 'trailer.g.dart';

@freezed
class TrailerRespone with _$TrailerRespone {
  const factory TrailerRespone({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'results') required List<Trailer> results,
  }) = _TrailerRespone;

  factory TrailerRespone.fromJson(Map<String, dynamic> json) =>
      _$TrailerResponeFromJson(json);
}

@freezed
class Trailer with _$Trailer {
  const factory Trailer({
    @JsonKey(name: 'iso_639_1') String? iso6391,
    @JsonKey(name: 'iso_3166_1') String? iso31661,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'key') String? key,
    @JsonKey(name: 'site') String? site,
    @JsonKey(name: 'size') int? size,
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'official') bool? official,
    @JsonKey(name: 'published_at') DateTime? publishedAt,
    @JsonKey(name: 'id') String? id,
  }) = _Trailer;

  factory Trailer.fromJson(Map<String, dynamic> json) =>
      _$TrailerFromJson(json);
}
