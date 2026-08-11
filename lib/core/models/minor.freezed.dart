// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'minor.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GuardianRelationship {

 String get uuid;@JsonKey(fromJson: relationshipFromJson) Relationship get relationship;@JsonKey(fromJson: verificationStatusFromJson) VerificationStatus get verificationStatus; bool get active; DateTime? get startedAt; DateTime? get verifiedAt; DateTime? get endedAt; String? get endedReason;
/// Create a copy of GuardianRelationship
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GuardianRelationshipCopyWith<GuardianRelationship> get copyWith => _$GuardianRelationshipCopyWithImpl<GuardianRelationship>(this as GuardianRelationship, _$identity);

  /// Serializes this GuardianRelationship to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GuardianRelationship&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.relationship, relationship) || other.relationship == relationship)&&(identical(other.verificationStatus, verificationStatus) || other.verificationStatus == verificationStatus)&&(identical(other.active, active) || other.active == active)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.verifiedAt, verifiedAt) || other.verifiedAt == verifiedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.endedReason, endedReason) || other.endedReason == endedReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uuid,relationship,verificationStatus,active,startedAt,verifiedAt,endedAt,endedReason);

@override
String toString() {
  return 'GuardianRelationship(uuid: $uuid, relationship: $relationship, verificationStatus: $verificationStatus, active: $active, startedAt: $startedAt, verifiedAt: $verifiedAt, endedAt: $endedAt, endedReason: $endedReason)';
}


}

/// @nodoc
abstract mixin class $GuardianRelationshipCopyWith<$Res>  {
  factory $GuardianRelationshipCopyWith(GuardianRelationship value, $Res Function(GuardianRelationship) _then) = _$GuardianRelationshipCopyWithImpl;
@useResult
$Res call({
 String uuid,@JsonKey(fromJson: relationshipFromJson) Relationship relationship,@JsonKey(fromJson: verificationStatusFromJson) VerificationStatus verificationStatus, bool active, DateTime? startedAt, DateTime? verifiedAt, DateTime? endedAt, String? endedReason
});




}
/// @nodoc
class _$GuardianRelationshipCopyWithImpl<$Res>
    implements $GuardianRelationshipCopyWith<$Res> {
  _$GuardianRelationshipCopyWithImpl(this._self, this._then);

  final GuardianRelationship _self;
  final $Res Function(GuardianRelationship) _then;

/// Create a copy of GuardianRelationship
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uuid = null,Object? relationship = null,Object? verificationStatus = null,Object? active = null,Object? startedAt = freezed,Object? verifiedAt = freezed,Object? endedAt = freezed,Object? endedReason = freezed,}) {
  return _then(_self.copyWith(
uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,relationship: null == relationship ? _self.relationship : relationship // ignore: cast_nullable_to_non_nullable
as Relationship,verificationStatus: null == verificationStatus ? _self.verificationStatus : verificationStatus // ignore: cast_nullable_to_non_nullable
as VerificationStatus,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,verifiedAt: freezed == verifiedAt ? _self.verifiedAt : verifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,endedReason: freezed == endedReason ? _self.endedReason : endedReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GuardianRelationship].
extension GuardianRelationshipPatterns on GuardianRelationship {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GuardianRelationship value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GuardianRelationship() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GuardianRelationship value)  $default,){
final _that = this;
switch (_that) {
case _GuardianRelationship():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GuardianRelationship value)?  $default,){
final _that = this;
switch (_that) {
case _GuardianRelationship() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uuid, @JsonKey(fromJson: relationshipFromJson)  Relationship relationship, @JsonKey(fromJson: verificationStatusFromJson)  VerificationStatus verificationStatus,  bool active,  DateTime? startedAt,  DateTime? verifiedAt,  DateTime? endedAt,  String? endedReason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GuardianRelationship() when $default != null:
return $default(_that.uuid,_that.relationship,_that.verificationStatus,_that.active,_that.startedAt,_that.verifiedAt,_that.endedAt,_that.endedReason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uuid, @JsonKey(fromJson: relationshipFromJson)  Relationship relationship, @JsonKey(fromJson: verificationStatusFromJson)  VerificationStatus verificationStatus,  bool active,  DateTime? startedAt,  DateTime? verifiedAt,  DateTime? endedAt,  String? endedReason)  $default,) {final _that = this;
switch (_that) {
case _GuardianRelationship():
return $default(_that.uuid,_that.relationship,_that.verificationStatus,_that.active,_that.startedAt,_that.verifiedAt,_that.endedAt,_that.endedReason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uuid, @JsonKey(fromJson: relationshipFromJson)  Relationship relationship, @JsonKey(fromJson: verificationStatusFromJson)  VerificationStatus verificationStatus,  bool active,  DateTime? startedAt,  DateTime? verifiedAt,  DateTime? endedAt,  String? endedReason)?  $default,) {final _that = this;
switch (_that) {
case _GuardianRelationship() when $default != null:
return $default(_that.uuid,_that.relationship,_that.verificationStatus,_that.active,_that.startedAt,_that.verifiedAt,_that.endedAt,_that.endedReason);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _GuardianRelationship implements GuardianRelationship {
  const _GuardianRelationship({required this.uuid, @JsonKey(fromJson: relationshipFromJson) this.relationship = Relationship.unknown, @JsonKey(fromJson: verificationStatusFromJson) this.verificationStatus = VerificationStatus.unknown, this.active = false, this.startedAt, this.verifiedAt, this.endedAt, this.endedReason});
  factory _GuardianRelationship.fromJson(Map<String, dynamic> json) => _$GuardianRelationshipFromJson(json);

@override final  String uuid;
@override@JsonKey(fromJson: relationshipFromJson) final  Relationship relationship;
@override@JsonKey(fromJson: verificationStatusFromJson) final  VerificationStatus verificationStatus;
@override@JsonKey() final  bool active;
@override final  DateTime? startedAt;
@override final  DateTime? verifiedAt;
@override final  DateTime? endedAt;
@override final  String? endedReason;

/// Create a copy of GuardianRelationship
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GuardianRelationshipCopyWith<_GuardianRelationship> get copyWith => __$GuardianRelationshipCopyWithImpl<_GuardianRelationship>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GuardianRelationshipToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GuardianRelationship&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.relationship, relationship) || other.relationship == relationship)&&(identical(other.verificationStatus, verificationStatus) || other.verificationStatus == verificationStatus)&&(identical(other.active, active) || other.active == active)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.verifiedAt, verifiedAt) || other.verifiedAt == verifiedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.endedReason, endedReason) || other.endedReason == endedReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uuid,relationship,verificationStatus,active,startedAt,verifiedAt,endedAt,endedReason);

@override
String toString() {
  return 'GuardianRelationship(uuid: $uuid, relationship: $relationship, verificationStatus: $verificationStatus, active: $active, startedAt: $startedAt, verifiedAt: $verifiedAt, endedAt: $endedAt, endedReason: $endedReason)';
}


}

/// @nodoc
abstract mixin class _$GuardianRelationshipCopyWith<$Res> implements $GuardianRelationshipCopyWith<$Res> {
  factory _$GuardianRelationshipCopyWith(_GuardianRelationship value, $Res Function(_GuardianRelationship) _then) = __$GuardianRelationshipCopyWithImpl;
@override @useResult
$Res call({
 String uuid,@JsonKey(fromJson: relationshipFromJson) Relationship relationship,@JsonKey(fromJson: verificationStatusFromJson) VerificationStatus verificationStatus, bool active, DateTime? startedAt, DateTime? verifiedAt, DateTime? endedAt, String? endedReason
});




}
/// @nodoc
class __$GuardianRelationshipCopyWithImpl<$Res>
    implements _$GuardianRelationshipCopyWith<$Res> {
  __$GuardianRelationshipCopyWithImpl(this._self, this._then);

  final _GuardianRelationship _self;
  final $Res Function(_GuardianRelationship) _then;

/// Create a copy of GuardianRelationship
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uuid = null,Object? relationship = null,Object? verificationStatus = null,Object? active = null,Object? startedAt = freezed,Object? verifiedAt = freezed,Object? endedAt = freezed,Object? endedReason = freezed,}) {
  return _then(_GuardianRelationship(
uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,relationship: null == relationship ? _self.relationship : relationship // ignore: cast_nullable_to_non_nullable
as Relationship,verificationStatus: null == verificationStatus ? _self.verificationStatus : verificationStatus // ignore: cast_nullable_to_non_nullable
as VerificationStatus,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,verifiedAt: freezed == verifiedAt ? _self.verifiedAt : verifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,endedReason: freezed == endedReason ? _self.endedReason : endedReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Minor {

 String get uuid; String get digitalId; String get fullName; DateTime? get dateOfBirth; int get age; bool get isMinor;@JsonKey(fromJson: sexFromJson) Sex get sex; String get nationality;@JsonKey(fromJson: bloodGroupFromJson) BloodGroup get bloodGroup;@JsonKey(fromJson: identityStatusFromJson) IdentityStatus get identityStatus; GuardianRelationship? get relationship; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of Minor
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MinorCopyWith<Minor> get copyWith => _$MinorCopyWithImpl<Minor>(this as Minor, _$identity);

  /// Serializes this Minor to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Minor&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.digitalId, digitalId) || other.digitalId == digitalId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.age, age) || other.age == age)&&(identical(other.isMinor, isMinor) || other.isMinor == isMinor)&&(identical(other.sex, sex) || other.sex == sex)&&(identical(other.nationality, nationality) || other.nationality == nationality)&&(identical(other.bloodGroup, bloodGroup) || other.bloodGroup == bloodGroup)&&(identical(other.identityStatus, identityStatus) || other.identityStatus == identityStatus)&&(identical(other.relationship, relationship) || other.relationship == relationship)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uuid,digitalId,fullName,dateOfBirth,age,isMinor,sex,nationality,bloodGroup,identityStatus,relationship,createdAt,updatedAt);

@override
String toString() {
  return 'Minor(uuid: $uuid, digitalId: $digitalId, fullName: $fullName, dateOfBirth: $dateOfBirth, age: $age, isMinor: $isMinor, sex: $sex, nationality: $nationality, bloodGroup: $bloodGroup, identityStatus: $identityStatus, relationship: $relationship, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $MinorCopyWith<$Res>  {
  factory $MinorCopyWith(Minor value, $Res Function(Minor) _then) = _$MinorCopyWithImpl;
@useResult
$Res call({
 String uuid, String digitalId, String fullName, DateTime? dateOfBirth, int age, bool isMinor,@JsonKey(fromJson: sexFromJson) Sex sex, String nationality,@JsonKey(fromJson: bloodGroupFromJson) BloodGroup bloodGroup,@JsonKey(fromJson: identityStatusFromJson) IdentityStatus identityStatus, GuardianRelationship? relationship, DateTime? createdAt, DateTime? updatedAt
});


$GuardianRelationshipCopyWith<$Res>? get relationship;

}
/// @nodoc
class _$MinorCopyWithImpl<$Res>
    implements $MinorCopyWith<$Res> {
  _$MinorCopyWithImpl(this._self, this._then);

  final Minor _self;
  final $Res Function(Minor) _then;

/// Create a copy of Minor
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uuid = null,Object? digitalId = null,Object? fullName = null,Object? dateOfBirth = freezed,Object? age = null,Object? isMinor = null,Object? sex = null,Object? nationality = null,Object? bloodGroup = null,Object? identityStatus = null,Object? relationship = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
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
as IdentityStatus,relationship: freezed == relationship ? _self.relationship : relationship // ignore: cast_nullable_to_non_nullable
as GuardianRelationship?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of Minor
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GuardianRelationshipCopyWith<$Res>? get relationship {
    if (_self.relationship == null) {
    return null;
  }

  return $GuardianRelationshipCopyWith<$Res>(_self.relationship!, (value) {
    return _then(_self.copyWith(relationship: value));
  });
}
}


/// Adds pattern-matching-related methods to [Minor].
extension MinorPatterns on Minor {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Minor value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Minor() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Minor value)  $default,){
final _that = this;
switch (_that) {
case _Minor():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Minor value)?  $default,){
final _that = this;
switch (_that) {
case _Minor() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uuid,  String digitalId,  String fullName,  DateTime? dateOfBirth,  int age,  bool isMinor, @JsonKey(fromJson: sexFromJson)  Sex sex,  String nationality, @JsonKey(fromJson: bloodGroupFromJson)  BloodGroup bloodGroup, @JsonKey(fromJson: identityStatusFromJson)  IdentityStatus identityStatus,  GuardianRelationship? relationship,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Minor() when $default != null:
return $default(_that.uuid,_that.digitalId,_that.fullName,_that.dateOfBirth,_that.age,_that.isMinor,_that.sex,_that.nationality,_that.bloodGroup,_that.identityStatus,_that.relationship,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uuid,  String digitalId,  String fullName,  DateTime? dateOfBirth,  int age,  bool isMinor, @JsonKey(fromJson: sexFromJson)  Sex sex,  String nationality, @JsonKey(fromJson: bloodGroupFromJson)  BloodGroup bloodGroup, @JsonKey(fromJson: identityStatusFromJson)  IdentityStatus identityStatus,  GuardianRelationship? relationship,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Minor():
return $default(_that.uuid,_that.digitalId,_that.fullName,_that.dateOfBirth,_that.age,_that.isMinor,_that.sex,_that.nationality,_that.bloodGroup,_that.identityStatus,_that.relationship,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uuid,  String digitalId,  String fullName,  DateTime? dateOfBirth,  int age,  bool isMinor, @JsonKey(fromJson: sexFromJson)  Sex sex,  String nationality, @JsonKey(fromJson: bloodGroupFromJson)  BloodGroup bloodGroup, @JsonKey(fromJson: identityStatusFromJson)  IdentityStatus identityStatus,  GuardianRelationship? relationship,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Minor() when $default != null:
return $default(_that.uuid,_that.digitalId,_that.fullName,_that.dateOfBirth,_that.age,_that.isMinor,_that.sex,_that.nationality,_that.bloodGroup,_that.identityStatus,_that.relationship,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _Minor implements Minor {
  const _Minor({required this.uuid, required this.digitalId, required this.fullName, this.dateOfBirth, this.age = 0, this.isMinor = false, @JsonKey(fromJson: sexFromJson) this.sex = Sex.unknown, this.nationality = '', @JsonKey(fromJson: bloodGroupFromJson) this.bloodGroup = BloodGroup.unknown, @JsonKey(fromJson: identityStatusFromJson) this.identityStatus = IdentityStatus.unknown, this.relationship, this.createdAt, this.updatedAt});
  factory _Minor.fromJson(Map<String, dynamic> json) => _$MinorFromJson(json);

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
@override final  GuardianRelationship? relationship;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of Minor
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MinorCopyWith<_Minor> get copyWith => __$MinorCopyWithImpl<_Minor>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MinorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Minor&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.digitalId, digitalId) || other.digitalId == digitalId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.age, age) || other.age == age)&&(identical(other.isMinor, isMinor) || other.isMinor == isMinor)&&(identical(other.sex, sex) || other.sex == sex)&&(identical(other.nationality, nationality) || other.nationality == nationality)&&(identical(other.bloodGroup, bloodGroup) || other.bloodGroup == bloodGroup)&&(identical(other.identityStatus, identityStatus) || other.identityStatus == identityStatus)&&(identical(other.relationship, relationship) || other.relationship == relationship)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uuid,digitalId,fullName,dateOfBirth,age,isMinor,sex,nationality,bloodGroup,identityStatus,relationship,createdAt,updatedAt);

@override
String toString() {
  return 'Minor(uuid: $uuid, digitalId: $digitalId, fullName: $fullName, dateOfBirth: $dateOfBirth, age: $age, isMinor: $isMinor, sex: $sex, nationality: $nationality, bloodGroup: $bloodGroup, identityStatus: $identityStatus, relationship: $relationship, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$MinorCopyWith<$Res> implements $MinorCopyWith<$Res> {
  factory _$MinorCopyWith(_Minor value, $Res Function(_Minor) _then) = __$MinorCopyWithImpl;
@override @useResult
$Res call({
 String uuid, String digitalId, String fullName, DateTime? dateOfBirth, int age, bool isMinor,@JsonKey(fromJson: sexFromJson) Sex sex, String nationality,@JsonKey(fromJson: bloodGroupFromJson) BloodGroup bloodGroup,@JsonKey(fromJson: identityStatusFromJson) IdentityStatus identityStatus, GuardianRelationship? relationship, DateTime? createdAt, DateTime? updatedAt
});


@override $GuardianRelationshipCopyWith<$Res>? get relationship;

}
/// @nodoc
class __$MinorCopyWithImpl<$Res>
    implements _$MinorCopyWith<$Res> {
  __$MinorCopyWithImpl(this._self, this._then);

  final _Minor _self;
  final $Res Function(_Minor) _then;

/// Create a copy of Minor
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uuid = null,Object? digitalId = null,Object? fullName = null,Object? dateOfBirth = freezed,Object? age = null,Object? isMinor = null,Object? sex = null,Object? nationality = null,Object? bloodGroup = null,Object? identityStatus = null,Object? relationship = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Minor(
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
as IdentityStatus,relationship: freezed == relationship ? _self.relationship : relationship // ignore: cast_nullable_to_non_nullable
as GuardianRelationship?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of Minor
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GuardianRelationshipCopyWith<$Res>? get relationship {
    if (_self.relationship == null) {
    return null;
  }

  return $GuardianRelationshipCopyWith<$Res>(_self.relationship!, (value) {
    return _then(_self.copyWith(relationship: value));
  });
}
}


/// @nodoc
mixin _$MinorCreateResponse {

 String get uuid; String get digitalId; String get fullName; DateTime? get dateOfBirth; int get age; bool get isMinor;@JsonKey(fromJson: sexFromJson) Sex get sex; String get nationality;@JsonKey(fromJson: bloodGroupFromJson) BloodGroup get bloodGroup;@JsonKey(fromJson: identityStatusFromJson) IdentityStatus get identityStatus; GuardianRelationship? get relationship; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of MinorCreateResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MinorCreateResponseCopyWith<MinorCreateResponse> get copyWith => _$MinorCreateResponseCopyWithImpl<MinorCreateResponse>(this as MinorCreateResponse, _$identity);

  /// Serializes this MinorCreateResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MinorCreateResponse&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.digitalId, digitalId) || other.digitalId == digitalId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.age, age) || other.age == age)&&(identical(other.isMinor, isMinor) || other.isMinor == isMinor)&&(identical(other.sex, sex) || other.sex == sex)&&(identical(other.nationality, nationality) || other.nationality == nationality)&&(identical(other.bloodGroup, bloodGroup) || other.bloodGroup == bloodGroup)&&(identical(other.identityStatus, identityStatus) || other.identityStatus == identityStatus)&&(identical(other.relationship, relationship) || other.relationship == relationship)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uuid,digitalId,fullName,dateOfBirth,age,isMinor,sex,nationality,bloodGroup,identityStatus,relationship,createdAt,updatedAt);

@override
String toString() {
  return 'MinorCreateResponse(uuid: $uuid, digitalId: $digitalId, fullName: $fullName, dateOfBirth: $dateOfBirth, age: $age, isMinor: $isMinor, sex: $sex, nationality: $nationality, bloodGroup: $bloodGroup, identityStatus: $identityStatus, relationship: $relationship, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $MinorCreateResponseCopyWith<$Res>  {
  factory $MinorCreateResponseCopyWith(MinorCreateResponse value, $Res Function(MinorCreateResponse) _then) = _$MinorCreateResponseCopyWithImpl;
@useResult
$Res call({
 String uuid, String digitalId, String fullName, DateTime? dateOfBirth, int age, bool isMinor,@JsonKey(fromJson: sexFromJson) Sex sex, String nationality,@JsonKey(fromJson: bloodGroupFromJson) BloodGroup bloodGroup,@JsonKey(fromJson: identityStatusFromJson) IdentityStatus identityStatus, GuardianRelationship? relationship, DateTime? createdAt, DateTime? updatedAt
});


$GuardianRelationshipCopyWith<$Res>? get relationship;

}
/// @nodoc
class _$MinorCreateResponseCopyWithImpl<$Res>
    implements $MinorCreateResponseCopyWith<$Res> {
  _$MinorCreateResponseCopyWithImpl(this._self, this._then);

  final MinorCreateResponse _self;
  final $Res Function(MinorCreateResponse) _then;

/// Create a copy of MinorCreateResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uuid = null,Object? digitalId = null,Object? fullName = null,Object? dateOfBirth = freezed,Object? age = null,Object? isMinor = null,Object? sex = null,Object? nationality = null,Object? bloodGroup = null,Object? identityStatus = null,Object? relationship = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
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
as IdentityStatus,relationship: freezed == relationship ? _self.relationship : relationship // ignore: cast_nullable_to_non_nullable
as GuardianRelationship?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of MinorCreateResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GuardianRelationshipCopyWith<$Res>? get relationship {
    if (_self.relationship == null) {
    return null;
  }

  return $GuardianRelationshipCopyWith<$Res>(_self.relationship!, (value) {
    return _then(_self.copyWith(relationship: value));
  });
}
}


/// Adds pattern-matching-related methods to [MinorCreateResponse].
extension MinorCreateResponsePatterns on MinorCreateResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MinorCreateResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MinorCreateResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MinorCreateResponse value)  $default,){
final _that = this;
switch (_that) {
case _MinorCreateResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MinorCreateResponse value)?  $default,){
final _that = this;
switch (_that) {
case _MinorCreateResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uuid,  String digitalId,  String fullName,  DateTime? dateOfBirth,  int age,  bool isMinor, @JsonKey(fromJson: sexFromJson)  Sex sex,  String nationality, @JsonKey(fromJson: bloodGroupFromJson)  BloodGroup bloodGroup, @JsonKey(fromJson: identityStatusFromJson)  IdentityStatus identityStatus,  GuardianRelationship? relationship,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MinorCreateResponse() when $default != null:
return $default(_that.uuid,_that.digitalId,_that.fullName,_that.dateOfBirth,_that.age,_that.isMinor,_that.sex,_that.nationality,_that.bloodGroup,_that.identityStatus,_that.relationship,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uuid,  String digitalId,  String fullName,  DateTime? dateOfBirth,  int age,  bool isMinor, @JsonKey(fromJson: sexFromJson)  Sex sex,  String nationality, @JsonKey(fromJson: bloodGroupFromJson)  BloodGroup bloodGroup, @JsonKey(fromJson: identityStatusFromJson)  IdentityStatus identityStatus,  GuardianRelationship? relationship,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _MinorCreateResponse():
return $default(_that.uuid,_that.digitalId,_that.fullName,_that.dateOfBirth,_that.age,_that.isMinor,_that.sex,_that.nationality,_that.bloodGroup,_that.identityStatus,_that.relationship,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uuid,  String digitalId,  String fullName,  DateTime? dateOfBirth,  int age,  bool isMinor, @JsonKey(fromJson: sexFromJson)  Sex sex,  String nationality, @JsonKey(fromJson: bloodGroupFromJson)  BloodGroup bloodGroup, @JsonKey(fromJson: identityStatusFromJson)  IdentityStatus identityStatus,  GuardianRelationship? relationship,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _MinorCreateResponse() when $default != null:
return $default(_that.uuid,_that.digitalId,_that.fullName,_that.dateOfBirth,_that.age,_that.isMinor,_that.sex,_that.nationality,_that.bloodGroup,_that.identityStatus,_that.relationship,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _MinorCreateResponse implements MinorCreateResponse {
  const _MinorCreateResponse({required this.uuid, required this.digitalId, required this.fullName, this.dateOfBirth, this.age = 0, this.isMinor = false, @JsonKey(fromJson: sexFromJson) this.sex = Sex.unknown, this.nationality = '', @JsonKey(fromJson: bloodGroupFromJson) this.bloodGroup = BloodGroup.unknown, @JsonKey(fromJson: identityStatusFromJson) this.identityStatus = IdentityStatus.unknown, this.relationship, this.createdAt, this.updatedAt});
  factory _MinorCreateResponse.fromJson(Map<String, dynamic> json) => _$MinorCreateResponseFromJson(json);

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
@override final  GuardianRelationship? relationship;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of MinorCreateResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MinorCreateResponseCopyWith<_MinorCreateResponse> get copyWith => __$MinorCreateResponseCopyWithImpl<_MinorCreateResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MinorCreateResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MinorCreateResponse&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.digitalId, digitalId) || other.digitalId == digitalId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.age, age) || other.age == age)&&(identical(other.isMinor, isMinor) || other.isMinor == isMinor)&&(identical(other.sex, sex) || other.sex == sex)&&(identical(other.nationality, nationality) || other.nationality == nationality)&&(identical(other.bloodGroup, bloodGroup) || other.bloodGroup == bloodGroup)&&(identical(other.identityStatus, identityStatus) || other.identityStatus == identityStatus)&&(identical(other.relationship, relationship) || other.relationship == relationship)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uuid,digitalId,fullName,dateOfBirth,age,isMinor,sex,nationality,bloodGroup,identityStatus,relationship,createdAt,updatedAt);

@override
String toString() {
  return 'MinorCreateResponse(uuid: $uuid, digitalId: $digitalId, fullName: $fullName, dateOfBirth: $dateOfBirth, age: $age, isMinor: $isMinor, sex: $sex, nationality: $nationality, bloodGroup: $bloodGroup, identityStatus: $identityStatus, relationship: $relationship, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$MinorCreateResponseCopyWith<$Res> implements $MinorCreateResponseCopyWith<$Res> {
  factory _$MinorCreateResponseCopyWith(_MinorCreateResponse value, $Res Function(_MinorCreateResponse) _then) = __$MinorCreateResponseCopyWithImpl;
@override @useResult
$Res call({
 String uuid, String digitalId, String fullName, DateTime? dateOfBirth, int age, bool isMinor,@JsonKey(fromJson: sexFromJson) Sex sex, String nationality,@JsonKey(fromJson: bloodGroupFromJson) BloodGroup bloodGroup,@JsonKey(fromJson: identityStatusFromJson) IdentityStatus identityStatus, GuardianRelationship? relationship, DateTime? createdAt, DateTime? updatedAt
});


@override $GuardianRelationshipCopyWith<$Res>? get relationship;

}
/// @nodoc
class __$MinorCreateResponseCopyWithImpl<$Res>
    implements _$MinorCreateResponseCopyWith<$Res> {
  __$MinorCreateResponseCopyWithImpl(this._self, this._then);

  final _MinorCreateResponse _self;
  final $Res Function(_MinorCreateResponse) _then;

/// Create a copy of MinorCreateResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uuid = null,Object? digitalId = null,Object? fullName = null,Object? dateOfBirth = freezed,Object? age = null,Object? isMinor = null,Object? sex = null,Object? nationality = null,Object? bloodGroup = null,Object? identityStatus = null,Object? relationship = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_MinorCreateResponse(
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
as IdentityStatus,relationship: freezed == relationship ? _self.relationship : relationship // ignore: cast_nullable_to_non_nullable
as GuardianRelationship?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of MinorCreateResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GuardianRelationshipCopyWith<$Res>? get relationship {
    if (_self.relationship == null) {
    return null;
  }

  return $GuardianRelationshipCopyWith<$Res>(_self.relationship!, (value) {
    return _then(_self.copyWith(relationship: value));
  });
}
}

// dart format on
