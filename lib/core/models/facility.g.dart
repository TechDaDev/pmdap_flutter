// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facility.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Country _$CountryFromJson(Map<String, dynamic> json) => _Country(
  code: json['code'] as String? ?? '',
  name: json['name'] as String? ?? '',
);

Map<String, dynamic> _$CountryToJson(_Country instance) => <String, dynamic>{
  'code': instance.code,
  'name': instance.name,
};

_Region _$RegionFromJson(Map<String, dynamic> json) => _Region(
  uuid: json['uuid'] as String?,
  name: json['name'] as String? ?? '',
  code: json['code'] as String? ?? '',
);

Map<String, dynamic> _$RegionToJson(_Region instance) => <String, dynamic>{
  'uuid': instance.uuid,
  'name': instance.name,
  'code': instance.code,
};

_City _$CityFromJson(Map<String, dynamic> json) =>
    _City(uuid: json['uuid'] as String?, name: json['name'] as String? ?? '');

Map<String, dynamic> _$CityToJson(_City instance) => <String, dynamic>{
  'uuid': instance.uuid,
  'name': instance.name,
};

_HealthcareFacility _$HealthcareFacilityFromJson(Map<String, dynamic> json) =>
    _HealthcareFacility(
      uuid: json['uuid'] as String,
      name: json['name'] as String? ?? '',
      country: json['country'] == null
          ? null
          : Country.fromJson(json['country'] as Map<String, dynamic>),
      region: json['region'] == null
          ? null
          : Region.fromJson(json['region'] as Map<String, dynamic>),
      city: json['city'] == null
          ? null
          : City.fromJson(json['city'] as Map<String, dynamic>),
      address: json['address'] as String? ?? '',
      facilityType: json['facilityType'] == null
          ? FacilityType.unknown
          : facilityTypeFromJson(json['facilityType']),
      active: json['active'] as bool? ?? false,
      aliases:
          (json['aliases'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const <Map<String, dynamic>>[],
    );

Map<String, dynamic> _$HealthcareFacilityToJson(_HealthcareFacility instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'country': instance.country,
      'region': instance.region,
      'city': instance.city,
      'address': instance.address,
      'facilityType': _$FacilityTypeEnumMap[instance.facilityType]!,
      'active': instance.active,
      'aliases': instance.aliases,
    };

const _$FacilityTypeEnumMap = {
  FacilityType.hospital: 'hospital',
  FacilityType.clinic: 'clinic',
  FacilityType.laboratory: 'laboratory',
  FacilityType.radiologyCenter: 'radiologyCenter',
  FacilityType.pharmacy: 'pharmacy',
  FacilityType.primaryCareCenter: 'primaryCareCenter',
  FacilityType.specializedCenter: 'specializedCenter',
  FacilityType.universityHospital: 'universityHospital',
  FacilityType.other: 'other',
  FacilityType.unknown: 'unknown',
};
