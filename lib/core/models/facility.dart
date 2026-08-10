import 'package:freezed_annotation/freezed_annotation.dart';

import 'enum_json.dart';
import 'enums.dart';

part 'facility.freezed.dart';
part 'facility.g.dart';

@freezed
abstract class Country with _$Country {
  const factory Country({@Default('') String code, @Default('') String name}) =
      _Country;

  factory Country.fromJson(Map<String, dynamic> json) =>
      _$CountryFromJson(json);
}

@freezed
abstract class Region with _$Region {
  const factory Region({
    String? uuid,
    @Default('') String name,
    @Default('') String code,
  }) = _Region;

  factory Region.fromJson(Map<String, dynamic> json) => _$RegionFromJson(json);
}

@freezed
abstract class City with _$City {
  const factory City({String? uuid, @Default('') String name}) = _City;

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);
}

/// Healthcare facility (read-only).
@freezed
abstract class HealthcareFacility with _$HealthcareFacility {
  const factory HealthcareFacility({
    required String uuid,
    @Default('') String name,
    Country? country,
    Region? region,
    City? city,
    @Default('') String address,
    @JsonKey(fromJson: facilityTypeFromJson)
    @Default(FacilityType.unknown)
    FacilityType facilityType,
    @Default(false) bool active,
    @Default(<Map<String, dynamic>>[]) List<Map<String, dynamic>> aliases,
  }) = _HealthcareFacility;

  factory HealthcareFacility.fromJson(Map<String, dynamic> json) =>
      _$HealthcareFacilityFromJson(json);
}
