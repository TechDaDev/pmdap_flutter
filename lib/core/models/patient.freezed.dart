// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'patient.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PatientProfile {

 String get uuid; String get digitalId; String get fullName; DateTime? get dateOfBirth; int get age; bool get isMinor;@JsonKey(fromJson: sexFromJson) Sex get sex; String get nationality;@JsonKey(fromJson: bloodGroupFromJson) BloodGroup get bloodGroup;@JsonKey(fromJson: identityStatusFromJson) IdentityStatus get identityStatus; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of PatientProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PatientProfileCopyWith<PatientProfile> get copyWith => _$PatientProfileCopyWithImpl<PatientProfile>(this as PatientProfile, _$identity);

  /// Serializes this PatientProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PatientProfile&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.digitalId, digitalId) || other.digitalId == digitalId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.age, age) || other.age == age)&&(identical(other.isMinor, isMinor) || other.isMinor == isMinor)&&(identical(other.sex, sex) || other.sex == sex)&&(identical(other.nationality, nationality) || other.nationality == nationality)&&(identical(other.bloodGroup, bloodGroup) || other.bloodGroup == bloodGroup)&&(identical(other.identityStatus, identityStatus) || other.identityStatus == identityStatus)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uuid,digitalId,fullName,dateOfBirth,age,isMinor,sex,nationality,bloodGroup,identityStatus,createdAt,updatedAt);

@override
String toString() {
  return 'PatientProfile(uuid: $uuid, digitalId: $digitalId, fullName: $fullName, dateOfBirth: $dateOfBirth, age: $age, isMinor: $isMinor, sex: $sex, nationality: $nationality, bloodGroup: $bloodGroup, identityStatus: $identityStatus, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $PatientProfileCopyWith<$Res>  {
  factory $PatientProfileCopyWith(PatientProfile value, $Res Function(PatientProfile) _then) = _$PatientProfileCopyWithImpl;
@useResult
$Res call({
 String uuid, String digitalId, String fullName, DateTime? dateOfBirth, int age, bool isMinor,@JsonKey(fromJson: sexFromJson) Sex sex, String nationality,@JsonKey(fromJson: bloodGroupFromJson) BloodGroup bloodGroup,@JsonKey(fromJson: identityStatusFromJson) IdentityStatus identityStatus, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$PatientProfileCopyWithImpl<$Res>
    implements $PatientProfileCopyWith<$Res> {
  _$PatientProfileCopyWithImpl(this._self, this._then);

  final PatientProfile _self;
  final $Res Function(PatientProfile) _then;

/// Create a copy of PatientProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uuid = null,Object? digitalId = null,Object? fullName = null,Object? dateOfBirth = freezed,Object? age = null,Object? isMinor = null,Object? sex = null,Object? nationality = null,Object? bloodGroup = null,Object? identityStatus = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,digitalId: null == digitalId ? _self.digitalId : digitalId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime?,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,isMinor: null == isMinor ? _self.isMinor : isMinor // ignore: cast_nullable_to_non_nullable
as bool,sex: null == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as Sex,nationality: null == nationality ? _self.nationality : nationality // ignore: cast_nullable_to_non_nullable
as String,bloodGroup: null == bloodGroup ? _self.bloodGroup : bloodGroup // ignore: cast_nullable_to_non_nullable
as BloodGroup,identityStatus: null == identityStatus ? _self.identityStatus : identityStatus // ignore: cast_nullable_to_non_nullable
as IdentityStatus,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PatientProfile].
extension PatientProfilePatterns on PatientProfile {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PatientProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PatientProfile() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PatientProfile value)  $default,){
final _that = this;
switch (_that) {
case _PatientProfile():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PatientProfile value)?  $default,){
final _that = this;
switch (_that) {
case _PatientProfile() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uuid,  String digitalId,  String fullName,  DateTime? dateOfBirth,  int age,  bool isMinor, @JsonKey(fromJson: sexFromJson)  Sex sex,  String nationality, @JsonKey(fromJson: bloodGroupFromJson)  BloodGroup bloodGroup, @JsonKey(fromJson: identityStatusFromJson)  IdentityStatus identityStatus,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PatientProfile() when $default != null:
return $default(_that.uuid,_that.digitalId,_that.fullName,_that.dateOfBirth,_that.age,_that.isMinor,_that.sex,_that.nationality,_that.bloodGroup,_that.identityStatus,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uuid,  String digitalId,  String fullName,  DateTime? dateOfBirth,  int age,  bool isMinor, @JsonKey(fromJson: sexFromJson)  Sex sex,  String nationality, @JsonKey(fromJson: bloodGroupFromJson)  BloodGroup bloodGroup, @JsonKey(fromJson: identityStatusFromJson)  IdentityStatus identityStatus,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _PatientProfile():
return $default(_that.uuid,_that.digitalId,_that.fullName,_that.dateOfBirth,_that.age,_that.isMinor,_that.sex,_that.nationality,_that.bloodGroup,_that.identityStatus,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uuid,  String digitalId,  String fullName,  DateTime? dateOfBirth,  int age,  bool isMinor, @JsonKey(fromJson: sexFromJson)  Sex sex,  String nationality, @JsonKey(fromJson: bloodGroupFromJson)  BloodGroup bloodGroup, @JsonKey(fromJson: identityStatusFromJson)  IdentityStatus identityStatus,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _PatientProfile() when $default != null:
return $default(_that.uuid,_that.digitalId,_that.fullName,_that.dateOfBirth,_that.age,_that.isMinor,_that.sex,_that.nationality,_that.bloodGroup,_that.identityStatus,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _PatientProfile implements PatientProfile {
  const _PatientProfile({required this.uuid, required this.digitalId, required this.fullName, this.dateOfBirth, this.age = 0, this.isMinor = false, @JsonKey(fromJson: sexFromJson) this.sex = Sex.unknown, this.nationality = '', @JsonKey(fromJson: bloodGroupFromJson) this.bloodGroup = BloodGroup.unknown, @JsonKey(fromJson: identityStatusFromJson) this.identityStatus = IdentityStatus.unknown, this.createdAt, this.updatedAt});
  factory _PatientProfile.fromJson(Map<String, dynamic> json) => _$PatientProfileFromJson(json);

@override final  String uuid;
@override final  String digitalId;
@override final  String fullName;
@override final  DateTime? dateOfBirth;
@override@JsonKey() final  int age;
@override@JsonKey() final  bool isMinor;
@override@JsonKey(fromJson: sexFromJson) final  Sex sex;
@override@JsonKey() final  String nationality;
@override@JsonKey(fromJson: bloodGroupFromJson) final  BloodGroup bloodGroup;
@override@JsonKey(fromJson: identityStatusFromJson) final  IdentityStatus identityStatus;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of PatientProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PatientProfileCopyWith<_PatientProfile> get copyWith => __$PatientProfileCopyWithImpl<_PatientProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PatientProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PatientProfile&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.digitalId, digitalId) || other.digitalId == digitalId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.age, age) || other.age == age)&&(identical(other.isMinor, isMinor) || other.isMinor == isMinor)&&(identical(other.sex, sex) || other.sex == sex)&&(identical(other.nationality, nationality) || other.nationality == nationality)&&(identical(other.bloodGroup, bloodGroup) || other.bloodGroup == bloodGroup)&&(identical(other.identityStatus, identityStatus) || other.identityStatus == identityStatus)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uuid,digitalId,fullName,dateOfBirth,age,isMinor,sex,nationality,bloodGroup,identityStatus,createdAt,updatedAt);

@override
String toString() {
  return 'PatientProfile(uuid: $uuid, digitalId: $digitalId, fullName: $fullName, dateOfBirth: $dateOfBirth, age: $age, isMinor: $isMinor, sex: $sex, nationality: $nationality, bloodGroup: $bloodGroup, identityStatus: $identityStatus, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PatientProfileCopyWith<$Res> implements $PatientProfileCopyWith<$Res> {
  factory _$PatientProfileCopyWith(_PatientProfile value, $Res Function(_PatientProfile) _then) = __$PatientProfileCopyWithImpl;
@override @useResult
$Res call({
 String uuid, String digitalId, String fullName, DateTime? dateOfBirth, int age, bool isMinor,@JsonKey(fromJson: sexFromJson) Sex sex, String nationality,@JsonKey(fromJson: bloodGroupFromJson) BloodGroup bloodGroup,@JsonKey(fromJson: identityStatusFromJson) IdentityStatus identityStatus, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$PatientProfileCopyWithImpl<$Res>
    implements _$PatientProfileCopyWith<$Res> {
  __$PatientProfileCopyWithImpl(this._self, this._then);

  final _PatientProfile _self;
  final $Res Function(_PatientProfile) _then;

/// Create a copy of PatientProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uuid = null,Object? digitalId = null,Object? fullName = null,Object? dateOfBirth = freezed,Object? age = null,Object? isMinor = null,Object? sex = null,Object? nationality = null,Object? bloodGroup = null,Object? identityStatus = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_PatientProfile(
uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,digitalId: null == digitalId ? _self.digitalId : digitalId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime?,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,isMinor: null == isMinor ? _self.isMinor : isMinor // ignore: cast_nullable_to_non_nullable
as bool,sex: null == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as Sex,nationality: null == nationality ? _self.nationality : nationality // ignore: cast_nullable_to_non_nullable
as String,bloodGroup: null == bloodGroup ? _self.bloodGroup : bloodGroup // ignore: cast_nullable_to_non_nullable
as BloodGroup,identityStatus: null == identityStatus ? _self.identityStatus : identityStatus // ignore: cast_nullable_to_non_nullable
as IdentityStatus,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
