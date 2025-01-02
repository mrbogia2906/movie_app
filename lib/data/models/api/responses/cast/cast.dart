import 'package:freezed_annotation/freezed_annotation.dart';

part 'cast.freezed.dart';
part 'cast.g.dart';

@freezed
class CastRespone with _$CastRespone {
  const factory CastRespone({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'cast') required List<Cast> cast,
    @JsonKey(name: 'crew') required List<Cast> crew,
  }) = _CastRespone;

  factory CastRespone.fromJson(Map<String, dynamic> json) =>
      _$CastResponeFromJson(json);
}

@freezed
class Cast with _$Cast {
  const factory Cast({
    @JsonKey(name: 'adult') bool? adult,
    @JsonKey(name: 'gender') int? gender,
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'known_for_department') String? knownForDepartment,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'original_name') String? originalName,
    @JsonKey(name: 'popularity') double? popularity,
    @JsonKey(name: 'profile_path') String? profilePath,
    @JsonKey(name: 'cast_id') int? castId,
    @JsonKey(name: 'character') String? character,
    @JsonKey(name: 'credit_id') String? creditId,
    @JsonKey(name: 'order') int? order,
    @JsonKey(name: 'also_known_as') List<String>? alsoKnownAs,
    @JsonKey(name: 'biography') String? biography,
    @JsonKey(name: 'birthday') String? birthday,
    @JsonKey(name: 'deathday') String? deathday,
    @JsonKey(name: 'imdb_id') String? imdbId,
    @JsonKey(name: 'place_of_birth') String? placeOfBirth,
    @JsonKey(name: 'homepage') String? homepage,
  }) = _Cast;

  factory Cast.fromJson(Map<String, dynamic> json) => _$CastFromJson(json);
}

enum Department {
  @JsonValue('Acting')
  ACTING,
  @JsonValue('Art')
  ART,
  @JsonValue('Camera')
  CAMERA,
  @JsonValue('Costume & Make-Up')
  COSTUME_MAKE_UP,
  @JsonValue('Crew')
  CREW,
  @JsonValue('Directing')
  DIRECTING,
  @JsonValue('Editing')
  EDITING,
  @JsonValue('Lighting')
  LIGHTING,
  @JsonValue('Production')
  PRODUCTION,
  @JsonValue('Sound')
  SOUND,
  @JsonValue('Visual Effects')
  VISUAL_EFFECTS,
  @JsonValue('Writing')
  WRITING
}
